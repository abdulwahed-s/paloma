import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ProfilePictureSection extends StatelessWidget {
  const ProfilePictureSection({
    super.key,
    required this.colorScheme,
    required this.profilePictureUrl,
    required this.isUploadingPicture,
    required this.onChangeProfilePicture,
  });

  final ColorScheme colorScheme;
  final String profilePictureUrl;
  final bool isUploadingPicture;
  final VoidCallback onChangeProfilePicture;

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: const Offset(0, -50),
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: colorScheme.shadow.withValues(alpha: 0.15),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Stack(
          alignment: Alignment.bottomRight,
          children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: colorScheme.surface,
                border: Border.all(
                  color: colorScheme.outline.withValues(alpha: 0.2),
                  width: 2,
                ),
              ),
              padding: const EdgeInsets.all(4),
              child: ClipOval(
                child: SizedBox.fromSize(
                  size: const Size.fromRadius(60),
                  child: Stack(
                    children: [
                      CachedNetworkImage(
                        imageUrl: profilePictureUrl,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: double.infinity,
                        errorWidget: (context, url, error) => Container(
                          color: colorScheme.surfaceVariant,
                          child: Icon(
                            Icons.person,
                            size: 60,
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                        placeholder: (context, url) => Container(
                          color: colorScheme.surfaceVariant,
                          child: CircularProgressIndicator(
                            color: colorScheme.primary,
                          ),
                        ),
                      ),
                      // Loading overlay for picture change
                      if (isUploadingPicture)
                        Container(
                          color: Colors.black.withValues(alpha: 0.5),
                          child: Center(
                            child: CircularProgressIndicator(
                              color: colorScheme.onPrimary,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
            // Edit button for profile picture
            Positioned(
              right: 0,
              bottom: 0,
              child: Container(
                decoration: BoxDecoration(
                  color: colorScheme.primaryContainer,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: colorScheme.shadow.withValues(alpha: 0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: IconButton(
                  onPressed: isUploadingPicture ? null : onChangeProfilePicture,
                  icon: Icon(
                    Icons.camera_alt_outlined,
                    color: colorScheme.onPrimaryContainer,
                    size: 20,
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 40,
                    minHeight: 40,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
