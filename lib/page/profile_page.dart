import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

import '../profile_avatar.dart';
import '../profile_data.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({
    super.key,
    required this.profile,
    required this.onSave,
    this.onBackHome,
  });

  final ProfileData profile;
  final ValueChanged<ProfileData> onSave;
  final VoidCallback? onBackHome;

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  void _showToast(String message,
      {Color backgroundColor = const Color(0xFF0A66C2)}) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: backgroundColor,
      textColor: Colors.white,
      fontSize: 15,
    );
  }

  Future<void> _openEditSheet() async {
    final updatedProfile = await showModalBottomSheet<ProfileData>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _ProfileEditSheet(profile: widget.profile),
    );

    if (updatedProfile == null) {
      return;
    }

    widget.onSave(updatedProfile);
    _showToast('Profil berhasil diperbarui');
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: widget.profile.isEmpty
          ? _EmptyProfileState(onBackHome: widget.onBackHome)
          : ListView(
              padding: const EdgeInsets.only(bottom: 24),
              children: [
                _ProfileHero(
                  profile: widget.profile,
                  onEdit: _openEditSheet,
                  onSeeDetail: () {
                    _showToast('Profil profesional sedang ditampilkan');
                  },
                ),
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: _ProfileActionCard(
                    profile: widget.profile,
                    onEdit: _openEditSheet,
                  ),
                ),
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: _SectionCard(
                    title: 'Tentang',
                    actionLabel: 'Edit',
                    onAction: _openEditSheet,
                    child: Text(
                      widget.profile.about,
                      style: const TextStyle(
                        fontSize: 15,
                        height: 1.7,
                        color: Color(0xFF344054),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: _SectionCard(
                    title: 'Informasi Pribadi',
                    child: Column(
                      children: [
                        _InfoTile(
                          icon: Icons.badge_outlined,
                          label: 'Nama Lengkap',
                          value: widget.profile.fullName,
                        ),
                        _InfoTile(
                          icon: Icons.location_on_outlined,
                          label: 'Lokasi',
                          value: widget.profile.location,
                        ),
                        _InfoTile(
                          icon: Icons.work_outline,
                          label: 'Jabatan',
                          value: widget.profile.position,
                        ),
                        _InfoTile(
                          icon: Icons.groups_2_outlined,
                          label: 'Profesi',
                          value: widget.profile.profession,
                        ),
                        _InfoTile(
                          icon: Icons.mail_outline,
                          label: 'Email',
                          value: widget.profile.email,
                        ),
                        _InfoTile(
                          icon: Icons.phone_outlined,
                          label: 'No. HP',
                          value: widget.profile.phoneNumber,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: _SectionCard(
                    title: 'Kontak & Identitas',
                    child: Column(
                      children: [
                        _MiniContactRow(
                          icon: Icons.mail_outline,
                          title: 'Email',
                          subtitle: widget.profile.email,
                        ),
                        const Divider(height: 20),
                        _MiniContactRow(
                          icon: Icons.phone_outlined,
                          title: 'No. HP',
                          subtitle: widget.profile.phoneNumber,
                        ),
                        const Divider(height: 20),
                        _MiniContactRow(
                          icon: Icons.badge_outlined,
                          title: 'Headline',
                          subtitle:
                              '${widget.profile.position} • ${widget.profile.profession}',
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: _SectionCard(
                    title: 'Highlights',
                    child: _StatsCard(profile: widget.profile),
                  ),
                ),
              ],
            ),
    );
  }
}

class _ProfileHero extends StatelessWidget {
  const _ProfileHero({
    required this.profile,
    required this.onEdit,
    required this.onSeeDetail,
  });

  final ProfileData profile;
  final VoidCallback onEdit;
  final VoidCallback onSeeDetail;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF0A66C2), Color(0xFF378FE9)],
        ),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(28)),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 18, 20, 24),
        child: Column(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                onPressed: onEdit,
                style: IconButton.styleFrom(
                  backgroundColor: Colors.white24,
                  foregroundColor: Colors.white,
                ),
                icon: const Icon(Icons.edit_outlined),
              ),
            ),
            ProfileAvatar(profile: profile),
            const SizedBox(height: 14),
            Text(
              profile.fullName,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w800,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              profile.profession,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w600,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              profile.location,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
              decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                profile.position,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: onSeeDetail,
                style: FilledButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: const Color(0xFF0A66C2),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                icon: const Icon(Icons.visibility_outlined),
                label: const Text(
                  'Lihat Detail Profil',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileActionCard extends StatelessWidget {
  const _ProfileActionCard({
    required this.profile,
    required this.onEdit,
  });

  static const String _linkedInProfileUrl =
      'https://www.linkedin.com/in/tiofan-pamor-wibowo-973166b6/';

  final ProfileData profile;
  final VoidCallback onEdit;

  Future<void> _copyProfileLink() async {
    await Clipboard.setData(const ClipboardData(text: _linkedInProfileUrl));
    Fluttertoast.showToast(
      msg: 'Link LinkedIn berhasil disalin',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: const Color(0xFF475467),
      textColor: Colors.white,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
          Row(
            children: [
              Expanded(
                child: FilledButton.icon(
                  onPressed: onEdit,
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFF0A66C2),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  icon: const Icon(Icons.edit_outlined),
                  label: const Text(
                    'Edit Profil',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _copyProfileLink,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF475467),
                    side: const BorderSide(color: Color(0xFFD0D5DD)),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  icon: const Icon(Icons.share_outlined),
                  label: const Text(
                    'Share',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: _ProfileMetaChip(
                  icon: Icons.location_on_outlined,
                  label: profile.location,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _ProfileMetaChip(
                  icon: Icons.badge_outlined,
                  label: profile.position,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ProfileMetaChip extends StatelessWidget {
  const _ProfileMetaChip({
    required this.icon,
    required this.label,
  });

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, size: 18, color: const Color(0xFF0A66C2)),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: Color(0xFF344054),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({
    required this.title,
    required this.child,
    this.actionLabel,
    this.onAction,
  });

  final String title;
  final Widget child;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF1F2937),
                  ),
                ),
              ),
              if (actionLabel != null && onAction != null)
                TextButton(
                  onPressed: onAction,
                  child: Text(actionLabel!),
                ),
            ],
          ),
          const SizedBox(height: 14),
          child,
        ],
      ),
    );
  }
}

class _StatsCard extends StatelessWidget {
  const _StatsCard({required this.profile});

  final ProfileData profile;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxWidth < 520;
        return compact
            ? Column(
                children: [
                  _StatItem(
                    icon: Icons.work_outline,
                    value: profile.projects,
                    label: 'Proyek',
                  ),
                  const SizedBox(height: 12),
                  _StatItem(
                    icon: Icons.groups_2_outlined,
                    value: profile.followers,
                    label: 'Pengikut',
                  ),
                  const SizedBox(height: 12),
                  _StatItem(
                    icon: Icons.trending_up,
                    value: profile.experienceLabel,
                    label: 'Pengalaman',
                  ),
                ],
              )
            : Row(
                children: [
                  Expanded(
                    child: _StatItem(
                      icon: Icons.work_outline,
                      value: profile.projects,
                      label: 'Proyek',
                    ),
                  ),
                  const _VerticalDividerLine(),
                  Expanded(
                    child: _StatItem(
                      icon: Icons.groups_2_outlined,
                      value: profile.followers,
                      label: 'Pengikut',
                    ),
                  ),
                  const _VerticalDividerLine(),
                  Expanded(
                    child: _StatItem(
                      icon: Icons.trending_up,
                      value: profile.experienceLabel,
                      label: 'Pengalaman',
                    ),
                  ),
                ],
              );
      },
    );
  }
}

class _StatItem extends StatelessWidget {
  const _StatItem({
    required this.icon,
    required this.value,
    required this.label,
  });

  final IconData icon;
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: const Color(0xFF0A66C2), size: 24),
        const SizedBox(height: 6),
        Text(
          value,
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w800,
            color: Color(0xFF0A66C2),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFF667085),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class _VerticalDividerLine extends StatelessWidget {
  const _VerticalDividerLine();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 48,
      color: const Color(0xFFE5E7EB),
      margin: const EdgeInsets.symmetric(horizontal: 12),
    );
  }
}

class _InfoTile extends StatelessWidget {
  const _InfoTile({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: const Color(0xFFEAF4FF),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: const Color(0xFF0A66C2), size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    color: Color(0xFF667085),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    color: Color(0xFF1F2937),
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MiniContactRow extends StatelessWidget {
  const _MiniContactRow({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: const Color(0xFFEAF4FF),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: const Color(0xFF0A66C2), size: 18),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Color(0xFF667085),
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: const TextStyle(
                  color: Color(0xFF1F2937),
                  fontWeight: FontWeight.w600,
                  height: 1.45,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ProfileEditSheet extends StatefulWidget {
  const _ProfileEditSheet({required this.profile});

  final ProfileData profile;

  @override
  State<_ProfileEditSheet> createState() => _ProfileEditSheetState();
}

class _ProfileEditSheetState extends State<_ProfileEditSheet> {
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
    _fullNameController = TextEditingController(text: widget.profile.fullName);
    _locationController = TextEditingController(text: widget.profile.location);
    _positionController = TextEditingController(text: widget.profile.position);
    _professionController =
        TextEditingController(text: widget.profile.profession);
    _emailController = TextEditingController(text: widget.profile.email);
    _phoneController = TextEditingController(text: widget.profile.phoneNumber);
    _aboutController = TextEditingController(text: widget.profile.about);
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

  void _submit() {
    final updated = widget.profile.copyWith(
      fullName: _fullNameController.text.trim(),
      location: _locationController.text.trim(),
      position: _positionController.text.trim(),
      profession: _professionController.text.trim(),
      email: _emailController.text.trim(),
      phoneNumber: _phoneController.text.trim(),
      about: _aboutController.text.trim(),
      photoBytes: _draftProfile.photoBytes,
    );

    if (updated.fullName.isEmpty ||
        updated.location.isEmpty ||
        updated.position.isEmpty ||
        updated.profession.isEmpty ||
        updated.email.isEmpty ||
        updated.phoneNumber.isEmpty ||
        updated.about.isEmpty) {
      Fluttertoast.showToast(
        msg: 'Lengkapi semua field profil',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: const Color(0xFFE67E22),
        textColor: Colors.white,
      );
      return;
    }

    Navigator.pop(context, updated);
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Padding(
      padding: EdgeInsets.only(top: 80, bottom: bottomInset),
      child: Container(
        decoration: const BoxDecoration(
          color: Color(0xFFF8FAFC),
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: SafeArea(
          top: false,
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 44,
                    height: 5,
                    decoration: BoxDecoration(
                      color: const Color(0xFFD0D5DD),
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                const Text(
                  'Edit Profil',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF1F2937),
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Perubahan di sini akan langsung memperbarui tampilan profil utama.',
                  style: TextStyle(
                    color: Color(0xFF667085),
                    height: 1.45,
                  ),
                ),
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
                _SheetField(
                  controller: _fullNameController,
                  label: 'Nama Lengkap',
                  icon: Icons.badge_outlined,
                ),
                const SizedBox(height: 12),
                _SheetField(
                  controller: _locationController,
                  label: 'Lokasi',
                  icon: Icons.location_on_outlined,
                ),
                const SizedBox(height: 12),
                _SheetField(
                  controller: _positionController,
                  label: 'Jabatan',
                  icon: Icons.work_outline,
                ),
                const SizedBox(height: 12),
                _SheetField(
                  controller: _professionController,
                  label: 'Profesi',
                  icon: Icons.groups_2_outlined,
                ),
                const SizedBox(height: 12),
                _SheetField(
                  controller: _emailController,
                  label: 'Email',
                  icon: Icons.mail_outline,
                ),
                const SizedBox(height: 12),
                _SheetField(
                  controller: _phoneController,
                  label: 'No. HP',
                  icon: Icons.phone_outlined,
                ),
                const SizedBox(height: 12),
                _SheetField(
                  controller: _aboutController,
                  label: 'Tentang Saya',
                  icon: Icons.info_outline,
                  maxLines: 5,
                ),
                const SizedBox(height: 18),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: _submit,
                    style: FilledButton.styleFrom(
                      backgroundColor: const Color(0xFF0A66C2),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                    ),
                    icon: const Icon(Icons.save_outlined),
                    label: const Text(
                      'Simpan Perubahan',
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SheetField extends StatelessWidget {
  const _SheetField({
    required this.controller,
    required this.label,
    required this.icon,
    this.maxLines = 1,
  });

  final TextEditingController controller;
  final String label;
  final IconData icon;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: const Color(0xFF0A66C2)),
        filled: true,
        fillColor: Colors.white,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFD0D5DD)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF0A66C2)),
        ),
      ),
    );
  }
}

class _EmptyProfileState extends StatelessWidget {
  const _EmptyProfileState({this.onBackHome});

  final VoidCallback? onBackHome;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Container(
          constraints: const BoxConstraints(maxWidth: 420),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: const [
              BoxShadow(
                color: Color(0x120F172A),
                blurRadius: 20,
                offset: Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 76,
                height: 76,
                decoration: BoxDecoration(
                  color: const Color(0xFFEAF2FF),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: const Icon(
                  Icons.person_off_outlined,
                  color: Color(0xFF0A66C2),
                  size: 38,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Data profil belum tersedia',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1F2937),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Isi form di menu editor terlebih dahulu agar detail profil bisa ditampilkan di sini.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFF667085),
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 18),
              FilledButton.icon(
                onPressed: onBackHome,
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFF0A66C2),
                  foregroundColor: Colors.white,
                ),
                icon: const Icon(Icons.arrow_back_outlined),
                label: const Text('Kembali ke Editor'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
