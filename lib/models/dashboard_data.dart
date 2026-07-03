import 'course.dart';
import 'learning_item.dart';

class DashboardData {
  const DashboardData({
    required this.course,
    required this.items,
    required this.progressSummary,
  });

  final Course course;
  final List<LearningItem> items;
  final DashboardProgressSummary progressSummary;

  factory DashboardData.fromJson(Map<String, dynamic> json) {
    return DashboardData(
      course: Course.fromJson(json['course'] as Map<String, dynamic>),
      items: (json['items'] as List<dynamic>)
          .map((item) => LearningItem.fromJson(item as Map<String, dynamic>))
          .toList(growable: false),
      progressSummary: DashboardProgressSummary.fromJson(
        json['progress_summary'] as Map<String, dynamic>,
      ),
    );
  }
}

class DashboardProgressSummary {
  const DashboardProgressSummary({
    required this.publishedMeetings,
    required this.completedMeetings,
    required this.progressPercent,
  });

  final int publishedMeetings;
  final int completedMeetings;
  final double progressPercent;

  factory DashboardProgressSummary.fromJson(Map<String, dynamic> json) {
    return DashboardProgressSummary(
      publishedMeetings: (json['published_meetings'] as num).toInt(),
      completedMeetings: (json['completed_meetings'] as num).toInt(),
      progressPercent: (json['progress_percent'] as num).toDouble(),
    );
  }
}
