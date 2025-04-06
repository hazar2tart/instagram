import 'package:my_ui/features/post/domain/entities/post.dart';
import 'package:my_ui/features/post/domain/entities/comment.dart';

abstract class PostRepo {
  Future<List<Post>> fetchAllPosts();
  Future<void> createPost(Post post);
  Future<void> deletePost(String postId, String imageUrl);
  Future<List<Post>> fetchPostsByUserId(String userid);
  Future<void> toogleLikesPost(String postId, String userId);
  Future<void> addComment(String postId, Comment comment);
  Future<void> deleteComment(String postId, String commentId);
}
