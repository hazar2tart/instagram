// pp states
import 'package:my_ui/features/auth/profiel/domain/entitites/profiel_user.dart';

abstract class ProfielStates {}

//init'
class ProfileInital extends ProfielStates {}

//laod
class ProfielLoading extends ProfielStates {}

//loaded
class ProfielLoaded extends ProfielStates {
  final ProfielUser profielUser;
  ProfielLoaded(this.profielUser);
}

//er
class ProfielError extends ProfielStates {
  final String message;
  ProfielError(this.message);
}
