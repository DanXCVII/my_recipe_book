part of 'website_import_bloc.dart';

abstract class WebsiteImportEvent extends Equatable {
  const WebsiteImportEvent();
}

class ImportRecipe extends WebsiteImportEvent {
  final String url;

  ImportRecipe(this.url);

  @override
  List<Object> get props => [url];
}
