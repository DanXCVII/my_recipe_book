part of 'splash_screen_bloc.dart';

abstract class SplashScreenState extends Equatable {
  const SplashScreenState();

  @override
  List<Object> get props => [];
}

class InitializingData extends SplashScreenState {}

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

class IntentImportRecipes extends SplashScreenState {}
