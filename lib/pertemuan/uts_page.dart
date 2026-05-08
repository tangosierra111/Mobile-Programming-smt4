import 'package:flutter/material.dart';

import 'ujian_template_page.dart';

class UtsPage extends StatelessWidget {
  const UtsPage({super.key});

  static const List<ExamInfo> _leftInfo = [
    ExamInfo(label: 'Matakuliah', value: 'Mobile Programming'),
    ExamInfo(label: 'Program Studi', value: 'Sistem Informasi'),
    ExamInfo(label: 'Fakultas', value: 'Ilmu Komputer'),
    ExamInfo(label: 'Dosen Pengampu', value: 'Nafiah, S.Si., M.Kom'),
  ];

  static const List<ExamInfo> _rightInfo = [
    ExamInfo(label: 'Ruang / Kode Kelas', value: 'V.925/04SIFE008'),
    ExamInfo(label: 'Hari, Tanggal Ujian', value: 'Sabtu, 9 April 2026'),
    ExamInfo(label: 'Waktu Ujian', value: '100 menit'),
    ExamInfo(label: 'Jenis Ujian', value: 'Utama'),
  ];

  static const List<ExamQuestion> _questions = [
    ExamQuestion(
      number: 1,
      question:
          'Buatlah aplikasi sederhana untuk menampilkan daftar pertemuan 1 sampai 7 menggunakan ListView',
      weight: '25%',
      maxTime: '15 menit',
    ),
    ExamQuestion(
      number: 2,
      question:
          'Buatlah aplikasi sederhana untuk menampilkan navigation bottom bar untuk membuat menu profile dan list menggunakan package salomon bottom bar',
      weight: '20%',
      maxTime: '10 menit',
    ),
    ExamQuestion(
      number: 3,
      question:
          'Buatlah aplikasi sederhana untuk menampilkan profile yang terdiri dari foto, nama, nim dan kelas kalian',
      weight: '25%',
      maxTime: '15 menit',
    ),
    ExamQuestion(
      number: 4,
      question:
          'Buatlah aplikasi sederhana dari gabungan soal pada nomor 1, 2 dan 3',
      weight: '30%',
      maxTime: '20 menit',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return const UjianTemplatePage(
      title: 'Ujian Tengah Semester (UTS)',
      leftInfo: _leftInfo,
      rightInfo: _rightInfo,
      learningOutcome:
          'Mahasiswa mampu menerapkan pemikiran logis dan inovatis dalam '
          'pengembangan teknologi sehingga mampu membangun perangkat lunak '
          'berdasarkan objek, kelas serta mampu menerapkan fungsi dan bahasa '
          'pemrograman pada aplikasi android',
      questions: _questions,
    );
  }
}
