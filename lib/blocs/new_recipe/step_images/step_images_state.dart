import 'package:equatable/equatable.dart';
import 'package:my_recipe_book/models/recipe.dart';

abstract class StepImagesState extends Equatable {
  const StepImagesState();
}

class LoadedStepImages extends StepImagesState {
  final List<List<String>> stepImages;

  LoadedStepImages(this.stepImages);

  @override
  List<Object> get props => [stepImages];
}
