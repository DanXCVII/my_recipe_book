part of 'ad_manager_bloc.dart';

abstract class AdManagerEvent extends Equatable {
  const AdManagerEvent();
}

class InitializeAds extends AdManagerEvent {
  const InitializeAds();

  @override
  List<Object> get props => [];
}

class WatchedVideo extends AdManagerEvent {
  final DateTime time;

  const WatchedVideo(this.time);

  @override
  List<Object> get props => [time];
}

class StartWatchingVideo extends AdManagerEvent {
  final DateTime time;

  const StartWatchingVideo(this.time);

  @override
  List<Object> get props => [time];
}

class ShowAdsAgain extends AdManagerEvent {
  @override
  List<Object> get props => [];
}

class PurchaseProVersion extends AdManagerEvent {
  @override
  List<Object> get props => [];
}

class _PurchaseSuccessfull extends AdManagerEvent {
  @override
  List<Object> get props => [];
}
