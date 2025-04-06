import 'package:flutter/foundation.dart';

abstract class StorageRepo {
  Future<String?> uploadProfileImageMobile(String path, String file);
  Future<String?> uploadProfileImageWeb(Uint8List filebytes, String file);
  // Future<String?> uploadNewProfileImage(
  //     String pathOrBytes, String fileName, bool isWeb);
  Future<String?> uploadPostImageMobile(String path, String file);
  Future<String?> uploadPostImageWeb(Uint8List filebytes, String file);
}
