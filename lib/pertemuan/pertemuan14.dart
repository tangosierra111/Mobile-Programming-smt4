import 'package:flutter/material.dart';

import 'pertemuan_placeholder_page.dart';

class Pertemuan14Page extends StatelessWidget {
  const Pertemuan14Page({super.key});

  static const List<PertemuanPlaceholderSection> _sections = [
    PertemuanPlaceholderSection(
      title: 'Ringkasan Materi',
      description: 'Area untuk penjelasan singkat materi pertemuan 14.',
      icon: Icons.article_outlined,
    ),
    PertemuanPlaceholderSection(
      title: 'Tujuan Pembelajaran',
      description: 'Area untuk daftar capaian pembelajaran pertemuan 14.',
      icon: Icons.school_outlined,
    ),
    PertemuanPlaceholderSection(
      title: 'Contoh Praktik',
      description: 'Area untuk contoh kode atau latihan pertemuan 14.',
      icon: Icons.code_rounded,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return const PertemuanPlaceholderPage(
      meetingNumber: 14,
      title: 'Pertemuan 14',
      accentColor: Color(0xFF6D28D9),
      backgroundColor: Color(0xFFF3E8FF),
      sections: _sections,
    );
  }
}
