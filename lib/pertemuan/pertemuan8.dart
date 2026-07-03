import 'package:flutter/material.dart';

class Pertemuan8Page extends StatefulWidget {
  const Pertemuan8Page({super.key});

  @override
  State<Pertemuan8Page> createState() => _Pertemuan8PageState();
}

class _Pertemuan8PageState extends State<Pertemuan8Page> {
  final _formKey = GlobalKey<FormState>();
  String _university = '';
  String _major = '';
  String? _educationLevel;
  String? _entryYear;

  static const Color _accentColor = Color(0xFF8E24AA);
  static const Color _softColor = Color(0xFFF5EAF8);

  static const List<_TopicInfo> _topics = [
    _TopicInfo(
      title: 'AutoComplete',
      description:
          'Widget input yang menampilkan daftar saran secara otomatis saat pengguna mengetik.',
      icon: Icons.manage_search_rounded,
    ),
    _TopicInfo(
      title: 'Spinner / DropdownButton',
      description:
          'Komponen pilihan yang memungkinkan pengguna memilih satu opsi dari daftar dropdown.',
      icon: Icons.arrow_drop_down_circle_outlined,
    ),
  ];

  static const List<_PropertyInfo> _autocompleteProperties = [
    _PropertyInfo(
      property: 'optionsBuilder',
      function: 'Menentukan data saran yang muncul saat pengguna mengetik.',
    ),
    _PropertyInfo(
      property: 'onSelected',
      function: 'Menjalankan aksi ketika salah satu saran dipilih.',
    ),
    _PropertyInfo(
      property: 'fieldViewBuilder',
      function: 'Mengatur tampilan input TextField.',
    ),
    _PropertyInfo(
      property: 'optionsViewBuilder',
      function: 'Mengatur tampilan daftar saran atau dropdown autocomplete.',
    ),
    _PropertyInfo(
      property: 'displayStringForOption',
      function: 'Mengubah teks yang ditampilkan untuk setiap pilihan.',
    ),
    _PropertyInfo(
      property: 'initialValue',
      function: 'Memberikan nilai awal pada field autocomplete.',
    ),
  ];

  static const List<_PropertyInfo> _dropdownProperties = [
    _PropertyInfo(property: 'value', function: 'Nilai yang sedang dipilih.'),
    _PropertyInfo(property: 'items', function: 'Daftar pilihan dropdown.'),
    _PropertyInfo(
      property: 'onChanged',
      function: 'Menjalankan aksi ketika pilihan berubah.',
    ),
    _PropertyInfo(
        property: 'hint', function: 'Placeholder saat belum dipilih.'),
    _PropertyInfo(
      property: 'isExpanded',
      function: 'Membuat dropdown memenuhi lebar parent.',
    ),
    _PropertyInfo(property: 'icon', function: 'Mengatur ikon dropdown.'),
    _PropertyInfo(
      property: 'dropdownColor',
      function: 'Mengatur warna menu dropdown.',
    ),
    _PropertyInfo(property: 'style', function: 'Mengatur gaya teks.'),
    _PropertyInfo(property: 'underline', function: 'Mengatur garis bawah.'),
  ];

  static const List<String> _useCases = [
    'Pencarian nama kota atau negara.',
    'Input nama produk, kampus, atau jurusan.',
    'Form dengan banyak pilihan yang perlu dicari cepat.',
    'Search bar dengan filter pilihan.',
  ];

  static const List<String> _universities = [
    'Universitas Indonesia',
    'Institut Teknologi Bandung',
    'Universitas Gadjah Mada',
    'Universitas Padjadjaran',
    'Universitas Airlangga',
    'Institut Pertanian Bogor',
    'Universitas Brawijaya',
    'Universitas Diponegoro',
    'Universitas Sebelas Maret',
    'Universitas Negeri Jakarta',
    'Universitas Pamulang',
  ];

  static const List<String> _majors = [
    'Teknik Informatika',
    'Sistem Informasi',
    'Teknik Elektro',
    'Manajemen',
    'Akuntansi',
    'Hukum',
    'Kedokteran',
    'Psikologi',
    'Desain Komunikasi Visual',
    'Hubungan Internasional',
  ];

  static const List<String> _educationLevels = [
    'SMA/Sederajat',
    'D3',
    'S1',
    'S2',
    'S3',
  ];

  static const List<String> _years = [
    '2020',
    '2021',
    '2022',
    '2023',
    '2024',
    '2025',
    '2026',
  ];

  void _submitForm() {
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: Colors.white),
              SizedBox(width: 10),
              Expanded(child: Text('Harap lengkapi semua field.')),
            ],
          ),
          backgroundColor: Colors.red.shade600,
          behavior: SnackBarBehavior.floating,
        ),
      );
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
              Icon(Icons.check_circle, color: Colors.green),
              SizedBox(width: 10),
              Text('Berhasil'),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Data mahasiswa berhasil disimpan.'),
              const SizedBox(height: 14),
              _DetailRow(
                icon: Icons.school,
                label: 'Universitas',
                value: _university,
              ),
              const SizedBox(height: 8),
              _DetailRow(
                icon: Icons.book,
                label: 'Jurusan',
                value: _major,
              ),
              const SizedBox(height: 8),
              _DetailRow(
                icon: Icons.timeline,
                label: 'Jenjang',
                value: _educationLevel ?? '-',
              ),
              const SizedBox(height: 8),
              _DetailRow(
                icon: Icons.calendar_today,
                label: 'Tahun',
                value: _entryYear ?? '-',
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                setState(() {
                  _university = '';
                  _major = '';
                  _educationLevel = null;
                  _entryYear = null;
                });
                _formKey.currentState?.reset();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Iterable<String> _filterOptions(List<String> options, String query) {
    if (query.isEmpty) {
      return const Iterable<String>.empty();
    }

    return options.where(
      (option) => option.toLowerCase().contains(query.toLowerCase()),
    );
  }

  String? _validateAutocomplete(
    String? value,
    String label,
    List<String> options,
  ) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) {
      return 'Silakan pilih $label';
    }
    if (!options.contains(text)) {
      return '$label tidak valid';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Pertemuan 8 - AutoComplete & Spinner'),
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
                    'Pertemuan 8 membahas AutoComplete dan Spinner pada '
                    'Flutter. Keduanya membantu pengguna memilih data dari '
                    'daftar pilihan, terutama ketika opsi cukup banyak atau '
                    'perlu dicari dengan cepat.',
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
              title: Text('Memahami AutoComplete dan Spinner pada Flutter'),
              subtitle: Text(
                'Mahasiswa diharapkan mampu memahami konsep AutoComplete dan '
                'Spinner serta penggunaannya pada pemrograman Android.',
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
            title: 'Kapan Digunakan?',
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
            title: 'Properti AutoComplete',
            style: Theme.of(context).textTheme,
          ),
          const SizedBox(height: 10),
          const _PropertyList(properties: _autocompleteProperties),
          const SizedBox(height: 18),
          _SectionTitle(
            title: 'Properti Spinner / DropdownButton',
            style: Theme.of(context).textTheme,
          ),
          const SizedBox(height: 10),
          const _PropertyList(properties: _dropdownProperties),
          const SizedBox(height: 18),
          _SectionTitle(
            title: 'Latihan Form Mahasiswa',
            style: Theme.of(context).textTheme,
          ),
          const SizedBox(height: 10),
          Card(
            elevation: 3,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: _softColor,
                          child: Icon(Icons.edit_note, color: _accentColor),
                        ),
                        SizedBox(width: 12),
                        Text(
                          'Informasi Mahasiswa',
                          style: TextStyle(
                            color: _accentColor,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    _AutocompleteField(
                      label: 'Universitas',
                      hint: 'Cari universitas...',
                      icon: Icons.school,
                      options: _universities,
                      initialValue: _university,
                      validator: (value) => _validateAutocomplete(
                        value,
                        'universitas',
                        _universities,
                      ),
                      onChanged: (value) {
                        setState(() {
                          _university = value;
                        });
                      },
                      optionsBuilder: (query) =>
                          _filterOptions(_universities, query),
                    ),
                    const SizedBox(height: 18),
                    _AutocompleteField(
                      label: 'Jurusan',
                      hint: 'Cari jurusan...',
                      icon: Icons.book,
                      options: _majors,
                      initialValue: _major,
                      validator: (value) => _validateAutocomplete(
                        value,
                        'jurusan',
                        _majors,
                      ),
                      onChanged: (value) {
                        setState(() {
                          _major = value;
                        });
                      },
                      optionsBuilder: (query) => _filterOptions(_majors, query),
                    ),
                    const SizedBox(height: 18),
                    _DropdownField(
                      label: 'Jenjang Pendidikan',
                      hint: 'Pilih jenjang pendidikan',
                      icon: Icons.timeline,
                      value: _educationLevel,
                      items: _educationLevels,
                      onChanged: (value) {
                        setState(() {
                          _educationLevel = value;
                        });
                      },
                    ),
                    const SizedBox(height: 18),
                    _DropdownField(
                      label: 'Tahun Masuk',
                      hint: 'Pilih tahun masuk',
                      icon: Icons.calendar_today,
                      value: _entryYear,
                      items: _years,
                      onChanged: (value) {
                        setState(() {
                          _entryYear = value;
                        });
                      },
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton.icon(
                        onPressed: _submitForm,
                        icon: const Icon(Icons.save),
                        label: const Text('Simpan Data'),
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
          ),
        ],
      ),
    );
  }
}

class _AutocompleteField extends StatelessWidget {
  const _AutocompleteField({
    required this.label,
    required this.hint,
    required this.icon,
    required this.options,
    required this.initialValue,
    required this.optionsBuilder,
    required this.onChanged,
    required this.validator,
  });

  final String label;
  final String hint;
  final IconData icon;
  final List<String> options;
  final String initialValue;
  final Iterable<String> Function(String query) optionsBuilder;
  final ValueChanged<String> onChanged;
  final String? Function(String? value) validator;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _FieldLabel(label: label, icon: icon),
        const SizedBox(height: 8),
        Autocomplete<String>(
          initialValue: TextEditingValue(text: initialValue),
          optionsBuilder: (textEditingValue) {
            return optionsBuilder(textEditingValue.text);
          },
          onSelected: onChanged,
          fieldViewBuilder: (
            context,
            textEditingController,
            focusNode,
            onFieldSubmitted,
          ) {
            return TextFormField(
              controller: textEditingController,
              focusNode: focusNode,
              validator: validator,
              onChanged: onChanged,
              decoration: InputDecoration(
                hintText: hint,
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.grey.shade50,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: _Pertemuan8PageState._accentColor,
                    width: 2,
                  ),
                ),
              ),
            );
          },
          optionsViewBuilder: (context, onSelected, options) {
            return Align(
              alignment: Alignment.topLeft,
              child: Material(
                elevation: 4,
                borderRadius: BorderRadius.circular(12),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxHeight: 220),
                  child: ListView.builder(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    itemCount: options.length,
                    itemBuilder: (context, index) {
                      final option = options.elementAt(index);
                      return ListTile(
                        leading: const Icon(
                          Icons.arrow_right,
                          color: _Pertemuan8PageState._accentColor,
                        ),
                        title: Text(option),
                        onTap: () {
                          onSelected(option);
                        },
                      );
                    },
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

class _DropdownField extends StatelessWidget {
  const _DropdownField({
    required this.label,
    required this.hint,
    required this.icon,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  final String label;
  final String hint;
  final IconData icon;
  final String? value;
  final List<String> items;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _FieldLabel(label: label, icon: icon),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          initialValue: value,
          hint: Text(hint),
          isExpanded: true,
          icon: const Icon(
            Icons.arrow_drop_down,
            color: _Pertemuan8PageState._accentColor,
          ),
          dropdownColor: Colors.white,
          style: const TextStyle(color: Colors.black87),
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.grey.shade50,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: _Pertemuan8PageState._accentColor,
                width: 2,
              ),
            ),
          ),
          items: items.map((item) {
            return DropdownMenuItem(
              value: item,
              child: Text(item),
            );
          }).toList(),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Silakan pilih $label';
            }
            return null;
          },
          onChanged: onChanged,
        ),
      ],
    );
  }
}

class _FieldLabel extends StatelessWidget {
  const _FieldLabel({
    required this.label,
    required this.icon,
  });

  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18, color: _Pertemuan8PageState._accentColor),
        const SizedBox(width: 8),
        Text(
          label,
          style: const TextStyle(
            color: _Pertemuan8PageState._accentColor,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
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
                backgroundColor: _Pertemuan8PageState._softColor,
                child: Text(
                  '${index + 1}',
                  style: const TextStyle(
                    color: _Pertemuan8PageState._accentColor,
                    fontWeight: FontWeight.bold,
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

class _DetailRow extends StatelessWidget {
  const _DetailRow({
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
      children: [
        Icon(icon, size: 18, color: _Pertemuan8PageState._accentColor),
        const SizedBox(width: 8),
        Text(
          '$label: ',
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
        Expanded(
          child: Text(
            value,
            overflow: TextOverflow.ellipsis,
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
      style: style.titleMedium?.copyWith(
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
