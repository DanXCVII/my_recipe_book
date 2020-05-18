import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../ad_related/ad.dart';

part 'ad_manager_event.dart';
part 'ad_manager_state.dart';

class AdManagerBloc extends Bloc<AdManagerEvent, AdManagerState> {
  StreamSubscription _periodicSub;
  bool isInitialized = false;
  DateTime lastTimeStartedWatching =
      DateTime.now().subtract(Duration(days: 10));

  /// if the API is available on the device
  bool _available = true;

  /// In App Purchase plugin
  InAppPurchaseConnection _iap;

  /// products for sale
  List<ProductDetails> _products = [];

  /// past purchases
  List<PurchaseDetails> _purchases = [];

  /// Updates to purchases
  StreamSubscription _subscription;

  SharedPreferences _sP;
  bool lastAdForBannerTime;
  bool _showVideo = false;

  AdManagerBloc() {
    RewardedVideoAd.instance.listener =
        (RewardedVideoAdEvent event, {String rewardType, int rewardAmount}) {
      if (event == RewardedVideoAdEvent.rewarded) {
        print(DateTime.now().toLocal().toString());
        _showVideo = false;
        if (lastAdForBannerTime) {
          add(WatchedVideo(DateTime.now()));
        }
      } else if (event == RewardedVideoAdEvent.loaded && _showVideo) {
        RewardedVideoAd.instance.show();
        _showVideo = false;
      } else if (event == RewardedVideoAdEvent.failedToLoad) {
        add(_FailedLoadingRewardedVideo());
        _showVideo = false;
      } else if (event == RewardedVideoAdEvent.closed) {
        add(_InterruptedLoadingVideo());
      }
    };
  }

  @override
  AdManagerState get initialState => AdManagerInitial();

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

    _sP ??= await SharedPreferences.getInstance();

    if (_sP.getBool('pro_version') == true) {
      Ads.showBannerAds(false);
      yield IsPurchased();
    } else {
      Ads.showBannerAds(true);
      InAppPurchaseConnection.enablePendingPurchases();
      print(await InAppPurchaseConnection.instance.isAvailable());
      _iap = InAppPurchaseConnection.instance;
      _available = await _iap.isAvailable();

      if (_available) {
        await _getProducts();
        await _getPastPurchases();
        await _verifyPurchase();

        _subscription = _iap.purchaseUpdatedStream.listen((data) {
          _purchases.addAll(data);
          _verifyPurchase();
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
    await Ads.loadRewardedVideo();
  }

  Stream<AdManagerState> _mapStartWatchingVideoToState(
      StartWatchingVideo event) async* {
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
      Ads.showRewardedVideoAd();
      await Ads.loadRewardedVideo();
      return;
    }

    if (hasInternetConnection) {
      lastTimeStartedWatching = event.time;

      yield LoadingVideo();

      Ads.showRewardedVideoAd();
      await Ads.loadRewardedVideo();
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

  Future<void> _getPastPurchases() async {
    QueryPurchaseDetailsResponse response = await _iap.queryPastPurchases();

    for (PurchaseDetails purchase in response.pastPurchases) {
      if (Platform.isIOS) {
        InAppPurchaseConnection.instance.completePurchase(purchase);
      }
    }

    _purchases = response.pastPurchases;
  }

  Future<void> _verifyPurchase() async {
    PurchaseDetails purchase = _hasPurchased('pro_version');

    if (purchase != null && purchase.status == PurchaseStatus.purchased) {
      _sP ??= await SharedPreferences.getInstance();
      _sP.setBool('pro_version', true);
      Ads.showBannerAds(false);
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
