import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:paloma/presentation/widgets/home/modern_post.dart';

class PostsList extends StatelessWidget {
  const PostsList({super.key, required this.posts, required this.users});

  final RxList<DocumentSnapshot> posts;
  final Map<String, dynamic> users;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      reverse: true,
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: posts.length,
      itemBuilder: (context, index) {
        final post = posts[index] as QueryDocumentSnapshot;
        final postData = post.data() as Map<String, dynamic>;
        final uid = postData['uid'];
        final userData = users[uid] ?? {};

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          child: ModernPost(
            username: userData['username'] ?? 'Unknown',
            message: postData['content'],
            timestamp: postData['timestamp'],
            postId: post.id,
            likes: List<String>.from(postData['likes'] ?? []),
            userPfp: userData['pfp'] ?? '',
            posterRole: userData['role'] ?? '',
            posterUid: uid,
          ),
        );
      },
    );
  }
}
