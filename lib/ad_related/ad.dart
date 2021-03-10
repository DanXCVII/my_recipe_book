import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:my_recipe_book/generated/i18n.dart';

import 'ad_id.dart';

class Ads {
  static AdRequest _adRequest;
  static RewardedAd _rewardedVideo;
  static bool _showBannerAds = true;
  static bool _showAds = false;
  static List<BannerAd> _bottomBannerAd = [];
  static BannerAd _topBannerAd;
  static bool _wideBottomBannerAd = false;
  static double adHeight;

  static void initialize(bool showAds, {bool personalized = false}) {
    _showAds = showAds;
    if (!_showAds) return;
    _adRequest = AdRequest(
        keywords: [
          'recipes',
          'kitchen',
          'cooking',
        ],
        nonPersonalizedAds: !personalized,
        testDevices: <String>["84A003142741DEE5AEED89CE56D794EB"]);
  }

  static void showWideBannerAds() {
    if (!_showBannerAds) return;
    _wideBottomBannerAd = true;
  }

  static void _setBottomBannerAd() {
    if (!_showBannerAds) return;
    _bottomBannerAd.add(
      BannerAd(
        adUnitId: getBannerAdUnitId(),
        size: _wideBottomBannerAd ? AdSize.fullBanner : AdSize.banner,
        request: _adRequest,
        listener: AdListener(
            onAdLoaded: (_) {},
            onAdFailedToLoad: (_, __) {
              _bottomBannerAd[_bottomBannerAd.length - 1].dispose();
            },
            onAdClosed: (_) {
              _bottomBannerAd[_bottomBannerAd.length - 1].dispose();
            }),
      ),
    );
  }

  static void setTopBannerAd() {
    if (!_showBannerAds) return;
    _topBannerAd = BannerAd(
      adUnitId: getBannerAdUnitId(),
      size: AdSize.banner,
      request: _adRequest,
      listener: AdListener(
        onAdLoaded: (_) {},
        onAdFailedToLoad: (_, __) {},
      ),
    );
  }

  static Future<void> loadRewardedVideo(
    bool showOnLoad,
    void Function() onAdClosed,
    void Function() onAdFailedToLoad,
    void Function() onRewardedAdUserEarnedReward, [
    State state,
  ]) async {
    if (!_showAds) return;
    if (state != null && !state.mounted) return;

    _rewardedVideo = RewardedAd(
      adUnitId: getRewardAdUnitId(),
      request: _adRequest,
      listener: AdListener(
        // Called when an ad is successfully received.
        onAdLoaded: (Ad ad) {
          print("rewarded video ad loaded");
          if (showOnLoad) _rewardedVideo.show();
        },
        // Called when an ad request failed.
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          onAdFailedToLoad();
        },
        // Called when an ad opens an overlay that covers the screen.
        onAdOpened: (Ad ad) => print('Ad opened.'),
        // Called when an ad removes an overlay that covers the screen.
        onAdClosed: (Ad ad) => onAdClosed(),
        // Called when an ad is in the process of leaving the application.
        onApplicationExit: (Ad ad) => print('Left application.'),
        // Called when a RewardedAd triggers a reward.
        onRewardedAdUserEarnedReward: (RewardedAd ad, RewardItem reward) {
          onRewardedAdUserEarnedReward();
        },
      ),
    )..load();
  }

  static void showBottomBannerAd([State state]) {
    if (!_showBannerAds) return;
    _setBottomBannerAd();
    _bottomBannerAd.last.load();
  }

  static void showTopBannerAd([State state]) {
    if (!_showBannerAds) return;
    // if (Purchases.isNoAds()) return;
    if (!_showBannerAds || (state != null && !state.mounted)) return;
    if (_topBannerAd == null) setTopBannerAd();
    _topBannerAd..load();
  }

  static void hideBottomBannerAd() {
    if (!_showBannerAds) return;
    if (_bottomBannerAd.isNotEmpty) {
      _bottomBannerAd.last.dispose().then((value) {
        _bottomBannerAd.removeLast();
      });
    }
  }

  static void hideTopBannerAd() {
    if (!_showBannerAds) return;
    _topBannerAd.dispose();
  }

  static void showInterstitialAd() {
    if (!_showAds) return;
    var interstitialAd = InterstitialAd(
        adUnitId: getInterstitialAdUnitId(),
        request: _adRequest,
        listener: AdListener());
    interstitialAd
      ..load()
      ..show();
  }

  static Future<void> showRewardedVideoAd() async {
    if (await _rewardedVideo.isLoaded()) {
      _rewardedVideo.show();
    } else {
      loadRewardedVideo(true, () {}, () {}, () {});
    }

    return;
  }

  static void showBannerAds(bool showBannerAds) {
    _showBannerAds = showBannerAds;
  }

  static bool shouldShowBannerAds() {
    return _showBannerAds;
  }

  static void showAds(bool showAds) {
    _showAds = showAds;
  }

  static bool shouldShowAds() {
    return _showAds;
  }

  Widget getAdPage(Widget page, BuildContext context) {
    if (_bottomBannerAd.isEmpty) {
      showBottomBannerAd();
    }
    return Ads.shouldShowBannerAds()
        ? Column(
            children: <Widget>[
              Expanded(child: page),
              Container(
                height: Ads.adHeight,
                child: Stack(
                  children: <Widget>[
                    Container(
                      height: Ads.adHeight,
                      width: double.infinity,
                      color: Colors.brown,
                      child: Image.asset(
                        "images/bannerAd.png",
                      ),
                    ),
                    Material(
                      type: MaterialType.transparency,
                      child: Center(
                        child: Text(
                          I18n.of(context).remove_ads_upgrade_in_settings,
                          style: TextStyle(fontSize: 18, color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    AdWidget(
                      ad: _bottomBannerAd.last,
                    )
                  ],
                ),
              )
            ],
          )
        : page;
  }
}
