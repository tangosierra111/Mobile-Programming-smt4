import 'package:flutter/material.dart';

import 'pertemuan_placeholder_page.dart';

class Pertemuan9Page extends StatelessWidget {
  const Pertemuan9Page({super.key});

  static const List<PertemuanPlaceholderSection> _sections = [
    PertemuanPlaceholderSection(
      title: 'Ringkasan Materi',
      description: 'Area untuk penjelasan singkat materi pertemuan 9.',
      icon: Icons.article_outlined,
    ),
    PertemuanPlaceholderSection(
      title: 'Tujuan Pembelajaran',
      description: 'Area untuk daftar capaian pembelajaran pertemuan 9.',
      icon: Icons.school_outlined,
    ),
    PertemuanPlaceholderSection(
      title: 'Contoh Praktik',
      description: 'Area untuk contoh kode atau latihan pertemuan 9.',
      icon: Icons.code_rounded,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return const PertemuanPlaceholderPage(
      meetingNumber: 9,
      title: 'Pertemuan 9',
      accentColor: Color(0xFF0F766E),
      backgroundColor: Color(0xFFE6FFFA),
      sections: _sections,
    );
  }
}
