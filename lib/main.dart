import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

import 'auth/login_page.dart';
import 'core/network/api_client.dart';
import 'firebase_options.dart';
import 'models/auth_session.dart';
import 'models/profile_data.dart';
import 'page/admin_content_page.dart';
import 'page/beranda_page.dart';
import 'page/profile_editor_page.dart';
import 'page/profile_page.dart';
import 'repositories/auth_repository.dart';
import 'repositories/content_repository.dart';
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
  late final AuthRepository _authRepository;
  late final ContentRepository _contentRepository;
  late final LearningRepository _learningRepository;
  late Future<AuthSession?> _apiSessionFuture;

  @override
  void initState() {
    super.initState();
    _apiClient = ApiClient();
    _authRepository = AuthRepository(_apiClient);
    _contentRepository = ContentRepository(_apiClient);
    _learningRepository = LearningRepository(_apiClient);
    _apiSessionFuture = _initializeApiSession();
  }

  Future<AuthSession?> _initializeApiSession() async {
    final user = widget.authUser;
    if (user == null) return null;
    return _authRepository.sync(displayName: user.displayName);
  }

  void _retryApiSession() {
    setState(() {
      _apiSessionFuture = _initializeApiSession();
    });
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
    if (widget.authUser == null) {
      return _buildScaffold(null);
    }

    return FutureBuilder<AuthSession?>(
      future: _apiSessionFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (snapshot.hasError) {
          return Scaffold(
            body: _ApiConnectionError(
              error: snapshot.error!,
              onRetry: _retryApiSession,
            ),
          );
        }
        return _buildScaffold(snapshot.data);
      },
    );
  }

  Widget _buildScaffold(AuthSession? session) {
    final canManageContent = session?.canManageContent ?? false;
    final pages = [
      BerandaPage(
        repository: widget.authUser == null ? null : _learningRepository,
        contentRepository: widget.authUser == null ? null : _contentRepository,
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
      if (canManageContent)
        AdminContentPage(
          learningRepository: _learningRepository,
          contentRepository: _contentRepository,
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
            2 => 'Profil',
            _ => 'Kelola Materi',
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
      body: IndexedStack(index: _currentIndex, children: pages),
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
            if (canManageContent)
              SalomonBottomBarItem(
                icon: const Icon(Icons.dashboard_customize_outlined),
                title: const Text('Materi'),
                selectedColor: const Color(0xFF0A66C2),
              ),
          ],
        ),
      ),
    );
  }
}

class _ApiConnectionError extends StatelessWidget {
  const _ApiConnectionError({required this.error, required this.onRetry});

  final Object error;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.cloud_off_rounded, size: 52, color: Colors.orange),
            const SizedBox(height: 12),
            const Text(
              'Laravel API belum terhubung',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            Text(
              error.toString(),
              textAlign: TextAlign.center,
              style: const TextStyle(color: Color(0xFF667085)),
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Coba lagi'),
            ),
          ],
        ),
      ),
    );
  }
}
