import 'package:flutter/material.dart';

import 'pertemuan_placeholder_page.dart';

class Pertemuan11Page extends StatelessWidget {
  const Pertemuan11Page({super.key});

  static const List<PertemuanPlaceholderSection> _sections = [
    PertemuanPlaceholderSection(
      title: 'Ringkasan Materi',
      description: 'Area untuk penjelasan singkat materi pertemuan 11.',
      icon: Icons.article_outlined,
    ),
    PertemuanPlaceholderSection(
      title: 'Tujuan Pembelajaran',
      description: 'Area untuk daftar capaian pembelajaran pertemuan 11.',
      icon: Icons.school_outlined,
    ),
    PertemuanPlaceholderSection(
      title: 'Contoh Praktik',
      description: 'Area untuk contoh kode atau latihan pertemuan 11.',
      icon: Icons.code_rounded,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return const PertemuanPlaceholderPage(
      meetingNumber: 11,
      title: 'Pertemuan 11',
      accentColor: Color(0xFFBE123C),
      backgroundColor: Color(0xFFFFE4E6),
      sections: _sections,
    );
  }
}
