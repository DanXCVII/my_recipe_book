import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:my_recipe_book/models/import_candidate.dart';
import 'package:my_recipe_book/services/import_file_stager.dart';
import 'package:path/path.dart' as path;

void main() {
  late Directory testDirectory;

  setUp(() async {
    testDirectory = await Directory.systemTemp.createTemp(
      'recipe-stager-test-',
    );
  });

  tearDown(() async {
    if (await testDirectory.exists()) {
      await testDirectory.delete(recursive: true);
    }
  });

  test('copies a source into a unique app-owned import job', () async {
    final source = File(path.join(testDirectory.path, 'source.ZIP'));
    await source.writeAsString('recipe backup');
    final stagingRoot = Directory(path.join(testDirectory.path, 'staging'));
    final stager = ImportFileStager(
      temporaryDirectory: () async => stagingRoot,
    );

    final first = await stager.stage(
      sourcePath: source.path,
      originalFileName: 'Family Recipes.ZIP',
      source: ImportSource.filePicker,
    );
    final second = await stager.stage(
      sourcePath: source.path,
      originalFileName: 'Family Recipes.ZIP',
      source: ImportSource.externalApp,
    );

    expect(first.extension, 'zip');
    expect(first.originalFileName, 'Family Recipes.ZIP');
    expect(await first.file.readAsString(), 'recipe backup');
    expect(first.file.parent.path, isNot(second.file.parent.path));
    expect(await source.exists(), isTrue);
  });

  test(
    'strips directories and unsafe characters from the display name',
    () async {
      final source = File(path.join(testDirectory.path, 'source.json'));
      await source.writeAsString('{}');
      final stager = ImportFileStager(
        temporaryDirectory: () async => testDirectory,
      );

      final candidate = await stager.stage(
        sourcePath: source.path,
        originalFileName: '../unsafe:name.json',
        source: ImportSource.externalApp,
      );

      expect(candidate.originalFileName, 'unsafe_name.json');
      expect(path.isWithin(testDirectory.path, candidate.file.path), isTrue);
    },
  );
}
