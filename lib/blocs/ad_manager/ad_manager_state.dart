part of 'ad_manager_bloc.dart';

abstract class AdManagerState extends Equatable {
  const AdManagerState();

  @override
  List<Object> get props => [];
}

class AdManagerInitial extends AdManagerState {}

class AdFreeUntil extends AdManagerState {
  final DateTime time;

  AdFreeUntil(this.time);

  @override
  List<Object> get props => [time];
}

class ShowAds extends AdManagerState {}

class IsPurchased extends AdManagerState {}

class LoadingVideo extends AdManagerState {}
