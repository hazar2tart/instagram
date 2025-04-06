import 'package:my_ui/features/auth/profiel/domain/entitites/profiel_user.dart';

abstract class SearchStates {}

class SearchInitial extends SearchStates {}

class SearchLoading extends SearchStates {}

class SearchLoaded extends SearchStates {
  final List<ProfielUser?> users;
  SearchLoaded(this.users);
}

class SearchError extends SearchStates {
  final String message;
  SearchError(this.message);
}
