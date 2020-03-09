import 'dart:async';

import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';

import 'ad_id.dart';

class Ads {
  static bool _showAds = true;
  static bool bottomBIsShown = false;
  static bool topBIsShown = false;
  static bool _bottomBIsGoingToBeShown = false;
  static bool _topBIsGoingToBeShown = false;
  static BannerAd _bottomBannerAd;
  static BannerAd _topBannerAd;
  static bool _wideBottomBannerAd = false;

  static void initialize() {
    FirebaseAdMob.instance.initialize(appId: getAdAppId());
  }

  static void showWideBannerAds() {
    _wideBottomBannerAd = true;
  }

  static void setBottomBannerAd() {
    _bottomBannerAd = BannerAd(
      adUnitId: getBannerAdUnitId(),
      size: _wideBottomBannerAd ? AdSize.fullBanner : AdSize.banner,
      targetingInfo: _getMobileAdTargetingInfo(),
      listener: (MobileAdEvent event) {
        if (event == MobileAdEvent.loaded) {
          bottomBIsShown = true;
          _bottomBIsGoingToBeShown = false;
        } else if (event == MobileAdEvent.failedToLoad) {
          bottomBIsShown = false;
          _bottomBIsGoingToBeShown = false;
        }
      },
    );
  }

  static void setTopBannerAd() {
    _topBannerAd = BannerAd(
      adUnitId: getBannerAdUnitId(),
      size: AdSize.banner, // maybe smartBanner
      targetingInfo: _getMobileAdTargetingInfo(),
      listener: (MobileAdEvent event) {
        if (event == MobileAdEvent.loaded) {
          topBIsShown = true;
          _topBIsGoingToBeShown = false;
        } else if (event == MobileAdEvent.failedToLoad) {
          topBIsShown = false;
          _topBIsGoingToBeShown = false;
        }
      },
    );
  }

  static Future<void> showRewardedVideo([State state]) async {
    if (state != null && !state.mounted) return;

    await RewardedVideoAd.instance
        .load(
          adUnitId: getRewardAdUnitId(),
          targetingInfo: _getMobileAdTargetingInfo(),
        )
        .catchError((e) => print('error loading'));
  }

  static void showBottomBannerAd([State state]) {
    // if (Purchases.isNoAds()) return;
    if (!_showAds || (state != null && !state.mounted)) {
      print("showBottomBannerAd: return");
      return;
    }

    if (_bottomBannerAd == null) {
      print("showBottomBannerAd: _bottomBannerAd = $_bottomBannerAd");
      setBottomBannerAd();
    }
    if (!bottomBIsShown && !_bottomBIsGoingToBeShown) {
      print(
          "showBottomBannerAd: bottomBIsShown = false, _bottomBIsGoingToBeShow = false");
      _bottomBIsGoingToBeShown = true;
      _bottomBannerAd
        ..load()
        ..show(
          // anchorOffset: 60.0,
          anchorType: AnchorType.bottom,
        );
    }
  }

  static void showTopBannerAd([State state]) {
    // if (Purchases.isNoAds()) return;
    if (!_showAds || (state != null && !state.mounted)) return;
    if (_topBannerAd == null) setTopBannerAd();
    if (!topBIsShown && !_topBIsGoingToBeShown) {
      _topBIsGoingToBeShown = true;
      _topBannerAd
        ..load()
        ..show(
          anchorOffset: 80.0,
          anchorType: AnchorType.top,
        );
    }
  }

  static int _reloaded = 0;

  static void hideBottomBannerAd() {
    if (!_showAds) return;
    if (_bottomBannerAd != null && !_bottomBIsGoingToBeShown) {
      print(
          'hideBottomBannerAd: _bottomBannerAd != null, _bottomBIsGoingToBeShow = false');
      _bottomBannerAd.dispose().then((disposed) {
        print('hideBottomBannerAd: setting bottomBIsShown to ${!disposed}');
        bottomBIsShown = !disposed;
      });
      print('hideBottomBannerAd: setting _bottomBannerAd to null');
      _bottomBannerAd = null;
    }
    if (_bottomBannerAd != null && _bottomBIsGoingToBeShown) {
      print(
          'hideBottomBannerAd: _bottomBannerAd != null, _bottomBIsGoingToBeShown = true');
      Future.delayed(const Duration(milliseconds: 100), () {
        if (_bottomBannerAd != null && !_bottomBIsGoingToBeShown) {
          print(
              'hideBottomBannerAd: _bottomBannerAd != null, _bottomBIsGoingToBeShown = false');
          _bottomBannerAd.dispose().then((disposed) {
            print(
                'hideBottomBannerAd: disposing (setting _bottomBIsShow = ${!disposed}, _bottomBIsGoingToBeShown = false, _bottomBannerAd = null');
            bottomBIsShown = !disposed;
            _bottomBIsGoingToBeShown = false;
            _bottomBannerAd = null;
          });
        } else {
          _reloaded++;
          if (_reloaded == 10) {
            _reloaded = 0;
          }
          hideBottomBannerAd();
        }
      });
    }
  }

  static void hideTopBannerAd() {
    if (_topBannerAd != null && !_topBIsGoingToBeShown) {
      _topBannerAd.dispose().then((disposed) {
        topBIsShown = !disposed;
      });
      _topBannerAd = null;
    }
    if (_topBannerAd != null && _topBIsGoingToBeShown) {
      Future.delayed(const Duration(milliseconds: 100), () {
        if (_topBannerAd != null && !_topBIsGoingToBeShown) {
          _topBannerAd.dispose().then((disposed) {
            topBIsShown = !disposed;
            _topBIsGoingToBeShown = false;
            _topBannerAd = null;
          });
        } else {
          hideTopBannerAd();
        }
      });
    }
  }

  static void showInterstitialAd() {
    var interstitialAd = InterstitialAd(
      adUnitId: getInterstitialAdUnitId(),
      targetingInfo: _getMobileAdTargetingInfo(),
      listener: (MobileAdEvent event) {},
    );
    interstitialAd
      ..load()
      ..show(anchorOffset: 0.0, anchorType: AnchorType.bottom);
  }

  static void showRewardedVideoAd() {
    RewardedVideoAd.instance.listener =
        (RewardedVideoAdEvent event, {String rewardType, int rewardAmount}) {
      if (event == RewardedVideoAdEvent.loaded) {
        RewardedVideoAd.instance.show();
      }
    };
    RewardedVideoAd.instance.load(
        adUnitId: getRewardAdUnitId(),
        targetingInfo: _getMobileAdTargetingInfo());
  }

  static MobileAdTargetingInfo _getMobileAdTargetingInfo() {
    return MobileAdTargetingInfo(
        keywords: <String>[
          'recipes',
          'kitchen',
          'cooking',
        ],
        // contentUrl: 'https://flutter.io',
        childDirected: false,
        testDevices: <String>["84A003142741DEE5AEED89CE56D794EB"]);
  }

  static void showAds(bool showAds) {
    _showAds = showAds;
  }

  static bool shouldShowAds() {
    return _showAds;
  }
}
