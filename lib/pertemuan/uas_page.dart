import 'package:flutter/material.dart';

import '../data/local_exam_data.dart';
import '../models/exam.dart';
import 'ujian_template_page.dart';

class UasPage extends StatelessWidget {
  const UasPage({super.key, this.exam});

  final Exam? exam;

  @override
  Widget build(BuildContext context) {
    return UjianTemplatePage(
      exam: exam ?? uasExam,
      unavailableMessage:
          'Template halaman sudah disiapkan. Detail soal, waktu, dan '
          'informasi pelaksanaan UAS dapat ditambahkan setelah materi '
          'tersedia.',
    );
  }
}
