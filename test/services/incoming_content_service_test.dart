import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:my_recipe_book/services/incoming_content_service.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';

void main() {
  test('maps files and safe web links into typed incoming content', () async {
    ReceiveSharingIntent.setMockValues(
      initialMedia: [
        SharedMediaFile(
          path: '/tmp/recipes.zip',
          type: SharedMediaType.file,
          mimeType: 'application/zip',
        ),
        SharedMediaFile(
          path: 'https://example.com/recipe',
          type: SharedMediaType.text,
          mimeType: 'text/plain',
        ),
        SharedMediaFile(
          path: 'not a web address',
          type: SharedMediaType.text,
          mimeType: 'text/plain',
        ),
      ],
      mediaStream: const Stream.empty(),
    );
    final service = ReceiveSharingIncomingContentService();

    final content = await service.getInitialContent();

    expect(content[0].type, IncomingContentType.recipeFile);
    expect(content[0].originalFileName, 'recipes.zip');
    expect(content[1].type, IncomingContentType.websiteUrl);
    expect(content[2].type, IncomingContentType.unsupported);
  });

  test('maps warm-launch stream events', () async {
    final controller = StreamController<List<SharedMediaFile>>();
    addTearDown(controller.close);
    ReceiveSharingIntent.setMockValues(
      initialMedia: const [],
      mediaStream: controller.stream,
    );
    final service = ReceiveSharingIncomingContentService();
    final nextBatch = service.contentStream.first;

    controller.add([
      SharedMediaFile(
        path: 'https://example.com/warm',
        type: SharedMediaType.url,
      ),
    ]);

    expect((await nextBatch).single.type, IncomingContentType.websiteUrl);
  });
}
