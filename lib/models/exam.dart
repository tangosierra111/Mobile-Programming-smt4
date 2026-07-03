import 'course.dart';

enum ExamType { uts, uas, quiz }

enum ExamStatus { draft, published, closed }

class Exam {
  const Exam({
    required this.id,
    required this.course,
    required this.type,
    required this.title,
    required this.status,
    this.room,
    this.classCode,
    this.examDate,
    this.startTime,
    this.durationMinutes,
    this.examKind,
    this.learningOutcome,
    this.instructions,
    this.questions = const [],
  });

  final int id;
  final Course course;
  final ExamType type;
  final String title;
  final String? room;
  final String? classCode;
  final DateTime? examDate;
  final String? startTime;
  final int? durationMinutes;
  final String? examKind;
  final String? learningOutcome;
  final String? instructions;
  final ExamStatus status;
  final List<ExamQuestion> questions;

  bool get isAvailable =>
      status == ExamStatus.published &&
      learningOutcome != null &&
      questions.isNotEmpty;

  String get roomAndClass {
    final values = [room, classCode]
        .whereType<String>()
        .where((value) => value.isNotEmpty)
        .toList();
    return values.isEmpty ? 'Belum tersedia' : values.join('/');
  }

  String get dateLabel {
    final value = examDate;
    if (value == null) return 'Belum tersedia';
    const days = [
      'Senin',
      'Selasa',
      'Rabu',
      'Kamis',
      'Jumat',
      'Sabtu',
      'Minggu',
    ];
    const months = [
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember',
    ];
    return '${days[value.weekday - 1]}, ${value.day} '
        '${months[value.month - 1]} ${value.year}';
  }

  String get durationLabel =>
      durationMinutes == null ? 'Belum tersedia' : '$durationMinutes menit';

  factory Exam.fromJson(Map<String, dynamic> json) {
    return Exam(
      id: (json['id'] as num).toInt(),
      course: Course.fromJson(json['course'] as Map<String, dynamic>),
      type: ExamType.values.byName(json['exam_type'] as String),
      title: json['title'] as String,
      room: json['room'] as String?,
      classCode: json['class_code'] as String?,
      examDate: DateTime.tryParse(json['exam_date'] as String? ?? ''),
      startTime: json['start_time'] as String?,
      durationMinutes: (json['duration_minutes'] as num?)?.toInt(),
      examKind: json['exam_kind'] as String?,
      learningOutcome: json['learning_outcome'] as String?,
      instructions: json['instructions'] as String?,
      status: ExamStatus.values.byName(json['status'] as String),
      questions: (json['questions'] as List<dynamic>? ?? const [])
          .map(
            (item) => ExamQuestion.fromJson(item as Map<String, dynamic>),
          )
          .toList(growable: false),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'course': course.toJson(),
        'exam_type': type.name,
        'title': title,
        'room': room,
        'class_code': classCode,
        'exam_date': examDate?.toIso8601String().split('T').first,
        'start_time': startTime,
        'duration_minutes': durationMinutes,
        'exam_kind': examKind,
        'learning_outcome': learningOutcome,
        'instructions': instructions,
        'status': status.name,
        'questions': questions.map((item) => item.toJson()).toList(),
      };
}

class ExamQuestion {
  const ExamQuestion({
    required this.id,
    required this.number,
    required this.question,
    required this.weightPercent,
    required this.sortOrder,
    this.questionType = 'essay',
    this.maxTimeMinutes,
  });

  final int id;
  final int number;
  final String question;
  final String questionType;
  final double weightPercent;
  final int? maxTimeMinutes;
  final int sortOrder;

  String get weightLabel => '${weightPercent.toStringAsFixed(0)}%';
  String get maxTimeLabel =>
      maxTimeMinutes == null ? '-' : '$maxTimeMinutes menit';

  factory ExamQuestion.fromJson(Map<String, dynamic> json) {
    return ExamQuestion(
      id: (json['id'] as num).toInt(),
      number: (json['question_number'] as num).toInt(),
      question: json['question_text'] as String,
      questionType: json['question_type'] as String? ?? 'essay',
      weightPercent: (json['weight_percent'] as num).toDouble(),
      maxTimeMinutes: (json['max_time_minutes'] as num?)?.toInt(),
      sortOrder: (json['sort_order'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'question_number': number,
        'question_text': question,
        'question_type': questionType,
        'weight_percent': weightPercent,
        'max_time_minutes': maxTimeMinutes,
        'sort_order': sortOrder,
      };
}
