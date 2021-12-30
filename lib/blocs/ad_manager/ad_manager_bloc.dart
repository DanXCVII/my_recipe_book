import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';

import '../../ad_related/ad.dart';

part 'ad_manager_event.dart';
part 'ad_manager_state.dart';

class AdManagerBloc extends Bloc<AdManagerEvent, AdManagerState> {
  StreamSubscription _periodicSub;
  bool isInitialized = false;
  DateTime lastTimeStartedWatching =
      DateTime.now().subtract(Duration(days: 10));

  final InAppPurchase _iap = InAppPurchase.instance;
  StreamSubscription<List<PurchaseDetails>> _subscription;
  List<String> _notFoundIds = [];
  List<ProductDetails> _products = [];
  List<PurchaseDetails> _purchases = [];
  List<String> _consumables = [];
  bool _isAvailable = false;
  bool _purchasePending = false;
  bool _loading = true;
  String _queryProductError;

  void Function() onAdClosed;
  void Function() onAdFailedToLoad;
  void Function() onRewardedAdUserEarnedReward;

  SharedPreferences _sP;
  bool lastAdForBannerTime;
  bool _showVideo = false;

  AdManagerBloc() : super(AdManagerInitial()) {
    
    final Stream<List<PurchaseDetails>> purchaseUpdated = _iap.purchaseStream;
    _subscription = purchaseUpdated.listen((purchaseDetailsList) {
      purchaseDetailsList.forEach((item) {
        InAppPurchase.instance.completePurchase(item);
      });
    }, onDone: () {
      _subscription.cancel();
    }, onError: (error) {
      // handle error here.
    });
    onAdClosed = onAdClosed = () {
      this.add(_InterruptedLoadingVideo());
    };
    onAdFailedToLoad = () {
      add(_FailedLoadingRewardedVideo());
      _showVideo = false;
    };
    onRewardedAdUserEarnedReward = () {
      print(DateTime.now().toLocal().toString());
      _showVideo = false;
      if (lastAdForBannerTime) {
        add(WatchedVideo(DateTime.now()));
      }
    };
    _iap.isAvailable().then((isAvailable) {
      if (isAvailable) {
        _isAvailable = isAvailable;
        _products = [];
        _purchases = [];
        _notFoundIds = [];
        _consumables = [];
        _purchasePending = false;
        _loading = false;
      }
    });
  }

  @override
  Stream<AdManagerState> mapEventToState(
    AdManagerEvent event,
  ) async* {
    if (!(state is IsPurchased)) {
      if (event is WatchedVideo) {
        yield* _mapWatchedVideoToState(event);
      } else if (event is InitializeAds) {
        yield* _mapInitializeAdsToState(event);
      } else if (event is StartWatchingVideo) {
        yield* _mapStartWatchingVideoToState(event);
      } else if (event is LoadVideo) {
        yield* _mapLoadVideoToState(event);
      } else if (event is ShowAdsAgain) {
        yield* _mapShowAdsAgain(event);
      } else if (event is PurchaseProVersion) {
        yield* _mapPurchaseProVersionToState(event);
      } else if (event is _PurchaseSuccessfull) {
        yield* _mapPurchaseSuccessfullToState(event);
      } else if (event is _FailedLoadingRewardedVideo) {
        yield* _mapFailedLoadingRewardedVideoToState(event);
      } else if (event is _InterruptedLoadingVideo) {
        yield* _mapInterruptedLoadingVideoToState(event);
      }
    }
  }

  Stream<AdManagerState> _mapInitializeAdsToState(InitializeAds event) async* {
    if (isInitialized) return;
    isInitialized = true;

    MobileAds.instance.updateRequestConfiguration(RequestConfiguration(testDeviceIds: ['']));
    
    _sP ??= await SharedPreferences.getInstance();

    if (_sP.getBool('pro_version') == true) {
      Ads.showBannerAds(false);
      yield IsPurchased();
    } else {
      Ads.showBannerAds(true);
      print(await _iap.isAvailable());
      _isAvailable = await _iap.isAvailable();

      if (_isAvailable) {
        await _getProducts();
        await _iap.restorePurchases();
        await _verifyPurchase(null);

        _subscription = _iap.purchaseStream.listen((data) {
          _purchases.addAll(data);

          _verifyPurchase(data.first);
        });
      }

      if (_sP.getString('noAdsUntil') != null) {
        DateTime noAdsUntil = DateTime.parse(_sP.getString('noAdsUntil'));

        if (noAdsUntil.isAfter(DateTime.now())) {
          Ads.showBannerAds(false);

          int waitTime = DateTime.now().difference(noAdsUntil).inMinutes + 5;

          _periodicSub = Stream.periodic(const Duration(minutes: 1), (v) => v)
              .take(waitTime)
              .listen((count) {
            print(count);
            if (DateTime.now().isAfter(noAdsUntil)) {
              Ads.showBannerAds(true);
              _periodicSub.cancel();
              add(ShowAdsAgain());
            }
          });

          yield AdFreeUntil(noAdsUntil);
        }
      }
    }
  }

  Stream<AdManagerState> _mapWatchedVideoToState(WatchedVideo event) async* {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    DateTime oldNoAdsUntil = DateTime.parse(prefs.getString('noAdsUntil'));
    DateTime noAdsUntil;
    if (oldNoAdsUntil.isAfter(DateTime.now())) {
      noAdsUntil = oldNoAdsUntil.add(Duration(minutes: 30));
    } else {
      noAdsUntil = DateTime.now().add(Duration(minutes: 30));
    }

    await prefs.setString('noAdsUntil', noAdsUntil.toString());

    Ads.showBannerAds(false);

    int waitTime = noAdsUntil.difference(DateTime.now()).inMinutes + 5;

    _periodicSub?.cancel();
    _periodicSub = Stream.periodic(const Duration(minutes: 1), (v) => v)
        .take(waitTime)
        .listen((count) {
      print(count);
      if (DateTime.now().isAfter(noAdsUntil)) {
        Ads.showBannerAds(true);
        _periodicSub.cancel();
        add(ShowAdsAgain());
      }
    });

    yield AdFreeUntil(noAdsUntil);
  }

  Stream<AdManagerState> _mapLoadVideoToState(LoadVideo event) async* {
    await Ads.loadRewardedVideo(
      false,
      onAdClosed,
      onAdFailedToLoad,
      onRewardedAdUserEarnedReward,
    );
  }

  Stream<AdManagerState> _mapStartWatchingVideoToState(
      StartWatchingVideo event) async* {
    if (!Ads.shouldShowAds()) return;
    lastAdForBannerTime = event.addAddFreeTime;
    _showVideo = true;
    bool hasInternetConnection = false;
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        hasInternetConnection = true;
      }
    } on SocketException catch (_) {
      hasInternetConnection = false;
    }

    if (!event.showLoadingIndicator) {
      await Ads.showRewardedVideoAd(onRewardedAdUserEarnedReward);

      return;
    }

    if (hasInternetConnection) {
      lastTimeStartedWatching = event.time;

      yield LoadingVideo();

      await Ads.loadRewardedVideo(
        true,
        onAdClosed,
        onAdFailedToLoad,
        onRewardedAdUserEarnedReward,
      );
    } else {
      yield NotConnected();
    }
  }

  Stream<AdManagerState> _mapShowAdsAgain(ShowAdsAgain event) async* {
    yield ShowAds();
  }

  Stream<AdManagerState> _mapPurchaseProVersionToState(
      PurchaseProVersion event) async* {
    if (_products != null && _products.isNotEmpty) {
      final PurchaseParam purchaseParam =
          PurchaseParam(productDetails: _products.first);
      await _iap.buyNonConsumable(purchaseParam: purchaseParam);
    }
  }

  Stream<AdManagerState> _mapPurchaseSuccessfullToState(
      _PurchaseSuccessfull event) async* {
    yield IsPurchased();
  }

  Stream<AdManagerState> _mapFailedLoadingRewardedVideoToState(
      _FailedLoadingRewardedVideo event) async* {
    if (_showVideo) {
      yield FailedLoadingRewardedVideo();
    }
  }

  Stream<AdManagerState> _mapInterruptedLoadingVideoToState(
      _InterruptedLoadingVideo event) async* {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    DateTime noAdsUntil = DateTime.parse(prefs.getString('noAdsUntil'));
    if (noAdsUntil.isAfter(DateTime.now())) {
      yield AdFreeUntil(noAdsUntil);
    } else {
      yield AdManagerInitial();
    }
  }

  Future<void> _getProducts() async {
    Set<String> ids = Set.from(['pro_version']);
    ProductDetailsResponse response = await _iap.queryProductDetails(ids);

    _products = response.productDetails;
  }

  Future<void> _verifyPurchase(PurchaseDetails details) async {
    PurchaseDetails purchase = _hasPurchased('pro_version');

    if (purchase != null && purchase.status == PurchaseStatus.purchased) {
      _sP ??= await SharedPreferences.getInstance();
      _sP.setBool('pro_version', true);
      Ads.showAds(false);
      Ads.showBannerAds(false);
      if (details != null) {
        await _iap.completePurchase(details);
      }
      add(_PurchaseSuccessfull());
    }
  }

  PurchaseDetails _hasPurchased(String productID) {
    return _purchases.firstWhere((purchase) => purchase.productID == productID,
        orElse: () => null);
  }

  @override
  Future<void> close() {
    _subscription.cancel();
    _periodicSub.cancel();
    return super.close();
  }
}
