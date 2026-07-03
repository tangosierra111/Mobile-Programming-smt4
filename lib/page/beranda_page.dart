import 'package:flutter/material.dart';

import '../data/local_learning_data.dart';
import '../models/learning_item.dart';
import '../models/user_meeting_progress.dart';
import '../pertemuan/pertemuan1.dart';
import '../pertemuan/pertemuan10.dart';
import '../pertemuan/pertemuan11.dart';
import '../pertemuan/pertemuan12.dart';
import '../pertemuan/pertemuan13.dart';
import '../pertemuan/pertemuan14.dart';
import '../pertemuan/pertemuan2.dart';
import '../pertemuan/pertemuan3.dart';
import '../pertemuan/pertemuan4.dart';
import '../pertemuan/pertemuan5.dart';
import '../pertemuan/pertemuan6.dart';
import '../pertemuan/pertemuan7.dart';
import '../pertemuan/pertemuan8.dart';
import '../pertemuan/pertemuan9.dart';
import '../pertemuan/uas_page.dart';
import '../pertemuan/uts_page.dart';
import '../repositories/learning_repository.dart';
import '../repositories/content_repository.dart';
import 'student_meeting_page.dart';

enum _DashboardViewMode { grid, list }

class BerandaPage extends StatefulWidget {
  const BerandaPage({
    super.key,
    this.items = localLearningItems,
    this.repository,
    this.contentRepository,
    this.courseId = 1,
  });

  final List<LearningItem> items;
  final LearningRepository? repository;
  final ContentRepository? contentRepository;
  final int courseId;

  @override
  State<BerandaPage> createState() => _BerandaPageState();
}

class _BerandaPageState extends State<BerandaPage> {
  _DashboardViewMode _viewMode = _DashboardViewMode.grid;
  String _searchQuery = '';
  final Set<String> _completedMeetings = {};
  late List<LearningItem> _menus;
  bool _isLoading = false;
  String? _loadError;
  bool _usesApiData = false;

  @override
  void initState() {
    super.initState();
    _menus = List.of(widget.items);
    _restoreCompletedItems();
    if (widget.repository != null) {
      _loadDashboard();
    }
  }

  void _restoreCompletedItems() {
    _completedMeetings
      ..clear()
      ..addAll(
        _menus
            .where((item) => item.progress?.isCompleted == true)
            .map((item) => item.id),
      );
  }

  Future<void> _loadDashboard() async {
    setState(() {
      _isLoading = true;
      _loadError = null;
    });

    try {
      final dashboard =
          await widget.repository!.fetchDashboard(widget.courseId);
      if (!mounted) return;
      setState(() {
        _menus = dashboard.items;
        _usesApiData = true;
        _restoreCompletedItems();
      });
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _usesApiData = false;
        _loadError = 'API gagal dimuat: $error Data lokal tetap ditampilkan.';
      });
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  List<LearningItem> get _filteredMenus {
    final query = _searchQuery.trim().toLowerCase();
    if (query.isEmpty) {
      return _menus;
    }

    return _menus.where((menu) => menu.matches(query)).toList();
  }

  double get _progressValue {
    final publishedMeetingIds = _menus
        .where((item) => !item.isExam && item.isAvailable)
        .map((item) => item.id)
        .toSet();
    if (publishedMeetingIds.isEmpty) {
      return 0;
    }
    final completed = _completedMeetings.intersection(publishedMeetingIds);
    return completed.length / publishedMeetingIds.length;
  }

  int get _publishedMeetingCount =>
      _menus.where((item) => !item.isExam && item.isAvailable).length;

  int get _completedPublishedMeetingCount {
    final publishedMeetingIds = _menus
        .where((item) => !item.isExam && item.isAvailable)
        .map((item) => item.id)
        .toSet();
    return _completedMeetings.intersection(publishedMeetingIds).length;
  }

  void _showUnavailableContentSnackBar(LearningItem menu) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '${menu.title} belum tersedia. Silakan hubungi dosen pengampu untuk informasi akses materi.',
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> _toggleCompleted(LearningItem menu) async {
    if (!menu.isAvailable) {
      _showUnavailableContentSnackBar(menu);
      return;
    }

    final wasCompleted = _completedMeetings.contains(menu.id);
    setState(() {
      if (wasCompleted) {
        _completedMeetings.remove(menu.id);
      } else {
        _completedMeetings.add(menu.id);
      }
    });

    final repository = widget.repository;
    final meetingId = menu.sourceId;
    if (repository == null || meetingId == null || menu.isExam) return;

    try {
      await repository.updateProgress(
        meetingId: meetingId,
        status: wasCompleted
            ? MeetingProgressStatus.notStarted
            : MeetingProgressStatus.completed,
        progressPercent: wasCompleted ? 0 : 100,
      );
    } catch (_) {
      if (!mounted) return;
      setState(() {
        if (wasCompleted) {
          _completedMeetings.add(menu.id);
        } else {
          _completedMeetings.remove(menu.id);
        }
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Progres gagal disimpan ke server.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  void _openMeeting(BuildContext context, LearningItem menu) {
    if (!menu.isAvailable) {
      _showUnavailableContentSnackBar(menu);
      return;
    }

    final contentRepository = widget.contentRepository;
    if (!menu.isExam && contentRepository != null && menu.sourceId != null) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => StudentMeetingPage(
            meetingId: menu.sourceId!,
            repository: contentRepository,
          ),
        ),
      );
      return;
    }

    final Widget? page = switch (menu.routeKey) {
      'meeting-1' => const Pertemuan1Page(),
      'meeting-2' => const Pertemuan2Page(),
      'meeting-3' => const Pertemuan3Page(),
      'meeting-4' => const Pertemuan4Page(),
      'meeting-5' => const Pertemuan5Page(),
      'meeting-6' => const Pertemuan6Page(),
      'meeting-7' => const Pertemuan7Page(),
      'exam-uts' => const UtsPage(),
      'meeting-8' => const Pertemuan8Page(),
      'meeting-9' => const Pertemuan9Page(),
      'meeting-10' => const Pertemuan10Page(),
      'meeting-11' => const Pertemuan11Page(),
      'meeting-12' => const Pertemuan12Page(),
      'meeting-13' => const Pertemuan13Page(),
      'meeting-14' => const Pertemuan14Page(),
      'exam-uas' => const UasPage(),
      _ => null,
    };

    if (page != null) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => _MeetingDetailPage(
            menu: menu,
            isCompleted: _completedMeetings.contains(menu.id),
            onToggleCompleted: () => _toggleCompleted(menu),
            child: page,
          ),
        ),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '${menu.title} belum tersedia. Silakan hubungi dosen pengampu untuk informasi akses materi.',
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filteredMenus = _filteredMenus;

    return SafeArea(
      top: false,
      child: Column(
        children: [
          if (_isLoading) const LinearProgressIndicator(minHeight: 2),
          if (_loadError != null)
            Container(
              width: double.infinity,
              color: const Color(0xFFFFF7ED),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Text(
                _loadError!,
                style: const TextStyle(
                  color: Color(0xFF9A3412),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 10),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Daftar Pertemuan',
                        style: TextStyle(
                          color: Color(0xFF111827),
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Pilih materi pembelajaran yang ingin dibuka.',
                        style: TextStyle(
                          color: Color(0xFF667085),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      _DataSourceBadge(usesApi: _usesApiData),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                SegmentedButton<_DashboardViewMode>(
                  showSelectedIcon: false,
                  segments: const [
                    ButtonSegment(
                      value: _DashboardViewMode.grid,
                      icon: Icon(Icons.grid_view_rounded),
                      tooltip: 'Grid view',
                    ),
                    ButtonSegment(
                      value: _DashboardViewMode.list,
                      icon: Icon(Icons.view_list_rounded),
                      tooltip: 'List view',
                    ),
                  ],
                  selected: {_viewMode},
                  onSelectionChanged: (selection) {
                    setState(() {
                      _viewMode = selection.first;
                    });
                  },
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.resolveWith(
                      (states) {
                        if (states.contains(WidgetState.selected)) {
                          return const Color(0xFFEAF4FF);
                        }
                        return Colors.white;
                      },
                    ),
                    foregroundColor: WidgetStateProperty.resolveWith(
                      (states) {
                        if (states.contains(WidgetState.selected)) {
                          return const Color(0xFF0A66C2);
                        }
                        return const Color(0xFF667085);
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
            child: _ProgressSummary(
              completed: _completedPublishedMeetingCount,
              total: _publishedMeetingCount,
              progressValue: _progressValue,
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
              decoration: InputDecoration(
                hintText: 'Cari materi, contoh: Form, Toast, Pertemuan 6',
                prefixIcon: const Icon(Icons.search_rounded),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(color: Color(0xFFD0D5DD)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(color: Color(0xFFD0D5DD)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(
                    color: Color(0xFF0A66C2),
                    width: 1.2,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 220),
              child: filteredMenus.isEmpty
                  ? _EmptySearchResult(
                      key: ValueKey('empty-search-$_searchQuery'),
                      query: _searchQuery,
                    )
                  : _viewMode == _DashboardViewMode.grid
                      ? _MeetingGrid(
                          key: const ValueKey('meeting-grid'),
                          menus: filteredMenus,
                          completedMeetings: _completedMeetings,
                          onOpen: (menu) => _openMeeting(context, menu),
                          onToggleCompleted: _toggleCompleted,
                        )
                      : _MeetingList(
                          key: const ValueKey('meeting-list'),
                          menus: filteredMenus,
                          completedMeetings: _completedMeetings,
                          onOpen: (menu) => _openMeeting(context, menu),
                          onToggleCompleted: _toggleCompleted,
                        ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DataSourceBadge extends StatelessWidget {
  const _DataSourceBadge({required this.usesApi});

  final bool usesApi;

  @override
  Widget build(BuildContext context) {
    final foreground =
        usesApi ? const Color(0xFF047857) : const Color(0xFF667085);
    final background =
        usesApi ? const Color(0xFFD1FAE5) : const Color(0xFFF2F4F7);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        usesApi ? 'Data Laravel API' : 'Data lokal',
        style: TextStyle(
          color: foreground,
          fontSize: 12,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _ProgressSummary extends StatelessWidget {
  const _ProgressSummary({
    required this.completed,
    required this.total,
    required this.progressValue,
  });

  final int completed;
  final int total;
  final double progressValue;

  @override
  Widget build(BuildContext context) {
    final percent = (progressValue * 100).round();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A0F172A),
            blurRadius: 12,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.trending_up_rounded, color: Color(0xFF0A66C2)),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Progress Belajar',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF111827),
                      ),
                ),
              ),
              Text(
                '$completed/$total selesai',
                style: const TextStyle(
                  color: Color(0xFF0A66C2),
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              minHeight: 9,
              value: progressValue,
              backgroundColor: const Color(0xFFEAF4FF),
              valueColor: const AlwaysStoppedAnimation(Color(0xFF0A66C2)),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '$percent% materi sudah ditandai selesai.',
            style: const TextStyle(
              color: Color(0xFF667085),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptySearchResult extends StatelessWidget {
  const _EmptySearchResult({
    super.key,
    required this.query,
  });

  final String query;

  @override
  Widget build(BuildContext context) {
    return Center(
      key: key,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.search_off_rounded,
              color: Color(0xFF98A2B3),
              size: 48,
            ),
            const SizedBox(height: 12),
            const Text(
              'Materi tidak ditemukan',
              style: TextStyle(
                color: Color(0xFF111827),
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Tidak ada hasil untuk "$query".',
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Color(0xFF667085),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MeetingGrid extends StatelessWidget {
  const _MeetingGrid({
    super.key,
    required this.menus,
    required this.completedMeetings,
    required this.onOpen,
    required this.onToggleCompleted,
  });

  final List<LearningItem> menus;
  final Set<String> completedMeetings;
  final ValueChanged<LearningItem> onOpen;
  final ValueChanged<LearningItem> onToggleCompleted;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount = switch (constraints.maxWidth) {
          >= 1100 => 4,
          >= 760 => 3,
          _ => 2,
        };

        final childAspectRatio = switch (crossAxisCount) {
          4 => 1.45,
          3 => 1.25,
          _ => 1.0,
        };

        return GridView.builder(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
          itemCount: menus.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            mainAxisSpacing: 18,
            crossAxisSpacing: 18,
            childAspectRatio: childAspectRatio,
          ),
          itemBuilder: (context, index) {
            final menu = menus[index];
            return _MeetingCard(
              menu: menu,
              isCompleted: completedMeetings.contains(menu.id),
              onTap: () => onOpen(menu),
              onToggleCompleted: () => onToggleCompleted(menu),
            );
          },
        );
      },
    );
  }
}

class _MeetingList extends StatelessWidget {
  const _MeetingList({
    super.key,
    required this.menus,
    required this.completedMeetings,
    required this.onOpen,
    required this.onToggleCompleted,
  });

  final List<LearningItem> menus;
  final Set<String> completedMeetings;
  final ValueChanged<LearningItem> onOpen;
  final ValueChanged<LearningItem> onToggleCompleted;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
      itemCount: menus.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final menu = menus[index];
        return _MeetingListTile(
          menu: menu,
          isCompleted: completedMeetings.contains(menu.id),
          onTap: () => onOpen(menu),
          onToggleCompleted: () => onToggleCompleted(menu),
        );
      },
    );
  }
}

class _MeetingListTile extends StatelessWidget {
  const _MeetingListTile({
    required this.menu,
    required this.isCompleted,
    required this.onTap,
    required this.onToggleCompleted,
  });

  final LearningItem menu;
  final bool isCompleted;
  final VoidCallback onTap;
  final VoidCallback onToggleCompleted;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      elevation: 1.5,
      shadowColor: const Color(0x12000000),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: menu.backgroundColor,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  menu.icon,
                  color: menu.color,
                  size: 30,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      menu.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Color(0xFF111827),
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      menu.statusLabel,
                      style: TextStyle(
                        color: menu.isAvailable
                            ? const Color(0xFF15803D)
                            : const Color(0xFF667085),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                color: menu.color,
              ),
              const SizedBox(width: 4),
              Checkbox(
                value: isCompleted,
                activeColor: menu.color,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
                onChanged: (_) => onToggleCompleted(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MeetingCard extends StatelessWidget {
  const _MeetingCard({
    required this.menu,
    required this.isCompleted,
    required this.onTap,
    required this.onToggleCompleted,
  });

  final LearningItem menu;
  final bool isCompleted;
  final VoidCallback onTap;
  final VoidCallback onToggleCompleted;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      elevation: 2,
      shadowColor: const Color(0x16000000),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          children: [
            Positioned.fill(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(14, 18, 14, 14),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: 52,
                        height: 52,
                        decoration: BoxDecoration(
                          color: menu.backgroundColor,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          menu.icon,
                          color: menu.color,
                          size: 30,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        menu.title,
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Color(0xFF111827),
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        isCompleted ? 'Selesai' : 'Belum selesai',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: isCompleted
                              ? const Color(0xFF15803D)
                              : Colors.grey,
                          fontWeight: FontWeight.w700,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              top: 8,
              right: 8,
              child: IconButton(
                onPressed: onToggleCompleted,
                tooltip:
                    isCompleted ? 'Tandai belum selesai' : 'Tandai selesai',
                style: IconButton.styleFrom(
                  backgroundColor:
                      isCompleted ? const Color(0xFFDCFCE7) : Colors.grey[100],
                ),
                icon: Icon(
                  isCompleted
                      ? Icons.check_circle_rounded
                      : Icons.radio_button_unchecked_rounded,
                  color: isCompleted ? const Color(0xFF15803D) : Colors.grey,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MeetingDetailPage extends StatefulWidget {
  const _MeetingDetailPage({
    required this.menu,
    required this.isCompleted,
    required this.onToggleCompleted,
    required this.child,
  });

  final LearningItem menu;
  final bool isCompleted;
  final VoidCallback onToggleCompleted;
  final Widget child;

  @override
  State<_MeetingDetailPage> createState() => _MeetingDetailPageState();
}

class _MeetingDetailPageState extends State<_MeetingDetailPage> {
  final GlobalKey<ScaffoldMessengerState> _detailMessengerKey =
      GlobalKey<ScaffoldMessengerState>();
  late bool _isCompleted;

  @override
  void initState() {
    super.initState();
    _isCompleted = widget.isCompleted;
  }

  void _toggleCompleted() {
    if (!widget.menu.isAvailable) {
      _detailMessengerKey.currentState
        ?..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text(
              '${widget.menu.title} belum tersedia. Silakan hubungi dosen pengampu untuk informasi akses materi.',
            ),
            behavior: SnackBarBehavior.floating,
          ),
        );
      return;
    }

    setState(() {
      _isCompleted = !_isCompleted;
    });
    widget.onToggleCompleted();
  }

  @override
  Widget build(BuildContext context) {
    final isAvailable = widget.menu.isAvailable;
    final buttonColor = !isAvailable
        ? const Color(0xFF667085)
        : _isCompleted
            ? const Color(0xFF15803D)
            : widget.menu.color;
    final buttonIcon = !isAvailable
        ? Icons.lock_clock_rounded
        : _isCompleted
            ? Icons.check_circle_rounded
            : Icons.check_circle_outline_rounded;
    final buttonLabel = !isAvailable
        ? widget.menu.statusLabel
        : _isCompleted
            ? 'Materi sudah selesai'
            : 'Tandai Selesai';

    return ScaffoldMessenger(
      key: _detailMessengerKey,
      child: Column(
        children: [
          Expanded(child: widget.child),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
              child: Material(
                color: Colors.transparent,
                child: SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: _toggleCompleted,
                    style: FilledButton.styleFrom(
                      backgroundColor: buttonColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      elevation: 4,
                    ),
                    icon: Icon(buttonIcon),
                    label: Text(
                      buttonLabel,
                      style: const TextStyle(fontWeight: FontWeight.w800),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

extension _LearningItemPresentation on LearningItem {
  Color get color => Color(accentColorValue);
  Color get backgroundColor => Color(backgroundColorValue);
  IconData get icon => isExam ? Icons.school_rounded : Icons.menu_book_rounded;
}
