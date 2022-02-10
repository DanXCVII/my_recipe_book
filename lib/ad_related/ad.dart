import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:my_recipe_book/generated/i18n.dart';

import 'ad_id.dart';

class Ads {
  static AdRequest _adRequest;
  static RewardedAd _rewardedAd;
  static int maxFailedLoadAttempts = 3;

  static InterstitialAd _interstitialAd;
  static int _numInterstitialLoadAttempts = 0;

  static int _numRewardedLoadAttempts = 0;
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
    );
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
        listener: BannerAdListener(
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
      listener: BannerAdListener(
        onAdLoaded: (_) {},
        onAdFailedToLoad: (_, __) {},
      ),
    );
  }

  static Future<void> loadRewardedVideo(
    bool showOnLoad,
    void Function() onAdLoaded,
    void Function() onAdFailedToLoad,
    void Function() onRewardedAdUserEarnedReward, [
    State state,
  ]) async {
    if (!_showAds) return;
    if (state != null && !state.mounted) return;

    RewardedAd.load(
      adUnitId: getRewardAdUnitId(),
      request: _adRequest,
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (RewardedAd ad) {
          print('$ad loaded.');
          _rewardedAd = ad;
          _numRewardedLoadAttempts = 0;
          onAdLoaded();

          if (showOnLoad) showRewardedVideoAd(onRewardedAdUserEarnedReward);
        },
        onAdFailedToLoad: (LoadAdError error) {
          print('RewardedAd failed to load: $error');
          _rewardedAd = null;
          _numRewardedLoadAttempts += 1;
          print('Yooooooooo' + _numRewardedLoadAttempts.toString());
          if (_numRewardedLoadAttempts <= maxFailedLoadAttempts) {
            loadRewardedVideo(
              showOnLoad,
              onAdLoaded,
              onAdFailedToLoad,
              onRewardedAdUserEarnedReward,
            );
          } else {
            onAdFailedToLoad();
          }
        },
      ),
    );
  }

  static void loadInterstitialAd() {
    if (!_showAds) return;

    InterstitialAd.load(
        adUnitId: InterstitialAd.testAdUnitId,
        request: _adRequest,
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (InterstitialAd ad) {
            print('$ad loaded');
            _interstitialAd = ad;
            _numInterstitialLoadAttempts = 0;
            _interstitialAd.setImmersiveMode(true);
          },
          onAdFailedToLoad: (LoadAdError error) {
            print('InterstitialAd failed to load: $error.');
            _numInterstitialLoadAttempts += 1;
            _interstitialAd = null;
            if (_numInterstitialLoadAttempts <= maxFailedLoadAttempts) {
              loadInterstitialAd();
            }
          },
        ));
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

    if (_interstitialAd == null) {
      print('Warning: attempt to show interstitial before loaded.');
      return;
    }
    _interstitialAd.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (InterstitialAd ad) =>
          print('ad onAdShowedFullScreenContent.'),
      onAdDismissedFullScreenContent: (InterstitialAd ad) {
        print('$ad onAdDismissedFullScreenContent.');
        ad.dispose();
        loadInterstitialAd();
      },
      onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
        print('$ad onAdFailedToShowFullScreenContent: $error');
        ad.dispose();
        loadInterstitialAd();
      },
    );
    _interstitialAd.show();
    _interstitialAd = null;
  }

  static Future<void> showRewardedVideoAd(
      void Function() onRewardedAdUserEarnedReward) async {
    if (_rewardedAd == null) {
      loadRewardedVideo(
        true,
        () {},
        () {},
        onRewardedAdUserEarnedReward,
      );
    } else {
      _rewardedAd.show(onUserEarnedReward: (_, __) {
        onRewardedAdUserEarnedReward();
      });
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
