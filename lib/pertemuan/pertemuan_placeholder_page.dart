import 'package:flutter/material.dart';

class PertemuanPlaceholderPage extends StatelessWidget {
  const PertemuanPlaceholderPage({
    super.key,
    required this.meetingNumber,
    required this.title,
    required this.accentColor,
    required this.backgroundColor,
    required this.sections,
  });

  final int meetingNumber;
  final String title;
  final Color accentColor;
  final Color backgroundColor;
  final List<PertemuanPlaceholderSection> sections;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('Pertemuan $meetingNumber'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            color: backgroundColor,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: accentColor,
                          fontWeight: FontWeight.w800,
                        ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Tampilan awal sudah disiapkan. Konten materi bisa '
                    'ditambahkan setelah detail pertemuan dibagikan.',
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Daftar Konten',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: 10),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: sections.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              final section = sections[index];
              return Card(
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: backgroundColor,
                    child: Icon(
                      section.icon,
                      color: accentColor,
                    ),
                  ),
                  title: Text(section.title),
                  subtitle: Text(section.description),
                ),
              );
            },
          ),
          const SizedBox(height: 18),
          Text(
            'Status Materi',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: 10),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: backgroundColor,
                    child: Icon(
                      Icons.pending_actions_rounded,
                      color: accentColor,
                    ),
                  ),
                  const SizedBox(width: 14),
                  const Expanded(
                    child: Text(
                      'Menunggu isi konten dari pertemuan ini.',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class PertemuanPlaceholderSection {
  const PertemuanPlaceholderSection({
    required this.title,
    required this.description,
    required this.icon,
  });

  final String title;
  final String description;
  final IconData icon;
}
