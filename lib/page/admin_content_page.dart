import 'package:flutter/material.dart';

import '../models/learning_item.dart';
import '../repositories/content_repository.dart';
import '../repositories/learning_repository.dart';
import 'meeting_content_editor_page.dart';

class AdminContentPage extends StatefulWidget {
  const AdminContentPage({
    super.key,
    required this.learningRepository,
    required this.contentRepository,
    this.courseId = 1,
  });

  final LearningRepository learningRepository;
  final ContentRepository contentRepository;
  final int courseId;

  @override
  State<AdminContentPage> createState() => _AdminContentPageState();
}

class _AdminContentPageState extends State<AdminContentPage> {
  late Future<List<LearningItem>> _futureMeetings;

  @override
  void initState() {
    super.initState();
    _futureMeetings = _loadMeetings();
  }

  Future<List<LearningItem>> _loadMeetings() async {
    final dashboard =
        await widget.learningRepository.fetchDashboard(widget.courseId);
    return dashboard.items.where((item) => !item.isExam).toList();
  }

  void _refresh() {
    setState(() => _futureMeetings = _loadMeetings());
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<LearningItem>>(
      future: _futureMeetings,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return _ErrorState(error: snapshot.error!, onRetry: _refresh);
        }

        final meetings = snapshot.data!;
        return ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Text(
              'Content Builder',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Pilih pertemuan, lalu susun blok materi yang akan dibaca mahasiswa.',
              style: TextStyle(color: Color(0xFF667085)),
            ),
            const SizedBox(height: 18),
            ...meetings.map(
              (meeting) => Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  leading: CircleAvatar(
                    backgroundColor: Color(meeting.backgroundColorValue),
                    child: Text(
                      '${meeting.meetingNumber}',
                      style: TextStyle(
                        color: Color(meeting.accentColorValue),
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  title: Text(
                    meeting.title,
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                  subtitle: Text(
                    meeting.isAvailable ? 'Dipublikasikan' : 'Draf',
                  ),
                  trailing: const Icon(Icons.chevron_right_rounded),
                  onTap: meeting.sourceId == null
                      ? null
                      : () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => MeetingContentEditorPage(
                                meetingId: meeting.sourceId!,
                                repository: widget.contentRepository,
                              ),
                            ),
                          ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.error, required this.onRetry});

  final Object error;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline_rounded, size: 48),
            const SizedBox(height: 12),
            Text(error.toString(), textAlign: TextAlign.center),
            const SizedBox(height: 12),
            FilledButton(onPressed: onRetry, child: const Text('Coba lagi')),
          ],
        ),
      ),
    );
  }
}
