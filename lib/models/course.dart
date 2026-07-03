class Course {
  const Course({
    required this.id,
    required this.code,
    required this.name,
    required this.studyProgram,
    required this.faculty,
    required this.lecturerName,
    this.description,
    this.isActive = true,
  });

  final int id;
  final String code;
  final String name;
  final String studyProgram;
  final String faculty;
  final String lecturerName;
  final String? description;
  final bool isActive;

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      id: (json['id'] as num).toInt(),
      code: json['code'] as String,
      name: json['name'] as String,
      studyProgram: json['study_program'] as String? ?? '',
      faculty: json['faculty'] as String? ?? '',
      lecturerName: json['lecturer_name'] as String? ?? '',
      description: json['description'] as String?,
      isActive: json['is_active'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'code': code,
        'name': name,
        'study_program': studyProgram,
        'faculty': faculty,
        'lecturer_name': lecturerName,
        'description': description,
        'is_active': isActive,
      };
}
