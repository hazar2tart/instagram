import 'package:my_ui/features/post/domain/entities/post.dart';

abstract class PostStates {}

//inital
class PostInitial extends PostStates {}
//loading

class PostLoading extends PostStates {}

//upload
class Postuploading extends PostStates {}

//er
class PostError extends PostStates {
  final String message;
  PostError(this.message);
}

//laoded
class PostLoaded extends PostStates {
  final List<Post> posts;
  PostLoaded(this.posts);
}
