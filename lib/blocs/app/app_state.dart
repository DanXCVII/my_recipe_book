part of 'app_bloc.dart';

abstract class AppState extends Equatable {
  const AppState();

  @override
  List<Object> get props => [];
}

class LoadingState extends AppState {}

class LoadedState extends AppState {
  final bool recipeCategoryOverview;
  final bool recipeCalendarOpen;
  final bool showShoppingCartSummary;
  final int selectedIndex;
  final String title;

  LoadedState(
    this.recipeCategoryOverview,
    this.recipeCalendarOpen,
    this.showShoppingCartSummary,
    this.selectedIndex,
    this.title,
  );

  @override
  List<Object> get props => [
    recipeCategoryOverview,
    selectedIndex,
    recipeCalendarOpen,
    showShoppingCartSummary,
    title,
  ];
}
