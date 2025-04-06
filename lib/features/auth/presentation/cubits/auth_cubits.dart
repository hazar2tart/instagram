import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_ui/features/auth/domain/entities/app_user.dart';
import 'package:my_ui/features/auth/domain/repos/auth_repos.dart';
import 'package:my_ui/features/auth/presentation/cubits/auth_states.dart';

class AuthCubits extends Cubit<AuthStates> {
  final AuthRepos authRepos;
  AppUser? _currentUser;
  AuthCubits({required this.authRepos}) : super(AuthInitial());
  // chk if already ex
  void checkAuth() async {
    final AppUser? user = await authRepos.getCurrentUser();
    if (user != null) {
      _currentUser = user;
      emit(Authenticated(user));
    } else {
      emit(Unauthenticated());
    }
  }

  //get user
  AppUser? get currentUser => _currentUser;
  //log with wma
  Future<void> login(String email, String pw) async {
    try {
      emit(AuthLoading());
      final user = await authRepos.loginWithEmailPassword(email, pw);
      if (user != null) {
        _currentUser = user;
        emit(Authenticated(user));
      } else {
        emit(Unauthenticated());
      }
    } catch (e) {
      Autherrors(e.toString());
      emit(Unauthenticated());
    }
  }

  Future<void> register(String name, String email, String pw) async {
    try {
      emit(AuthLoading());
      final user = await authRepos.registerWithEmailPassword(name, email, pw);
      if (user != null) {
        _currentUser = user;
        emit(Authenticated(user));
      } else {
        emit(Unauthenticated());
      }
    } catch (e) {
      Autherrors(e.toString());
      emit(Unauthenticated());
    }
  }

  Future<void> logout() async {
    authRepos.logout();
    emit(Unauthenticated());
  }
}
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:my_ui/features/auth/domain/entities/app_user.dart';
// import 'package:my_ui/features/auth/domain/repos/auth_repos.dart';
// import 'package:my_ui/features/auth/presentation/cubits/auth_states.dart';
// import 'package:my_ui/main.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';

// class AuthCubits extends Cubit<AuthStates> {
//   final AuthRepos authRepos;
//   AppUser? _currentUser;

//   AuthCubits({required this.authRepos}) : super(AuthInitial());

//   // التحقق مما إذا كان المستخدم مسجلاً بالفعل
//   void checkAuth() async {
//     final AppUser? user = await authRepos.getCurrentUser();
//     if (user != null) {
//       _currentUser = user;
//       await loginToSupabase(user); // تسجيل الدخول إلى Supabase
//       emit(Authenticated(user));
//     } else {
//       emit(Unauthenticated());
//     }
//   }

//   // إرجاع المستخدم الحالي
//   AppUser? get currentUser => _currentUser;

//   Future<void> login(String email, String pw) async {
//     try {
//       emit(AuthLoading());

//       // تسجيل الدخول في Firebase
//       final user = await authRepos.loginWithEmailPassword(email, pw);

//       if (user != null) {
//         _currentUser = user;

//         // تسجيل الدخول في Supabase بعد نجاح تسجيل الدخول في Firebase
//         final response = await supabase.auth.signInWithPassword(
//           email: email,
//           password: pw, // تأكد أن كلمة المرور مطابقة لتلك المسجلة في Supabase
//         );

//         if (response.session == null) {
//           print("❌ فشل تسجيل الدخول في Supabase");
//         } else {
//           print("✅ تم تسجيل الدخول في Supabase كمستخدم ${response.user?.id}");
//         }

//         emit(Authenticated(user));
//       } else {
//         emit(Unauthenticated());
//       }
//     } catch (e) {
//       emit(Autherrors(e.toString()));
//       emit(Unauthenticated());
//     }
//   }

//   // تسجيل مستخدم جديد
//   // Future<void> register(String name, String email, String pw) async {
//   //   try {
//   //     emit(AuthLoading());

//   //     // ✅ 1. تسجيل المستخدم في Firebase
//   //     final user = await authRepos.registerWithEmailPassword(name, email, pw);

//   //     if (user != null) {
//   //       _currentUser = user;

//   //       // ✅ 2. تسجيل المستخدم في Supabase بنفس بيانات Firebase
//   //       final supabaseResponse = await supabase.auth.signUp(
//   //         email: email,
//   //         password: pw, // تأكد من تطابق كلمة المرور
//   //       );

//   //       if (supabaseResponse.user != null) {
//   //         print(
//   //             "✅ تم إنشاء الحساب في Supabase للمستخدم: ${supabaseResponse.user!.id}");

//   //         // ✅ 3. تسجيل الدخول إلى Supabase بعد التسجيل
//   //         await loginToSupabase(user);
//   //       } else {
//   //         print("❌ فشل إنشاء الحساب في Supabase");
//   //       }

//   //       emit(Authenticated(user));
//   //     } else {
//   //       emit(Unauthenticated());
//   //     }
//   //   } catch (e) {
//   //     emit(Autherrors(e.toString()));
//   //   }
//   // }
//   Future<void> register(String name, String email, String pw) async {
//     try {
//       emit(AuthLoading());
//       final user = await authRepos.registerWithEmailPassword(name, email, pw);
//       if (user != null) {
//         _currentUser = user;
//         emit(Authenticated(user));
//       } else {
//         emit(Unauthenticated());
//       }
//     } catch (e) {
//       Autherrors(e.toString());
//       emit(Unauthenticated());
//     }
//   }

//   // تسجيل الخروج
//   Future<void> logout() async {
//     await authRepos.logout();
//     await Supabase.instance.client.auth.signOut(); // تسجيل الخروج من Supabase
//     emit(Unauthenticated());
//   }

//   // تسجيل الدخول إلى Supabase
//   Future<void> loginToSupabase(AppUser firebaseUser) async {
//     try {
//       final supabase = Supabase.instance.client;
//       final response = await supabase.auth.signInWithPassword(
//         email: firebaseUser.email,
//         password: 'your_supabase_password_here', // استبدل بكلمة المرور الصحيحة
//       );

// // التحقق من نجاح تسجيل الدخول
//       if (response.session == null) {
//         print("❌ فشل تسجيل الدخول في Supabase");
//       } else {
//         print("✅ تم تسجيل الدخول في Supabase كمستخدم ${response.user?.id}");
//       }
//     } catch (e) {
//       print("❌ خطأ أثناء تسجيل الدخول في Supabase: $e");
//     }
//   }
// }
