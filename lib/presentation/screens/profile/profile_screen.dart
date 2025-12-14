import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:paloma/controllers/profile_controller.dart';
import 'package:paloma/presentation/widgets/profile/bio_card.dart';
import 'package:paloma/presentation/widgets/profile/edit_dialog.dart';
import 'package:paloma/presentation/widgets/profile/profile_header.dart';
import 'package:paloma/presentation/widgets/profile/profile_picture_section.dart';
import 'package:paloma/presentation/widgets/profile/theme_card.dart';
import 'package:paloma/presentation/widgets/profile/username_card.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({super.key});

  final ProfileController _controller = Get.put(ProfileController());

  void _showEditDialog(
    String type,
    String currentValue,
    Function(String) onSave,
  ) {
    final title = type == 'username' ? 'Edit Username' : 'Edit Bio';
    EditDialog.show(
      title: title,
      initialValue: currentValue,
      onSave: onSave,
      maxLines: type == 'bio' ? 3 : 1,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: const Text(
          'Profile',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
      ),
      body: Obx(() {
        if (_controller.userData == null) {
          return Center(
            child: CircularProgressIndicator(color: colorScheme.primary),
          );
        }

        final userData = _controller.userData!.data() as Map<String, dynamic>;

        return Column(
          children: [
            ProfileHeader(colorScheme: colorScheme),

            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: colorScheme.surface,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: Column(
                  children: [
                    ProfilePictureSection(
                      colorScheme: colorScheme,
                      profilePictureUrl: userData["pfp"] ?? '',
                      isUploadingPicture: _controller.isUploadingPicture,
                      onChangeProfilePicture: _controller.changeProfilePicture,
                    ),

                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          children: [
                            UsernameCard(
                              colorScheme: colorScheme,
                              theme: theme,
                              username: userData['username'] ?? '',
                              onEditPressed: () {
                                _showEditDialog(
                                  'username',
                                  userData['username'] ?? '',
                                  _controller.updateUsername,
                                );
                              },
                            ),

                            const SizedBox(height: 16),

                            BioCard(
                              colorScheme: colorScheme,
                              theme: theme,
                              bio: userData['bio'] ?? '',
                              onEditPressed: () {
                                _showEditDialog(
                                  'bio',
                                  userData['bio'] ?? '',
                                  _controller.updateBio,
                                );
                              },
                            ),

                            const SizedBox(height: 16),

                            ThemeCard(
                              colorScheme: colorScheme,
                              theme: theme,
                              isDarkMode: _controller.isDarkMode,
                              onToggle: _controller.toggleTheme,
                            ),

                            const SizedBox(height: 30),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}
