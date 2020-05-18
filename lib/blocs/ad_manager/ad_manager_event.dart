part of 'ad_manager_bloc.dart';

abstract class AdManagerEvent {
  const AdManagerEvent();
}

class InitializeAds extends AdManagerEvent {
  const InitializeAds();
}

class WatchedVideo extends AdManagerEvent {
  final DateTime time;

  const WatchedVideo(this.time);
}

class LoadVideo extends AdManagerEvent {}

class StartWatchingVideo extends AdManagerEvent {
  final DateTime time;
  final bool addAddFreeTime;
  final bool showLoadingIndicator;

  const StartWatchingVideo(
    this.time,
    this.addAddFreeTime,
    this.showLoadingIndicator,
  );
}

class ShowAdsAgain extends AdManagerEvent {}

class PurchaseProVersion extends AdManagerEvent {}

class _PurchaseSuccessfull extends AdManagerEvent {}

class _FailedLoadingRewardedVideo extends AdManagerEvent {}

class _InterruptedLoadingVideo extends AdManagerEvent {}
