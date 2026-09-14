part of 'splash_screen_bloc.dart';

abstract class SplashScreenState extends Equatable {
  const SplashScreenState();

  @override
  List<Object?> get props => [];
}

class InitializingData extends SplashScreenState {}

class MigratingData extends SplashScreenState {
  const MigratingData(this.progress);
  final StorageMigrationProgress progress;

  @override
  List<Object?> get props => [progress.stage, progress.current, progress.total];
}

class StorageMigrationFailed extends SplashScreenState {
  const StorageMigrationFailed(this.errorCode);
  final String errorCode;

  @override
  List<Object?> get props => [errorCode];
}

class InitializedData extends SplashScreenState {
  final bool? recipeCategoryOverview;
  final bool? showShoppingCartSummary;
  final bool? showIntro;
  final int migrationWarningCount;

  InitializedData(
    this.recipeCategoryOverview,
    this.showShoppingCartSummary,
    this.showIntro,
    this.migrationWarningCount,
  );

  @override
  List<Object?> get props => [
    recipeCategoryOverview,
    showShoppingCartSummary,
    showIntro,
    migrationWarningCount,
  ];
}
