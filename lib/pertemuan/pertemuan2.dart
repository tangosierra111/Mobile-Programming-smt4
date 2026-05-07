import 'package:flutter/material.dart';

class Pertemuan2Page extends StatelessWidget {
  const Pertemuan2Page({super.key});

  static const Color _accentColor = Color(0xFF7C3AED);
  static const Color _backgroundColor = Color(0xFFF3E8FF);

  static const List<_Topic> _topics = [
    _Topic(
      title: 'Membuat Hello World',
      description:
          'Mengenal struktur awal file main.dart dan menampilkan teks pertama di aplikasi Flutter.',
      icon: Icons.emoji_objects_outlined,
    ),
    _Topic(
      title: 'MaterialApp dan Scaffold',
      description:
          'MaterialApp membungkus aplikasi dengan tema Material Design, sedangkan Scaffold menyediakan struktur halaman.',
      icon: Icons.dashboard_customize_outlined,
    ),
    _Topic(
      title: 'AppBar dan Body',
      description:
          'AppBar digunakan sebagai bagian atas halaman, sementara body menjadi tempat isi utama aplikasi.',
      icon: Icons.web_asset_outlined,
    ),
    _Topic(
      title: 'Widget Column',
      description: 'Column menyusun widget secara vertikal dari atas ke bawah.',
      icon: Icons.view_column_outlined,
    ),
    _Topic(
      title: 'Widget Row',
      description: 'Row menyusun widget secara horizontal dari kiri ke kanan.',
      icon: Icons.view_week_outlined,
    ),
    _Topic(
      title: 'StatelessWidget dan StatefulWidget',
      description:
          'StatelessWidget tidak berubah setelah dibuat, sedangkan StatefulWidget dapat berubah saat aplikasi berjalan.',
      icon: Icons.change_circle_outlined,
    ),
  ];

  static const List<_Concept> _concepts = [
    _Concept(
      name: 'MyApp',
      meaning: 'Widget induk yang menjadi titik awal tampilan aplikasi.',
    ),
    _Concept(
      name: 'MaterialApp',
      meaning:
          'Widget utama untuk memakai tampilan dan navigasi bergaya Material Design.',
    ),
    _Concept(
      name: 'Scaffold',
      meaning:
          'Kerangka dasar halaman yang menyediakan appBar, body, drawer, dan bagian layout lainnya.',
    ),
    _Concept(
      name: 'AppBar',
      meaning: 'Widget untuk membuat bar bagian atas halaman.',
    ),
    _Concept(
      name: 'body',
      meaning: 'Area utama untuk menampilkan konten halaman.',
    ),
  ];

  static const String _helloWorldCode = '''
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Pertemuan 2'),
        ),
        body: Center(
          child: Text('Hello World'),
        ),
      ),
    );
  }
}
''';

  static const String _columnRowCode = '''
Column(
  children: const [
    Text('Baris pertama'),
    Text('Baris kedua'),
    Text('Baris ketiga'),
  ],
)

Row(
  mainAxisAlignment: MainAxisAlignment.center,
  children: const [
    Icon(Icons.home),
    SizedBox(width: 8),
    Text('Menu Home'),
  ],
)
''';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Pertemuan 2 - Dasar Widget Flutter'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            color: _backgroundColor,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Hello World dan Struktur Dasar Flutter',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: _accentColor,
                          fontWeight: FontWeight.w800,
                        ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Pertemuan 2 membahas cara membuat tampilan sederhana pada '
                    'Flutter, mengenal widget dasar, dan memahami perbedaan '
                    'StatelessWidget dengan StatefulWidget.',
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          _SectionTitle(
            title: 'Materi Utama',
            style: Theme.of(context).textTheme,
          ),
          const SizedBox(height: 10),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _topics.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              final topic = _topics[index];
              return Card(
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: _backgroundColor,
                    child: Icon(topic.icon, color: _accentColor),
                  ),
                  title: Text(topic.title),
                  subtitle: Text(topic.description),
                ),
              );
            },
          ),
          const SizedBox(height: 18),
          _SectionTitle(
            title: 'Konsep Widget Dasar',
            style: Theme.of(context).textTheme,
          ),
          const SizedBox(height: 10),
          Card(
            child: Column(
              children: [
                for (var index = 0; index < _concepts.length; index++) ...[
                  ListTile(
                    leading: CircleAvatar(
                      backgroundColor: _backgroundColor,
                      child: Text(
                        '${index + 1}',
                        style: const TextStyle(
                          color: _accentColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    title: Text(
                      _concepts[index].name,
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                    subtitle: Text(_concepts[index].meaning),
                  ),
                  if (index != _concepts.length - 1) const Divider(height: 1),
                ],
              ],
            ),
          ),
          const SizedBox(height: 18),
          const _CodeCard(
            title: 'Contoh Hello World',
            description:
                'Kode berikut menampilkan AppBar dan teks Hello World di tengah halaman.',
            code: _helloWorldCode,
          ),
          const SizedBox(height: 18),
          const _CodeCard(
            title: 'Contoh Column dan Row',
            description:
                'Column digunakan untuk susunan vertikal, sedangkan Row digunakan untuk susunan horizontal.',
            code: _columnRowCode,
          ),
          const SizedBox(height: 18),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CircleAvatar(
                    backgroundColor: _backgroundColor,
                    child: Icon(Icons.lightbulb_outline, color: _accentColor),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Text(
                      'Kesimpulan: Flutter membangun tampilan dari susunan '
                      'widget. Memahami MaterialApp, Scaffold, Column, Row, '
                      'dan jenis widget adalah dasar penting sebelum membuat '
                      'form dan navigasi.',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
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

class _CodeCard extends StatelessWidget {
  const _CodeCard({
    required this.title,
    required this.description,
    required this.code,
  });

  final String title;
  final String description;
  final String code;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
            ),
            const SizedBox(height: 8),
            Text(description),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFF111827),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                code,
                style: const TextStyle(
                  color: Colors.white,
                  fontFamily: 'monospace',
                  height: 1.35,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({
    required this.title,
    required this.style,
  });

  final String title;
  final TextTheme style;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: style.titleMedium?.copyWith(fontWeight: FontWeight.w700),
    );
  }
}

class _Topic {
  const _Topic({
    required this.title,
    required this.description,
    required this.icon,
  });

  final String title;
  final String description;
  final IconData icon;
}

class _Concept {
  const _Concept({
    required this.name,
    required this.meaning,
  });

  final String name;
  final String meaning;
}
