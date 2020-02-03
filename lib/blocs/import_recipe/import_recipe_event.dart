import 'dart:io';

import 'package:equatable/equatable.dart';

abstract class ImportRecipeEvent extends Equatable {
  const ImportRecipeEvent();
}

class ImportRecipes extends ImportRecipeEvent {
  final File importZipFile;
  final Duration delay;

  ImportRecipes(this.importZipFile, {this.delay});

  @override
  List<Object> get props => [importZipFile, delay];

  @override
  String toString() => 'Import recipe { importZipFile: $importZipFile }';
}
