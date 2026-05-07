import 'package:flutter/material.dart';

import 'pertemuan_placeholder_page.dart';

class Pertemuan13Page extends StatelessWidget {
  const Pertemuan13Page({super.key});

  static const List<PertemuanPlaceholderSection> _sections = [
    PertemuanPlaceholderSection(
      title: 'Ringkasan Materi',
      description: 'Area untuk penjelasan singkat materi pertemuan 13.',
      icon: Icons.article_outlined,
    ),
    PertemuanPlaceholderSection(
      title: 'Tujuan Pembelajaran',
      description: 'Area untuk daftar capaian pembelajaran pertemuan 13.',
      icon: Icons.school_outlined,
    ),
    PertemuanPlaceholderSection(
      title: 'Contoh Praktik',
      description: 'Area untuk contoh kode atau latihan pertemuan 13.',
      icon: Icons.code_rounded,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return const PertemuanPlaceholderPage(
      meetingNumber: 13,
      title: 'Pertemuan 13',
      accentColor: Color(0xFF15803D),
      backgroundColor: Color(0xFFDCFCE7),
      sections: _sections,
    );
  }
}
