import 'package:flutter/material.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

import 'profile_data.dart';
import 'page/beranda_page.dart';
import 'page/profile_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Pertemuan 4',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF0A66C2)),
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF3F6FB),
      ),
      home: const AppShell(),
    );
  }
}

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _currentIndex = 0;
  ProfileData _profile = ProfileData.initial;

  void _changeTab(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void _saveProfile(ProfileData profile) {
    setState(() {
      _profile = profile;
      _currentIndex = 1;
    });
  }

  void _clearProfile() {
    setState(() {
      _profile = ProfileData.empty;
    });
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      BerandaPage(
        profile: _profile,
        onSave: _saveProfile,
        onDelete: _clearProfile,
        onOpenProfile: () => _changeTab(1),
      ),
      ProfilePage(
        profile: _profile,
        onSave: _saveProfile,
        onBackHome: () => _changeTab(0),
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFF0A66C2),
        foregroundColor: Colors.white,
        centerTitle: true,
        title: const Text(
          'Pertemuan 4',
          style: TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: pages,
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Color(0x14000000),
              blurRadius: 16,
              offset: Offset(0, -4),
            ),
          ],
        ),
        padding: const EdgeInsets.fromLTRB(8, 8, 8, 14),
        child: SalomonBottomBar(
          currentIndex: _currentIndex,
          onTap: _changeTab,
          selectedItemColor: const Color(0xFF0A66C2),
          unselectedItemColor: const Color(0xFF667085),
          items: [
            SalomonBottomBarItem(
              icon: const Icon(Icons.home_outlined),
              title: const Text('Beranda'),
              selectedColor: const Color(0xFF0A66C2),
            ),
            SalomonBottomBarItem(
              icon: const Icon(Icons.person_outline),
              title: const Text('Profil'),
              selectedColor: const Color(0xFF0A66C2),
            ),
          ],
        ),
      ),
    );
  }
}
