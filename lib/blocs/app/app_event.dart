part of 'app_bloc.dart';

abstract class AppEvent extends Equatable {
  const AppEvent();

  @override
  List<Object> get props => [];
}

class InitializeData extends AppEvent {
  final bool recipeCategoryOverview;
  final bool showIntro;
  final BuildContext context;

  const InitializeData(
    this.context,
    this.recipeCategoryOverview,
    this.showIntro,
  );

  @override
  List<Object> get props => [
        context,
        recipeCategoryOverview,
        showIntro,
      ];

  @override
  String toString() =>
      'Load App { context: $context , recipeCategoryOverview : $recipeCategoryOverview , showIntro : $showIntro }';
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

  @override
  String toString() => 'Change index { index: $index, context: $context }';
}
