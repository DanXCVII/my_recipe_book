import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

abstract class SplashScreenEvent extends Equatable {
  const SplashScreenEvent();

  @override
  List<Object> get props => [];
}

class SPInitializeData extends SplashScreenEvent {
  final BuildContext context;

  SPInitializeData(this.context);

  @override
  List<Object> get props => [context];
}
