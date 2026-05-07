import 'package:flutter/material.dart';

class Pertemuan6Page extends StatefulWidget {
  const Pertemuan6Page({super.key});

  @override
  State<Pertemuan6Page> createState() => _Pertemuan6PageState();
}

class _Pertemuan6PageState extends State<Pertemuan6Page> {
  bool _basicCheckbox = false;
  bool _termsAccepted = false;
  bool? _triStateCheckbox;

  static const List<_CheckboxTopic> _topics = [
    _CheckboxTopic(
      title: 'Checkbox',
      description:
          'Widget input untuk memilih opsi boolean, yaitu true atau false.',
      icon: Icons.check_box_outline_blank_rounded,
    ),
    _CheckboxTopic(
      title: 'CheckboxListTile',
      description:
          'Checkbox yang sudah dilengkapi teks label dan susunan layout rapi.',
      icon: Icons.fact_check_outlined,
    ),
    _CheckboxTopic(
      title: 'Tri-State Checkbox',
      description: 'Checkbox dengan tiga keadaan: true, false, dan null.',
      icon: Icons.indeterminate_check_box_outlined,
    ),
  ];

  static const List<_CheckboxMethod> _methods = [
    _CheckboxMethod(
      method: 'onChanged',
      function: 'Dipanggil saat checkbox diklik.',
    ),
    _CheckboxMethod(
      method: 'setState()',
      function: 'Memperbarui UI setelah nilai berubah.',
    ),
    _CheckboxMethod(
      method: 'onChanged: null',
      function: 'Menonaktifkan checkbox.',
    ),
    _CheckboxMethod(
      method: 'tristate + onChanged',
      function: 'Mengaktifkan tiga state: true, false, dan null.',
    ),
    _CheckboxMethod(
      method: 'fillColor',
      function: 'Menentukan warna checkbox berdasarkan state.',
    ),
    _CheckboxMethod(
      method: 'mouseCursor',
      function: 'Mengubah cursor saat hover.',
    ),
    _CheckboxMethod(
      method: 'overlayColor',
      function: 'Mengatur warna efek saat ditekan atau hover.',
    ),
  ];

  String get _triStateLabel {
    return switch (_triStateCheckbox) {
      true => 'true (dicentang)',
      false => 'false (tidak dicentang)',
      null => 'null (sebagian/tidak pasti)',
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Pertemuan 6 - Checkbox'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            color: const Color(0xFFEAF7ED),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Ringkasan Materi',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF176B2C),
                        ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Pertemuan 6 membahas penggunaan Checkbox pada Flutter. '
                    'Checkbox digunakan untuk memilih opsi bernilai boolean '
                    '(true/false), terutama pada form, pengaturan, atau daftar '
                    'pilihan yang memungkinkan pengguna memilih satu atau lebih opsi.',
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
                backgroundColor: Color(0xFFEAF7ED),
                child: Icon(
                  Icons.school_outlined,
                  color: Color(0xFF34A853),
                ),
              ),
              title: Text('Memahami Checkbox pada Flutter'),
              subtitle: Text(
                'Mahasiswa diharapkan mampu memahami konsep Checkbox serta '
                'penggunaannya pada pemrograman Android dengan Flutter.',
              ),
            ),
          ),
          const SizedBox(height: 18),
          _SectionTitle(
            title: 'Jenis Checkbox pada Flutter',
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
                    backgroundColor: Colors.green.shade50,
                    child: Icon(
                      topic.icon,
                      color: const Color(0xFF34A853),
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
            title: 'Method dan Properti Penting',
            style: Theme.of(context).textTheme,
          ),
          const SizedBox(height: 10),
          Card(
            child: Column(
              children: [
                for (var index = 0; index < _methods.length; index++) ...[
                  ListTile(
                    leading: CircleAvatar(
                      backgroundColor: const Color(0xFFEAF7ED),
                      child: Text(
                        '${index + 1}',
                        style: const TextStyle(
                          color: Color(0xFF176B2C),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    title: Text(
                      _methods[index].method,
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                    subtitle: Text(_methods[index].function),
                  ),
                  if (index != _methods.length - 1) const Divider(height: 1),
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
                children: [
                  CheckboxListTile(
                    value: _basicCheckbox,
                    activeColor: const Color(0xFF34A853),
                    title: const Text('Checkbox Dasar'),
                    subtitle: Text(
                      _basicCheckbox ? 'Status: true' : 'Status: false',
                    ),
                    controlAffinity: ListTileControlAffinity.leading,
                    onChanged: (value) {
                      setState(() {
                        _basicCheckbox = value ?? false;
                      });
                    },
                  ),
                  const Divider(height: 1),
                  CheckboxListTile(
                    value: _termsAccepted,
                    activeColor: const Color(0xFF34A853),
                    title: const Text('CheckboxListTile'),
                    subtitle: const Text(
                      'Contoh pilihan dengan label dan deskripsi.',
                    ),
                    controlAffinity: ListTileControlAffinity.leading,
                    onChanged: (value) {
                      setState(() {
                        _termsAccepted = value ?? false;
                      });
                    },
                  ),
                  const Divider(height: 1),
                  CheckboxListTile(
                    tristate: true,
                    value: _triStateCheckbox,
                    activeColor: const Color(0xFF34A853),
                    title: const Text('Tri-State Checkbox'),
                    subtitle: Text('Status: $_triStateLabel'),
                    controlAffinity: ListTileControlAffinity.leading,
                    onChanged: (value) {
                      setState(() {
                        _triStateCheckbox = value;
                      });
                    },
                  ),
                  const Divider(height: 1),
                  const CheckboxListTile(
                    value: false,
                    title: Text('Checkbox Nonaktif'),
                    subtitle: Text(
                      'Contoh penggunaan onChanged: null.',
                    ),
                    controlAffinity: ListTileControlAffinity.leading,
                    onChanged: null,
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

class _CheckboxTopic {
  const _CheckboxTopic({
    required this.title,
    required this.description,
    required this.icon,
  });

  final String title;
  final String description;
  final IconData icon;
}

class _CheckboxMethod {
  const _CheckboxMethod({
    required this.method,
    required this.function,
  });

  final String method;
  final String function;
}
