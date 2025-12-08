import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomeController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final RxList<DocumentSnapshot> posts = <DocumentSnapshot>[].obs;
  final RxMap<String, dynamic> users = <String, dynamic>{}.obs;

  final TextEditingController messageController = TextEditingController();

  RxString currentUserRole = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchPosts();
    _fetchUsers();
    _fetchUserRole();
  }

  final RxBool _isLoading = true.obs;
  bool get isLoading => _isLoading.value;

  void fetchPosts() {
    _isLoading.value = true;
    _firestore
        .collection("User_Posts")
        .orderBy("timestamp", descending: false)
        .snapshots()
        .listen(
          (snapshot) {
            posts.assignAll(snapshot.docs.reversed);
            _isLoading.value = false;
          },
          onError: (error) {
            _isLoading.value = false;
          },
        );
  }

  void _fetchUsers() {
    _firestore.collection("users").snapshots().listen((snapshot) {
      users.assignAll({for (var doc in snapshot.docs) doc.id: doc.data()});
    });
  }

  void _fetchUserRole() async {
    await _firestore
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .get()
        .then((doc) => currentUserRole.value = doc.data()?['role'] ?? 'user');
  }

  void sendPost() {
    final message = messageController.text.trim();
    if (message.isNotEmpty) {
      _firestore.collection("User_Posts").add({
        "uid": _auth.currentUser?.uid,
        "content": message,
        "timestamp": FieldValue.serverTimestamp(),
        "likes": [],
      });
      messageController.clear();
    }
  }

  void toggleLike(String postId, List<String> likes) {
    final userId = _auth.currentUser?.uid;
    if (userId == null) return;

    final isLiked = likes.contains(userId);
    final postRef = _firestore.collection("User_Posts").doc(postId);

    if (isLiked) {
      postRef.update({
        "likes": FieldValue.arrayRemove([userId]),
      });
    } else {
      postRef.update({
        "likes": FieldValue.arrayUnion([userId]),
      });
    }
  }

  final RxString _deletingPostId = ''.obs;
  String get deletingPostId => _deletingPostId.value;
  bool isDeleting(String postId) => _deletingPostId.value == postId;

  Future<void> deletePost(String postId) async {
    _deletingPostId.value = postId;
    try {
      final repliesDocs = await _firestore
          .collection("User_Posts")
          .doc(postId)
          .collection("Replies")
          .get();

      for (var doc in repliesDocs.docs) {
        await doc.reference.delete();
      }

      await _firestore.collection("User_Posts").doc(postId).delete();
    } finally {
      _deletingPostId.value = '';
    }
  }

  Future<void> addReply(String postId, String content) async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) return;

    await _firestore
        .collection("User_Posts")
        .doc(postId)
        .collection("Replies")
        .add({
          "content": content,
          "uid": userId,
          "timestamp": FieldValue.serverTimestamp(),
        });
  }

  @override
  void onClose() {
    messageController.dispose();
    super.onClose();
  }
}
