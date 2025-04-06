import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_ui/features/auth/domain/entities/app_user.dart';
import 'package:my_ui/features/auth/profiel/presentation/cubits/profiel_cubit.dart';
import 'package:my_ui/features/post/domain/entities/post.dart';
import 'package:my_ui/features/post/domain/repo/post_repo.dart';
import 'package:my_ui/features/post/domain/entities/comment.dart';
import 'package:my_ui/features/post/presentation/cubits/post_states.dart';
import 'package:my_ui/features/storage/domain/storage_repo.dart';

class PostCubit extends Cubit<PostStates> {
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  AppUser? currentUser;
  Future<void> updateProfileInFirebase(String uid, String imageUrl) async {
    try {
      final userDoc = firebaseFirestore.collection('users').doc(uid);
      await userDoc.update({
        'profielImageUrl': imageUrl,
      });
      print("Profile updated successfully in Firebase");
    } catch (e) {
      print("Error updating profile in Firebase: $e");
    }
  }
  //   Future<PostCubit?> getUserProfile(String uid) async {
  //   final user = await postRepo.fetchUserProfile(uid);
  //   return user;
  // }

  final PostRepo postRepo;
  final StorageRepo storageRepo;
  PostCubit({required this.postRepo, required this.storageRepo})
      : super(PostInitial());
  Future<void> createPost(Post post,
      {String? imagePath, Uint8List? imageBytes}) async {
    try {
      String? imageUrl;
      emit(Postuploading());

      // رفع الصورة إلى Supabase
      if (imagePath != null || imageBytes != null) {
        if (imageBytes != null) {
          print("🔁 Calling uploadPostImageWeb...");
          imageUrl = await storageRepo.uploadPostImageWeb(imageBytes, post.id);
          print("✅ Image URL returned from uploadPostImageWeb: $imageUrl");
        }
      } else if (imagePath != null) {
        imageUrl = await storageRepo.uploadPostImageMobile(imagePath, post.id);
        print("✅ Image URL returned from uploadPostImageMobile: $imageUrl");
      }

      // طباعة الـ imageUrl للتأكد
      print("🚀 Image URL after upload = $imageUrl");

      if (imageUrl == null || imageUrl.isEmpty) {
        throw Exception("Image URL is null after upload");
      }

      // بعد رفع الصورة إلى Supabase، الآن يمكن تحميل الرابط إلى Firebase:
      // await updateProfileInFirebase(post.userId,
      //     imageUrl); // حفظ الرابط في Firebase (إذا كان هذا مطلوبًا)

      // إنشاء البوست مع الرابط
      final newPost = post.copyWith(imageUrl: imageUrl);
      await postRepo.createPost(newPost); // إنشاء البوست
      await fetchAllPosts();
      //   await profileRepo.updateProfile(updateProfile);
      emit(PostLoaded([newPost])); // تحميل جميع البوستات
    } catch (e, stack) {
      // إذا فشلت العملية، أطبع الخطأ
      print("🔥🔥🔥 FULL ERROR DURING POST CREATION 🔥🔥🔥");
      print("Error: $e");
      print("Stack: $stack");
      emit(PostError('Failed to create post: $e'));
    }
  }

//fetch all pots
  Future<void> fetchAllPosts() async {
    try {
      emit(PostLoading());
      final posts = await postRepo.fetchAllPosts();
      print('Fetched posts: $posts'); // طباعة البيانات المسترجعة
      if (posts != null && posts.isNotEmpty) {
        emit(PostLoaded(posts));
      } else {
        emit(PostError('No posts available'));
      }
    } catch (e) {
      print('Error: $e'); // طباعة الخطأ
      emit(PostError('Failed to fetch posts :$e'));
    }
  }

  Future<void> deletePosts(String postId, String imageUrl) async {
    try {
      await postRepo.deletePost(postId, imageUrl);
    } catch (e) {
      print("Error: $e");
    }
  }

  Future<void> toogleLikesPost(String postId, String userId) async {
    try {
      await postRepo.toogleLikesPost(postId, userId);
      fetchAllPosts();
    } catch (e) {
      emit(PostError("Falied to toogle liek : $e"));
    }
  }
  // ad cmnt

  Future<void> addComment(String postId, Comment comment) async {
    try {
      await postRepo.addComment(postId, comment);
      await fetchAllPosts();
    } catch (e) {
      emit(PostError("Faled to add comment:$e"));
    }
  }

  // dlt cmnt
  Future<void> deleteComment(String postId, String commentId) async {
    try {
      await postRepo.deleteComment(postId, commentId);
      await fetchAllPosts();
    } catch (e) {
      emit(PostError("Faled to add comment:$e"));
    }
  }
}
