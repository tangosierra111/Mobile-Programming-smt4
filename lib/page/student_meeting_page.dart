import 'package:flutter/material.dart';

import '../models/meeting.dart';
import '../pertemuan/pertemuan1.dart';
import '../pertemuan/pertemuan10.dart';
import '../pertemuan/pertemuan2.dart';
import '../pertemuan/pertemuan3.dart';
import '../pertemuan/pertemuan4.dart';
import '../pertemuan/pertemuan5.dart';
import '../pertemuan/pertemuan6.dart';
import '../pertemuan/pertemuan7.dart';
import '../pertemuan/pertemuan8.dart';
import '../pertemuan/pertemuan9.dart';
import '../repositories/content_repository.dart';

class StudentMeetingPage extends StatefulWidget {
  const StudentMeetingPage({
    super.key,
    required this.meetingId,
    required this.repository,
  });

  final int meetingId;
  final ContentRepository repository;

  @override
  State<StudentMeetingPage> createState() => _StudentMeetingPageState();
}

class _StudentMeetingPageState extends State<StudentMeetingPage> {
  late Future<Meeting> _futureMeeting;

  @override
  void initState() {
    super.initState();
    _load();
  }

  void _load() {
    _futureMeeting = widget.repository.fetchMeeting(widget.meetingId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Materi Pertemuan')),
      body: FutureBuilder<Meeting>(
        future: _futureMeeting,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return _MeetingLoadError(
              error: snapshot.error!,
              onRetry: () => setState(_load),
            );
          }

          final meeting = snapshot.data!;
          final blocks = meeting.contentBlocks
              .where((block) => block.isVisible)
              .toList()
            ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));

          return CustomScrollView(
            slivers: [
              SliverToBoxAdapter(child: _MeetingHeader(meeting: meeting)),
              if (blocks.isEmpty)
                const SliverFillRemaining(
                  hasScrollBody: false,
                  child: _EmptyContent(),
                )
              else
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
                  sliver: SliverList.separated(
                    itemCount: blocks.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 16),
                    itemBuilder: (context, index) => _ContentBlockView(
                      block: blocks[index],
                      meeting: meeting,
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

class _MeetingHeader extends StatelessWidget {
  const _MeetingHeader({required this.meeting});

  final Meeting meeting;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Color(meeting.backgroundColorValue),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'PERTEMUAN ${meeting.meetingNumber}',
            style: TextStyle(
              color: Color(meeting.accentColorValue),
              fontWeight: FontWeight.w800,
              letterSpacing: 1.1,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            meeting.title,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF111827),
                ),
          ),
          if (meeting.summary?.trim().isNotEmpty == true) ...[
            const SizedBox(height: 8),
            Text(
              meeting.summary!,
              style: const TextStyle(
                color: Color(0xFF475467),
                fontSize: 16,
                height: 1.5,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _ContentBlockView extends StatelessWidget {
  const _ContentBlockView({required this.block, required this.meeting});

  final MeetingContentBlock block;
  final Meeting meeting;

  @override
  Widget build(BuildContext context) {
    return switch (block.type) {
      ContentBlockType.heading => _HeadingBlock(block: block),
      ContentBlockType.paragraph => _TextBlock(block: block),
      ContentBlockType.bulletList => _BulletBlock(block: block),
      ContentBlockType.code => _CodeBlock(block: block),
      ContentBlockType.keyValue => _KeyValueBlock(block: block),
      ContentBlockType.callout => _CalloutBlock(block: block),
      ContentBlockType.image => _ImageBlock(block: block),
      ContentBlockType.demo => _DemoBlock(block: block, meeting: meeting),
    };
  }
}

class _HeadingBlock extends StatelessWidget {
  const _HeadingBlock({required this.block});

  final MeetingContentBlock block;

  @override
  Widget build(BuildContext context) {
    final text = block.title ?? block.content['text']?.toString() ?? '';
    return Text(
      text,
      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w800,
            color: const Color(0xFF111827),
          ),
    );
  }
}

class _TextBlock extends StatelessWidget {
  const _TextBlock({required this.block});

  final MeetingContentBlock block;

  @override
  Widget build(BuildContext context) {
    return _BlockCard(
      title: block.title,
      child: SelectableText(
        block.content['text']?.toString() ?? '',
        style: const TextStyle(fontSize: 16, height: 1.65),
      ),
    );
  }
}

class _BulletBlock extends StatelessWidget {
  const _BulletBlock({required this.block});

  final MeetingContentBlock block;

  @override
  Widget build(BuildContext context) {
    final items = block.content['items'] as List<dynamic>? ?? const [];
    return _BlockCard(
      title: block.title,
      child: Column(
        children: items
            .map(
              (item) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(top: 7),
                      child: Icon(Icons.circle, size: 7),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: SelectableText(
                        item.toString(),
                        style: const TextStyle(fontSize: 16, height: 1.5),
                      ),
                    ),
                  ],
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}

class _CodeBlock extends StatelessWidget {
  const _CodeBlock({required this.block});

  final MeetingContentBlock block;

  @override
  Widget build(BuildContext context) {
    final language = block.content['language']?.toString() ?? 'code';
    return _BlockCard(
      title: block.title ?? language.toUpperCase(),
      padding: EdgeInsets.zero,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: const Color(0xFF101828),
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: SelectableText(
            block.content['code']?.toString() ?? '',
            style: const TextStyle(
              color: Color(0xFFF2F4F7),
              fontFamily: 'monospace',
              fontSize: 14,
              height: 1.55,
            ),
          ),
        ),
      ),
    );
  }
}

class _KeyValueBlock extends StatelessWidget {
  const _KeyValueBlock({required this.block});

  final MeetingContentBlock block;

  @override
  Widget build(BuildContext context) {
    final items = block.content['items'] as List<dynamic>? ?? const [];
    return _BlockCard(
      title: block.title,
      child: Column(
        children: items.map((item) {
          final map = Map<String, dynamic>.from(item as Map);
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 7),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 150,
                  child: Text(
                    map['label']?.toString() ?? '',
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
                Expanded(child: Text(map['value']?.toString() ?? '')),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _CalloutBlock extends StatelessWidget {
  const _CalloutBlock({required this.block});

  final MeetingContentBlock block;

  @override
  Widget build(BuildContext context) {
    final variant = block.content['variant']?.toString() ?? 'info';
    final (background, foreground, icon) = switch (variant) {
      'warning' => (
          const Color(0xFFFFF4E5),
          const Color(0xFFB54708),
          Icons.warning_amber_rounded,
        ),
      'success' => (
          const Color(0xFFECFDF3),
          const Color(0xFF027A48),
          Icons.check_circle_outline_rounded,
        ),
      _ => (
          const Color(0xFFEAF4FF),
          const Color(0xFF0A66C2),
          Icons.info_outline_rounded,
        ),
    };
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: foreground),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (block.title?.isNotEmpty == true) ...[
                  Text(
                    block.title!,
                    style: TextStyle(
                      color: foreground,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 4),
                ],
                SelectableText(
                  block.content['text']?.toString() ?? '',
                  style: TextStyle(color: foreground, height: 1.5),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ImageBlock extends StatelessWidget {
  const _ImageBlock({required this.block});

  final MeetingContentBlock block;

  @override
  Widget build(BuildContext context) {
    final url = block.content['url']?.toString() ?? '';
    final alt = block.content['alt']?.toString() ?? block.title ?? 'Gambar';
    return _BlockCard(
      title: block.title,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.network(
          url,
          fit: BoxFit.contain,
          errorBuilder: (_, __, ___) => Container(
            padding: const EdgeInsets.all(28),
            color: const Color(0xFFF2F4F7),
            child: Column(
              children: [
                const Icon(Icons.broken_image_outlined, size: 42),
                const SizedBox(height: 8),
                Text('Gambar tidak dapat dimuat: $alt'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _DemoBlock extends StatelessWidget {
  const _DemoBlock({required this.block, required this.meeting});

  final MeetingContentBlock block;
  final Meeting meeting;

  @override
  Widget build(BuildContext context) {
    final demoKey = block.content['demo_key']?.toString() ??
        meeting.interactiveDemoKey ??
        '';
    final page = _demoPage(demoKey);
    return _BlockCard(
      title: block.title ?? 'Demo Interaktif',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            page == null
                ? 'Demo "$demoKey" belum tersedia di aplikasi.'
                : 'Jalankan contoh interaktif untuk mempraktikkan materi ini.',
          ),
          const SizedBox(height: 12),
          FilledButton.icon(
            onPressed: page == null
                ? null
                : () => Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => page),
                    ),
            icon: const Icon(Icons.play_arrow_rounded),
            label: const Text('Buka demo'),
          ),
        ],
      ),
    );
  }
}

Widget? _demoPage(String key) => switch (key) {
      'flutter_introduction' => const Pertemuan1Page(),
      'layout_basics' => const Pertemuan2Page(),
      'form_demo' => const Pertemuan3Page(),
      'notification_demo' => const Pertemuan4Page(),
      'list_view_demo' => const Pertemuan5Page(),
      'checkbox_demo' => const Pertemuan6Page(),
      'radio_button_demo' => const Pertemuan7Page(),
      'dropdown_demo' => const Pertemuan8Page(),
      'date_time_picker_demo' => const Pertemuan9Page(),
      'navigation_demo' => const Pertemuan10Page(),
      _ => null,
    };

class _BlockCard extends StatelessWidget {
  const _BlockCard({
    required this.child,
    this.title,
    this.padding = const EdgeInsets.all(18),
  });

  final String? title;
  final Widget child;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE4E7EC)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title?.isNotEmpty == true) ...[
            Text(
              title!,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
            ),
            const SizedBox(height: 12),
          ],
          child,
        ],
      ),
    );
  }
}

class _EmptyContent extends StatelessWidget {
  const _EmptyContent();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.menu_book_outlined, size: 52, color: Color(0xFF98A2B3)),
            SizedBox(height: 12),
            Text(
              'Konten belum tersedia',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
            ),
            SizedBox(height: 6),
            Text(
              'Materi ini sudah dipublikasikan, tetapi belum memiliki blok konten.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Color(0xFF667085)),
            ),
          ],
        ),
      ),
    );
  }
}

class _MeetingLoadError extends StatelessWidget {
  const _MeetingLoadError({required this.error, required this.onRetry});

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
            const Icon(Icons.cloud_off_rounded, size: 48),
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
