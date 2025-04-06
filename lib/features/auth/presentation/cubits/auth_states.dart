// auth states
import 'package:my_ui/features/auth/domain/entities/app_user.dart';

abstract class AuthStates {}

//init
class AuthInitial extends AuthStates {}

//load
class AuthLoading extends AuthStates {}

//auth
class Authenticated extends AuthStates {
  final AppUser user;
  Authenticated(this.user);
}

//umauth
class Unauthenticated extends AuthStates {}

//errri
class Autherrors extends AuthStates {
  final String message;
  Autherrors(this.message);
}
