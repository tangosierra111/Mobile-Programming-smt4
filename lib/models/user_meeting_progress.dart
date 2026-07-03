enum MeetingProgressStatus { notStarted, inProgress, completed }

class UserMeetingProgress {
  const UserMeetingProgress({
    required this.id,
    required this.userId,
    required this.meetingId,
    required this.status,
    required this.progressPercent,
    this.startedAt,
    this.completedAt,
    this.lastOpenedAt,
  });

  final int id;
  final int userId;
  final int meetingId;
  final MeetingProgressStatus status;
  final int progressPercent;
  final DateTime? startedAt;
  final DateTime? completedAt;
  final DateTime? lastOpenedAt;

  bool get isCompleted => status == MeetingProgressStatus.completed;

  factory UserMeetingProgress.fromJson(Map<String, dynamic> json) {
    return UserMeetingProgress(
      id: (json['id'] as num).toInt(),
      userId: (json['user_id'] as num).toInt(),
      meetingId: (json['meeting_id'] as num).toInt(),
      status: _statusFromApi(json['status'] as String),
      progressPercent: (json['progress_percent'] as num?)?.toInt() ?? 0,
      startedAt: DateTime.tryParse(json['started_at'] as String? ?? ''),
      completedAt: DateTime.tryParse(json['completed_at'] as String? ?? ''),
      lastOpenedAt: DateTime.tryParse(
        json['last_opened_at'] as String? ?? '',
      ),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'user_id': userId,
        'meeting_id': meetingId,
        'status': switch (status) {
          MeetingProgressStatus.notStarted => 'not_started',
          MeetingProgressStatus.inProgress => 'in_progress',
          MeetingProgressStatus.completed => 'completed',
        },
        'progress_percent': progressPercent,
        'started_at': startedAt?.toIso8601String(),
        'completed_at': completedAt?.toIso8601String(),
        'last_opened_at': lastOpenedAt?.toIso8601String(),
      };
}

MeetingProgressStatus _statusFromApi(String value) {
  return switch (value) {
    'in_progress' => MeetingProgressStatus.inProgress,
    'completed' => MeetingProgressStatus.completed,
    _ => MeetingProgressStatus.notStarted,
  };
}
