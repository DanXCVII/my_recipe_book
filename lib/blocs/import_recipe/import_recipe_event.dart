import 'dart:io';

import 'package:equatable/equatable.dart';

abstract class ImportRecipeEvent extends Equatable {
  const ImportRecipeEvent();
}

class ImportRecipes extends ImportRecipeEvent {
  final File importZipFile;

  ImportRecipes(this.importZipFile);

  @override
  List<Object> get props => [importZipFile];

  @override
  String toString() => 'Import recipe { importZipFile: $importZipFile }';
}
