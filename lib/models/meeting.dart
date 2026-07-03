import 'learning_item.dart';

enum ContentBlockType {
  heading,
  paragraph,
  bulletList,
  code,
  keyValue,
  callout,
  image,
  demo,
}

class Meeting {
  const Meeting({
    required this.id,
    required this.courseId,
    required this.meetingNumber,
    required this.slug,
    required this.title,
    required this.accentColorValue,
    required this.backgroundColorValue,
    required this.status,
    required this.sortOrder,
    this.summary,
    this.availableAt,
    this.interactiveDemoKey,
    this.keywords = const [],
    this.contentBlocks = const [],
  });

  final int id;
  final int courseId;
  final int meetingNumber;
  final String slug;
  final String title;
  final String? summary;
  final int accentColorValue;
  final int backgroundColorValue;
  final PublicationStatus status;
  final DateTime? availableAt;
  final String? interactiveDemoKey;
  final int sortOrder;
  final List<String> keywords;
  final List<MeetingContentBlock> contentBlocks;

  factory Meeting.fromJson(Map<String, dynamic> json) {
    return Meeting(
      id: (json['id'] as num).toInt(),
      courseId: (json['course_id'] as num).toInt(),
      meetingNumber: (json['meeting_number'] as num).toInt(),
      slug: json['slug'] as String,
      title: json['title'] as String,
      summary: json['summary'] as String?,
      accentColorValue: _colorValue(json['accent_color'] as String?),
      backgroundColorValue: _colorValue(json['background_color'] as String?),
      status: PublicationStatus.values.byName(json['status'] as String),
      availableAt: DateTime.tryParse(json['available_at'] as String? ?? ''),
      interactiveDemoKey: json['interactive_demo_key'] as String?,
      sortOrder: (json['sort_order'] as num?)?.toInt() ?? 0,
      keywords: (json['keywords'] as List<dynamic>? ?? const [])
          .map((item) => item is Map<String, dynamic>
              ? item['keyword'].toString()
              : item.toString())
          .toList(growable: false),
      contentBlocks: (json['content_blocks'] as List<dynamic>? ?? const [])
          .map(
            (item) =>
                MeetingContentBlock.fromJson(item as Map<String, dynamic>),
          )
          .toList(growable: false),
    );
  }

  LearningItem toLearningItem() => LearningItem(
        id: 'meeting-$id',
        sourceId: id,
        type: LearningItemType.meeting,
        routeKey: 'meeting-$meetingNumber',
        meetingNumber: meetingNumber,
        slug: slug,
        title: title,
        accentColorValue: accentColorValue,
        backgroundColorValue: backgroundColorValue,
        status: status,
        interactiveDemoKey: interactiveDemoKey,
        sortOrder: sortOrder,
        keywords: keywords,
      );
}

class MeetingContentBlock {
  const MeetingContentBlock({
    required this.id,
    required this.meetingId,
    required this.blockKey,
    required this.type,
    required this.content,
    required this.sortOrder,
    required this.isVisible,
    this.title,
  });

  final int id;
  final int meetingId;
  final String blockKey;
  final ContentBlockType type;
  final String? title;
  final Map<String, dynamic> content;
  final int sortOrder;
  final bool isVisible;

  factory MeetingContentBlock.fromJson(Map<String, dynamic> json) {
    final rawType = (json['block_type'] as String).replaceAllMapped(
      RegExp(r'_([a-z])'),
      (match) => match.group(1)!.toUpperCase(),
    );
    return MeetingContentBlock(
      id: (json['id'] as num).toInt(),
      meetingId: (json['meeting_id'] as num).toInt(),
      blockKey: json['block_key'] as String,
      type: ContentBlockType.values.byName(rawType),
      title: json['title'] as String?,
      content: Map<String, dynamic>.from(
        json['content_json'] as Map<dynamic, dynamic>,
      ),
      sortOrder: (json['sort_order'] as num?)?.toInt() ?? 0,
      isVisible: json['is_visible'] as bool? ?? true,
    );
  }
}

int _colorValue(String? hex) {
  final normalized = (hex ?? '#0A66C2').replaceFirst('#', '');
  return 0xFF000000 | (int.tryParse(normalized, radix: 16) ?? 0x0A66C2);
}
