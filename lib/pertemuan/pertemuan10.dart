import 'package:flutter/material.dart';

class Pertemuan10Page extends StatefulWidget {
  const Pertemuan10Page({super.key});

  @override
  State<Pertemuan10Page> createState() => _Pertemuan10PageState();
}

class _Pertemuan10PageState extends State<Pertemuan10Page> {
  final PageController _pageController = PageController();
  int _pageIndex = 0;

  static const Color _accentColor = Color(0xFF4338CA);
  static const Color _softColor = Color(0xFFEDEBFE);

  static const List<_TopicInfo> _topics = [
    _TopicInfo(
      title: 'TabBar',
      description:
          'Widget menu tab untuk berpindah antar kategori dalam satu layar.',
      icon: Icons.tab_outlined,
    ),
    _TopicInfo(
      title: 'TabBarView',
      description:
          'Area konten yang berubah mengikuti tab yang sedang dipilih.',
      icon: Icons.view_carousel_outlined,
    ),
    _TopicInfo(
      title: 'PageView',
      description:
          'Widget untuk membuat halaman yang bisa digeser seperti onboarding atau carousel.',
      icon: Icons.swipe_outlined,
    ),
  ];

  static const List<_PropertyInfo> _tabBarProperties = [
    _PropertyInfo(property: 'tabs', function: 'Daftar tab yang ditampilkan.'),
    _PropertyInfo(
      property: 'indicatorColor',
      function: 'Warna garis indikator tab aktif.',
    ),
    _PropertyInfo(
      property: 'labelColor',
      function: 'Warna teks atau ikon tab aktif.',
    ),
    _PropertyInfo(
      property: 'unselectedLabelColor',
      function: 'Warna teks atau ikon tab tidak aktif.',
    ),
    _PropertyInfo(
      property: 'isScrollable',
      function: 'Membuat tab bisa digeser jika jumlah tab banyak.',
    ),
  ];

  static const List<_PropertyInfo> _pageViewProperties = [
    _PropertyInfo(
      property: 'controller',
      function: 'Mengontrol perpindahan halaman secara manual.',
    ),
    _PropertyInfo(property: 'children', function: 'Daftar halaman.'),
    _PropertyInfo(
      property: 'scrollDirection',
      function: 'Arah geser, horizontal atau vertical.',
    ),
    _PropertyInfo(
      property: 'onPageChanged',
      function: 'Event saat halaman berubah.',
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _goToPage(int index) {
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 280),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Pertemuan 10 - TabBar & PageView'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            color: _softColor,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'TabLayout dan ViewPage',
                    style: textTheme.titleLarge?.copyWith(
                      color: _accentColor,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Pertemuan ini membahas navigasi berbasis tab dan halaman '
                    'yang dapat digeser. Di Flutter, konsep TabLayout Android '
                    'biasanya dibuat menggunakan DefaultTabController, TabBar, '
                    'TabBarView, dan PageView.',
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 18),
          _SectionTitle(title: 'Tujuan Pembelajaran', style: textTheme),
          const SizedBox(height: 10),
          const Card(
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: _softColor,
                child: Icon(Icons.school_outlined, color: _accentColor),
              ),
              title: Text('Memahami TabLayout dan ViewPage pada Flutter'),
              subtitle: Text(
                'Mahasiswa mampu membuat navigasi tab dan halaman swipe '
                'untuk aplikasi mobile yang lebih rapi dan modern.',
              ),
            ),
          ),
          const SizedBox(height: 18),
          _SectionTitle(title: 'Topik Bahasan', style: textTheme),
          const SizedBox(height: 10),
          const _TopicList(topics: _topics),
          const SizedBox(height: 18),
          _SectionTitle(title: 'Demo TabBarView', style: textTheme),
          const SizedBox(height: 10),
          const _TabBarDemo(),
          const SizedBox(height: 18),
          _SectionTitle(title: 'Properti TabBar', style: textTheme),
          const SizedBox(height: 10),
          const _PropertyList(properties: _tabBarProperties),
          const SizedBox(height: 18),
          _SectionTitle(title: 'Demo PageView', style: textTheme),
          const SizedBox(height: 10),
          _PageViewDemo(
            controller: _pageController,
            pageIndex: _pageIndex,
            onPageChanged: (index) => setState(() => _pageIndex = index),
            onSelectPage: _goToPage,
          ),
          const SizedBox(height: 18),
          _SectionTitle(title: 'Properti PageView', style: textTheme),
          const SizedBox(height: 10),
          const _PropertyList(properties: _pageViewProperties),
          const SizedBox(height: 18),
          _SectionTitle(title: 'Latihan', style: textTheme),
          const SizedBox(height: 10),
          const _ExerciseCard(),
        ],
      ),
    );
  }
}

class _TabBarDemo extends StatelessWidget {
  const _TabBarDemo();

  @override
  Widget build(BuildContext context) {
    return const DefaultTabController(
      length: 3,
      child: Card(
        elevation: 3,
        child: SizedBox(
          height: 220,
          child: Column(
            children: [
              Material(
                color: _Pertemuan10PageState._softColor,
                child: TabBar(
                  indicatorColor: _Pertemuan10PageState._accentColor,
                  labelColor: _Pertemuan10PageState._accentColor,
                  unselectedLabelColor: Color(0xFF64748B),
                  tabs: [
                    Tab(text: 'Beranda'),
                    Tab(text: 'Profil'),
                    Tab(text: 'Setting'),
                  ],
                ),
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    _DemoPanel(
                      icon: Icons.home_outlined,
                      title: 'Halaman Beranda',
                      description: 'Konten utama aplikasi ditampilkan di sini.',
                    ),
                    _DemoPanel(
                      icon: Icons.person_outline,
                      title: 'Halaman Profil',
                      description: 'Informasi pengguna dan identitas akun.',
                    ),
                    _DemoPanel(
                      icon: Icons.settings_outlined,
                      title: 'Halaman Setting',
                      description: 'Pengaturan preferensi aplikasi.',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PageViewDemo extends StatelessWidget {
  const _PageViewDemo({
    required this.controller,
    required this.pageIndex,
    required this.onPageChanged,
    required this.onSelectPage,
  });

  final PageController controller;
  final int pageIndex;
  final ValueChanged<int> onPageChanged;
  final ValueChanged<int> onSelectPage;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            SizedBox(
              height: 180,
              child: PageView(
                controller: controller,
                onPageChanged: onPageChanged,
                children: const [
                  _DemoPanel(
                    icon: Icons.filter_1,
                    title: 'Onboarding',
                    description: 'PageView cocok untuk pengenalan fitur.',
                  ),
                  _DemoPanel(
                    icon: Icons.photo_library_outlined,
                    title: 'Gallery Foto',
                    description: 'Pengguna bisa menggeser konten gambar.',
                  ),
                  _DemoPanel(
                    icon: Icons.view_week_outlined,
                    title: 'Carousel',
                    description: 'Konten promosi dapat dibuat berurutan.',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (var index = 0; index < 3; index++)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: InkWell(
                      onTap: () => onSelectPage(index),
                      customBorder: const CircleBorder(),
                      child: CircleAvatar(
                        radius: 6,
                        backgroundColor: pageIndex == index
                            ? _Pertemuan10PageState._accentColor
                            : const Color(0xFFCBD5E1),
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _DemoPanel extends StatelessWidget {
  const _DemoPanel({
    required this.icon,
    required this.title,
    required this.description,
  });

  final IconData icon;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      alignment: Alignment.center,
      padding: const EdgeInsets.all(16),
      color: const Color(0xFFF8FAFC),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: _Pertemuan10PageState._softColor,
            child: Icon(
              icon,
              color: _Pertemuan10PageState._accentColor,
              size: 30,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: _Pertemuan10PageState._accentColor,
              fontWeight: FontWeight.w800,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            description,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Color(0xFF475569)),
          ),
        ],
      ),
    );
  }
}

class _TopicList extends StatelessWidget {
  const _TopicList({required this.topics});

  final List<_TopicInfo> topics;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          for (var index = 0; index < topics.length; index++) ...[
            ListTile(
              leading: CircleAvatar(
                backgroundColor: _Pertemuan10PageState._softColor,
                child: Icon(
                  topics[index].icon,
                  color: _Pertemuan10PageState._accentColor,
                ),
              ),
              title: Text(
                topics[index].title,
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
              subtitle: Text(topics[index].description),
            ),
            if (index != topics.length - 1) const Divider(height: 1),
          ],
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
                backgroundColor: _Pertemuan10PageState._softColor,
                child: Text(
                  '${index + 1}',
                  style: const TextStyle(
                    color: _Pertemuan10PageState._accentColor,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              title: Text(
                properties[index].property,
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

class _ExerciseCard extends StatelessWidget {
  const _ExerciseCard();

  @override
  Widget build(BuildContext context) {
    return const Card(
      child: Column(
        children: [
          ListTile(
            leading: CircleAvatar(
              backgroundColor: _Pertemuan10PageState._softColor,
              child: Icon(
                Icons.code_rounded,
                color: _Pertemuan10PageState._accentColor,
              ),
            ),
            title: Text('Buat 3 tab: Home, Profile, Settings'),
            subtitle: Text(
              'Gunakan DefaultTabController, TabBar, dan TabBarView.',
            ),
          ),
          Divider(height: 1),
          ListTile(
            leading: CircleAvatar(
              backgroundColor: _Pertemuan10PageState._softColor,
              child: Icon(
                Icons.swipe_outlined,
                color: _Pertemuan10PageState._accentColor,
              ),
            ),
            title: Text('Tambahkan PageView sederhana'),
            subtitle: Text(
              'Buat tiga halaman yang bisa digeser dan tampilkan indikator aktif.',
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
      style: style.titleLarge?.copyWith(
        color: _Pertemuan10PageState._accentColor,
        fontWeight: FontWeight.w700,
      ),
    );
  }
}

class _TopicInfo {
  const _TopicInfo({
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
    required this.property,
    required this.function,
  });

  final String property;
  final String function;
}
