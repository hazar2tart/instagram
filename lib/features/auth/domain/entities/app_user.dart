class AppUser {
  final String uid;
  final String email;
  final String name;
  AppUser({required this.email, required this.name, required this.uid});

//conv _> json
  Map<String, dynamic> toJson() {
    return {'uid': uid, 'email': email, 'name': name};
  }

  //json to user
  factory AppUser.fromJson(Map<String, dynamic> jsonUser) {
    return AppUser(
        email: jsonUser['email'], name: jsonUser['name'], uid: jsonUser['uid']);
  }
}
