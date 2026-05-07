import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Pertemuan4Page extends StatelessWidget {
  const Pertemuan4Page({super.key});

  static const Color _accentColor = Color(0xFFDC2626);
  static const Color _backgroundColor = Color(0xFFFEE2E2);

  static const List<_Topic> _topics = [
    _Topic(
      title: 'Toast pada Flutter',
      description:
          'Toast adalah pesan kecil yang muncul sementara untuk memberi informasi cepat tanpa mengganggu aktivitas utama pengguna.',
      icon: Icons.notifications_active_outlined,
    ),
    _Topic(
      title: 'Snackbar',
      description:
          'Snackbar menampilkan pesan singkat di bagian bawah layar dan biasanya terhubung dengan ScaffoldMessenger.',
      icon: Icons.message_outlined,
    ),
    _Topic(
      title: 'AlertDialog',
      description:
          'AlertDialog adalah popup dialog untuk konfirmasi aksi, informasi penting, atau input sederhana.',
      icon: Icons.warning_amber_rounded,
    ),
    _Topic(
      title: 'Latihan Struktur Halaman',
      description:
          'Materi latihan menggunakan folder page dan file seperti beranda_page.dart serta profile_page.dart.',
      icon: Icons.folder_copy_outlined,
    ),
  ];

  static const List<_PropertyInfo> _toastProperties = [
    _PropertyInfo(name: 'msg', function: 'Pesan yang ditampilkan.'),
    _PropertyInfo(name: 'toastLength', function: 'Durasi Toast.'),
    _PropertyInfo(name: 'gravity', function: 'Posisi Toast di layar.'),
    _PropertyInfo(
      name: 'backgroundColor',
      function: 'Warna latar belakang Toast.',
    ),
    _PropertyInfo(name: 'textColor', function: 'Warna teks Toast.'),
    _PropertyInfo(name: 'fontSize', function: 'Ukuran font Toast.'),
  ];

  static const List<_PropertyInfo> _dialogProperties = [
    _PropertyInfo(name: 'title', function: 'Judul dialog.'),
    _PropertyInfo(name: 'content', function: 'Isi atau pesan dialog.'),
    _PropertyInfo(name: 'actions', function: 'Tombol aksi pada dialog.'),
    _PropertyInfo(name: 'shape', function: 'Bentuk dialog, misalnya rounded.'),
    _PropertyInfo(
      name: 'backgroundColor',
      function: 'Warna latar belakang dialog.',
    ),
    _PropertyInfo(name: 'elevation', function: 'Bayangan dialog.'),
    _PropertyInfo(
        name: 'insetPadding', function: 'Jarak dialog ke tepi layar.'),
  ];

  static const String _toastCode = '''
Fluttertoast.showToast(
  msg: 'Data berhasil disimpan',
  toastLength: Toast.LENGTH_SHORT,
  gravity: ToastGravity.BOTTOM,
  backgroundColor: Colors.black87,
  textColor: Colors.white,
  fontSize: 16,
);
''';

  static const String _snackbarCode = '''
ScaffoldMessenger.of(context).showSnackBar(
  const SnackBar(
    content: Text('Profil berhasil diperbarui'),
    behavior: SnackBarBehavior.floating,
  ),
);
''';

  static const String _dialogCode = '''
showDialog(
  context: context,
  builder: (context) {
    return AlertDialog(
      title: const Text('Konfirmasi'),
      content: const Text('Apakah data ingin disimpan?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Batal'),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Simpan'),
        ),
      ],
    );
  },
);
''';

  void _showToast() {
    Fluttertoast.showToast(
      msg: 'Data berhasil disimpan',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: _accentColor,
      textColor: Colors.white,
      fontSize: 16,
    );
  }

  void _showSnackbar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Ini contoh Snackbar pada Flutter'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showAlertDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Konfirmasi Hapus Data'),
          content: const Text(
            'AlertDialog cocok digunakan untuk meminta persetujuan pengguna sebelum menjalankan aksi penting.',
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context),
              style: FilledButton.styleFrom(backgroundColor: _accentColor),
              child: const Text('Hapus'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Pertemuan 4 - Toast dan AlertDialog'),
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
                    'Toast, Snackbar, dan AlertDialog',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: _accentColor,
                          fontWeight: FontWeight.w800,
                        ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Pertemuan 4 membahas cara menampilkan pesan dan dialog '
                    'pada Flutter. Materi ini digunakan agar aplikasi dapat '
                    'memberikan feedback seperti berhasil, error, konfirmasi, '
                    'atau informasi penting kepada pengguna.',
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
                backgroundColor: _backgroundColor,
                child: Icon(Icons.school_outlined, color: _accentColor),
              ),
              title: Text('Memahami Toast dan Snackbar pada Flutter'),
              subtitle: Text(
                'Mahasiswa diharapkan mampu memahami Toast, Snackbar, '
                'AlertDialog, serta penggunaannya pada pemrograman Android '
                'dengan Flutter.',
              ),
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
            title: 'Contoh Interaktif',
            style: Theme.of(context).textTheme,
          ),
          const SizedBox(height: 10),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  FilledButton.icon(
                    onPressed: _showToast,
                    icon: const Icon(Icons.notifications_outlined),
                    label: const Text('Toast'),
                    style: FilledButton.styleFrom(
                      backgroundColor: _accentColor,
                    ),
                  ),
                  OutlinedButton.icon(
                    onPressed: () => _showSnackbar(context),
                    icon: const Icon(Icons.message_outlined),
                    label: const Text('Snackbar'),
                  ),
                  OutlinedButton.icon(
                    onPressed: () => _showAlertDialog(context),
                    icon: const Icon(Icons.warning_amber_rounded),
                    label: const Text('AlertDialog'),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 18),
          _SectionTitle(
            title: 'Parameter Toast',
            style: Theme.of(context).textTheme,
          ),
          const SizedBox(height: 10),
          const _PropertyList(properties: _toastProperties),
          const SizedBox(height: 18),
          _SectionTitle(
            title: 'Properti AlertDialog',
            style: Theme.of(context).textTheme,
          ),
          const SizedBox(height: 10),
          const _PropertyList(properties: _dialogProperties),
          const SizedBox(height: 18),
          const _CodeCard(
            title: 'Contoh Toast',
            description:
                'Flutter tidak memiliki Toast bawaan, sehingga pada materi ini digunakan package fluttertoast.',
            code: _toastCode,
          ),
          const SizedBox(height: 18),
          const _CodeCard(
            title: 'Contoh Snackbar',
            description:
                'Snackbar dapat dipakai tanpa package tambahan karena sudah tersedia melalui ScaffoldMessenger.',
            code: _snackbarCode,
          ),
          const SizedBox(height: 18),
          const _CodeCard(
            title: 'Contoh AlertDialog',
            description:
                'AlertDialog digunakan untuk konfirmasi aksi seperti hapus data, logout, atau menyimpan perubahan.',
            code: _dialogCode,
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
                      'Kesimpulan: Toast dan Snackbar cocok untuk feedback '
                      'singkat, sedangkan AlertDialog cocok untuk informasi '
                      'penting atau konfirmasi sebelum aksi dijalankan.',
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

class _PropertyList extends StatelessWidget {
  const _PropertyList({required this.properties});

  final List<_PropertyInfo> properties;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          for (var index = 0; index < properties.length; index++) ...[
            ListTile(
              leading: CircleAvatar(
                backgroundColor: Pertemuan4Page._backgroundColor,
                child: Text(
                  '${index + 1}',
                  style: const TextStyle(
                    color: Pertemuan4Page._accentColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              title: Text(
                properties[index].name,
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
              subtitle: Text(properties[index].function),
            ),
            if (index != properties.length - 1) const Divider(height: 1),
          ],
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

class _PropertyInfo {
  const _PropertyInfo({
    required this.name,
    required this.function,
  });

  final String name;
  final String function;
}
