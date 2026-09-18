part of 'app_bloc.dart';

abstract class AppEvent extends Equatable {
  const AppEvent();

  @override
  List<Object> get props => [];
}

class InitializeData extends AppEvent {
  final bool recipeCategoryOverview;
  final bool showSummary;
  final BuildContext context;

  const InitializeData(
    this.context,
    this.recipeCategoryOverview,
    this.showSummary,
  );

  @override
  List<Object> get props => [context, recipeCategoryOverview, showSummary];

  @override
  String toString() =>
      'Load App { context: $context , recipeCategoryOverview : $recipeCategoryOverview }';
}

class ShoppingCartShowSummary extends AppEvent {
  final bool showSummary;

  const ShoppingCartShowSummary(this.showSummary);

  @override
  List<Object> get props => [showSummary];
}

class ChangeCategoryOverview extends AppEvent {
  final bool recipeCategoryOverview;

  const ChangeCategoryOverview(this.recipeCategoryOverview);

  @override
  List<Object> get props => [recipeCategoryOverview];

  @override
  String toString() =>
      'Change CategoryOverview { recipeCategoryOverview: $recipeCategoryOverview }';
}

class ChangeView extends AppEvent {
  final int index;
  final BuildContext context;

  const ChangeView(this.index, this.context);

  @override
  List<Object> get props => [index, context];
}

class ChangeRecipeCalendarView extends AppEvent {
  final bool open;

  const ChangeRecipeCalendarView(this.open);

  @override
  List<Object> get props => [open];
}
