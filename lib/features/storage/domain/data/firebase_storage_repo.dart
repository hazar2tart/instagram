// import 'dart:io';
// import 'dart:typed_data';

// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:my_ui/features/storage/domain/storage_repo.dart';

// class FirebaseStorageRepo implements StorageRepo {
//   final FirebaseStorage storage = FirebaseStorage.instance;
//   @override
//   Future<String?> uploadProfileImageMobile(String path, String file) {
//     return _uploadFile(path, file, "profiel_images");
//   }

//   @override
//   Future<String?> uploadProfileImageWeb(Uint8List filebytes, String file) {
//     return _uploadFileBytes(filebytes, file, "profiel_images");
//   }

//   //mob olat
//   Future<String?> _uploadFile(
//       String path, String fileName, String folder) async {
//     try {
//       final file = File(path);
//       final storageRef = storage.ref().child('$folder/$fileName');
//       final uploadTask = storageRef.putFile(file);
//       final snapshot = await uploadTask.whenComplete(() => null);
//       final downloadUrl = await snapshot.ref.getDownloadURL();
//       //  final downloadUrl = await UploadTask.ref.getDownloadURL();
//       return downloadUrl;
//     } catch (e) {
//       return null;
//     }
//   }

//   //web platforms (bytes)
//   Future<String?> _uploadFileBytes(
//       Uint8List fileBytes, String fileName, String folder) async {
//     try {
//       //final file = File(path);
//       final storageRef = storage.ref().child('$folder/$fileName');
//       // final UploadTask = await storageRef.putData(fileBytes);
//       // final downloadUrl = await UploadTask.ref.getDownloadURL();
//       final uploadTask = storageRef.putData(fileBytes);
//       final snapshot = await uploadTask.whenComplete(() => null);
//       final downloadUrl = await snapshot.ref.getDownloadURL();

//       return downloadUrl;
//     } catch (e) {
//       return null;
//     }
//   }

//   @override
//   Future<String?> uploadNewProfileImage(
//       String pathOrBytes, String fileName, bool isWeb) async {
//     if (isWeb) {
//       return _uploadFileBytes(Uint8List.fromList(pathOrBytes.codeUnits),
//           fileName, "profile_images");
//     } else {
//       return _uploadFile(pathOrBytes, fileName, "profile_images");
//     }
//   }

//   @override
//   Future<String?> uploadPostImageMobile(String path, String file) {
//     return _uploadFile(path, file, "post_images");
//   }

//   @override
//   Future<String?> uploadPostImageWeb(Uint8List filebytes, String file) {
//     return _uploadFileBytes(filebytes, file, "post_images");
//   }
// }
import 'dart:io';
import 'dart:typed_data';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:my_ui/features/storage/domain/storage_repo.dart';

class SupabaseStorageRepo implements StorageRepo {
  final SupabaseClient supabase = Supabase.instance.client;

  @override
  Future<String?> uploadProfileImageMobile(String path, String fileName) {
    return _uploadFile(path, fileName, "postimages23");
  }

  @override
  Future<String?> uploadPostImageWeb(Uint8List filebytes, String file) async {
    final url = await _uploadFileBytes(filebytes, file, "postimages23");
    print("🎯 Returned image URL from uploadPostImageWeb: $url");
    return url;
  }

  @override
  Future<String?> uploadProfileImageWeb(Uint8List fileBytes, String fileName) {
    return _uploadFileBytes(fileBytes, fileName, "postimages23");
  }
  // Future<String?> uploadProfileImageWeb(
  //     Uint8List fileBytes, String fileName) async {
  //   final user = supabase.auth.currentUser;
  //   if (user == null) {
  //     print("No user logged in!");
  //     return null;
  //   }

  //   return _uploadFileBytes(fileBytes, user.id, fileName, "profile_images");
  // }
  // Future<String?> uploadProfileImageWeb(
  //     Uint8List fileBytes, String fileName) async {
  //   final user = supabase.auth.currentUser; // تحقق من المستخدم المسجل الدخول
  //   if (user == null) {
  //     print("❌ No user logged in!");
  //     return null; // إذا لم يكن هناك مستخدم مسجل، أوقف عملية رفع الصورة
  //   }

  //   try {
  //     print("📂 Uploading file: $fileName for user: ${user.id}");

  //     // رفع الملف إلى Supabase
  //     final response = await supabase.storage
  //         .from('postimages23')
  //         .uploadBinary(fileName, fileBytes);

  //     // if (response.error != null) {
  //     //   print("❌ Error uploading file: ${response.error?.message}");
  //     //   return null;
  //     // }

  //     // الحصول على الرابط العام للملف
  //     final fileUrl =
  //         supabase.storage.from('postimages23').getPublicUrl(fileName);
  //     print("✅ Upload successful! File URL: $fileUrl");

  //     return fileUrl;
  //   } catch (e) {
  //     print("❌ Upload Error: ${e.toString()}");
  //     return null;
  //   }
  // }

  Future<String?> _uploadFile(
      String path, String fileName, String folder) async {
    try {
      final file = File(path);
      final response =
          await supabase.storage.from(folder).upload(fileName, file);
      return supabase.storage.from(folder).getPublicUrl(fileName);
    } catch (e) {
      print("Error uploading file: $e");
      return null;
    }
  }

  Future<String?> _uploadFileBytes(
      Uint8List fileBytes, String fileName, String folder) async {
    try {
      print("Uploading to folder: $folder, filename: $fileName");

      final response = await supabase.storage.from(folder).uploadBinary(
            fileName,
            fileBytes,
            fileOptions:
                const FileOptions(contentType: "image/png", upsert: true),
          );

      print("Upload response: $response");

      final publicUrl = supabase.storage.from(folder).getPublicUrl(fileName);

      print("✅ Extracted Public URL as String: $publicUrl");

      if (publicUrl != null && publicUrl.isNotEmpty) {
        return publicUrl;
      } else {
        print("❌ Public URL is null or empty");
        return null;
      }
    } catch (e) {
      print("Error uploading file: $e");
      return null;
    }
  }

  // Future<String?> _uploadFileBytes(
  //     Uint8List fileBytes, String fileName, String folder) async {
  //   // final user = supabase.auth.currentUser;
  //   // if (user == null) {
  //   //   print("🚨 User not logged in!");
  //   //   return null;
  //   // }
  //   try {
  //     print("Uploading to folder: $folder, filename: $fileName");
  //     final response = await supabase.storage.from(folder).uploadBinary(
  //           fileName,
  //           fileBytes,
  //           fileOptions:
  //               const FileOptions(contentType: "image/png", upsert: true),
  //         );
  //     print("Upload response: $response");

  //     //   return supabase.storage.from(folder).getPublicUrl(fileName);
  //     // final publicUrl =
  //     //     supabase.storage.from('postimages23').getPublicUrl(fileName);
  //     final publicUrl = supabase.storage
  //   .from('postimages23')
  //   .getPublicUrl(fileName)
  //   .publicUrl;

  //     print("✅ Extracted Public URL as String: $publicUrl");

  //     // تأكد من حفظ الرابط في قاعدة البيانات
  //     if (publicUrl != null) {
  //       // حفظ الرابط في قاعدة البيانات هنا
  //       // مثلاً: await saveProfileImageUrlToDatabase(publicUrl);
  //     }

  //     return publicUrl;
  //   } catch (e) {
  //     print("Error uploading file: $e");
  //     return null;
  //   }
  // }
  // Future<String?> _uploadFileBytes(
  //     Uint8List fileBytes,
  //     String userId, // Add user ID parameter
  //     String fileName,
  //     String folder) async {
  //   try {
  //     // 1. Create user-specific file path
  //     final userFolderPath = '$userId/';
  //     final fullPath = '$userFolderPath$fileName';

  //     // 2. Upload to correct bucket (profile_images instead of postimages23)
  //     await supabase.storage
  //         .from('postimages23') // Fixed bucket name
  //         .uploadBinary(fullPath, fileBytes);

  //     // 3. Get public URL
  //     return supabase.storage.from('postimages23').getPublicUrl(fullPath);
  //   } catch (e) {
  //     print("Detailed upload error: ${e.toString()}");
  //     return null;
  //   }
  // }

  @override
  // Future<String?> uploadNewProfileImage(
  //     String pathOrBytes, String fileName, bool isWeb) async {
  //   if (isWeb) {
  //     return _uploadFileBytes(Uint8List.fromList(pathOrBytes.codeUnits),
  //         fileName, "profile_images",);
  //   } else {
  //     return _uploadFile(pathOrBytes, fileName, "profile_images");
  //   }
  // }

  @override
  Future<String?> uploadPostImageMobile(String path, String fileName) {
    return _uploadFile(path, fileName, "post_images");
  }

  // @override
  // Future<String?> uploadPostImageWeb(Uint8List fileBytes, String fileName) {
  //   return _uploadFileBytes(fileBytes, fileName, "post_images");
  // }
}
