import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hive_ce/hive_ce.dart';
import 'package:my_recipe_book/local_storage/hive.dart' as legacy;

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late Directory directory;

  setUp(() async {
    await Hive.close();
    Hive.resetAdapters();
    directory = await Directory.systemTemp.createTemp('legacy-hive-reader-');
  });

  tearDown(() async {
    await Hive.close();
    Hive.resetAdapters();
    await directory.delete(recursive: true);
  });

  test('opens every legacy box and registers nested value adapters', () async {
    await legacy.openLegacyHive(directoryPath: directory.path);

    expect(
      Hive.box<List<String>>(legacy.BoxNames.recipeTagsList).isOpen,
      isTrue,
    );
    expect(Hive.isAdapterRegistered(5), isTrue);
  });
}
