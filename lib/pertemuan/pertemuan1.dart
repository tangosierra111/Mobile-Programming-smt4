import 'package:flutter/material.dart';

class Pertemuan1Page extends StatelessWidget {
  const Pertemuan1Page({super.key});

  static const Color _accentColor = Color(0xFF0A66C2);
  static const Color _backgroundColor = Color(0xFFEAF4FF);

  static const List<_FlutterTopic> _topics = [
    _FlutterTopic(
      title: 'Apa itu Flutter?',
      description:
          'Flutter adalah framework dari Google untuk membuat aplikasi mobile, web, dan desktop menggunakan satu basis kode.',
      icon: Icons.flutter_dash_rounded,
    ),
    _FlutterTopic(
      title: 'Bahasa Pemrograman Dart',
      description:
          'Flutter menggunakan Dart, bahasa yang mendukung pemrograman berorientasi objek dan cocok untuk membangun antarmuka modern.',
      icon: Icons.code_rounded,
    ),
    _FlutterTopic(
      title: 'Widget sebagai Dasar UI',
      description:
          'Di Flutter, hampir semua bagian tampilan adalah widget, mulai dari teks, tombol, gambar, layout, sampai halaman.',
      icon: Icons.widgets_outlined,
    ),
    _FlutterTopic(
      title: 'Hot Reload',
      description:
          'Hot reload membantu developer melihat perubahan kode dengan cepat tanpa menjalankan ulang aplikasi dari awal.',
      icon: Icons.flash_on_rounded,
    ),
  ];

  static const List<String> _advantages = [
    'Satu kode dapat digunakan untuk beberapa platform.',
    'Tampilan aplikasi konsisten dan mudah dikustomisasi.',
    'Proses pengembangan lebih cepat dengan hot reload.',
    'Memiliki banyak widget siap pakai untuk membangun UI.',
    'Didukung komunitas dan dokumentasi yang luas.',
  ];

  static const List<_LearningGoal> _learningGoals = [
    _LearningGoal(
      title: 'Memahami pengertian Flutter',
      description:
          'Mahasiswa mengenal Flutter sebagai framework lintas platform.',
    ),
    _LearningGoal(
      title: 'Mengenal konsep widget',
      description:
          'Mahasiswa memahami bahwa tampilan Flutter dibangun dari kumpulan widget.',
    ),
    _LearningGoal(
      title: 'Mengenal struktur awal aplikasi',
      description:
          'Mahasiswa mengetahui fungsi dasar main(), runApp(), dan MaterialApp.',
    ),
  ];

  static const String _sampleCode = '''
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: Center(
          child: Text('Halo Flutter'),
        ),
      ),
    );
  }
}
''';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Pertemuan 1 - Pengenalan Flutter'),
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
                    'Pengenalan Flutter',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: _accentColor,
                          fontWeight: FontWeight.w800,
                        ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Pada pertemuan ini kita mengenal Flutter sebagai framework '
                    'untuk membangun aplikasi modern. Materi berfokus pada '
                    'pengertian Flutter, fungsi Dart, konsep widget, dan struktur '
                    'awal aplikasi Flutter.',
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          _SectionTitle(
            title: 'Tujuan Pembelajaran',
            style: Theme.of(context).textTheme,
          ),
          const SizedBox(height: 10),
          Card(
            child: Column(
              children: [
                for (var index = 0; index < _learningGoals.length; index++) ...[
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
                      _learningGoals[index].title,
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                    subtitle: Text(_learningGoals[index].description),
                  ),
                  if (index != _learningGoals.length - 1)
                    const Divider(height: 1),
                ],
              ],
            ),
          ),
          const SizedBox(height: 18),
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
                    child: Icon(
                      topic.icon,
                      color: _accentColor,
                    ),
                  ),
                  title: Text(topic.title),
                  subtitle: Text(topic.description),
                ),
              );
            },
          ),
          const SizedBox(height: 18),
          _SectionTitle(
            title: 'Kelebihan Flutter',
            style: Theme.of(context).textTheme,
          ),
          const SizedBox(height: 10),
          Card(
            child: Column(
              children: [
                for (var index = 0; index < _advantages.length; index++) ...[
                  ListTile(
                    leading: const Icon(
                      Icons.check_circle_outline,
                      color: _accentColor,
                    ),
                    title: Text(_advantages[index]),
                  ),
                  if (index != _advantages.length - 1) const Divider(height: 1),
                ],
              ],
            ),
          ),
          const SizedBox(height: 18),
          _SectionTitle(
            title: 'Struktur Dasar Aplikasi',
            style: Theme.of(context).textTheme,
          ),
          const SizedBox(height: 10),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Contoh kode sederhana berikut menampilkan teks "Halo Flutter" di tengah layar.',
                  ),
                  const SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: const Color(0xFF111827),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      _sampleCode,
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'monospace',
                        height: 1.35,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 18),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  const CircleAvatar(
                    backgroundColor: _backgroundColor,
                    child: Icon(
                      Icons.lightbulb_outline,
                      color: _accentColor,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Text(
                      'Kesimpulan: Flutter memudahkan developer membuat aplikasi '
                      'dengan tampilan menarik, performa baik, dan basis kode yang '
                      'dapat dipakai di berbagai platform.',
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
      style: style.titleMedium?.copyWith(
        fontWeight: FontWeight.w700,
      ),
    );
  }
}

class _FlutterTopic {
  const _FlutterTopic({
    required this.title,
    required this.description,
    required this.icon,
  });

  final String title;
  final String description;
  final IconData icon;
}

class _LearningGoal {
  const _LearningGoal({
    required this.title,
    required this.description,
  });

  final String title;
  final String description;
}
