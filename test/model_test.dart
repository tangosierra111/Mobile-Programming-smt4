import 'package:app_46/models/exam.dart';
import 'package:app_46/models/learning_item.dart';
import 'package:app_46/models/profile_data.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('LearningItem parses Laravel dashboard JSON', () {
    final item = LearningItem.fromJson({
      'id': 10,
      'source_id': 10,
      'type': 'meeting',
      'meeting_number': 10,
      'slug': 'pertemuan-10',
      'title': 'Pertemuan 10',
      'accent_color': '#4338CA',
      'background_color': '#EDEBFE',
      'status': 'published',
      'sort_order': 10,
      'keywords': ['tabbar', 'pageview'],
    });

    expect(item.id, '10');
    expect(item.sourceId, 10);
    expect(item.routeKey, 'meeting-10');
    expect(item.isAvailable, isTrue);
    expect(item.matches('pageview'), isTrue);
    expect(item.accentColorValue, 0xFF4338CA);
  });

  test('Exam parses nested course and questions', () {
    final exam = Exam.fromJson({
      'id': 1,
      'exam_type': 'uts',
      'title': 'Ujian Tengah Semester (UTS)',
      'exam_date': '2026-04-09',
      'duration_minutes': 100,
      'learning_outcome': 'Capaian pembelajaran',
      'status': 'published',
      'course': {
        'id': 1,
        'code': '04SIFE008',
        'name': 'Mobile Programming',
        'study_program': 'Sistem Informasi',
        'faculty': 'Ilmu Komputer',
        'lecturer_name': 'Nafiah, S.Si., M.Kom',
      },
      'questions': [
        {
          'id': 1,
          'question_number': 1,
          'question_text': 'Contoh soal',
          'question_type': 'essay',
          'weight_percent': 25,
          'max_time_minutes': 15,
          'sort_order': 1,
        },
      ],
    });

    expect(exam.course.code, '04SIFE008');
    expect(exam.dateLabel, 'Kamis, 9 April 2026');
    expect(exam.questions.single.weightLabel, '25%');
    expect(exam.isAvailable, isTrue);
  });

  test('ProfileData maps API counters to editable labels', () {
    final profile = ProfileData.fromJson({
      'user_id': 7,
      'full_name': 'Pengguna Test',
      'projects_count': 12,
      'followers_count': 30,
      'experience_years': 2,
    });

    expect(profile.projects, '12');
    expect(profile.followers, '30');
    expect(profile.experienceLabel, '2Y');
    expect(profile.toJson()['experience_years'], 2);
  });
}
