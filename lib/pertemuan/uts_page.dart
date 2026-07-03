import 'package:flutter/material.dart';

import '../data/local_exam_data.dart';
import '../models/exam.dart';
import 'ujian_template_page.dart';

class UtsPage extends StatelessWidget {
  const UtsPage({super.key, this.exam});

  final Exam? exam;

  @override
  Widget build(BuildContext context) {
    return UjianTemplatePage(exam: exam ?? utsExam);
  }
}
