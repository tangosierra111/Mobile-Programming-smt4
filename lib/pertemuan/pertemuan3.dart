import 'package:flutter/material.dart';

class Pertemuan3Page extends StatefulWidget {
  const Pertemuan3Page({super.key});

  @override
  State<Pertemuan3Page> createState() => _Pertemuan3PageState();
}

class _Pertemuan3PageState extends State<Pertemuan3Page> {
  static const Color _accentColor = Color(0xFF0891B2);
  static const Color _backgroundColor = Color(0xFFE6F7FB);

  final TextEditingController _kodeController =
      TextEditingController(text: 'PRD001');
  final TextEditingController _namaController =
      TextEditingController(text: 'Keyboard Mechanical');
  final TextEditingController _hargaController =
      TextEditingController(text: '750000');

  static const List<_FormTopic> _topics = [
    _FormTopic(
      title: 'Membuat Folder ui',
      description:
          'Halaman form dipisahkan ke folder lib/ui agar struktur project lebih rapi.',
      icon: Icons.folder_outlined,
    ),
    _FormTopic(
      title: 'Membuat produk_form.dart',
      description:
          'File produk_form.dart digunakan untuk menyusun input data produk.',
      icon: Icons.description_outlined,
    ),
    _FormTopic(
      title: 'Memisahkan Widget ke Fungsi',
      description:
          'TextField dan tombol dibuat dalam method terpisah agar kode mudah dibaca dan dikembangkan.',
      icon: Icons.call_split_outlined,
    ),
    _FormTopic(
      title: 'Membuat produk_detail.dart',
      description:
          'File detail digunakan untuk menerima dan menampilkan data yang dikirim dari halaman form.',
      icon: Icons.article_outlined,
    ),
    _FormTopic(
      title: 'TextEditingController',
      description:
          'Controller dipakai untuk mengambil nilai yang diketik pengguna pada TextField.',
      icon: Icons.edit_note_outlined,
    ),
  ];

  static const List<_FormTopic> _uiTopics = [
    _FormTopic(
      title: 'User Interface (UI)',
      description:
          'UI adalah tampilan yang dilihat dan digunakan pengguna saat berinteraksi dengan aplikasi.',
      icon: Icons.phone_android_outlined,
    ),
    _FormTopic(
      title: 'Widget Tree',
      description:
          'Flutter membangun UI secara deklaratif sebagai susunan pohon widget yang dapat diperbarui secara dinamis.',
      icon: Icons.account_tree_outlined,
    ),
    _FormTopic(
      title: 'StatelessWidget',
      description:
          'Widget yang tampilannya tidak berubah setelah dibuat, contohnya Text, Image, Icon, dan Container.',
      icon: Icons.lock_outline,
    ),
    _FormTopic(
      title: 'StatefulWidget',
      description:
          'Widget yang tampilannya dapat berubah selama aplikasi berjalan, seperti form input, counter, animasi, atau data dari API.',
      icon: Icons.sync_outlined,
    ),
  ];

  static const List<_WidgetCategory> _widgetCategories = [
    _WidgetCategory(
      title: 'Layout Widget',
      description: 'Mengatur posisi dan tata letak widget lain.',
      examples: 'Container, Row, Column, Stack, Expanded, Padding',
    ),
    _WidgetCategory(
      title: 'Material Widget',
      description: 'Membentuk struktur aplikasi bergaya Material Design.',
      examples:
          'Scaffold, AppBar, FloatingActionButton, Drawer, BottomNavigationBar',
    ),
    _WidgetCategory(
      title: 'Input Widget',
      description: 'Menerima input atau pilihan dari pengguna.',
      examples: 'TextField, Checkbox, Radio, Switch, Slider',
    ),
    _WidgetCategory(
      title: 'Display Widget',
      description: 'Menampilkan data atau informasi di layar.',
      examples: 'Text, Image, Icon, Card',
    ),
    _WidgetCategory(
      title: 'Navigation Widget',
      description: 'Mengatur perpindahan halaman atau tab aplikasi.',
      examples: 'Navigator, Route, TabBar',
    ),
  ];

  static const List<String> _buttonCharacteristics = [
    'Dapat ditekan oleh pengguna.',
    'Memiliki event handler seperti onPressed.',
    'Dapat berisi ikon, teks, atau kombinasi keduanya.',
    'Warna, ukuran, bentuk, dan efek animasi dapat dikustomisasi.',
  ];

  static const String _formCode = '''
final kodeController = TextEditingController();
final namaController = TextEditingController();
final hargaController = TextEditingController();

TextField(
  controller: kodeController,
  decoration: const InputDecoration(
    labelText: 'Kode Produk',
  ),
)
''';

  static const String _saveCode = '''
ElevatedButton(
  onPressed: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProdukDetail(
          kodeProduk: kodeController.text,
          namaProduk: namaController.text,
          hargaProduk: hargaController.text,
        ),
      ),
    );
  },
  child: const Text('Simpan'),
)
''';

  @override
  void dispose() {
    _kodeController.dispose();
    _namaController.dispose();
    _hargaController.dispose();
    super.dispose();
  }

  void _showProductDetail() {
    final kode = _kodeController.text.trim();
    final nama = _namaController.text.trim();
    final harga = _hargaController.text.trim();

    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Detail Produk'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Kode Produk: ${kode.isEmpty ? '-' : kode}'),
              Text('Nama Produk: ${nama.isEmpty ? '-' : nama}'),
              Text('Harga Produk: ${harga.isEmpty ? '-' : harga}'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Tutup'),
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
        title: const Text('Pertemuan 3 - UI, Button, dan Form'),
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
                    'UI, Widget, Button, dan Form Produk',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: _accentColor,
                          fontWeight: FontWeight.w800,
                        ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Pertemuan 3 membahas User Interface pada Flutter, widget '
                    'dan button sebagai komponen interaksi, lalu dilanjutkan '
                    'dengan pembuatan form produk menggunakan TextField dan '
                    'TextEditingController.',
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          _SectionTitle(
            title: 'User Interface dan Widget',
            style: Theme.of(context).textTheme,
          ),
          const SizedBox(height: 10),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _uiTopics.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              final topic = _uiTopics[index];
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
            title: 'Kategori Widget pada Flutter',
            style: Theme.of(context).textTheme,
          ),
          const SizedBox(height: 10),
          Card(
            child: Column(
              children: [
                for (var index = 0;
                    index < _widgetCategories.length;
                    index++) ...[
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
                      _widgetCategories[index].title,
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                    subtitle: Text(
                      '${_widgetCategories[index].description}\nContoh: ${_widgetCategories[index].examples}',
                    ),
                  ),
                  if (index != _widgetCategories.length - 1)
                    const Divider(height: 1),
                ],
              ],
            ),
          ),
          const SizedBox(height: 18),
          _SectionTitle(
            title: 'Button pada Flutter',
            style: Theme.of(context).textTheme,
          ),
          const SizedBox(height: 10),
          Card(
            child: Column(
              children: [
                const ListTile(
                  leading: CircleAvatar(
                    backgroundColor: _backgroundColor,
                    child: Icon(Icons.touch_app_outlined, color: _accentColor),
                  ),
                  title: Text('Pengertian Button'),
                  subtitle: Text(
                    'Button adalah widget yang memungkinkan pengguna '
                    'berinteraksi dengan aplikasi melalui sentuhan atau klik.',
                  ),
                ),
                const Divider(height: 1),
                for (var index = 0;
                    index < _buttonCharacteristics.length;
                    index++) ...[
                  ListTile(
                    leading: const Icon(
                      Icons.check_circle_outline,
                      color: _accentColor,
                    ),
                    title: Text(_buttonCharacteristics[index]),
                  ),
                  if (index != _buttonCharacteristics.length - 1)
                    const Divider(height: 1),
                ],
              ],
            ),
          ),
          const SizedBox(height: 18),
          _SectionTitle(
            title: 'Alur Materi',
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
            title: 'Contoh Form Interaktif',
            style: Theme.of(context).textTheme,
          ),
          const SizedBox(height: 10),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  TextField(
                    controller: _kodeController,
                    decoration: const InputDecoration(
                      labelText: 'Kode Produk',
                      prefixIcon: Icon(Icons.qr_code_2_outlined),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _namaController,
                    decoration: const InputDecoration(
                      labelText: 'Nama Produk',
                      prefixIcon: Icon(Icons.inventory_2_outlined),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _hargaController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Harga Produk',
                      prefixIcon: Icon(Icons.payments_outlined),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 14),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: _showProductDetail,
                      icon: const Icon(Icons.save_outlined),
                      label: const Text('Simpan dan Lihat Detail'),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 18),
          const _CodeCard(
            title: 'TextEditingController pada TextField',
            description:
                'Setiap TextField diberi controller supaya nilai input dapat dibaca saat tombol simpan ditekan.',
            code: _formCode,
          ),
          const SizedBox(height: 18),
          const _CodeCard(
            title: 'Tombol Simpan dan Navigasi Detail',
            description:
                'Pada contoh PDF, tombol simpan mengirim data dari form ke ProdukDetail menggunakan Navigator.push.',
            code: _saveCode,
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
                      'Kesimpulan sementara: form Flutter akan lebih mudah '
                      'dirawat jika input, tombol, dan halaman detail dipisah '
                      'dengan rapi. Controller menjadi penghubung utama antara '
                      'TextField dan data yang akan diproses.',
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

class _FormTopic {
  const _FormTopic({
    required this.title,
    required this.description,
    required this.icon,
  });

  final String title;
  final String description;
  final IconData icon;
}

class _WidgetCategory {
  const _WidgetCategory({
    required this.title,
    required this.description,
    required this.examples,
  });

  final String title;
  final String description;
  final String examples;
}
