import '../models/course.dart';
import '../models/exam.dart';

const mobileProgrammingCourse = Course(
  id: 1,
  code: '04SIFE008',
  name: 'Mobile Programming',
  studyProgram: 'Sistem Informasi',
  faculty: 'Ilmu Komputer',
  lecturerName: 'Nafiah, S.Si., M.Kom',
  description: 'Materi Mobile Programming menggunakan Flutter dan Dart.',
);

final utsExam = Exam(
  id: 1,
  course: mobileProgrammingCourse,
  type: ExamType.uts,
  title: 'Ujian Tengah Semester (UTS)',
  room: 'V.925',
  classCode: '04SIFE008',
  examDate: DateTime(2026, 4, 9),
  durationMinutes: 100,
  examKind: 'Utama',
  learningOutcome:
      'Mahasiswa mampu menerapkan pemikiran logis dan inovatif dalam '
      'pengembangan teknologi sehingga mampu membangun perangkat lunak '
      'berdasarkan objek, kelas serta mampu menerapkan fungsi dan bahasa '
      'pemrograman pada aplikasi Android.',
  instructions: 'Jawablah pertanyaan ini dengan uraian yang jelas!',
  status: ExamStatus.published,
  questions: const [
    ExamQuestion(
      id: 1,
      number: 1,
      question:
          'Buatlah aplikasi sederhana untuk menampilkan daftar pertemuan 1 sampai 7 menggunakan ListView',
      weightPercent: 25,
      maxTimeMinutes: 15,
      sortOrder: 1,
    ),
    ExamQuestion(
      id: 2,
      number: 2,
      question:
          'Buatlah aplikasi sederhana untuk menampilkan navigation bottom bar untuk membuat menu profile dan list menggunakan package salomon bottom bar',
      weightPercent: 20,
      maxTimeMinutes: 10,
      sortOrder: 2,
    ),
    ExamQuestion(
      id: 3,
      number: 3,
      question:
          'Buatlah aplikasi sederhana untuk menampilkan profile yang terdiri dari foto, nama, NIM dan kelas kalian',
      weightPercent: 25,
      maxTimeMinutes: 15,
      sortOrder: 3,
    ),
    ExamQuestion(
      id: 4,
      number: 4,
      question:
          'Buatlah aplikasi sederhana dari gabungan soal pada nomor 1, 2 dan 3',
      weightPercent: 30,
      maxTimeMinutes: 20,
      sortOrder: 4,
    ),
  ],
);

const uasExam = Exam(
  id: 2,
  course: mobileProgrammingCourse,
  type: ExamType.uas,
  title: 'Ujian Akhir Semester (UAS)',
  classCode: '04SIFE008',
  status: ExamStatus.draft,
);
