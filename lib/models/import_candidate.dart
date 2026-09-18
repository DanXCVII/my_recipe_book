import 'dart:io';

enum ImportSource { filePicker, externalApp }

class ImportCandidate {
  const ImportCandidate({
    required this.file,
    required this.originalFileName,
    required this.extension,
    required this.source,
    this.mimeType,
  });

  final File file;
  final String originalFileName;
  final String extension;
  final ImportSource source;
  final String? mimeType;
}
