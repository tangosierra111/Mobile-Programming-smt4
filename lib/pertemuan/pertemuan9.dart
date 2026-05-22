import 'package:flutter/material.dart';

class Pertemuan9Page extends StatefulWidget {
  const Pertemuan9Page({super.key});

  @override
  State<Pertemuan9Page> createState() => _Pertemuan9PageState();
}

class _Pertemuan9PageState extends State<Pertemuan9Page> {
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  DateTimeRange? _selectedRange;
  DateTime? _checkInDate;
  DateTime? _checkOutDate;

  static const Color _accentColor = Color(0xFF0F766E);
  static const Color _softColor = Color(0xFFE6FFFA);

  static const List<_TopicInfo> _topics = [
    _TopicInfo(
      title: 'showDatePicker()',
      description:
          'Dialog bawaan Flutter untuk memilih satu tanggal dari kalender.',
      icon: Icons.calendar_month_outlined,
    ),
    _TopicInfo(
      title: 'showTimePicker()',
      description:
          'Dialog bawaan Flutter untuk memilih jam dan menit dalam format dial atau input.',
      icon: Icons.access_time,
    ),
    _TopicInfo(
      title: 'showDateRangePicker()',
      description:
          'Dialog untuk memilih rentang tanggal, misalnya tanggal mulai dan selesai booking.',
      icon: Icons.date_range_outlined,
    ),
  ];

  static const List<_ParameterInfo> _dateParameters = [
    _ParameterInfo(
      parameter: 'initialDate',
      function: 'Tanggal awal yang sudah terpilih saat dialog dibuka.',
    ),
    _ParameterInfo(
      parameter: 'firstDate / lastDate',
      function: 'Batas tanggal paling awal dan paling akhir yang bisa dipilih.',
    ),
    _ParameterInfo(
      parameter: 'selectableDayPredicate',
      function:
          'Fungsi untuk menonaktifkan hari tertentu, misalnya disable weekend.',
    ),
  ];

  static const List<_ParameterInfo> _timeParameters = [
    _ParameterInfo(
      parameter: 'initialTime',
      function: 'Waktu awal yang ditampilkan saat dialog dibuka.',
    ),
    _ParameterInfo(
      parameter: 'initialEntryMode',
      function: 'Mengatur tampilan awal picker, misalnya dial atau input teks.',
    ),
    _ParameterInfo(
      parameter: 'TimePickerEntryMode.dial',
      function: 'Tampilan jam analog sebagai mode default.',
    ),
    _ParameterInfo(
      parameter: 'TimePickerEntryMode.input',
      function: 'Tampilan input teks untuk mengisi jam dan menit.',
    ),
  ];

  static const List<String> _useCases = [
    'Form booking ruangan, hotel, atau layanan.',
    'Jadwal kegiatan dan pengingat agenda.',
    'Sistem absensi berbasis tanggal dan jam.',
    'Pemesanan tiket dengan tanggal keberangkatan.',
  ];

  static const List<_ParameterInfo> _hotelValidations = [
    _ParameterInfo(
      parameter: 'Check-in tidak boleh sebelum hari ini',
      function:
          'Pengguna hanya boleh memilih tanggal sekarang atau masa depan.',
    ),
    _ParameterInfo(
      parameter: 'Check-out harus setelah check-in',
      function:
          'Tanggal keluar tidak boleh sama atau lebih awal dari tanggal masuk.',
    ),
    _ParameterInfo(
      parameter: 'Check-in dan check-out wajib dipilih',
      function:
          'Sistem perlu memastikan kedua tanggal terisi sebelum booking diproses.',
    ),
    _ParameterInfo(
      parameter: 'Ketersediaan kamar harus dicek',
      function:
          'Sistem perlu memastikan kamar masih tersedia pada rentang tanggal tersebut.',
    ),
    _ParameterInfo(
      parameter: 'Maksimal lama menginap dibatasi',
      function:
          'Contohnya maksimal 30 hari agar sesuai aturan pemesanan hotel.',
    ),
  ];

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? now,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      helpText: 'Pilih tanggal kegiatan',
    );

    if (pickedDate == null) return;

    setState(() {
      _selectedDate = pickedDate;
    });
  }

  Future<void> _pickWorkday() async {
    final now = DateTime.now();
    final initialDate = _nextWorkday(_selectedDate ?? now);
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      selectableDayPredicate: (date) {
        return date.weekday != DateTime.saturday &&
            date.weekday != DateTime.sunday;
      },
      helpText: 'Pilih hari kerja',
    );

    if (pickedDate == null) return;

    setState(() {
      _selectedDate = pickedDate;
    });
  }

  Future<void> _pickTime() async {
    final pickedTime = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? TimeOfDay.now(),
      initialEntryMode: TimePickerEntryMode.dial,
      helpText: 'Pilih waktu kegiatan',
    );

    if (pickedTime == null) return;

    setState(() {
      _selectedTime = pickedTime;
    });
  }

  Future<void> _pickRange() async {
    final now = DateTime.now();
    final pickedRange = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      initialDateRange: _selectedRange ??
          DateTimeRange(
            start: now,
            end: now.add(const Duration(days: 2)),
          ),
      helpText: 'Pilih rentang tanggal',
    );

    if (pickedRange == null) return;

    setState(() {
      _selectedRange = pickedRange;
    });
  }

  Future<void> _pickCheckInDate() async {
    final today = _today();
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _checkInDate ?? today,
      firstDate: today,
      lastDate: today.add(const Duration(days: 365)),
      helpText: 'Pilih tanggal check-in',
    );

    if (pickedDate == null) return;

    setState(() {
      _checkInDate = pickedDate;
      if (_checkOutDate != null && !_checkOutDate!.isAfter(pickedDate)) {
        _checkOutDate = null;
      }
    });
  }

  Future<void> _pickCheckOutDate() async {
    if (_checkInDate == null) {
      _showMessage('Pilih tanggal check-in terlebih dahulu.');
      return;
    }

    final firstCheckOut = _checkInDate!.add(const Duration(days: 1));
    final lastCheckOut = _checkInDate!.add(const Duration(days: 30));
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _checkOutDate ?? firstCheckOut,
      firstDate: firstCheckOut,
      lastDate: lastCheckOut,
      helpText: 'Pilih tanggal check-out',
    );

    if (pickedDate == null) return;

    setState(() {
      _checkOutDate = pickedDate;
    });
  }

  void _validateHotelBooking() {
    if (_checkInDate == null || _checkOutDate == null) {
      _showMessage('Tanggal check-in dan check-out tidak boleh kosong.');
      return;
    }

    final stayDuration = _checkOutDate!.difference(_checkInDate!).inDays;
    if (stayDuration <= 0) {
      _showMessage('Tanggal check-out harus lebih besar dari check-in.');
      return;
    }

    if (stayDuration > 30) {
      _showMessage('Maksimal lama menginap adalah 30 hari.');
      return;
    }

    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          title: const Row(
            children: [
              Icon(Icons.hotel, color: _accentColor),
              SizedBox(width: 10),
              Text('Booking Valid'),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _ResultRow(
                icon: Icons.login,
                label: 'Check-in',
                value: _formatDate(_checkInDate),
              ),
              const SizedBox(height: 10),
              _ResultRow(
                icon: Icons.logout,
                label: 'Check-out',
                value: _formatDate(_checkOutDate),
              ),
              const SizedBox(height: 10),
              _ResultRow(
                icon: Icons.nights_stay,
                label: 'Durasi',
                value: '$stayDuration malam',
              ),
              const SizedBox(height: 10),
              const _ResultRow(
                icon: Icons.meeting_room,
                label: 'Ketersediaan',
                value: 'Contoh validasi: kamar tersedia.',
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.warning_amber_rounded, color: Colors.white),
            const SizedBox(width: 10),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.red.shade600,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  DateTime _today() {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }

  DateTime _nextWorkday(DateTime date) {
    var result = DateTime(date.year, date.month, date.day);
    while (result.weekday == DateTime.saturday ||
        result.weekday == DateTime.sunday) {
      result = result.add(const Duration(days: 1));
    }
    return result;
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'Belum dipilih';
    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  String _formatRange(DateTimeRange? range) {
    if (range == null) return 'Belum dipilih';
    return '${_formatDate(range.start)} - ${_formatDate(range.end)}';
  }

  String _formatTime(TimeOfDay? time) {
    if (time == null) return 'Belum dipilih';
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  void _showScheduleResult() {
    if (_selectedDate == null || _selectedTime == null) {
      _showMessage('Pilih tanggal dan waktu terlebih dahulu.');
      return;
    }

    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          title: const Row(
            children: [
              Icon(Icons.event_available, color: _accentColor),
              SizedBox(width: 10),
              Text('Jadwal Tersimpan'),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _ResultRow(
                icon: Icons.calendar_today,
                label: 'Tanggal',
                value: _formatDate(_selectedDate),
              ),
              const SizedBox(height: 10),
              _ResultRow(
                icon: Icons.access_time,
                label: 'Waktu',
                value: _formatTime(_selectedTime),
              ),
              const SizedBox(height: 10),
              _ResultRow(
                icon: Icons.date_range,
                label: 'Rentang',
                value: _formatRange(_selectedRange),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
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
        title: const Text('Pertemuan 9 - Date & Time Picker'),
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
                    'Ringkasan Materi',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: _accentColor,
                        ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Pertemuan 9 membahas Date dan Time Picker pada Flutter. '
                    'Widget ini mempermudah pengguna memilih tanggal, waktu, '
                    'atau rentang tanggal tanpa perlu mengetik manual.',
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
                backgroundColor: _softColor,
                child: Icon(Icons.school_outlined, color: _accentColor),
              ),
              title: Text('Memahami Date dan Time Picker pada Flutter'),
              subtitle: Text(
                'Mahasiswa diharapkan mampu menggunakan showDatePicker, '
                'showTimePicker, dan showDateRangePicker pada aplikasi Android.',
              ),
            ),
          ),
          const SizedBox(height: 18),
          _SectionTitle(
            title: 'Topik Bahasan',
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
                    backgroundColor: _softColor,
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
            title: 'Biasa Digunakan Pada',
            style: Theme.of(context).textTheme,
          ),
          const SizedBox(height: 10),
          Card(
            child: Column(
              children: [
                for (var index = 0; index < _useCases.length; index++) ...[
                  ListTile(
                    leading: CircleAvatar(
                      backgroundColor: _softColor,
                      child: Text(
                        '${index + 1}',
                        style: const TextStyle(
                          color: _accentColor,
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
            title: 'Parameter showDatePicker()',
            style: Theme.of(context).textTheme,
          ),
          const SizedBox(height: 10),
          const _ParameterList(parameters: _dateParameters),
          const SizedBox(height: 18),
          _SectionTitle(
            title: 'Parameter showTimePicker()',
            style: Theme.of(context).textTheme,
          ),
          const SizedBox(height: 10),
          const _ParameterList(parameters: _timeParameters),
          const SizedBox(height: 18),
          _SectionTitle(
            title: 'Studi Kasus Booking Hotel',
            style: Theme.of(context).textTheme,
          ),
          const SizedBox(height: 10),
          Card(
            color: _softColor,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Mengapa DatePicker Penting?',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: _accentColor,
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Pada aplikasi booking hotel, pengguna harus memilih '
                    'tanggal check-in dan check-out dengan benar. DatePicker '
                    'membantu pilihan tanggal menjadi lebih rapi, sedangkan '
                    'validasi memastikan booking tidak salah, tidak bentrok, '
                    'dan sesuai aturan sistem hotel.',
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          const _ParameterList(parameters: _hotelValidations),
          const SizedBox(height: 10),
          Card(
            elevation: 3,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: _softColor,
                        child: Icon(Icons.hotel, color: _accentColor),
                      ),
                      SizedBox(width: 12),
                      Text(
                        'Simulasi Booking Hotel',
                        style: TextStyle(
                          color: _accentColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  _PickerTile(
                    icon: Icons.login,
                    title: 'Tanggal Check-in',
                    value: _formatDate(_checkInDate),
                    buttonLabel: 'Pilih Check-in',
                    onPressed: _pickCheckInDate,
                  ),
                  const SizedBox(height: 12),
                  _PickerTile(
                    icon: Icons.logout,
                    title: 'Tanggal Check-out',
                    value: _formatDate(_checkOutDate),
                    buttonLabel: 'Pilih Check-out',
                    onPressed: _pickCheckOutDate,
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Aturan contoh: check-in mulai hari ini, check-out harus '
                    'setelah check-in, dan maksimal lama menginap 30 hari.',
                  ),
                  const SizedBox(height: 18),
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton.icon(
                      onPressed: _validateHotelBooking,
                      icon: const Icon(Icons.verified_outlined),
                      label: const Text('Validasi Booking'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _accentColor,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 18),
          _SectionTitle(
            title: 'Latihan Jadwal Kegiatan',
            style: Theme.of(context).textTheme,
          ),
          const SizedBox(height: 10),
          Card(
            elevation: 3,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: _softColor,
                        child: Icon(Icons.edit_calendar, color: _accentColor),
                      ),
                      SizedBox(width: 12),
                      Text(
                        'Form Jadwal',
                        style: TextStyle(
                          color: _accentColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  _PickerTile(
                    icon: Icons.calendar_today,
                    title: 'Tanggal Kegiatan',
                    value: _formatDate(_selectedDate),
                    buttonLabel: 'Pilih Tanggal',
                    onPressed: _pickDate,
                  ),
                  const SizedBox(height: 12),
                  _PickerTile(
                    icon: Icons.work_outline,
                    title: 'Tanggal Hari Kerja',
                    value: _formatDate(_selectedDate),
                    buttonLabel: 'Pilih Hari Kerja',
                    onPressed: _pickWorkday,
                  ),
                  const SizedBox(height: 12),
                  _PickerTile(
                    icon: Icons.access_time,
                    title: 'Waktu Kegiatan',
                    value: _formatTime(_selectedTime),
                    buttonLabel: 'Pilih Waktu',
                    onPressed: _pickTime,
                  ),
                  const SizedBox(height: 12),
                  _PickerTile(
                    icon: Icons.date_range,
                    title: 'Rentang Tanggal',
                    value: _formatRange(_selectedRange),
                    buttonLabel: 'Pilih Rentang',
                    onPressed: _pickRange,
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton.icon(
                      onPressed: _showScheduleResult,
                      icon: const Icon(Icons.save),
                      label: const Text('Simpan Jadwal'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _accentColor,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
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

class _PickerTile extends StatelessWidget {
  const _PickerTile({
    required this.icon,
    required this.title,
    required this.value,
    required this.buttonLabel,
    required this.onPressed,
  });

  final IconData icon;
  final String title;
  final String value;
  final String buttonLabel;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: _Pertemuan9PageState._softColor,
                child: Icon(icon, color: _Pertemuan9PageState._accentColor),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 4),
                    Text(value),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: onPressed,
              icon: const Icon(Icons.touch_app_outlined),
              label: Text(buttonLabel),
              style: OutlinedButton.styleFrom(
                foregroundColor: _Pertemuan9PageState._accentColor,
                side:
                    const BorderSide(color: _Pertemuan9PageState._accentColor),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ParameterList extends StatelessWidget {
  const _ParameterList({required this.parameters});

  final List<_ParameterInfo> parameters;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          for (var index = 0; index < parameters.length; index++) ...[
            ListTile(
              leading: CircleAvatar(
                backgroundColor: _Pertemuan9PageState._softColor,
                child: Text(
                  '${index + 1}',
                  style: const TextStyle(
                    color: _Pertemuan9PageState._accentColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              title: Text(
                parameters[index].parameter,
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
              subtitle: Text(parameters[index].function),
            ),
            if (index != parameters.length - 1) const Divider(height: 1),
          ],
        ],
      ),
    );
  }
}

class _ResultRow extends StatelessWidget {
  const _ResultRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: _Pertemuan9PageState._accentColor, size: 20),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
              Text(value),
            ],
          ),
        ),
      ],
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
        fontWeight: FontWeight.w700,
        color: _Pertemuan9PageState._accentColor,
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

class _ParameterInfo {
  const _ParameterInfo({
    required this.parameter,
    required this.function,
  });

  final String parameter;
  final String function;
}
