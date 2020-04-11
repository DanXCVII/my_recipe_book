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
  final int selectedIndex;
  final String title;

  LoadedState(
    this.recipeCategoryOverview,
    this.showIntro,
    this.shoppingCartOpen,
    this.selectedIndex,
    this.title,
  );

  @override
  List<Object> get props => [
        recipeCategoryOverview,
        showIntro,
        selectedIndex,
        shoppingCartOpen,
        title,
      ];

  @override
  String toString() =>
      'Loaded State { recipeCategoryOverview : $recipeCategoryOverview, '
      'showIntro : $showIntro, selectedIndex : $selectedIndex, title : $title }';
}
