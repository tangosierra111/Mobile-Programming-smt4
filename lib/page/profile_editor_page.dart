import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

import '../profile_avatar.dart';
import '../profile_data.dart';

class ProfileEditorPage extends StatefulWidget {
  const ProfileEditorPage({
    super.key,
    required this.profile,
    required this.onSave,
    required this.onDelete,
  });

  final ProfileData profile;
  final ValueChanged<ProfileData> onSave;
  final VoidCallback onDelete;

  @override
  State<ProfileEditorPage> createState() => _ProfileEditorPageState();
}

class _ProfileEditorPageState extends State<ProfileEditorPage> {
  late final TextEditingController _fullNameController;
  late final TextEditingController _locationController;
  late final TextEditingController _positionController;
  late final TextEditingController _professionController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;
  late final TextEditingController _aboutController;
  late ProfileData _draftProfile;
  final ImagePicker _imagePicker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _draftProfile = widget.profile;
    _fullNameController = TextEditingController();
    _locationController = TextEditingController();
    _positionController = TextEditingController();
    _professionController = TextEditingController();
    _emailController = TextEditingController();
    _phoneController = TextEditingController();
    _aboutController = TextEditingController();
    _syncControllers(widget.profile);
  }

  @override
  void didUpdateWidget(covariant ProfileEditorPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.profile != widget.profile) {
      _syncControllers(widget.profile);
      _draftProfile = widget.profile;
    }
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _locationController.dispose();
    _positionController.dispose();
    _professionController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _aboutController.dispose();
    super.dispose();
  }

  void _syncControllers(ProfileData profile) {
    _fullNameController.text = profile.fullName;
    _locationController.text = profile.location;
    _positionController.text = profile.position;
    _professionController.text = profile.profession;
    _emailController.text = profile.email;
    _phoneController.text = profile.phoneNumber;
    _aboutController.text = profile.about;
  }

  Future<void> _pickPhoto() async {
    final pickedImage = await _imagePicker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
      maxWidth: 1200,
    );

    if (pickedImage == null) {
      return;
    }

    final bytes = await pickedImage.readAsBytes();
    setState(() {
      _draftProfile = _draftProfile.copyWith(photoBytes: bytes);
    });
  }

  void _showToast(
    String message, {
    Color backgroundColor = const Color(0xFF0A66C2),
  }) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: backgroundColor,
      textColor: Colors.white,
      fontSize: 15,
    );
  }

  ProfileData _buildProfileFromForm() {
    return widget.profile.copyWith(
      fullName: _fullNameController.text.trim(),
      location: _locationController.text.trim(),
      position: _positionController.text.trim(),
      profession: _professionController.text.trim(),
      email: _emailController.text.trim(),
      phoneNumber: _phoneController.text.trim(),
      about: _aboutController.text.trim(),
      photoBytes: _draftProfile.photoBytes,
    );
  }

  Future<void> _showSaveDialog(BuildContext context) async {
    final profile = _buildProfileFromForm();
    if (profile.fullName.isEmpty ||
        profile.location.isEmpty ||
        profile.position.isEmpty ||
        profile.profession.isEmpty ||
        profile.email.isEmpty ||
        profile.phoneNumber.isEmpty ||
        profile.about.isEmpty) {
      _showToast(
        'Lengkapi semua data profil terlebih dahulu',
        backgroundColor: const Color(0xFFE67E22),
      );
      return;
    }

    showDialog<void>(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 24),
                decoration: const BoxDecoration(
                  color: Color(0xFFEAF4FF),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                child: const Icon(
                  Icons.verified_outlined,
                  color: Color(0xFF0A66C2),
                  size: 48,
                ),
              ),
              const Padding(
                padding: EdgeInsets.fromLTRB(20, 18, 20, 8),
                child: Text(
                  'Simpan Profil',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF1F2937),
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.fromLTRB(20, 0, 20, 18),
                child: Text(
                  'Perubahan ini akan disimpan pada menu profil.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFF667085),
                    height: 1.45,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 18),
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Batal'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: FilledButton(
                        onPressed: () {
                          Navigator.pop(context);
                          widget.onSave(profile);
                          _showToast('Profil berhasil disimpan');
                        },
                        style: FilledButton.styleFrom(
                          backgroundColor: const Color(0xFF0A66C2),
                        ),
                        child: const Text('Simpan'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _deleteData() {
    widget.onDelete();
    _syncControllers(ProfileData.empty);
    setState(() {
      _draftProfile = ProfileData.empty;
    });
    _showToast(
      'Data profil berhasil dihapus',
      backgroundColor: const Color(0xFF667085),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 18, 16, 24),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 960),
            child: Column(
              children: [
                _buildHeroCard(),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: const Color(0xFFE5E7EB)),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x0A0F172A),
                        blurRadius: 16,
                        offset: Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      _buildSectionTitle(),
                      const SizedBox(height: 18),
                      Center(
                        child: Column(
                          children: [
                            ProfileAvatar(
                              profile: _draftProfile,
                              size: 108,
                              onTap: _pickPhoto,
                              showEditBadge: true,
                            ),
                            const SizedBox(height: 12),
                            OutlinedButton.icon(
                              onPressed: _pickPhoto,
                              icon: const Icon(Icons.photo_camera_outlined),
                              label: const Text('Ganti Foto'),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 18),
                      _buildResponsiveFields(
                        left: _buildTextField(
                          controller: _fullNameController,
                          labelText: 'Nama Lengkap',
                          icon: Icons.badge_outlined,
                        ),
                        right: _buildTextField(
                          controller: _locationController,
                          labelText: 'Lokasi',
                          icon: Icons.location_on_outlined,
                        ),
                      ),
                      const SizedBox(height: 14),
                      _buildResponsiveFields(
                        left: _buildTextField(
                          controller: _positionController,
                          labelText: 'Jabatan',
                          icon: Icons.work_outline,
                        ),
                        right: _buildTextField(
                          controller: _professionController,
                          labelText: 'Profesi',
                          icon: Icons.groups_2_outlined,
                        ),
                      ),
                      const SizedBox(height: 14),
                      _buildResponsiveFields(
                        left: _buildTextField(
                          controller: _emailController,
                          labelText: 'Email',
                          icon: Icons.mail_outline,
                          keyboardType: TextInputType.emailAddress,
                        ),
                        right: _buildTextField(
                          controller: _phoneController,
                          labelText: 'No. HP',
                          icon: Icons.phone_outlined,
                          keyboardType: TextInputType.phone,
                        ),
                      ),
                      const SizedBox(height: 14),
                      _buildTextField(
                        controller: _aboutController,
                        labelText: 'Tentang Saya',
                        icon: Icons.info_outline,
                        maxLines: 6,
                      ),
                      const SizedBox(height: 18),
                      Row(
                        children: [
                          Expanded(
                            child: FilledButton.icon(
                              onPressed: () => _showSaveDialog(context),
                              style: FilledButton.styleFrom(
                                backgroundColor: const Color(0xFF0A66C2),
                                foregroundColor: Colors.white,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              icon: const Icon(Icons.save_outlined),
                              label: const Text(
                                'Simpan Profil',
                                style: TextStyle(fontWeight: FontWeight.w700),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: _deleteData,
                              style: OutlinedButton.styleFrom(
                                foregroundColor: const Color(0xFF475467),
                                side: const BorderSide(
                                  color: Color(0xFFD0D5DD),
                                ),
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              icon: const Icon(Icons.delete_outline),
                              label: const Text(
                                'Hapus',
                                style: TextStyle(fontWeight: FontWeight.w700),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeroCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0A66C2), Color(0xFF378FE9)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1A0A66C2),
            blurRadius: 20,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: SizedBox(
              width: 70,
              height: 70,
              child: Image(
                image: _heroPhotoProvider,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) {
                  return const ColoredBox(
                    color: Colors.white,
                    child: Icon(
                      Icons.person_pin_outlined,
                      size: 36,
                      color: Color(0xFF0A66C2),
                    ),
                  );
                },
              ),
            ),
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Editor Profil Profesional',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  'Tampilan dibuat lebih clean dan profesional agar terasa seperti panel pengelola profil LinkedIn.',
                  style: TextStyle(
                    color: Color(0xFFEAF4FF),
                    height: 1.5,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  ImageProvider<Object> get _heroPhotoProvider {
    final photoBytes = _draftProfile.photoBytes;
    if (photoBytes != null) {
      return MemoryImage(photoBytes);
    }

    return const AssetImage(ProfileData.defaultPhotoAsset);
  }

  Widget _buildSectionTitle() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: const Color(0xFFEAF4FF),
            borderRadius: BorderRadius.circular(14),
          ),
          child: const Icon(Icons.edit_document, color: Color(0xFF0A66C2)),
        ),
        const SizedBox(width: 12),
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Lengkapi Data Profil',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1F2937),
                ),
              ),
              SizedBox(height: 4),
              Text(
                'Informasi di bawah ini akan digunakan untuk membentuk tampilan profil yang lebih profesional.',
                style: TextStyle(
                  color: Color(0xFF667085),
                  height: 1.45,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildResponsiveFields({
    required Widget left,
    required Widget right,
  }) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 680) {
          return Column(
            children: [
              left,
              const SizedBox(height: 14),
              right,
            ],
          );
        }

        return Row(
          children: [
            Expanded(child: left),
            const SizedBox(width: 14),
            Expanded(child: right),
          ],
        );
      },
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    required IconData icon,
    TextInputType? keyboardType,
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: labelText,
        prefixIcon: Icon(icon, color: const Color(0xFF0A66C2)),
        filled: true,
        fillColor: const Color(0xFFF8FAFC),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFD0D5DD)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF0A66C2), width: 1.2),
        ),
      ),
    );
  }
}
