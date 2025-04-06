// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/material.dart';
// import 'package:my_ui/app.dart';
// import 'package:my_ui/firebase_options.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp(
//     options: DefaultFirebaseOptions.currentPlatform,
//   );
//   await Supabase.initialize(
//     url: 'https://lctnyebeanerygjsbfxh.supabase.co', // ضع رابط Supabase هنا
//     anonKey:
//         'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImxjdG55ZWJlYW5lcnlnanNiZnhoIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDM1OTYyNDcsImV4cCI6MjA1OTE3MjI0N30.4KyCIpiq8K6UYZmc9_cFi7Fj-x9RtUJ4fXV8BOq3V8Y', // ضع مفتاح Supabase هنا
//   );
//   // await verifySupabaseConnection();
//   runApp(MyApp());
// }

// final supabase = Supabase.instance.client;
// Future<void> verifySupabaseConnection() async {
//   try {
//     // Try fetching the current user (this assumes the user is logged in)
//     final user = Supabase.instance.client.auth.currentUser;

//     if (user != null) {
//       print("Successfully connected to Supabase. User: ${user.email}");
//     } else {
//       print("Successfully connected to Supabase, but no user is logged in.");
//     }

//     // Optionally, you can also perform a simple query to check if the connection works
//     final response = await Supabase.instance.client
//         .from('postimages23') // استبدل باسم الجدول الفعلي
//         .select()
//         .limit(1)
//         .single();

// // if (response.hasError) {
// //   print("حدث خطأ أثناء الاستعلام من Supabase: ${response.error?.message}");
// // } else {
// //   print("تم الاستعلام بنجاح من Supabase. البيانات: ${response.data}");
// // }
//   } catch (e) {
//     print("Error initializing Supabase: $e");
//   }
// }
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:my_ui/app.dart';
import 'package:my_ui/firebase_options.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Initialize Supabase with proper error handling
  await Supabase.initialize(
    url: 'https://lctnyebeanerygjsbfxh.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImxjdG55ZWJlYW5lcnlnanNiZnhoIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDM1OTYyNDcsImV4cCI6MjA1OTE3MjI0N30.4KyCIpiq8K6UYZmc9_cFi7Fj-x9RtUJ4fXV8BOq3V8Y',
  );

  // Verify connection and auth state
//  await verifySupabaseConnection();

  runApp(MyApp());
}

final supabase = Supabase.instance.client;

Future<void> verifySupabaseConnection() async {
  try {
    // Check auth state after initialization
    await Future.delayed(const Duration(milliseconds: 500));

    final user = supabase.auth.currentUser;
    if (user != null) {
      print("✅ User authenticated: ${user.id}");
      print("🔄 Checking profile...");

      // Ensure profile exists
      final profile = await supabase
          .from('postimages23')
          .select()
          .eq('user_id', user.id)
          .maybeSingle();

      if (profile == null) {
        print("ℹ️ No profile found, creating one...");
        await createUserProfile(user.id);
      }
    } else {
      print("ℹ️ No user logged in (expected for first launch)");
    }
  } catch (e) {
    print("❌ Supabase error: $e");
  }
}

Future<void> createUserProfile(String userId) async {
  try {
    await supabase.from('postimages23').insert({
      'user_id': userId,
      'created_at': DateTime.now().toIso8601String(),
      'username': 'user_${userId.substring(0, 6)}',
    });
    print("✅ Profile created for user: $userId");
  } catch (e) {
    print("❌ Failed to create profile: $e");
  }
}
