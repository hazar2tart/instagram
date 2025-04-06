import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:my_ui/features/auth/profiel/domain/entitites/profiel_user.dart';
import 'package:my_ui/features/auth/profiel/domain/entitites/repos/profiel_repo.dart';
import 'package:my_ui/main.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class FirebaseProfileRepo implements ProfielRepo {
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  @override
  Future<ProfielUser?> fetchUserProfile(String uid) async {
    try {
      print("Fetching user profile for UID: $uid");

      final userDoc =
          await firebaseFirestore.collection('users').doc(uid).get();
      if (userDoc.exists) {
        final userData = userDoc.data();

        if (userData != null) {
          final followers = List<String>.from(userData['followers'] ?? []);
          final following = List<String>.from(userData['following'] ?? []);
          return ProfielUser(
              bio: userData['bio'] ?? '',
              profielImageUrl: userData['profielImageUrl']?.toString() ?? '',
              email: userData['email'] ?? '',
              name: userData['name'] ?? '',
              uid: uid,
              followers: followers,
              following: following);
        }
      }

      print("No profile found for UID: $uid");
      return null;
    } catch (e) {
      return null;
    }
  }

  // Future<ProfielUser?> fetchUserProfile(String uid) async {
  //   final supabase = Supabase.instance.client;

  //   try {
  //     debugPrint("Fetching user profile for UID: $uid");

  //     // Check if the table exists (optional, but we can remove the ambiguous part)
  //     try {
  //       final tables = await supabase.rpc('list_tables');
  //       if (!tables.contains('users')) {
  //         debugPrint("Error: 'users' table doesn't exist in Supabase");
  //         return null;
  //       }
  //     } catch (e) {
  //       debugPrint("Couldn't verify table existence: $e");
  //     }

  //     // Fetch user data (treating UID as string)
  //     final response =
  //         await supabase.from('users').select().eq('id', uid).maybeSingle();
  //     if (response == null) {
  //       debugPrint("No user found with UID: $uid");
  //       return null;
  //     }

  //     final data = response as Map<String, dynamic>;

  //     // Return the user profile data
  //     return ProfielUser(
  //       bio: data['bio']?.toString() ?? '',
  //       profielImageUrl: data['profileImageUrl']?.toString() ?? '',
  //       email: data['email']?.toString() ?? '',
  //       name: data['name']?.toString() ?? '',
  //       uid: uid,
  //       followers: List<String>.from(data['followers'] ?? []),
  //       following: List<String>.from(data['following'] ?? []),
  //     );
  //   } on PostgrestException catch (e) {
  //     debugPrint("Supabase Error (${e.code}): ${e.message}");
  //     if (e.code == '42P01') {
  //       debugPrint("Critical: The 'users' table doesn't exist in Supabase");
  //     }
  //     return null;
  //   } catch (e, stackTrace) {
  //     debugPrint("Unexpected error: $e");
  //     debugPrint(stackTrace.toString());
  //     return null;
  //   }
  // }
//
  @override
  Future<void> updateProfile(ProfielUser updateProrfile) async {
    try {
      await firebaseFirestore
          .collection('users')
          .doc(updateProrfile.uid)
          .update({
        'bio': updateProrfile.bio,
        'profileImageUrl': updateProrfile.profielImageUrl,
      });
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  @override
  Future<void> toggleFollow(String currentUid, String targetUid) async {
    try {
      final currentUserDoc =
          await firebaseFirestore.collection('users').doc(currentUid).get();
      final targetUserDoc =
          await firebaseFirestore.collection('users').doc(targetUid).get();

      if (currentUserDoc.exists && targetUserDoc.exists) {
        final currentUserData = currentUserDoc.data();
        final targetUserData = targetUserDoc.data();

        if (currentUserData != null && targetUserData != null) {
          final List<String> currentFollowing =
              List<String>.from(currentUserData['following'] ?? []);

          // If already following, unfollow
          if (currentFollowing.contains(targetUid)) {
            await firebaseFirestore.collection('users').doc(currentUid).update({
              'following':
                  FieldValue.arrayRemove([targetUid]) // Remove from following
            });
            await firebaseFirestore.collection('users').doc(targetUid).update({
              'followers':
                  FieldValue.arrayRemove([currentUid]) // Remove from followers
            });
          } else {
            // If not following, follow
            await firebaseFirestore.collection('users').doc(currentUid).update({
              'following':
                  FieldValue.arrayUnion([targetUid]) // Add to following
            });
            await firebaseFirestore.collection('users').doc(targetUid).update({
              'followers':
                  FieldValue.arrayUnion([currentUid]) // Add to followers
            });
          }

          // Fetch updated user data after updating Firestore
          final updatedCurrentUserDoc =
              await firebaseFirestore.collection('users').doc(currentUid).get();
          final updatedTargetUserDoc =
              await firebaseFirestore.collection('users').doc(targetUid).get();

          if (updatedCurrentUserDoc.exists && updatedTargetUserDoc.exists) {
            final updatedCurrentUserData = updatedCurrentUserDoc.data();
            final updatedTargetUserData = updatedTargetUserDoc.data();

            // Log updated follower/following counts for debugging
            print(
                "Updated Follower Count: ${updatedTargetUserData?['followers'].length}");
            print(
                "Updated Following Count: ${updatedCurrentUserData?['following'].length}");
          }
        }
      }
    } catch (e) {
      print("Error: $e");
    }
  }
}
