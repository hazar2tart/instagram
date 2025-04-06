import 'package:my_ui/features/auth/domain/entities/app_user.dart';

class ProfielUser extends AppUser {
  final String bio;
  final String profielImageUrl;
  final List<String> followers;
  final List<String> following;
  ProfielUser(
      {required this.bio,
      required this.profielImageUrl,
      required super.email,
      required super.name,
      required super.uid,
      required this.followers,
      required this.following
      
      });
  ProfielUser copyWith({String? newBio, String? newProfile,
  List<String>?newFollowers,
  List<String>?newFollowing}) {
    return ProfielUser(
        bio: newBio ?? bio,
        profielImageUrl: newProfile ?? profielImageUrl,
        email: email,
        name: name,
        uid: uid,
        followers: newFollowers??followers,
        following: newFollowing??following
        );
  }

  //cov prof to json
  Map<String, dynamic> toJson() {
    return {
      'bio': bio,
      'profielImageUrl': profielImageUrl,
      'email': email,
      'name': name,
      'uid': uid,
      'followers':followers,
      'following':following
    };
  }

  /// ✅ Create `ProfielUser` from JSON
  factory ProfielUser.fromJson(Map<String, dynamic> json) {
    return ProfielUser(
      bio: json['bio'] ?? '',
      profielImageUrl: json['profielImageUrl'] ?? '',
      email: json['email'] ?? '',
      name: json['name'] ?? '',
      uid: json['uid'] ?? '',
      followers: List<String>.from(json['followers']??[]),
      following:  List<String>.from(json['following']??[]),
    );
    //conv json to profi
  }
}
