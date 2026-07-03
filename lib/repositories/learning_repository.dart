import '../core/network/api_client.dart';
import '../models/dashboard_data.dart';
import '../models/user_meeting_progress.dart';

class LearningRepository {
  const LearningRepository(this._apiClient);

  final ApiClient _apiClient;

  Future<DashboardData> fetchDashboard(int courseId) async {
    final data = await _apiClient.get('/courses/$courseId/dashboard');
    return DashboardData.fromJson(data as Map<String, dynamic>);
  }

  Future<UserMeetingProgress> updateProgress({
    required int meetingId,
    required MeetingProgressStatus status,
    required int progressPercent,
  }) async {
    final data = await _apiClient.put(
      '/meetings/$meetingId/progress',
      body: {
        'status': switch (status) {
          MeetingProgressStatus.notStarted => 'not_started',
          MeetingProgressStatus.inProgress => 'in_progress',
          MeetingProgressStatus.completed => 'completed',
        },
        'progress_percent': progressPercent,
      },
    );
    return UserMeetingProgress.fromJson(data as Map<String, dynamic>);
  }
}
