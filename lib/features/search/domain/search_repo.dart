import 'package:my_ui/features/auth/profiel/domain/entitites/profiel_user.dart';

abstract class SearchRepo {
  Future<List<ProfielUser?>> searchUsers(String query);
}
