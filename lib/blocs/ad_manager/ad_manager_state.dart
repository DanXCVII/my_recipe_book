part of 'ad_manager_bloc.dart';

abstract class AdManagerState {
  const AdManagerState();
}

class AdManagerInitial extends AdManagerState {}

class AdFreeUntil extends AdManagerState {
  final DateTime time;

  AdFreeUntil(this.time);
}

class ShowAds extends AdManagerState {}

class IsPurchased extends AdManagerState {}

class LoadingVideo extends AdManagerState {}

class NotConnected extends AdManagerState {}

class FailedLoadingRewardedVideo extends AdManagerState {}
