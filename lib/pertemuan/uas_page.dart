import 'package:flutter/material.dart';

import 'ujian_template_page.dart';

class UasPage extends StatelessWidget {
  const UasPage({super.key});

  static const List<ExamInfo> _leftInfo = [
    ExamInfo(label: 'Matakuliah', value: 'Mobile Programming'),
    ExamInfo(label: 'Program Studi', value: 'Sistem Informasi'),
    ExamInfo(label: 'Fakultas', value: 'Ilmu Komputer'),
    ExamInfo(label: 'Dosen Pengampu', value: 'Nafiah, S.Si., M.Kom'),
  ];

  static const List<ExamInfo> _rightInfo = [
    ExamInfo(label: 'Ruang / Kode Kelas', value: 'Belum tersedia'),
    ExamInfo(label: 'Hari, Tanggal Ujian', value: 'Belum tersedia'),
    ExamInfo(label: 'Waktu Ujian', value: 'Belum tersedia'),
    ExamInfo(label: 'Jenis Ujian', value: 'Belum tersedia'),
  ];

  @override
  Widget build(BuildContext context) {
    return const UjianTemplatePage(
      title: 'Ujian Akhir Semester (UAS)',
      leftInfo: _leftInfo,
      rightInfo: _rightInfo,
      unavailableMessage:
          'Template halaman sudah disiapkan. Detail soal, waktu, dan '
          'informasi pelaksanaan UAS dapat ditambahkan setelah materi '
          'tersedia.',
    );
  }
}
