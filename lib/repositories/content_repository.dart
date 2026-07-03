import '../core/network/api_client.dart';
import '../models/meeting.dart';

class ContentRepository {
  const ContentRepository(this._apiClient);

  final ApiClient _apiClient;

  Future<Meeting> fetchMeeting(int meetingId) async {
    final data = await _apiClient.get('/meetings/$meetingId');
    return Meeting.fromJson(data as Map<String, dynamic>);
  }

  Future<MeetingContentBlock> createBlock({
    required int meetingId,
    required String blockKey,
    required ContentBlockType type,
    required Map<String, dynamic> content,
    required int sortOrder,
    String? title,
    bool isVisible = true,
  }) async {
    final data = await _apiClient.post(
      '/meetings/$meetingId/content-blocks',
      body: _body(
        blockKey: blockKey,
        type: type,
        content: content,
        sortOrder: sortOrder,
        title: title,
        isVisible: isVisible,
      ),
    );
    return MeetingContentBlock.fromJson(data as Map<String, dynamic>);
  }

  Future<MeetingContentBlock> updateBlock({
    required MeetingContentBlock block,
    required String blockKey,
    required ContentBlockType type,
    required Map<String, dynamic> content,
    required int sortOrder,
    String? title,
    bool isVisible = true,
  }) async {
    final data = await _apiClient.put(
      '/content-blocks/${block.id}',
      body: _body(
        blockKey: blockKey,
        type: type,
        content: content,
        sortOrder: sortOrder,
        title: title,
        isVisible: isVisible,
      ),
    );
    return MeetingContentBlock.fromJson(data as Map<String, dynamic>);
  }

  Future<void> deleteBlock(int blockId) async {
    await _apiClient.delete('/content-blocks/$blockId');
  }

  Map<String, dynamic> _body({
    required String blockKey,
    required ContentBlockType type,
    required Map<String, dynamic> content,
    required int sortOrder,
    required String? title,
    required bool isVisible,
  }) {
    return {
      'block_key': blockKey,
      'block_type': switch (type) {
        ContentBlockType.bulletList => 'bullet_list',
        ContentBlockType.keyValue => 'key_value',
        _ => type.name,
      },
      'title': title,
      'content_json': content,
      'sort_order': sortOrder,
      'is_visible': isVisible,
    };
  }
}
