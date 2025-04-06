//auth - outlines for this ap
import 'package:my_ui/features/auth/domain/entities/app_user.dart';

abstract class AuthRepos {
  Future<AppUser?> loginWithEmailPassword(String email, String password);
  Future<AppUser?> registerWithEmailPassword(
      String name, String email, String password);
  Future<void> logout();
  Future<AppUser?> getCurrentUser();
}
