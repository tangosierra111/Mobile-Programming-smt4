import 'package:flutter/material.dart';

import 'profile_data.dart';

class ProfileAvatar extends StatelessWidget {
  const ProfileAvatar({
    super.key,
    required this.profile,
    this.size = 96,
    this.onTap,
    this.showEditBadge = false,
  });

  final ProfileData profile;
  final double size;
  final VoidCallback? onTap;
  final bool showEditBadge;

  @override
  Widget build(BuildContext context) {
    final avatar = Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 3),
            boxShadow: const [
              BoxShadow(
                color: Color(0x26000000),
                blurRadius: 12,
                offset: Offset(0, 6),
              ),
            ],
          ),
          child: ClipOval(
            child: _ProfileAvatarImage(
              profile: profile,
              size: size,
            ),
          ),
        ),
        if (showEditBadge)
          Positioned(
            right: -2,
            bottom: -2,
            child: Container(
              width: size * 0.32,
              height: size * 0.32,
              decoration: BoxDecoration(
                color: const Color(0xFF0A66C2),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
              ),
              child: Icon(
                Icons.camera_alt_outlined,
                color: Colors.white,
                size: size * 0.17,
              ),
            ),
          ),
      ],
    );

    if (onTap == null) {
      return avatar;
    }

    return InkWell(
      onTap: onTap,
      customBorder: const CircleBorder(),
      child: avatar,
    );
  }
}

class _ProfileAvatarImage extends StatelessWidget {
  const _ProfileAvatarImage({
    required this.profile,
    required this.size,
  });

  final ProfileData profile;
  final double size;

  @override
  Widget build(BuildContext context) {
    final photoBytes = profile.photoBytes;
    if (photoBytes != null) {
      return Image.memory(
        photoBytes,
        width: size,
        height: size,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _AvatarFallback(profile: profile),
      );
    }

    return Image.asset(
      ProfileData.defaultPhotoAsset,
      width: size,
      height: size,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => _AvatarFallback(profile: profile),
    );
  }
}

class _AvatarFallback extends StatelessWidget {
  const _AvatarFallback({required this.profile});

  final ProfileData profile;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: const Color(0xFFD7E7FF),
      child: Center(
        child: Text(
          profile.initials,
          style: const TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.w800,
            color: Color(0xFF376FD8),
          ),
        ),
      ),
    );
  }
}
