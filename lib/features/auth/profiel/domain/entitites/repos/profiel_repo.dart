import 'package:my_ui/features/auth/profiel/domain/entitites/profiel_user.dart';

abstract class ProfielRepo {
  Future<ProfielUser?> fetchUserProfile(String uid); // ✅ Make it nullable
  Future<void> updateProfile(ProfielUser updateProfile);
  Future<void> toggleFollow(String currentUid, String targertUid);
}
