# Kontrak API Mobile Programming

Dokumen ini menjadi kesepakatan antara Laravel API dan aplikasi Flutter.
Spesifikasi mesin yang lebih lengkap tersedia di `docs/openapi.yaml`.

## Aturan umum

- Base path: `/api/v1`
- Format: JSON UTF-8, kecuali upload foto menggunakan `multipart/form-data`.
- Nama properti: `snake_case` agar sama dengan Laravel dan database.
- ID tabel: integer. ID item dashboard: string berformat `meeting-{id}` atau
  `exam-{id}` agar tidak bertabrakan.
- Waktu: ISO-8601, misalnya `2026-07-03T13:30:00Z`.
- Tanggal: `YYYY-MM-DD`.
- Warna: hexadecimal `#RRGGBB`.
- Nilai kosong menggunakan `null`, bukan teks `"Belum tersedia"`.
- Boolean harus dikirim sebagai `true`/`false`, bukan `0`/`1`.

## Autentikasi

Flutter mengirim Firebase ID token:

```http
Authorization: Bearer <firebase-id-token>
Accept: application/json
```

Laravel memverifikasi token Firebase, kemudian mencocokkan claim `uid` dengan
`users.firebase_uid`. Endpoint `POST /auth/sync` membuat atau memperbarui user
Laravel setelah login Firebase berhasil.

## Envelope respons

Respons berhasil:

```json
{
  "success": true,
  "message": "Data berhasil diambil.",
  "data": {},
  "meta": null
}
```

Validasi gagal (`422`):

```json
{
  "success": false,
  "message": "Data yang diberikan tidak valid.",
  "errors": {
    "full_name": ["Nama lengkap wajib diisi."]
  }
}
```

Kode status yang digunakan: `200`, `201`, `204`, `400`, `401`, `403`, `404`,
`409`, `422`, dan `500`.

## Endpoint utama

| Method | Endpoint | Fungsi |
|---|---|---|
| POST | `/auth/sync` | Sinkronkan akun Firebase dengan tabel `users` |
| GET | `/courses` | Daftar mata kuliah aktif |
| GET | `/courses/{course}/dashboard` | Course, materi/ujian, dan progres pengguna |
| GET | `/meetings/{meeting}` | Detail materi beserta content blocks |
| PUT | `/meetings/{meeting}/progress` | Simpan progres belajar pengguna |
| GET | `/profile` | Profil pengguna aktif |
| PUT | `/profile` | Perbarui profil |
| POST | `/profile/photo` | Upload foto profil |
| GET | `/exams/{exam}` | Detail ujian dan soal |
| POST | `/exams/{exam}/attempts` | Mulai percobaan ujian |
| PUT | `/attempts/{attempt}/answers/{question}` | Simpan jawaban |
| POST | `/attempts/{attempt}/submit` | Kirim jawaban ujian |

## Contoh dashboard

```json
{
  "success": true,
  "message": "Dashboard berhasil diambil.",
  "data": {
    "course": {
      "id": 1,
      "code": "04SIFE008",
      "name": "Mobile Programming",
      "study_program": "Sistem Informasi",
      "faculty": "Ilmu Komputer",
      "lecturer_name": "Nafiah, S.Si., M.Kom",
      "description": "Materi Mobile Programming menggunakan Flutter dan Dart.",
      "is_active": true
    },
    "items": [
      {
        "id": "meeting-1",
        "source_id": 1,
        "type": "meeting",
        "route_key": "meeting-1",
        "meeting_number": 1,
        "exam_type": null,
        "slug": "pertemuan-1",
        "title": "Pertemuan 1",
        "accent_color": "#0A66C2",
        "background_color": "#EAF4FF",
        "status": "published",
        "interactive_demo_key": "flutter_introduction",
        "sort_order": 1,
        "keywords": ["flutter", "dart", "widget"],
        "progress": {
          "status": "completed",
          "progress_percent": 100,
          "completed_at": "2026-07-03T13:30:00Z"
        }
      },
      {
        "id": "exam-1",
        "source_id": 1,
        "type": "exam",
        "route_key": "exam-uts",
        "meeting_number": null,
        "exam_type": "uts",
        "slug": null,
        "title": "Ujian Tengah Semester (UTS)",
        "accent_color": "#2563EB",
        "background_color": "#EAF4FF",
        "status": "published",
        "interactive_demo_key": null,
        "sort_order": 8,
        "keywords": ["uts", "ujian tengah semester"],
        "progress": null
      }
    ],
    "progress_summary": {
      "published_meetings": 10,
      "completed_meetings": 1,
      "progress_percent": 10.0
    }
  },
  "meta": null
}
```

## Contoh detail materi

```json
{
  "success": true,
  "message": "Materi berhasil diambil.",
  "data": {
    "id": 7,
    "course_id": 1,
    "meeting_number": 7,
    "slug": "pertemuan-7",
    "title": "Pertemuan 7",
    "summary": "Penggunaan RadioButton pada Flutter.",
    "accent_color": "#F59E0B",
    "background_color": "#FFF5E5",
    "status": "published",
    "available_at": null,
    "interactive_demo_key": "radio_button_demo",
    "sort_order": 7,
    "keywords": ["radio", "radiobutton", "radiolisttile"],
    "content_blocks": [
      {
        "id": 1,
        "meeting_id": 7,
        "block_key": "introduction",
        "block_type": "paragraph",
        "title": "Pengenalan",
        "content_json": {
          "text": "RadioButton digunakan ketika pengguna memilih satu opsi."
        },
        "sort_order": 1,
        "is_visible": true
      },
      {
        "id": 2,
        "meeting_id": 7,
        "block_key": "interactive-demo",
        "block_type": "demo",
        "title": "Contoh Interaktif",
        "content_json": {
          "demo_key": "radio_button_demo"
        },
        "sort_order": 2,
        "is_visible": true
      }
    ]
  },
  "meta": null
}
```

`demo_key` hanya memilih widget Flutter yang telah tersedia. Laravel tidak
mengirim source code UI untuk dieksekusi.

## Contoh profil

`email` berasal dari tabel `users`, sedangkan properti lainnya berasal dari
`profiles`.

```json
{
  "success": true,
  "message": "Profil berhasil diambil.",
  "data": {
    "user_id": 1,
    "full_name": "Tiofan Pamor Wibowo",
    "email": "taruna.tiofan11@gmail.com",
    "location": "Jakarta, Indonesia",
    "position": "Mahasiswa",
    "profession": "Project Manager",
    "phone_number": "082213677657",
    "about": "Deskripsi profil.",
    "photo_url": "http://127.0.0.1:8000/storage/profiles/1.jpg",
    "projects_count": 21,
    "followers_count": 5000,
    "experience_years": 9,
    "linkedin_url": null
  },
  "meta": null
}
```

## Implementasi Laravel

- Gunakan API Resources agar tipe JSON konsisten.
- Cast `is_active` dan `is_visible` sebagai boolean.
- Cast `content_json` dan `options_json` sebagai array.
- Eager-load `keywords`, `contentBlocks`, `course`, dan `questions` untuk
  menghindari N+1 query.
- Hanya kirim meeting berstatus `published` kepada student, kecuali user admin
  atau lecturer.
- `user_id` untuk progres dan ujian harus selalu diambil dari user terautentikasi,
  bukan dipercaya dari request body.

## URL pengembangan Flutter

- Android emulator: `http://10.0.2.2:8000/api/v1`
- Windows/Web lokal: `http://127.0.0.1:8000/api/v1`
- Perangkat fisik: `http://<IP-LAN-komputer>:8000/api/v1`

Laravel perlu mengizinkan CORS untuk origin Web Flutter yang digunakan saat
pengembangan.
