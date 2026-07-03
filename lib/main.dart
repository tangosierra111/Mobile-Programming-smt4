import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

import 'auth/login_page.dart';
import 'core/network/api_client.dart';
import 'firebase_options.dart';
import 'models/profile_data.dart';
import 'page/beranda_page.dart';
import 'page/profile_editor_page.dart';
import 'page/profile_page.dart';
import 'repositories/learning_repository.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  if (!kIsWeb) {
    await GoogleSignIn.instance.initialize();
  }
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
      home: const AuthGate(),
    );
  }
}

class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  bool _isLocalAdminLoggedIn = false;

  void _loginLocalAdmin() {
    setState(() {
      _isLocalAdminLoggedIn = true;
    });
  }

  Future<void> _logout() async {
    if (_isLocalAdminLoggedIn) {
      setState(() {
        _isLocalAdminLoggedIn = false;
      });
      return;
    }

    await FirebaseAuth.instance.signOut();
    if (!kIsWeb) {
      try {
        await GoogleSignIn.instance.signOut();
      } catch (_) {
        // Email/password users may not have an active Google session.
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLocalAdminLoggedIn) {
      return AppShell(onLogout: _logout);
    }

    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final user = snapshot.data;
        if (user == null) {
          return LoginPage(onLocalAdminLogin: _loginLocalAdmin);
        }

        return AppShell(
          authUser: user,
          onLogout: _logout,
        );
      },
    );
  }
}

class AppShell extends StatefulWidget {
  const AppShell({
    super.key,
    this.authUser,
    required this.onLogout,
  });

  final User? authUser;
  final VoidCallback onLogout;

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _currentIndex = 0;
  ProfileData _profile = ProfileData.initial;
  late final ApiClient _apiClient;
  late final LearningRepository _learningRepository;

  @override
  void initState() {
    super.initState();
    _apiClient = ApiClient();
    _learningRepository = LearningRepository(_apiClient);
  }

  @override
  void dispose() {
    _apiClient.close();
    super.dispose();
  }

  void _changeTab(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void _saveProfile(ProfileData profile) {
    setState(() {
      _profile = profile;
      _currentIndex = 2;
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
        repository: widget.authUser == null ? null : _learningRepository,
      ),
      ProfileEditorPage(
        profile: _profile,
        onSave: _saveProfile,
        onDelete: _clearProfile,
      ),
      ProfilePage(
        profile: _profile,
        authUser: widget.authUser,
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
        title: Text(
          switch (_currentIndex) {
            0 => 'Dashboard',
            1 => 'Editor Profil',
            _ => 'Profil',
          },
          style: const TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            onPressed: widget.onLogout,
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
          ),
        ],
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
              icon: const Icon(Icons.edit_document),
              title: const Text('Editor'),
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
