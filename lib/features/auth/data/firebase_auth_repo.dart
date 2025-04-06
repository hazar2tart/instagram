import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:my_ui/features/auth/domain/entities/app_user.dart';
import 'package:my_ui/features/auth/domain/repos/auth_repos.dart';
import 'package:my_ui/main.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class FirebaseAuthRepo implements AuthRepos {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  final SupabaseClient supabase = Supabase.instance.client;
  @override
  Future<AppUser?> getCurrentUser() async {
    final firebaseUser = firebaseAuth.currentUser;
    if (firebaseUser == null) {
      return null;
    }
    // fetch user docum
    DocumentSnapshot userDoc =
        await firebaseFirestore.collection('users').doc(firebaseUser.uid).get();
    //checkuser exis t
    if (!userDoc.exists) {
      return null;
    }
    return AppUser(
        email: firebaseUser.email!,
        name: userDoc['name'],
        uid: firebaseUser.uid);
  }

  @override
  Future<AppUser?> loginWithEmailPassword(String email, String password) async {
    try {
      UserCredential userCredential = await firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);

// fetch user docum
      DocumentSnapshot userDoc = await firebaseFirestore
          .collection('users')
          .doc(userCredential.user!.uid)
          .get();

      AppUser user = AppUser(
          email: email, name: userDoc['name'], uid: userCredential.user!.uid);
      return user;
    } catch (e) {
      throw Exception('Login failed' + e.toString());
    }
  }

  @override
  Future<void> logout() async {
    await firebaseAuth.signOut();
  }

  @override
  Future<AppUser?> registerWithEmailPassword(
      String name, String email, String password) async {
    try {
      UserCredential userCredential = await firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);
      AppUser user =
          AppUser(email: email, name: name, uid: userCredential.user!.uid);
//sabe in fir
      await firebaseFirestore
          .collection("users")
          .doc(user.uid)
          .set(user.toJson());

      return user;
    } catch (e) {
      throw Exception('Login failed' + e.toString());
    }
  }
}
