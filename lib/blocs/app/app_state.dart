part of 'app_bloc.dart';

abstract class AppState extends Equatable {
  const AppState();

  @override
  List<Object> get props => [];
}

class LoadingState extends AppState {}

class LoadedState extends AppState {
  final bool recipeCategoryOverview;
  final bool showIntro;
  final bool shoppingCartOpen;
  final bool showShoppingCartSummary;
  final int selectedIndex;
  final String title;

  LoadedState(
    this.recipeCategoryOverview,
    this.showIntro,
    this.shoppingCartOpen,
    this.showShoppingCartSummary,
    this.selectedIndex,
    this.title,
  );

  @override
  List<Object> get props => [
        recipeCategoryOverview,
        showIntro,
        selectedIndex,
        shoppingCartOpen,
        showShoppingCartSummary,
        title,
      ];
}
