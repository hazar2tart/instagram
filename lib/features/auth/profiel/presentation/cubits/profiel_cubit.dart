import 'dart:typed_data';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_ui/features/auth/profiel/domain/entitites/profiel_user.dart';
import 'package:my_ui/features/auth/profiel/domain/entitites/repos/profiel_repo.dart';
import 'package:my_ui/features/auth/profiel/presentation/cubits/profiel_states.dart';
import 'package:my_ui/features/storage/domain/storage_repo.dart';
import 'package:my_ui/main.dart';

class ProfielCubit extends Cubit<ProfielStates> {
  final ProfielRepo profileRepo;
  final StorageRepo storageRepo;
  ProfielCubit({required this.profileRepo, required this.storageRepo})
      : super(ProfileInital());

//ftech user
  Future<void> fetchUserProfiel(String uid) async {
    try {
      emit(ProfielLoading());
      final user = await profileRepo.fetchUserProfile(uid);
      print("Fetched Profile Image URL: ${user?.profielImageUrl}");
      if (user != null) {
        emit(ProfielLoaded(user));
      } else {
        emit(ProfielError("User not found"));
      }
    } catch (e) {
      emit(ProfielError(e.toString()));
    }
  }
  // In your ProfielCubit
  // Future<void> fetchUserProfiel(String uid) async {
  //   emit(ProfielLoading());
  //   try {
  //     // 1. Try fetching profile
  //     final response = await supabase
  //         .from('profiles')
  //         .select()
  //         .eq('user_id', uid)
  //         .maybeSingle();

  //     // 2. Create if doesn't exist
  //     if (response == null) {
  //       final newProfile = {
  //         'user_id': uid,
  //         'created_at': DateTime.now().toIso8601String(),
  //         'username': 'user_${uid.substring(0, 6)}',
  //         'bio': "Hello! I'm new here", // Fixed string quote
  //       };

  //       final insertResponse =
  //           await supabase.from('profiles').insert(newProfile);

  //       if (insertResponse.error != null) {
  //         throw Exception(
  //             'Failed to create profile: ${insertResponse.error!.message}');
  //       }

  //       emit(ProfielLoaded(ProfielUser.fromJson(newProfile)));
  //     } else {
  //       emit(ProfielLoaded(ProfielUser.fromJson(response)));
  //     }
  //   } catch (e) {
  //     emit(ProfielError('Failed to load profile: ${e.toString()}'));
  //     // Add debug logging
  //     print('Profile fetch error for $uid: $e');
  //     print('Stack trace: ${StackTrace.current}');
  //   }
  // }

// retuen uswerr profiel
  Future<ProfielUser?> getUserProfile(String uid) async {
    final user = await profileRepo.fetchUserProfile(uid);
    return user;
  }

  Future<void> updateProfile({
    required String uid,
    String? newBio,
    Uint8List? imagewebBytes,
    String? imageMobilePtah,
  }) async {
    emit(ProfielLoading());
    try {
      final currentUser = await profileRepo.fetchUserProfile(uid);
      if (currentUser == null) {
        emit(ProfielError("Failed to fetch user for profile update"));
        return;
      }

//prf
      String? imageDownlaosUrl;
      if (imagewebBytes != null || imageMobilePtah != null) {
        if (imageMobilePtah != null) {
          imageDownlaosUrl =
              await storageRepo.uploadProfileImageMobile(imageMobilePtah, uid);
        } else if (imagewebBytes != null) {
          imageDownlaosUrl =
              await storageRepo.uploadProfileImageWeb(imagewebBytes, uid);
        }
        if (imageDownlaosUrl == null) {
          emit(ProfielError("Failed to uplaod "));
          return;
        }
      }
      final updateProfile = currentUser!.copyWith(
          newBio: newBio ?? currentUser.bio,
          newProfile: imageDownlaosUrl ?? currentUser.profielImageUrl);
      await profileRepo.updateProfile(updateProfile);
      emit(ProfielLoaded(updateProfile));

      //refetch
    } catch (e) {
      emit(ProfielError('Error updating profiel $e'));
    }
  }

//update//toogle
  Future<void> toogleFollow(String currentUserId, String targetUserId) async {
    try {
      await profileRepo.toggleFollow(currentUserId, targetUserId);
      //  await fetchUserProfiel(targetUserId);
    } catch (e) {
      emit(ProfielError("Erroe toggling follow :$e "));
    }
  }
}
