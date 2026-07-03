import 'dart:typed_data';

class ProfileData {
  const ProfileData({
    required this.fullName,
    required this.location,
    required this.position,
    required this.profession,
    required this.email,
    required this.phoneNumber,
    required this.about,
    required this.projects,
    required this.followers,
    required this.experienceLabel,
    required this.photoBytes,
    this.userId,
    this.photoUrl,
    this.linkedinUrl,
  });

  static const String defaultPhotoAsset = 'assets/images/default_profile.png';

  final int? userId;
  final String fullName;
  final String location;
  final String position;
  final String profession;
  final String email;
  final String phoneNumber;
  final String about;
  final String projects;
  final String followers;
  final String experienceLabel;
  final String? photoUrl;
  final String? linkedinUrl;
  final Uint8List? photoBytes;

  static const ProfileData initial = ProfileData(
    fullName: 'Tiofan Pamor Wibowo',
    location: 'Jakarta, Indonesia',
    position: 'Mahasiswa',
    profession: 'Project Manager',
    email: 'taruna.tiofan11@gmail.com',
    phoneNumber: '082213677657',
    about:
        'Saya adalah seorang mahasiswa yang memiliki minat besar dalam dunia teknologi dan manajemen proyek. Dengan pengalaman sebagai project manager, saya telah berhasil memimpin berbagai proyek yang melibatkan tim lintas fungsi. Saya memiliki kemampuan komunikasi yang baik, serta mampu mengelola waktu dan sumber daya dengan efektif untuk mencapai tujuan proyek. Saya selalu bersemangat untuk belajar hal baru dan berkontribusi dalam lingkungan kerja yang dinamis.',
    projects: '21',
    followers: '5000',
    experienceLabel: '9Y',
    photoBytes: null,
  );

  static const ProfileData empty = ProfileData(
    fullName: '',
    location: '',
    position: '',
    profession: '',
    email: '',
    phoneNumber: '',
    about: '',
    projects: '0',
    followers: '0',
    experienceLabel: '0Y',
    photoBytes: null,
  );

  bool get isEmpty =>
      fullName.isEmpty &&
      location.isEmpty &&
      position.isEmpty &&
      profession.isEmpty &&
      email.isEmpty &&
      phoneNumber.isEmpty &&
      about.isEmpty;

  String get initials {
    final parts = fullName
        .trim()
        .split(RegExp(r'\s+'))
        .where((part) => part.isNotEmpty)
        .toList();

    if (parts.isEmpty) return 'P';
    if (parts.length == 1) {
      return parts.first.substring(0, 1).toUpperCase();
    }
    return (parts.first.substring(0, 1) + parts.last.substring(0, 1))
        .toUpperCase();
  }

  factory ProfileData.fromJson(Map<String, dynamic> json) {
    final experience = (json['experience_years'] as num?)?.toInt() ?? 0;
    return ProfileData(
      userId: (json['user_id'] as num?)?.toInt(),
      fullName: json['full_name'] as String? ?? '',
      location: json['location'] as String? ?? '',
      position: json['position'] as String? ?? '',
      profession: json['profession'] as String? ?? '',
      email: json['email'] as String? ?? '',
      phoneNumber: json['phone_number'] as String? ?? '',
      about: json['about'] as String? ?? '',
      projects: '${(json['projects_count'] as num?)?.toInt() ?? 0}',
      followers: '${(json['followers_count'] as num?)?.toInt() ?? 0}',
      experienceLabel: '${experience}Y',
      photoUrl: json['photo_url'] as String?,
      linkedinUrl: json['linkedin_url'] as String?,
      photoBytes: null,
    );
  }

  Map<String, dynamic> toJson() => {
        'user_id': userId,
        'full_name': fullName,
        'location': location,
        'position': position,
        'profession': profession,
        'email': email,
        'phone_number': phoneNumber,
        'about': about,
        'photo_url': photoUrl,
        'projects_count': int.tryParse(projects) ?? 0,
        'followers_count': int.tryParse(followers) ?? 0,
        'experience_years':
            int.tryParse(experienceLabel.replaceAll(RegExp(r'[^0-9]'), '')) ??
                0,
        'linkedin_url': linkedinUrl,
      };

  ProfileData copyWith({
    int? userId,
    String? fullName,
    String? location,
    String? position,
    String? profession,
    String? email,
    String? phoneNumber,
    String? about,
    String? projects,
    String? followers,
    String? experienceLabel,
    String? photoUrl,
    String? linkedinUrl,
    Uint8List? photoBytes,
  }) {
    return ProfileData(
      userId: userId ?? this.userId,
      fullName: fullName ?? this.fullName,
      location: location ?? this.location,
      position: position ?? this.position,
      profession: profession ?? this.profession,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      about: about ?? this.about,
      projects: projects ?? this.projects,
      followers: followers ?? this.followers,
      experienceLabel: experienceLabel ?? this.experienceLabel,
      photoUrl: photoUrl ?? this.photoUrl,
      linkedinUrl: linkedinUrl ?? this.linkedinUrl,
      photoBytes: photoBytes ?? this.photoBytes,
    );
  }
}
