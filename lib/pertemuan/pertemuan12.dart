import 'package:flutter/material.dart';

import 'pertemuan_placeholder_page.dart';

class Pertemuan12Page extends StatelessWidget {
  const Pertemuan12Page({super.key});

  static const List<PertemuanPlaceholderSection> _sections = [
    PertemuanPlaceholderSection(
      title: 'Ringkasan Materi',
      description: 'Area untuk penjelasan singkat materi pertemuan 12.',
      icon: Icons.article_outlined,
    ),
    PertemuanPlaceholderSection(
      title: 'Tujuan Pembelajaran',
      description: 'Area untuk daftar capaian pembelajaran pertemuan 12.',
      icon: Icons.school_outlined,
    ),
    PertemuanPlaceholderSection(
      title: 'Contoh Praktik',
      description: 'Area untuk contoh kode atau latihan pertemuan 12.',
      icon: Icons.code_rounded,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return const PertemuanPlaceholderPage(
      meetingNumber: 12,
      title: 'Pertemuan 12',
      accentColor: Color(0xFFB45309),
      backgroundColor: Color(0xFFFEF3C7),
      sections: _sections,
    );
  }
}
