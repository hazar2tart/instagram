import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_ui/features/auth/domain/entities/app_user.dart';
import 'package:my_ui/features/auth/presentation/cubits/auth_cubits.dart';
import 'package:my_ui/features/auth/presentation/cubits/components/my_text_field.dart';
import 'package:my_ui/features/post/domain/entities/post.dart';
import 'package:my_ui/features/post/presentation/cubits/post_cubit.dart';
import 'package:my_ui/features/post/presentation/cubits/post_states.dart';
import 'package:my_ui/features/storage/domain/data/firebase_storage_repo.dart';
import 'package:my_ui/features/storage/domain/storage_repo.dart';
import 'package:my_ui/responsive/constrained_scaffold.dart';

class UploadPostPages extends StatefulWidget {
  const UploadPostPages({super.key});

  @override
  State<UploadPostPages> createState() => _UploadPostPagesState();
}

class _UploadPostPagesState extends State<UploadPostPages> {
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  Future<void> updateProfileInFirebase(String uid, String imageUrl) async {
    try {
      final userDoc = firebaseFirestore.collection('users').doc(uid);
      await userDoc.update({
        'imageUrl': imageUrl,
      });
      print("Profile updated successfully in Firebase");
    } catch (e) {
      print("Error updating profile in Firebase: $e");
    }
  }

  late final StorageRepo storageRepo;
  //mob image pick
  PlatformFile? imagepickedFile;
  Uint8List? webImage;
  final textController = TextEditingController();

//cuect
  AppUser? currentUser;
  @override
  void initState() {
    super.initState();
    getCurrentUser();
    storageRepo = SupabaseStorageRepo();
  }

  Future<void> pickImage() async {
    final result = await FilePicker.platform
        .pickFiles(type: FileType.image, withData: kIsWeb);
    if (result != null) {
      if (!mounted) return;
      setState(() {
        imagepickedFile = result.files.first;
        if (kIsWeb) {
          webImage = imagepickedFile!.bytes;
        }
      });
    }
  }

//getcurentus
  void getCurrentUser() async {
    final authCubit = context.read<AuthCubits>();
    currentUser = authCubit.currentUser;
  }

//create & upload post
  void uploadPost() async {
    // التحقق من إذا كان المستخدم قد اختار صورة وأدخل نصًا للمنشور
    if (imagepickedFile == null || textController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Both image and caption are required")),
      );
      return; // التوقف إذا لم يتم تحديد صورة أو إدخال نص
    }

    final postCubit = context.read<PostCubit>();
    final String postId = DateTime.now().microsecondsSinceEpoch.toString();

    // تحديد نوع الصورة التي تم اختيارها (للموبايل أو للويب)
    final imageMobilePath = kIsWeb ? null : imagepickedFile?.path;
    final imagewebBytes = kIsWeb ? imagepickedFile?.bytes : null;

    String? imageUrl;

    // رفع الصورة بناءً على المنصة
    if (kIsWeb && imagewebBytes != null) {
      imageUrl = await storageRepo.uploadPostImageWeb(imagewebBytes, postId);
    } else if (!kIsWeb && imageMobilePath != null) {
      imageUrl =
          await storageRepo.uploadPostImageMobile(imageMobilePath, postId);
    }
    print('Uploaded image URL: $imageUrl');
    debugPrint('Uploaded image URL: $imageUrl');
    // التحقق من إذا فشلت عملية رفع الصورة
    if (imageUrl == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Image upload failed")),
      );
      return; // التوقف إذا فشلت عملية رفع الصورة
    }

    // تحديث صورة الملف الشخصي في Firebase (إذا كنت ترغب في تحديث صورة الملف الشخصي أيضًا)
    final uid = currentUser!.uid;
    await updateProfileInFirebase(uid, imageUrl);

    // إنشاء البوست مع الصورة التي تم رفعها
    final newPost = Post(
      id: postId,
      userId: currentUser!.uid,
      userName: currentUser!.name,
      text: textController.text,
      imageUrl: imageUrl,
      timestamp: DateTime.now(),
      likes: [],
      comments: [],
    );

    // إرسال البوست إلى الـ Cubit
    postCubit.createPost(newPost, imageBytes: imagewebBytes);

    // مسح النصوص المختارة
    //  textController.clear();
  }

  // @override
  // void dispose() {
  //   textController.dispose();
  //   super.dispose();
  // }

//web image picl
  @override
  Widget build(BuildContext context) {
    //build +list
    return BlocConsumer<PostCubit, PostStates>(builder: (context, state) {
      print(state);
      //loading or upl
      if (state is PostLoading || state is Postuploading) {
        return Scaffold(
            body: Center(
          child: CircularProgressIndicator(),
        ));
      }
      //upload
      return builUploadPage();
      //
    },
        //go to previois page when upload
        listener: (context, state) {
      if (state is PostLoaded) {
        Navigator.pop(context);
      }
    });
  }

  Widget builUploadPage() {
    return ConstrainedScaffold(
      appBar: AppBar(
        title: const Text("Create Post"),
        foregroundColor: Theme.of(context).colorScheme.primary,
        actions: [IconButton(onPressed: uploadPost, icon: Icon(Icons.upload))],
      ),
      //body
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              //imag for web
              if (kIsWeb && webImage != null) Image.memory(webImage!),
              if (!kIsWeb && imagepickedFile != null)
                Image.file(File(imagepickedFile!.path!)),
              //pick imag button
              MaterialButton(
                onPressed: pickImage,
                color: Colors.blue,
                child: Text("Pick image"),
              ),
              SizedBox(
                height: 20,
              ),
              //caption text box
              MyTextField(
                  controller: textController,
                  hinText: "caption",
                  obscureText: false),
            ],
          ),
        ),
      ),
    );
  }
}
