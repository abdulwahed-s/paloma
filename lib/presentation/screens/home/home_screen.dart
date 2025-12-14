// lib/presentation/screens/home/home_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:paloma/controllers/home_controller.dart';
import 'package:paloma/presentation/widgets/home/home_app_bar.dart';
import 'package:paloma/presentation/widgets/home/home_drawer.dart';
import 'package:paloma/presentation/widgets/home/logout_dialog.dart';
import 'package:paloma/presentation/widgets/home/message_input.dart';
import 'package:paloma/presentation/widgets/home/posts_empty_state.dart';
import 'package:paloma/presentation/widgets/home/posts_list.dart';
import 'package:paloma/presentation/widgets/home/posts_shimmer_loading.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final HomeController _controller = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: HomeAppBar(colorScheme: colorScheme),
      drawer: HomeDrawer(
        colorScheme: colorScheme,
        onShowLogoutDialog: () => LogoutDialog.show(context),
      ),
      body: Column(
        children: [
          // Add a subtle divider
          Container(
            height: 1,
            color: colorScheme.outlineVariant.withValues(alpha: 0.3),
          ),
          Expanded(
            child: Obx(() {
              if (_controller.isLoading) {
                return PostsShimmerLoading(colorScheme: colorScheme);
              }
              if (_controller.posts.isEmpty) {
                return PostsEmptyState(colorScheme: colorScheme);
              }

              return PostsList(
                posts: _controller.posts,
                users: _controller.users,
              );
            }),
          ),
          MessageInput(
            colorScheme: colorScheme,
            controller: _controller.messageController,
            onSendPost: _controller.sendPost,
          ),
        ],
      ),
    );
  }
}
