import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_ui/features/post/domain/entities/comment.dart';

class Post {
  final String id;
  final String userId;
  final String userName;
  final String text;
  final String imageUrl;
  final DateTime timestamp;
  final List<String> likes;
  final List<Comment> comments;
  //store uids

  // Constructor to initialize a Post object
  Post(
      {required this.id,
      required this.userId,
      required this.userName,
      required this.text,
      required this.imageUrl,
      required this.timestamp,
      required this.likes,
      required this.comments});

  // Creates a copy of the Post object with updated values (useful for immutability)
  Post copyWith({
    String? imageUrl,
  }) {
    return Post(
        id: id,
        userId: userId,
        userName: userName,
        text: text,
        imageUrl: imageUrl ?? this.imageUrl,
        timestamp: timestamp,
        likes: likes,
        comments: comments);
  }

  // Converts Post object to JSON format (useful for APIs, storage, etc.)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'userName': userName,
      'text': text,
      'imageUrl': imageUrl,
      'timestamp': timestamp,
      'likes': likes,
      'comments': comments.map((comment) => comment.toJson()).toList()
    };
  }

  // Creates a Post object from a JSON map (useful when fetching from APIs)
  factory Post.fromJson(Map<String, dynamic> json) {
    final List<Comment> comments = (json['comments'] as List<dynamic>?)
            ?.map((commentJson) => Comment.fromJson(commentJson))
            .toList() ??
        [];
    return Post(
        id: json['id'] ?? '',
        userId: json['userId'] ?? '',
        userName: json['userName'] ?? '',
        text: json['text'],
        imageUrl: json['imageUrl'] ?? '',
        timestamp: (json['timestamp'] as Timestamp).toDate(),
        likes: List<String>.from(json['likes'] ?? []),
        comments: comments);
  }
}
