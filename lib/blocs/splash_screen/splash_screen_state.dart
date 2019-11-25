import 'package:equatable/equatable.dart';

abstract class SplashScreenState extends Equatable {
  const SplashScreenState();
}

class InitializingData extends SplashScreenState {
  @override
  List<Object> get props => [];
}

class InitializedData extends SplashScreenState {
  final bool recipeCategoryOverview;
  final bool showIntro;

  InitializedData([
    this.recipeCategoryOverview,
    this.showIntro,
  ]);

  @override
  List<Object> get props => [
        recipeCategoryOverview,
        showIntro,
      ];

  @override
  String toString() =>
      'Loaded State { recipeCategoryOverview : $recipeCategoryOverview, '
      'showIntro : $showIntro }';
}
