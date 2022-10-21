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
  List<ProductDetails> _products = [];
  List<PurchaseDetails> _purchases = [];
  bool _isAvailable = false;

  void Function() /*!*/ onAdLoaded;
  void Function() onAdFailedToLoad;
  void Function() onRewardedAdUserEarnedReward;

  SharedPreferences _sP;
  bool lastAdForBannerTime;
  bool _showVideo = false;

  AdManagerBloc() : super(AdManagerInitial()) {
    final Stream<List<PurchaseDetails>> purchaseUpdated = _iap.purchaseStream;
    _subscription = purchaseUpdated.listen((purchaseDetailsList) {
      purchaseDetailsList.forEach((purchase) {
        if (purchase.pendingCompletePurchase) {
          InAppPurchase.instance.completePurchase(purchase);
        }
      });
    }, onDone: () {
      _subscription.cancel();
    }, onError: (error) {
      // handle error here.
    });

    _iap.isAvailable().then((isAvailable) {
      if (isAvailable) {
        _isAvailable = isAvailable;
        _products = [];
        _purchases = [];
      }
    });

    onAdLoaded = () {
      this.add(_DisplayCurrentVideoAdState());
    };
    onAdFailedToLoad = () {
      this.add(_FailedLoadingRewardedVideo());
      _showVideo = false;
    };
    onRewardedAdUserEarnedReward = () {
      print(DateTime.now().toLocal().toString());
      _showVideo = false;
      if (lastAdForBannerTime) {
        this.add(WatchedVideo(DateTime.now()));
      }
    };

    on<WatchedVideo>((event, emit) async {
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

      emit(AdFreeUntil(noAdsUntil));
    });

    on<InitializeAds>((event, emit) async {
      if (isInitialized) return;
      isInitialized = true;

      MobileAds.instance.updateRequestConfiguration(
          RequestConfiguration(testDeviceIds: ['']));

      _sP ??= await SharedPreferences.getInstance();

      if (_sP.getBool('pro_version') == true) {
        Ads.showBannerAds(false);
        emit(IsPurchased());
      } else {
        Ads.showBannerAds(true);
        print(await _iap.isAvailable());
        _isAvailable = await _iap.isAvailable();

        if (_isAvailable) {
          await _getProducts();

          try {
            await _iap.restorePurchases();
          } catch (e) {
            print(e);
          }

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

            emit(AdFreeUntil(noAdsUntil));
          }
        }
      }
    });

    on<StartWatchingVideo>((event, emit) async {
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
      } else {
        if (hasInternetConnection) {
          lastTimeStartedWatching = event.time;

          emit(LoadingVideo());

          await Ads.loadRewardedVideo(
            true,
            onAdLoaded,
            onAdFailedToLoad,
            onRewardedAdUserEarnedReward,
          );
        } else {
          emit(NotConnected());
        }
      }
    });

    on<LoadVideo>((event, emit) async {
      await Ads.loadRewardedVideo(
        false,
        onAdLoaded,
        onAdFailedToLoad,
        onRewardedAdUserEarnedReward,
      );
    });

    on<ShowAdsAgain>((event, emit) async {
      emit(ShowAds());
    });

    on<PurchaseProVersion>((event, emit) async {
      if (_products != null && _products.isNotEmpty) {
        final PurchaseParam purchaseParam = GooglePlayPurchaseParam(
            productDetails: _products.first, applicationUserName: null);

        await _iap.buyNonConsumable(purchaseParam: purchaseParam);
      }
    });

    on<_PurchaseSuccessfull>((event, emit) async {
      emit(IsPurchased());
    });

    on<_FailedLoadingRewardedVideo>((event, emit) async {
      if (_showVideo) {
        emit(FailedLoadingRewardedVideo());
      }
    });

    on<_DisplayCurrentVideoAdState>((event, emit) async {
      DateTime noAdsUntil = await _getStatusNoAds();

      if (noAdsUntil.isAfter(DateTime.now())) {
        emit(AdFreeUntil(noAdsUntil));
      } else {
        emit(AdManagerInitial());
      }
    });
  }

  Future<void> _getProducts() async {
    Set<String> ids = ['pro_version'].toSet();
    ProductDetailsResponse response = await _iap.queryProductDetails(ids);

    List<String> _notFoundIds = response.notFoundIDs;

    _products = response.productDetails;
  }

  Future<void> _verifyPurchase(PurchaseDetails details) async {
    PurchaseDetails purchase = _hasPurchased('pro_version');

    if (purchase != null &&
        (purchase.status == PurchaseStatus.purchased ||
            purchase.status == PurchaseStatus.restored)) {
      _sP ??= await SharedPreferences.getInstance();
      await _sP.setBool('pro_version', true);
      Ads.showAds(false);
      Ads.showBannerAds(false);
      if (details != null) {
        await _iap.completePurchase(details);
      }
      add(_PurchaseSuccessfull());
    } else if (details != null &&
        details.error.message == "BillingResponse.itemAlreadyOwned") {
      _sP ??= await SharedPreferences.getInstance();
      await _sP.setBool('pro_version', true);
      Ads.showAds(false);
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

  Future<DateTime> _getStatusNoAds() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    DateTime noAdsUntil = DateTime.parse(prefs.getString('noAdsUntil'));

    if (_sP.getString('noAdsUntil') != null &&
        noAdsUntil.isAfter(DateTime.now())) {
      return noAdsUntil;
    } else {
      return DateTime(0);
    }
  }
}
