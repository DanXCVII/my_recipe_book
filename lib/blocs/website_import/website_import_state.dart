part of 'website_import_bloc.dart';

abstract class WebsiteImportState extends Equatable {
  const WebsiteImportState();
}

class ReadyToImport extends WebsiteImportState {
  @override
  List<Object> get props => [];
}

class ImportedRecipe extends WebsiteImportState {
  final Recipe recipe;

  ImportedRecipe(this.recipe);

  @override
  List<Object> get props => [recipe];
}

class FailedImportingRecipe extends WebsiteImportState {
  final String url;

  FailedImportingRecipe(this.url);

  @override
  List<Object> get props => [url];
}

class FailedToConnect extends WebsiteImportState {
  @override
  List<Object> get props => [];
}

class InvalidUrl extends WebsiteImportState {
  @override
  List<Object> get props => [];
}

class AlreadyExists extends WebsiteImportState {
  final String recipeName;

  AlreadyExists(this.recipeName);

  @override
  List<Object> get props => [];
}
