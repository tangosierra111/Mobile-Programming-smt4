import 'package:flutter/material.dart';

import '../models/meeting.dart';
import '../repositories/content_repository.dart';

class MeetingContentEditorPage extends StatefulWidget {
  const MeetingContentEditorPage({
    super.key,
    required this.meetingId,
    required this.repository,
  });

  final int meetingId;
  final ContentRepository repository;

  @override
  State<MeetingContentEditorPage> createState() =>
      _MeetingContentEditorPageState();
}

class _MeetingContentEditorPageState extends State<MeetingContentEditorPage> {
  late Future<Meeting> _futureMeeting;

  @override
  void initState() {
    super.initState();
    _reload();
  }

  void _reload() {
    _futureMeeting = widget.repository.fetchMeeting(widget.meetingId);
  }

  Future<void> _openEditor(
    Meeting meeting, [
    MeetingContentBlock? block,
  ]) async {
    final draft = await showDialog<_BlockDraft>(
      context: context,
      barrierDismissible: false,
      builder: (_) => _BlockEditorDialog(block: block),
    );
    if (draft == null) return;

    try {
      if (block == null) {
        await widget.repository.createBlock(
          meetingId: meeting.id,
          blockKey: 'block-${DateTime.now().microsecondsSinceEpoch}',
          type: draft.type,
          title: draft.title,
          content: draft.content,
          sortOrder: meeting.contentBlocks.length + 1,
          isVisible: draft.isVisible,
        );
      } else {
        await widget.repository.updateBlock(
          block: block,
          blockKey: block.blockKey,
          type: draft.type,
          title: draft.title,
          content: draft.content,
          sortOrder: block.sortOrder,
          isVisible: draft.isVisible,
        );
      }
      if (!mounted) return;
      setState(_reload);
    } catch (error) {
      _showError(error);
    }
  }

  Future<void> _delete(MeetingContentBlock block) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus blok?'),
        content: const Text('Blok yang dihapus tidak dapat dikembalikan.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    try {
      await widget.repository.deleteBlock(block.id);
      if (mounted) setState(_reload);
    } catch (error) {
      _showError(error);
    }
  }

  void _showError(Object error) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(error.toString())),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Kelola Konten Materi')),
      body: FutureBuilder<Meeting>(
        future: _futureMeeting,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          }
          final meeting = snapshot.data!;
          final blocks = [...meeting.contentBlocks]
            ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
          return Column(
            children: [
              Container(
                width: double.infinity,
                color: meeting.backgroundColorValue == 0
                    ? Colors.blue.shade50
                    : Color(meeting.backgroundColorValue),
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      meeting.title,
                      style:
                          Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.w800,
                              ),
                    ),
                    const SizedBox(height: 4),
                    Text('${blocks.length} blok konten'),
                  ],
                ),
              ),
              Expanded(
                child: blocks.isEmpty
                    ? const Center(
                        child:
                            Text('Belum ada konten. Tambahkan blok pertama.'),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: blocks.length,
                        itemBuilder: (context, index) {
                          final block = blocks[index];
                          return Card(
                            child: ListTile(
                              leading: Icon(_icon(block.type)),
                              title: Text(
                                block.title?.isNotEmpty == true
                                    ? block.title!
                                    : _label(block.type),
                                style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              subtitle: Text(
                                '${_label(block.type)} • ${block.isVisible ? 'Tampil' : 'Disembunyikan'}',
                              ),
                              onTap: () => _openEditor(meeting, block),
                              trailing: IconButton(
                                tooltip: 'Hapus',
                                onPressed: () => _delete(block),
                                icon: const Icon(Icons.delete_outline_rounded),
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FutureBuilder<Meeting>(
        future: _futureMeeting,
        builder: (context, snapshot) => FloatingActionButton.extended(
          onPressed:
              snapshot.hasData ? () => _openEditor(snapshot.data!) : null,
          icon: const Icon(Icons.add_rounded),
          label: const Text('Tambah blok'),
        ),
      ),
    );
  }
}

class _BlockDraft {
  const _BlockDraft({
    required this.type,
    required this.title,
    required this.content,
    required this.isVisible,
  });

  final ContentBlockType type;
  final String? title;
  final Map<String, dynamic> content;
  final bool isVisible;
}

class _BlockEditorDialog extends StatefulWidget {
  const _BlockEditorDialog({this.block});

  final MeetingContentBlock? block;

  @override
  State<_BlockEditorDialog> createState() => _BlockEditorDialogState();
}

class _BlockEditorDialogState extends State<_BlockEditorDialog> {
  final _formKey = GlobalKey<FormState>();
  late ContentBlockType _type;
  late bool _isVisible;
  late final TextEditingController _title;
  late final TextEditingController _primary;
  late final TextEditingController _secondary;

  @override
  void initState() {
    super.initState();
    final block = widget.block;
    _type = block?.type ?? ContentBlockType.paragraph;
    _isVisible = block?.isVisible ?? true;
    _title = TextEditingController(text: block?.title ?? '');
    _primary = TextEditingController(text: _primaryText(block));
    _secondary = TextEditingController(text: _secondaryText(block));
  }

  @override
  void dispose() {
    _title.dispose();
    _primary.dispose();
    _secondary.dispose();
    super.dispose();
  }

  String _primaryText(MeetingContentBlock? block) {
    if (block == null) return '';
    return switch (block.type) {
      ContentBlockType.bulletList =>
        (block.content['items'] as List<dynamic>? ?? const []).join('\n'),
      ContentBlockType.code => block.content['code']?.toString() ?? '',
      ContentBlockType.keyValue =>
        (block.content['items'] as List<dynamic>? ?? const []).map((item) {
          final map = item as Map<String, dynamic>;
          return '${map['label']}=${map['value']}';
        }).join('\n'),
      ContentBlockType.image => block.content['url']?.toString() ?? '',
      ContentBlockType.demo => block.content['demo_key']?.toString() ?? '',
      _ => block.content['text']?.toString() ?? '',
    };
  }

  String _secondaryText(MeetingContentBlock? block) {
    if (block == null) return '';
    return switch (block.type) {
      ContentBlockType.code => block.content['language']?.toString() ?? 'dart',
      ContentBlockType.image => block.content['alt']?.toString() ?? '',
      ContentBlockType.callout =>
        block.content['variant']?.toString() ?? 'info',
      _ => '',
    };
  }

  void _changeType(ContentBlockType? type) {
    if (type == null || type == _type) return;
    setState(() {
      _type = type;
      _primary.clear();
      _secondary.text = type == ContentBlockType.code ? 'dart' : '';
    });
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    final lines = _primary.text
        .split('\n')
        .map((line) => line.trim())
        .where((line) => line.isNotEmpty)
        .toList();
    final content = switch (_type) {
      ContentBlockType.bulletList => <String, dynamic>{'items': lines},
      ContentBlockType.code => <String, dynamic>{
          'language':
              _secondary.text.trim().isEmpty ? 'dart' : _secondary.text.trim(),
          'code': _primary.text,
        },
      ContentBlockType.keyValue => <String, dynamic>{
          'items': lines.map((line) {
            final separator = line.indexOf('=');
            return {
              'label': separator < 0 ? line : line.substring(0, separator),
              'value': separator < 0 ? '' : line.substring(separator + 1),
            };
          }).toList(),
        },
      ContentBlockType.image => <String, dynamic>{
          'url': _primary.text.trim(),
          'alt': _secondary.text.trim(),
        },
      ContentBlockType.demo => <String, dynamic>{
          'demo_key': _primary.text.trim(),
        },
      ContentBlockType.callout => <String, dynamic>{
          'text': _primary.text.trim(),
          'variant':
              _secondary.text.trim().isEmpty ? 'info' : _secondary.text.trim(),
        },
      _ => <String, dynamic>{'text': _primary.text.trim()},
    };
    Navigator.pop(
      context,
      _BlockDraft(
        type: _type,
        title: _title.text.trim().isEmpty ? null : _title.text.trim(),
        content: content,
        isVisible: _isVisible,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final secondaryLabel = switch (_type) {
      ContentBlockType.code => 'Bahasa kode',
      ContentBlockType.image => 'Teks alternatif',
      ContentBlockType.callout => 'Varian (info/warning/success)',
      _ => null,
    };
    return AlertDialog(
      title: Text(widget.block == null ? 'Tambah Blok' : 'Edit Blok'),
      content: SizedBox(
        width: 620,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField<ContentBlockType>(
                  initialValue: _type,
                  decoration: const InputDecoration(
                    labelText: 'Jenis blok',
                    border: OutlineInputBorder(),
                  ),
                  items: ContentBlockType.values
                      .map(
                        (type) => DropdownMenuItem(
                          value: type,
                          child: Text(_label(type)),
                        ),
                      )
                      .toList(),
                  onChanged: _changeType,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _title,
                  decoration: const InputDecoration(
                    labelText: 'Judul opsional',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _primary,
                  minLines: _type == ContentBlockType.code ? 8 : 4,
                  maxLines: 12,
                  decoration: InputDecoration(
                    labelText: _primaryLabel(_type),
                    helperText: _helperText(_type),
                    alignLabelWithHint: true,
                    border: const OutlineInputBorder(),
                  ),
                  validator: (value) => value == null || value.trim().isEmpty
                      ? 'Konten wajib diisi'
                      : null,
                ),
                if (secondaryLabel != null) ...[
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _secondary,
                    decoration: InputDecoration(
                      labelText: secondaryLabel,
                      border: const OutlineInputBorder(),
                    ),
                  ),
                ],
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Tampilkan kepada mahasiswa'),
                  value: _isVisible,
                  onChanged: (value) => setState(() => _isVisible = value),
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Batal'),
        ),
        FilledButton(onPressed: _submit, child: const Text('Simpan')),
      ],
    );
  }
}

String _label(ContentBlockType type) => switch (type) {
      ContentBlockType.heading => 'Judul Bagian',
      ContentBlockType.paragraph => 'Paragraf',
      ContentBlockType.bulletList => 'Daftar Poin',
      ContentBlockType.code => 'Kode Program',
      ContentBlockType.keyValue => 'Pasangan Label–Nilai',
      ContentBlockType.callout => 'Kotak Informasi',
      ContentBlockType.image => 'Gambar',
      ContentBlockType.demo => 'Demo Interaktif',
    };

String _primaryLabel(ContentBlockType type) => switch (type) {
      ContentBlockType.bulletList => 'Poin-poin',
      ContentBlockType.code => 'Kode',
      ContentBlockType.keyValue => 'Label dan nilai',
      ContentBlockType.image => 'URL gambar',
      ContentBlockType.demo => 'Kunci demo',
      _ => 'Isi konten',
    };

String? _helperText(ContentBlockType type) => switch (type) {
      ContentBlockType.bulletList => 'Satu poin per baris',
      ContentBlockType.keyValue => 'Satu pasangan per baris: Label=Nilai',
      _ => null,
    };

IconData _icon(ContentBlockType type) => switch (type) {
      ContentBlockType.heading => Icons.title_rounded,
      ContentBlockType.paragraph => Icons.notes_rounded,
      ContentBlockType.bulletList => Icons.format_list_bulleted_rounded,
      ContentBlockType.code => Icons.code_rounded,
      ContentBlockType.keyValue => Icons.view_list_rounded,
      ContentBlockType.callout => Icons.info_outline_rounded,
      ContentBlockType.image => Icons.image_outlined,
      ContentBlockType.demo => Icons.widgets_outlined,
    };
