import 'dart:io';

import 'package:archive/archive.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_recipe_book/local_storage/io_operations.dart';
import 'package:path/path.dart' as path;

void main() {
  late Directory testDirectory;

  setUp(() async {
    testDirectory = await Directory.systemTemp.createTemp('recipe-zip-test-');
  });

  tearDown(() async {
    if (await testDirectory.exists()) {
      await testDirectory.delete(recursive: true);
    }
  });

  test('extracts ordinary archive entries inside the destination', () async {
    final zip = await _writeArchive(
      testDirectory,
      Archive()..addFile(ArchiveFile.string('recipe/data.json', '{}')),
    );
    final destination = path.join(testDirectory.path, 'output');

    await exstractZip(zip, destination);

    expect(
      await File(path.join(destination, 'recipe', 'data.json')).readAsString(),
      '{}',
    );
  });

  test('rejects entries that escape the extraction directory', () async {
    final zip = await _writeArchive(
      testDirectory,
      Archive()..addFile(ArchiveFile.string('../escaped.txt', 'unsafe')),
    );
    final destination = path.join(testDirectory.path, 'output');

    await expectLater(
      exstractZip(zip, destination),
      throwsA(isA<FormatException>()),
    );
    expect(
      await File(path.join(testDirectory.path, 'escaped.txt')).exists(),
      isFalse,
    );
  });
}

Future<File> _writeArchive(Directory directory, Archive archive) async {
  final file = File(path.join(directory.path, 'recipes.zip'));
  await file.writeAsBytes(ZipEncoder().encodeBytes(archive));
  return file;
}
