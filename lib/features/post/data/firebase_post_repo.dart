import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_ui/features/post/domain/entities/post.dart';
import 'package:my_ui/features/post/domain/repo/post_repo.dart';
import 'package:my_ui/features/post/domain/entities/comment.dart';
import 'package:my_ui/main.dart';

class FirebasePostRepo implements PostRepo {
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  //stored posts
  final CollectionReference postsCollection =
      FirebaseFirestore.instance.collection("posts");
  @override
  Future<void> createPost(Post post) async {
    try {
      await postsCollection.doc(post.id).set(post.toJson());
    } catch (e) {
      throw Exception('Error creating post :$e');
    }
  }

  @override
  Future<void> deletePost(String postId, String imageUrl) async {
    try {
      print("Attempting to delete post with ID: $postId and image: $imageUrl");

      // حذف الصورة من التخزين
      final response =
          await supabase.storage.from('postimages23').remove([imageUrl]);
      print("Image deletion response: $response");

      if (response == null) {
        print("Error deleting image: ");
      } else {
        print("Image deleted successfully");
      }

      // حذف البوست من قاعدة البيانات
      await postsCollection.doc(postId).delete();
      print("Post deleted successfully");
    } catch (e) {
      print("Error during post deletion: $e");
    }
  }

  @override
  Future<List<Post>> fetchAllPosts() async {
    try {
      final postsSnapshot =
          await postsCollection.orderBy('timestamp', descending: true).get();

      //cov each doc from json to list of post
      final List<Post> allposts = postsSnapshot.docs
          .map((doc) => Post.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
      return allposts;
    } catch (e) {
      throw Exception("Error fetching posts : $e");
    }
  }

  @override
  Future<List<Post>> fetchPostsByUserId(String userId) async {
    try {
      final postsSnapshot =
          await postsCollection.where('userId', isEqualTo: userId).get();
      //cov firestoe doc . from josn , to posst
      final userPosts = postsSnapshot.docs
          .map((doc) => Post.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
      return userPosts;
    } catch (e) {
      throw Exception(" Error fetching by user :$e");
    }
  }

  @override
  Future<void> toogleLikesPost(String postId, String userId) async {
    try {
      //get the post deoc
      final postDoc = await postsCollection.doc(postId).get();
      if (postDoc.exists) {
        final post = Post.fromJson(postDoc.data() as Map<String, dynamic>);
        //alraedy have
        final hasLiked = post.likes.contains(userId);
        //update  likes
        if (hasLiked) {
          post.likes.remove(userId);
        } else {
          post.likes.add(userId);
        }
        //updat efor new likes
        await postsCollection.doc(postId).update({'likes': post.likes});
      } else {
        throw Exception("Post not founded");
      }
    } catch (e) {
      throw Exception("error laoding: $e");
    }
  }

  @override
  Future<void> addComment(String postId, Comment comment) async {
    try {
//get doc
      final postDoc = await postsCollection.doc(postId).get();

      if (postDoc.exists) {
        //  cov json > post
        final post = Post.fromJson(postDoc.data() as Map<String, dynamic>);
        //add teh new com
        post.comments.add(comment);
        //update
        await postsCollection.doc(postId).update({
          'comments': post.comments.map((comment) => comment.toJson()).toList()
        });
      } else {
        throw Exception("Post not found");
      }
    } catch (e) {
      throw Exception("Error adding comment : $e");
    }
  }

  @override
  Future<void> deleteComment(String postId, String commentId) async {
    try {
//get doc
      final postDoc = await postsCollection.doc(postId).get();

      if (postDoc.exists) {
        //  cov json > post
        final post = Post.fromJson(postDoc.data() as Map<String, dynamic>);
        //add teh new com
        post.comments.removeWhere((comment) => comment.id == commentId);
        //update
        await postsCollection.doc(postId).update({
          'comments': post.comments.map((comment) => comment.toJson()).toList()
        });
      } else {
        throw Exception("Post not found");
      }
    } catch (e) {
      throw Exception("Error adding comment : $e");
    }
  }
}
