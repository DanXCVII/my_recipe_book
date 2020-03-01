import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../ad_related/ad.dart';

part 'ad_manager_event.dart';
part 'ad_manager_state.dart';

class AdManagerBloc extends Bloc<AdManagerEvent, AdManagerState> {
  StreamSubscription _periodicSub;
  bool isInitialized = false;
  DateTime lastTimeStartedWatching =
      DateTime.now().subtract(Duration(days: 10));

  AdManagerBloc() {
    RewardedVideoAd.instance.listener =
        (RewardedVideoAdEvent event, {String rewardType, int rewardAmount}) {
      if (event == RewardedVideoAdEvent.rewarded) {
        print(DateTime.now().toLocal().toString());
        add(WatchedVideo(DateTime.now()));
      } else if (event == RewardedVideoAdEvent.loaded &&
          DateTime.now().difference(lastTimeStartedWatching) <
              Duration(minutes: 5)) {
        RewardedVideoAd.instance.show();
      }
    };
  }

  @override
  AdManagerState get initialState => AdManagerInitial();

  @override
  Stream<AdManagerState> mapEventToState(
    AdManagerEvent event,
  ) async* {
    if (event is WatchedVideo) {
      yield* _mapWatchedVideoToState(event);
    } else if (event is InitializeAds) {
      yield* _mapInitializeAdsToState(event);
    } else if (event is StartWatchingVideo) {
      yield* _mapStartWatchingVideoToState(event);
    }
  }

  Stream<AdManagerState> _mapInitializeAdsToState(InitializeAds event) async* {
    if (isInitialized) return;
    isInitialized = true;

    SharedPreferences prefs = await SharedPreferences.getInstance();

    Ads.showAds(true);

    if (prefs.getString('noAdsUntil') != null) {
      DateTime noAdsUntil = DateTime.parse(prefs.getString('noAdsUntil'));

      if (noAdsUntil.isAfter(DateTime.now())) {
        Ads.showAds(false);

        int waitTime = DateTime.now().difference(noAdsUntil).inMinutes + 5;

        _periodicSub = Stream.periodic(const Duration(minutes: 1), (v) => v)
            .take(waitTime)
            .listen((count) {
          print(count);
          if (DateTime.now().isAfter(noAdsUntil)) {
            Ads.showAds(true);
            _periodicSub.cancel();
          }
        });

        yield AdFreeUntil(noAdsUntil);
      }
    }
  }

  Stream<AdManagerState> _mapWatchedVideoToState(WatchedVideo event) async* {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    DateTime oldNoAdsUntil = DateTime.parse(prefs.getString('noAdsUntil'));
    DateTime noAdsUntil;
    if (oldNoAdsUntil.isAfter(DateTime.now())) {
      noAdsUntil = oldNoAdsUntil.add(Duration(minutes: 20));
    } else {
      noAdsUntil = DateTime.now().add(Duration(minutes: 20));
    }

    await prefs.setString('noAdsUntil', noAdsUntil.toString());

    Ads.showAds(false);

    int waitTime = noAdsUntil.difference(DateTime.now()).inMinutes + 5;

    _periodicSub?.cancel();
    _periodicSub = Stream.periodic(const Duration(minutes: 1), (v) => v)
        .take(waitTime)
        .listen((count) {
      print(count);
      if (DateTime.now().isAfter(noAdsUntil)) {
        Ads.showAds(true);
        _periodicSub.cancel();
      }
    });

    yield AdFreeUntil(noAdsUntil);
  }

  Stream<AdManagerState> _mapStartWatchingVideoToState(
      StartWatchingVideo event) async* {
    lastTimeStartedWatching = event.time;
    await Ads.showRewardedVideo();
  }

  @override
  Future<void> close() {
    _periodicSub.cancel();
    return super.close();
  }
}
