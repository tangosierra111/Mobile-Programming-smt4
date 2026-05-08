import 'package:flutter/material.dart';

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
import '../pertemuan/pertemuan9.dart';
import '../pertemuan/uas_page.dart';
import '../pertemuan/uts_page.dart';

enum _DashboardViewMode { grid, list }

class BerandaPage extends StatefulWidget {
  const BerandaPage({super.key});

  @override
  State<BerandaPage> createState() => _BerandaPageState();
}

class _BerandaPageState extends State<BerandaPage> {
  _DashboardViewMode _viewMode = _DashboardViewMode.grid;
  String _searchQuery = '';
  final Set<int> _completedMeetings = {};

  static const List<_MeetingMenu> _menus = [
    _MeetingMenu(
      meetingNumber: 1,
      title: 'Pertemuan 1',
      color: Color(0xFF0A66C2),
      backgroundColor: Color(0xFFEAF4FF),
    ),
    _MeetingMenu(
      meetingNumber: 2,
      title: 'Pertemuan 2',
      color: Color(0xFF7C3AED),
      backgroundColor: Color(0xFFF3E8FF),
    ),
    _MeetingMenu(
      meetingNumber: 3,
      title: 'Pertemuan 3',
      color: Color(0xFF0891B2),
      backgroundColor: Color(0xFFE6F7FB),
    ),
    _MeetingMenu(
      meetingNumber: 4,
      title: 'Pertemuan 4',
      color: Color(0xFFDC2626),
      backgroundColor: Color(0xFFFEE2E2),
    ),
    _MeetingMenu(
      meetingNumber: 5,
      title: 'Pertemuan 5',
      color: Color(0xFF1E88E5),
      backgroundColor: Color(0xFFEAF4FF),
    ),
    _MeetingMenu(
      meetingNumber: 6,
      title: 'Pertemuan 6',
      color: Color(0xFF34A853),
      backgroundColor: Color(0xFFEAF7ED),
    ),
    _MeetingMenu(
      meetingNumber: 7,
      title: 'Pertemuan 7',
      color: Color(0xFFF59E0B),
      backgroundColor: Color(0xFFFFF5E5),
    ),
    _MeetingMenu(
      meetingNumber: 0,
      title: 'Ujian Tengah Semester (UTS)',
      color: Color(0xFF2563EB),
      backgroundColor: Color(0xFFEAF4FF),
    ),
    _MeetingMenu(
      meetingNumber: 8,
      title: 'Pertemuan 8',
      color: Color(0xFF8E24AA),
      backgroundColor: Color(0xFFF5EAF8),
    ),
    _MeetingMenu(
      meetingNumber: 9,
      title: 'Pertemuan 9',
      color: Color(0xFF0F766E),
      backgroundColor: Color(0xFFE6FFFA),
    ),
    _MeetingMenu(
      meetingNumber: 10,
      title: 'Pertemuan 10',
      color: Color(0xFF4338CA),
      backgroundColor: Color(0xFFEDEBFE),
    ),
    _MeetingMenu(
      meetingNumber: 11,
      title: 'Pertemuan 11',
      color: Color(0xFFBE123C),
      backgroundColor: Color(0xFFFFE4E6),
    ),
    _MeetingMenu(
      meetingNumber: 12,
      title: 'Pertemuan 12',
      color: Color(0xFFB45309),
      backgroundColor: Color(0xFFFEF3C7),
    ),
    _MeetingMenu(
      meetingNumber: 13,
      title: 'Pertemuan 13',
      color: Color(0xFF15803D),
      backgroundColor: Color(0xFFDCFCE7),
    ),
    _MeetingMenu(
      meetingNumber: 14,
      title: 'Pertemuan 14',
      color: Color(0xFF6D28D9),
      backgroundColor: Color(0xFFF3E8FF),
    ),
    _MeetingMenu(
      meetingNumber: 15,
      title: 'Ujian Akhir Semester (UAS)',
      color: Color(0xFF0F766E),
      backgroundColor: Color(0xFFE6FFFA),
    ),
  ];

  List<_MeetingMenu> get _filteredMenus {
    final query = _searchQuery.trim().toLowerCase();
    if (query.isEmpty) {
      return _menus;
    }

    return _menus.where((menu) => menu.matches(query)).toList();
  }

  double get _progressValue {
    if (_menus.isEmpty) {
      return 0;
    }

    return _completedMeetings.length / _menus.length;
  }

  void _showUnavailableContentSnackBar(_MeetingMenu menu) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '${menu.title} belum tersedia. Silakan hubungi dosen pengampu untuk informasi akses materi.',
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _toggleCompleted(_MeetingMenu menu) {
    if (!menu.isAvailable) {
      _showUnavailableContentSnackBar(menu);
      return;
    }

    setState(() {
      if (_completedMeetings.contains(menu.meetingNumber)) {
        _completedMeetings.remove(menu.meetingNumber);
      } else {
        _completedMeetings.add(menu.meetingNumber);
      }
    });
  }

  void _openMeeting(BuildContext context, _MeetingMenu menu) {
    final Widget? page = switch (menu.meetingNumber) {
      1 => const Pertemuan1Page(),
      2 => const Pertemuan2Page(),
      3 => const Pertemuan3Page(),
      4 => const Pertemuan4Page(),
      5 => const Pertemuan5Page(),
      6 => const Pertemuan6Page(),
      7 => const Pertemuan7Page(),
      0 => const UtsPage(),
      9 => const Pertemuan9Page(),
      10 => const Pertemuan10Page(),
      11 => const Pertemuan11Page(),
      12 => const Pertemuan12Page(),
      13 => const Pertemuan13Page(),
      14 => const Pertemuan14Page(),
      15 => const UasPage(),
      _ => null,
    };

    if (page != null) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => _MeetingDetailPage(
            menu: menu,
            isCompleted: _completedMeetings.contains(menu.meetingNumber),
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
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 10),
            child: Row(
              children: [
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Daftar Pertemuan',
                        style: TextStyle(
                          color: Color(0xFF111827),
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Pilih materi pembelajaran yang ingin dibuka.',
                        style: TextStyle(
                          color: Color(0xFF667085),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
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
                  style: SegmentedButton.styleFrom(
                    selectedBackgroundColor: const Color(0xFFEAF4FF),
                    selectedForegroundColor: const Color(0xFF0A66C2),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
            child: _ProgressSummary(
              completed: _completedMeetings.length,
              total: _menus.length,
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

  final List<_MeetingMenu> menus;
  final Set<int> completedMeetings;
  final ValueChanged<_MeetingMenu> onOpen;
  final ValueChanged<_MeetingMenu> onToggleCompleted;

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
              isCompleted: completedMeetings.contains(menu.meetingNumber),
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

  final List<_MeetingMenu> menus;
  final Set<int> completedMeetings;
  final ValueChanged<_MeetingMenu> onOpen;
  final ValueChanged<_MeetingMenu> onToggleCompleted;

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
          isCompleted: completedMeetings.contains(menu.meetingNumber),
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

  final _MeetingMenu menu;
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

  final _MeetingMenu menu;
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

  final _MeetingMenu menu;
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
            : 'Tandai selesai';

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

class _MeetingMenu {
  const _MeetingMenu({
    required this.meetingNumber,
    required this.title,
    required this.color,
    required this.backgroundColor,
  });

  final int meetingNumber;
  final String title;
  final Color color;
  final Color backgroundColor;

  bool get isExam => meetingNumber == 0 || meetingNumber == 15;
  bool get isUts => meetingNumber == 0;
  bool get isUas => meetingNumber == 15;
  bool get isAvailable => isUts || meetingNumber >= 1 && meetingNumber <= 7;
  IconData get icon => isExam ? Icons.school_rounded : Icons.menu_book_rounded;

  bool matches(String query) {
    return title.toLowerCase().contains(query) ||
        statusLabel.toLowerCase().contains(query) ||
        keywords.any((keyword) => keyword.toLowerCase().contains(query));
  }

  String get statusLabel {
    if (isUts) {
      return 'Ujian tersedia';
    }

    if (isUas) {
      return 'Ujian belum tersedia';
    }

    return isAvailable ? 'Materi tersedia' : 'Materi belum tersedia';
  }

  List<String> get keywords {
    return switch (meetingNumber) {
      1 => ['flutter', 'pengenalan', 'dart', 'widget'],
      2 => ['hello world', 'materialapp', 'scaffold', 'row', 'column'],
      3 => ['ui', 'button', 'form', 'textfield', 'controller'],
      4 => ['toast', 'snackbar', 'alertdialog', 'dialog'],
      5 => ['listview', 'builder', 'separated', 'horizontal'],
      6 => ['checkbox', 'checkboxlisttile', 'tristate'],
      7 => ['radio', 'radiobutton', 'radiolisttile'],
      0 => ['uts', 'ujian tengah semester', 'evaluasi'],
      15 => ['uas', 'ujian akhir semester', 'evaluasi'],
      _ => ['belum tersedia', 'placeholder'],
    };
  }
}
