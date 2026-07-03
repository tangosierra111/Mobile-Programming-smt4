import 'user_meeting_progress.dart';

enum LearningItemType { meeting, exam }

enum PublicationStatus { draft, published, archived, closed }

class LearningItem {
  const LearningItem({
    required this.id,
    required this.type,
    required this.routeKey,
    required this.title,
    required this.accentColorValue,
    required this.backgroundColorValue,
    required this.status,
    required this.sortOrder,
    this.sourceId,
    this.meetingNumber,
    this.slug,
    this.examType,
    this.interactiveDemoKey,
    this.keywords = const [],
    this.progress,
  });

  final String id;
  final int? sourceId;
  final LearningItemType type;
  final String routeKey;
  final int? meetingNumber;
  final String? slug;
  final String? examType;
  final String title;
  final int accentColorValue;
  final int backgroundColorValue;
  final PublicationStatus status;
  final String? interactiveDemoKey;
  final int sortOrder;
  final List<String> keywords;
  final UserMeetingProgress? progress;

  bool get isExam => type == LearningItemType.exam;
  bool get isAvailable => status == PublicationStatus.published;

  String get statusLabel {
    if (isExam) {
      return isAvailable ? 'Ujian tersedia' : 'Ujian belum tersedia';
    }
    return isAvailable ? 'Materi tersedia' : 'Materi belum tersedia';
  }

  bool matches(String query) {
    final normalizedQuery = query.trim().toLowerCase();
    return title.toLowerCase().contains(normalizedQuery) ||
        statusLabel.toLowerCase().contains(normalizedQuery) ||
        keywords.any(
          (keyword) => keyword.toLowerCase().contains(normalizedQuery),
        );
  }

  factory LearningItem.fromJson(Map<String, dynamic> json) {
    final type = _enumByName(
      LearningItemType.values,
      json['type'] as String? ?? 'meeting',
      LearningItemType.meeting,
    );
    final id = json['id'].toString();

    return LearningItem(
      id: id,
      sourceId: (json['source_id'] as num?)?.toInt() ??
          (json['id'] is num ? (json['id'] as num).toInt() : null),
      type: type,
      routeKey: json['route_key'] as String? ??
          (type == LearningItemType.exam
              ? 'exam-${json['exam_type']}'
              : 'meeting-${json['meeting_number']}'),
      meetingNumber: (json['meeting_number'] as num?)?.toInt(),
      slug: json['slug'] as String?,
      examType: json['exam_type'] as String?,
      title: json['title'] as String,
      accentColorValue: _colorValue(
        json['accent_color'] as String? ?? '#0A66C2',
      ),
      backgroundColorValue: _colorValue(
        json['background_color'] as String? ?? '#EAF4FF',
      ),
      status: _enumByName(
        PublicationStatus.values,
        json['status'] as String? ?? 'draft',
        PublicationStatus.draft,
      ),
      interactiveDemoKey: json['interactive_demo_key'] as String?,
      sortOrder: (json['sort_order'] as num?)?.toInt() ?? 0,
      keywords: (json['keywords'] as List<dynamic>? ?? const [])
          .map((item) => item.toString())
          .toList(growable: false),
      progress: json['progress'] is Map<String, dynamic>
          ? UserMeetingProgress.fromJson(
              json['progress'] as Map<String, dynamic>,
            )
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'source_id': sourceId,
        'type': type.name,
        'route_key': routeKey,
        'meeting_number': meetingNumber,
        'slug': slug,
        'exam_type': examType,
        'title': title,
        'accent_color': _hexColor(accentColorValue),
        'background_color': _hexColor(backgroundColorValue),
        'status': status.name,
        'interactive_demo_key': interactiveDemoKey,
        'sort_order': sortOrder,
        'keywords': keywords,
        'progress': progress?.toJson(),
      };
}

T _enumByName<T extends Enum>(List<T> values, String name, T fallback) {
  for (final value in values) {
    if (value.name == name) return value;
  }
  return fallback;
}

int _colorValue(String hex) {
  final normalized = hex.replaceFirst('#', '');
  final rgb = int.tryParse(normalized, radix: 16) ?? 0x0A66C2;
  return 0xFF000000 | rgb;
}

String _hexColor(int value) {
  final rgb = value & 0x00FFFFFF;
  return '#${rgb.toRadixString(16).padLeft(6, '0').toUpperCase()}';
}
