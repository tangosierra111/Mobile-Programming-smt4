import 'package:flutter/material.dart';

class Pertemuan7Page extends StatefulWidget {
  const Pertemuan7Page({super.key});

  @override
  State<Pertemuan7Page> createState() => _Pertemuan7PageState();
}

class _Pertemuan7PageState extends State<Pertemuan7Page> {
  String _selectedCategory = 'Mahasiswa';
  String _selectedSize = 'M';
  String? _selectedTheme = 'Terang';

  static const List<_RadioTopic> _topics = [
    _RadioTopic(
      title: 'RadioButton',
      description:
          'Komponen UI untuk memilih satu opsi saja dari sekumpulan pilihan.',
      icon: Icons.radio_button_checked,
    ),
    _RadioTopic(
      title: 'RadioListTile',
      description:
          'Radio yang sudah lengkap dengan title, subtitle, dan area tap satu baris.',
      icon: Icons.list_alt_outlined,
    ),
    _RadioTopic(
      title: 'Radio Horizontal',
      description:
          'Radio yang disusun horizontal, cocok untuk pilihan sedikit seperti ukuran atau rating.',
      icon: Icons.swap_horiz,
    ),
    _RadioTopic(
      title: 'Radio Toggleable',
      description:
          'Radio yang bisa di-unselect dengan mengeklik pilihan yang sama lagi.',
      icon: Icons.touch_app_outlined,
    ),
  ];

  static const List<_RadioProperty> _properties = [
    _RadioProperty(
      property: 'value',
      function: 'Nilai dari radio tersebut.',
    ),
    _RadioProperty(
      property: 'groupValue',
      function: 'Nilai yang sedang dipilih dalam satu grup radio.',
    ),
    _RadioProperty(
      property: 'onChanged',
      function: 'Fungsi yang dijalankan saat radio dipilih.',
    ),
    _RadioProperty(
      property: 'activeColor',
      function: 'Mengatur warna radio saat aktif.',
    ),
    _RadioProperty(
      property: 'toggleable',
      function: 'Membuat radio bisa dipilih ulang untuk menghapus pilihan.',
    ),
  ];

  static const List<String> _useCases = [
    'Formulir pilihan tunggal seperti jenis kelamin, status, atau kategori.',
    'Pengaturan preferensi pengguna.',
    'Kuis atau survei dengan satu jawaban benar.',
    'Filter atau penyaringan data.',
    'Konfigurasi aplikasi seperti mode gelap atau terang.',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Pertemuan 7 - RadioButton'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            color: const Color(0xFFFFF5E5),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Ringkasan Materi',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF92400E),
                        ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Pertemuan 7 membahas penggunaan RadioButton pada Flutter. '
                    'RadioButton digunakan ketika pengguna hanya boleh memilih '
                    'satu opsi dari beberapa pilihan yang tersedia.',
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
          const Card(
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Color(0xFFFFF5E5),
                child: Icon(
                  Icons.school_outlined,
                  color: Color(0xFFF59E0B),
                ),
              ),
              title: Text('Memahami RadioButton pada Flutter'),
              subtitle: Text(
                'Mahasiswa diharapkan mampu memahami konsep RadioButton serta '
                'penggunaannya pada pemrograman Android dengan Flutter.',
              ),
            ),
          ),
          const SizedBox(height: 18),
          _SectionTitle(
            title: 'Kapan RadioButton Digunakan?',
            style: Theme.of(context).textTheme,
          ),
          const SizedBox(height: 10),
          Card(
            child: Column(
              children: [
                for (var index = 0; index < _useCases.length; index++) ...[
                  ListTile(
                    leading: CircleAvatar(
                      backgroundColor: const Color(0xFFFFF5E5),
                      child: Text(
                        '${index + 1}',
                        style: const TextStyle(
                          color: Color(0xFF92400E),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    title: Text(_useCases[index]),
                  ),
                  if (index != _useCases.length - 1) const Divider(height: 1),
                ],
              ],
            ),
          ),
          const SizedBox(height: 18),
          _SectionTitle(
            title: 'Jenis RadioButton',
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
                    backgroundColor: Colors.orange.shade50,
                    child: Icon(
                      topic.icon,
                      color: const Color(0xFFF59E0B),
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
            title: 'Properti Penting',
            style: Theme.of(context).textTheme,
          ),
          const SizedBox(height: 10),
          Card(
            child: Column(
              children: [
                for (var index = 0; index < _properties.length; index++) ...[
                  ListTile(
                    leading: CircleAvatar(
                      backgroundColor: const Color(0xFFFFF5E5),
                      child: Text(
                        '${index + 1}',
                        style: const TextStyle(
                          color: Color(0xFF92400E),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    title: Text(
                      _properties[index].property,
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                    subtitle: Text(_properties[index].function),
                  ),
                  if (index != _properties.length - 1) const Divider(height: 1),
                ],
              ],
            ),
          ),
          const SizedBox(height: 18),
          _SectionTitle(
            title: 'Contoh Interaktif',
            style: Theme.of(context).textTheme,
          ),
          const SizedBox(height: 10),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RadioListTile<String>(
                    value: 'Mahasiswa',
                    groupValue: _selectedCategory,
                    activeColor: const Color(0xFFF59E0B),
                    title: const Text('Mahasiswa'),
                    subtitle: const Text('Contoh pilihan kategori pengguna.'),
                    onChanged: (value) {
                      setState(() {
                        _selectedCategory = value ?? _selectedCategory;
                      });
                    },
                  ),
                  const Divider(height: 1),
                  RadioListTile<String>(
                    value: 'Dosen',
                    groupValue: _selectedCategory,
                    activeColor: const Color(0xFFF59E0B),
                    title: const Text('Dosen'),
                    subtitle: const Text(
                      'RadioListTile dapat dipilih lewat seluruh baris.',
                    ),
                    onChanged: (value) {
                      setState(() {
                        _selectedCategory = value ?? _selectedCategory;
                      });
                    },
                  ),
                  const Divider(height: 1),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 14, 16, 6),
                    child: Text(
                      'Radio Horizontal: ukuran $_selectedSize',
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 4, right: 4),
                    child: Wrap(
                      spacing: 8,
                      children: ['S', 'M', 'L'].map((size) {
                        return Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Radio<String>(
                              value: size,
                              groupValue: _selectedSize,
                              activeColor: const Color(0xFFF59E0B),
                              onChanged: (value) {
                                setState(() {
                                  _selectedSize = value ?? _selectedSize;
                                });
                              },
                            ),
                            Text(size),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                  const Divider(height: 1),
                  RadioListTile<String>(
                    toggleable: true,
                    value: 'Terang',
                    groupValue: _selectedTheme,
                    activeColor: const Color(0xFFF59E0B),
                    title: const Text('Radio Toggleable'),
                    subtitle: Text(
                      _selectedTheme == null
                          ? 'Status: null (tidak ada pilihan)'
                          : 'Status: $_selectedTheme',
                    ),
                    onChanged: (value) {
                      setState(() {
                        _selectedTheme = value;
                      });
                    },
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

class _RadioTopic {
  const _RadioTopic({
    required this.title,
    required this.description,
    required this.icon,
  });

  final String title;
  final String description;
  final IconData icon;
}

class _RadioProperty {
  const _RadioProperty({
    required this.property,
    required this.function,
  });

  final String property;
  final String function;
}
