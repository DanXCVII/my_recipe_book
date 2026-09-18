import 'dart:async';

import 'package:path/path.dart' as path;
import 'package:receive_sharing_intent/receive_sharing_intent.dart';

enum IncomingContentType { recipeFile, websiteUrl, unsupported }

class IncomingContent {
  const IncomingContent({
    required this.type,
    required this.value,
    this.originalFileName,
    this.mimeType,
  });

  final IncomingContentType type;
  final String value;
  final String? originalFileName;
  final String? mimeType;

  String get identity => '$type|$value|${mimeType ?? ''}';
}

abstract interface class IncomingContentService {
  Future<List<IncomingContent>> getInitialContent();

  Stream<List<IncomingContent>> get contentStream;

  Future<void> reset();
}

class ReceiveSharingIncomingContentService implements IncomingContentService {
  ReceiveSharingIncomingContentService({ReceiveSharingIntent? receiver})
    : _receiver = receiver ?? ReceiveSharingIntent.instance;

  final ReceiveSharingIntent _receiver;

  @override
  Future<List<IncomingContent>> getInitialContent() async {
    return _mapItems(await _receiver.getInitialMedia());
  }

  @override
  Stream<List<IncomingContent>> get contentStream =>
      _receiver.getMediaStream().map(_mapItems);

  @override
  Future<void> reset() async {
    await _receiver.reset();
  }

  List<IncomingContent> _mapItems(List<SharedMediaFile> items) {
    return items.map(_mapItem).toList(growable: false);
  }

  IncomingContent _mapItem(SharedMediaFile item) {
    if (item.type == SharedMediaType.file) {
      return IncomingContent(
        type: IncomingContentType.recipeFile,
        value: item.path,
        originalFileName: path.basename(item.path),
        mimeType: item.mimeType,
      );
    }

    if (item.type == SharedMediaType.url || item.type == SharedMediaType.text) {
      final uri = Uri.tryParse(item.path.trim());
      if (uri != null && (uri.scheme == 'https' || uri.scheme == 'http')) {
        return IncomingContent(
          type: IncomingContentType.websiteUrl,
          value: uri.toString(),
          mimeType: item.mimeType,
        );
      }
    }

    return IncomingContent(
      type: IncomingContentType.unsupported,
      value: item.path,
      mimeType: item.mimeType,
    );
  }
}
