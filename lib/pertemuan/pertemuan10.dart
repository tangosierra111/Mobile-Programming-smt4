import 'package:flutter/material.dart';

import 'pertemuan_placeholder_page.dart';

class Pertemuan10Page extends StatelessWidget {
  const Pertemuan10Page({super.key});

  static const List<PertemuanPlaceholderSection> _sections = [
    PertemuanPlaceholderSection(
      title: 'Ringkasan Materi',
      description: 'Area untuk penjelasan singkat materi pertemuan 10.',
      icon: Icons.article_outlined,
    ),
    PertemuanPlaceholderSection(
      title: 'Tujuan Pembelajaran',
      description: 'Area untuk daftar capaian pembelajaran pertemuan 10.',
      icon: Icons.school_outlined,
    ),
    PertemuanPlaceholderSection(
      title: 'Contoh Praktik',
      description: 'Area untuk contoh kode atau latihan pertemuan 10.',
      icon: Icons.code_rounded,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return const PertemuanPlaceholderPage(
      meetingNumber: 10,
      title: 'Pertemuan 10',
      accentColor: Color(0xFF4338CA),
      backgroundColor: Color(0xFFEDEBFE),
      sections: _sections,
    );
  }
}
