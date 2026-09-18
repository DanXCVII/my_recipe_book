import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

import '../models/import_candidate.dart';

class ImportFileStager {
  ImportFileStager({Future<Directory> Function()? temporaryDirectory})
    : _temporaryDirectory = temporaryDirectory ?? getTemporaryDirectory;

  final Future<Directory> Function() _temporaryDirectory;
  int _sequence = 0;

  Future<ImportCandidate> stage({
    required String sourcePath,
    required ImportSource source,
    String? originalFileName,
    String? mimeType,
  }) async {
    final sourceFile = File(sourcePath);
    if (!await sourceFile.exists()) {
      throw FileSystemException('Import source does not exist', sourcePath);
    }

    final suppliedName = originalFileName?.trim();
    final safeName = _safeFileName(
      suppliedName == null || suppliedName.isEmpty
          ? path.basename(sourcePath)
          : suppliedName,
    );
    final tempDirectory = await _temporaryDirectory();
    final jobId = '${DateTime.now().microsecondsSinceEpoch}-${_sequence++}';
    final jobDirectory = Directory(
      path.join(tempDirectory.path, 'import_jobs', jobId),
    );
    await jobDirectory.create(recursive: true);

    final stagedFile = await sourceFile.copy(
      path.join(jobDirectory.path, safeName),
    );
    final extension = path
        .extension(safeName)
        .replaceFirst('.', '')
        .toLowerCase();

    return ImportCandidate(
      file: stagedFile,
      originalFileName: safeName,
      extension: extension,
      source: source,
      mimeType: mimeType,
    );
  }

  String _safeFileName(String name) {
    final baseName = path
        .basename(name)
        .replaceAll(RegExp(r'[\x00-\x1f\\/:*?"<>|]'), '_');
    return baseName.isEmpty ? 'import-file' : baseName;
  }
}
