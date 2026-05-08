import 'package:flutter/material.dart';

class UjianTemplatePage extends StatelessWidget {
  const UjianTemplatePage({
    super.key,
    required this.title,
    required this.leftInfo,
    required this.rightInfo,
    this.learningOutcome,
    this.questions = const [],
    this.unavailableMessage,
  });

  final String title;
  final List<ExamInfo> leftInfo;
  final List<ExamInfo> rightInfo;
  final String? learningOutcome;
  final List<ExamQuestion> questions;
  final String? unavailableMessage;

  bool get _isContentAvailable =>
      learningOutcome != null && questions.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(title),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _HeaderCard(
            title: title,
            leftInfo: leftInfo,
            rightInfo: rightInfo,
          ),
          const SizedBox(height: 16),
          if (_isContentAvailable) ...[
            Card(
              color: const Color(0xFFEAF4FF),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Capaian Pembelajaran Mata Kuliah',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: const Color(0xFF0A66C2),
                            fontWeight: FontWeight.w800,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Text(learningOutcome!),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 18),
            Text(
              'Jawablah pertanyaan ini dengan uraian yang jelas!',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF111827),
                  ),
            ),
            const SizedBox(height: 10),
            for (final question in questions) ...[
              _QuestionCard(question: question),
              const SizedBox(height: 12),
            ],
          ] else
            _UnavailableExamCard(message: unavailableMessage),
          const SizedBox(height: 80),
        ],
      ),
    );
  }
}

class _UnavailableExamCard extends StatelessWidget {
  const _UnavailableExamCard({this.message});

  final String? message;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFFF8FAFC),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Konten ujian belum tersedia',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: const Color(0xFF475467),
                    fontWeight: FontWeight.w800,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              message ??
                  'Template halaman sudah disiapkan. Detail soal, waktu, dan '
                      'informasi pelaksanaan dapat ditambahkan setelah materi '
                      'tersedia.',
              style: const TextStyle(
                color: Color(0xFF667085),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HeaderCard extends StatelessWidget {
  const _HeaderCard({
    required this.title,
    required this.leftInfo,
    required this.rightInfo,
  });

  final String title;
  final List<ExamInfo> leftInfo;
  final List<ExamInfo> rightInfo;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const CircleAvatar(
                  backgroundColor: Color(0xFFEAF4FF),
                  child: Icon(
                    Icons.school_rounded,
                    color: Color(0xFF0A66C2),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFF111827),
                        ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(thickness: 2, color: Color(0xFF111827)),
            const SizedBox(height: 12),
            LayoutBuilder(
              builder: (context, constraints) {
                final useTwoColumns = constraints.maxWidth >= 720;
                final infoColumns = [
                  _InfoColumn(items: leftInfo),
                  _InfoColumn(items: rightInfo),
                ];

                if (!useTwoColumns) {
                  return Column(
                    children: [
                      infoColumns.first,
                      const SizedBox(height: 8),
                      infoColumns.last,
                    ],
                  );
                }

                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: infoColumns.first),
                    const SizedBox(width: 24),
                    Expanded(child: infoColumns.last),
                  ],
                );
              },
            ),
            const SizedBox(height: 12),
            const Divider(thickness: 2, color: Color(0xFF111827)),
          ],
        ),
      ),
    );
  }
}

class _InfoColumn extends StatelessWidget {
  const _InfoColumn({required this.items});

  final List<ExamInfo> items;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (final item in items)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 132,
                  child: Text(
                    item.label,
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
                const Text(':  '),
                Expanded(child: Text(item.value)),
              ],
            ),
          ),
      ],
    );
  }
}

class _QuestionCard extends StatelessWidget {
  const _QuestionCard({required this.question});

  final ExamQuestion question;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              backgroundColor: const Color(0xFFEAF4FF),
              child: Text(
                '${question.number}',
                style: const TextStyle(
                  color: Color(0xFF0A66C2),
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    question.question,
                    style: const TextStyle(
                      color: Color(0xFF111827),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Bobot : ${question.weight} | Waktu Maksimal : ${question.maxTime}',
                    style: const TextStyle(
                      color: Color(0xFF111827),
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ExamInfo {
  const ExamInfo({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;
}

class ExamQuestion {
  const ExamQuestion({
    required this.number,
    required this.question,
    required this.weight,
    required this.maxTime,
  });

  final int number;
  final String question;
  final String weight;
  final String maxTime;
}
