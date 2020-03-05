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

class StartWatchingVideo extends AdManagerEvent {
  final DateTime time;

  const StartWatchingVideo(this.time);
}

class ShowAdsAgain extends AdManagerEvent {}

class PurchaseProVersion extends AdManagerEvent {}

class _PurchaseSuccessfull extends AdManagerEvent {}

class _FailedLoadingRewardedVideo extends AdManagerEvent {}

class _InterruptedLoadingVideo extends AdManagerEvent {}
