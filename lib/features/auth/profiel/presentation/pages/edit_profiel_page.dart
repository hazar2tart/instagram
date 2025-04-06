import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_ui/features/auth/presentation/cubits/auth_cubits.dart';
import 'package:my_ui/features/auth/presentation/cubits/auth_states.dart';
import 'package:my_ui/features/auth/presentation/cubits/components/my_text_field.dart';
import 'package:my_ui/features/auth/profiel/domain/entitites/profiel_user.dart';
import 'package:my_ui/features/auth/profiel/presentation/cubits/profiel_cubit.dart';
import 'package:my_ui/features/auth/profiel/presentation/cubits/profiel_states.dart';
import 'package:my_ui/features/storage/domain/data/firebase_storage_repo.dart';
import 'package:my_ui/features/storage/domain/storage_repo.dart';
import 'package:my_ui/main.dart';
import 'package:my_ui/responsive/constrained_scaffold.dart';
import 'package:uuid/uuid.dart';

class EditProfilPage extends StatefulWidget {
  final ProfielUser user;
  const EditProfilPage({super.key, required this.user});

  @override
  State<EditProfilPage> createState() => _EditProfielPageState();
}

class _EditProfielPageState extends State<EditProfilPage> {
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  Future<void> updateProfileInFirebase(String uid, String imageUrl) async {
    try {
      final userDoc = firebaseFirestore.collection('users').doc(uid);
      await userDoc.update({
        'profielImageUrl': imageUrl,
      });
      print("Profile updated successfully in Firebase");
    } catch (e) {
      print("Error updating profile in Firebase: $e");
    }
  }

  //mobile image pick
  PlatformFile? imagepickedFile;
  Uint8List? webImage;
  late final StorageRepo storageRepo;

  final BioTextController = TextEditingController();
  void initState() {
    super.initState();
    // You can initialize the storageRepo here (or inject it via Bloc/Provider)
    storageRepo = SupabaseStorageRepo();
    // FirebaseStorageRepo(); // Assuming FirebaseStorageRepo is your implementation
  }

  //pick
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
      //   await uploadImage();
    }
  }

  // void updateProfile() async {
  //   final profielCubit = context.read<ProfielCubit>();
  //   //prepare images
  //   final String uid = widget.user.uid;
  //   final imageMobilePath = kIsWeb ? null : imagepickedFile?.path;
  //   final imagewebBytes = kIsWeb ? imagepickedFile?.bytes : null;
  //   final String? newBio =
  //       BioTextController.text.isNotEmpty ? BioTextController.text : null;
  //   //only update profiel image

  //   if (imagepickedFile != null || newBio != null) {
  //     profielCubit.updateProfile(
  //         uid: uid,
  //         newBio: newBio,
  //         imageMobilePtah: imageMobilePath,
  //         imagewebBytes: imagewebBytes);
  //   } else {
  //     Navigator.pop(context);
  //   }
  // }

  void updateProfile() async {
    final authState = context.read<AuthCubits>().state;

    // Check if the user is authenticated
    if (authState is! Authenticated) {
      print("No user logged in");
      return; // Stop execution if the user is not authenticated
    }

    final profielCubit = context.read<ProfielCubit>();
    final String uid = widget.user.uid;

    // Prepare images for upload
    final imageMobilePath = kIsWeb ? null : imagepickedFile?.path;
    final imagewebBytes = kIsWeb ? imagepickedFile?.bytes : null;

    // Prepare bio text
    final String? newBio =
        BioTextController.text.isNotEmpty ? BioTextController.text : null;

    // Only upload if there's a new profile image or bio
    if (imagepickedFile != null || newBio != null) {
      // Separate out storage upload logic here
      String? imageUrl;

      if (kIsWeb && imagewebBytes != null) {
        imageUrl = await storageRepo.uploadProfileImageWeb(
            imagewebBytes, widget.user.name);
      } else if (!kIsWeb && imageMobilePath != null) {
        imageUrl = await storageRepo.uploadProfileImageMobile(
            imageMobilePath, widget.user.name);
      }
      // تحديث الملف الشخصي في Firebase مع الرابط الجديد للصورة
      if (imageUrl != null) {
        await updateProfileInFirebase(uid, imageUrl);
      }
      profielCubit.updateProfile(
          uid: uid,
          newBio: newBio,
          imageMobilePtah: imageMobilePath,
          imagewebBytes: imagewebBytes);
    } else {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfielCubit, ProfielStates>(builder: (context, state) {
      //load
      if (state is ProfielLoading) {
        return ConstrainedScaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [CircularProgressIndicator(), Text("uploading")],
            ),
          ),
        );
      }
      //ere
      else {
        return buildEditPage();
      }
      // edit
    }, listener: (context, state) {
      if (state is ProfielLoaded) {
        Navigator.pop(context);
      }
    });
  }

  Widget buildEditPage() {
    return ConstrainedScaffold(
      appBar: AppBar(
        title: const Text('edit profile'),
        foregroundColor: Theme.of(context).colorScheme.primary,
        actions: [
          IconButton(onPressed: updateProfile, icon: Icon(Icons.upload))
        ],
      ),
      body: Column(
        children: [
          //profiel pic
          //bio
          Center(
            child: Container(
              height: 200,
              width: 200,
              decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondary,
                  shape: BoxShape.circle),
              clipBehavior: Clip.hardEdge,
              child:
                  //dis im
                  //dis im for web
                  //d isp exsiting prof
                  (!kIsWeb && imagepickedFile != null)
                      ? Image.file(File(imagepickedFile!.path!),
                          fit: BoxFit.cover)
                      : (kIsWeb && webImage != null)
                          ? Image.memory(webImage!, fit: BoxFit.cover)
                          : (widget.user.profielImageUrl != null &&
                                  widget.user.profielImageUrl!.isNotEmpty)
                              ? CachedNetworkImage(
                                  imageUrl: widget.user.profielImageUrl!,
                                  placeholder: (context, url) =>
                                      const CircularProgressIndicator(), // ✅ Correction
                                  errorWidget: (context, url, error) =>
                                      const Icon(Icons.person,
                                          size: 72), // ✅ Correction
                                  imageBuilder: (context, imageProvider) =>
                                      Image(image: imageProvider),
                                  fit: BoxFit.cover, // ✅ Correction
                                )
                              : const Icon(Icons.person, size: 72),
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          Center(
            child: MaterialButton(
              onPressed: pickImage,
              color: Colors.blue,
              child: Text("Pick Image"),
            ),
          ),
          SizedBox(
            height: 10,
          ),

          Text("Bio"),
          const SizedBox(
            height: 15,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: MyTextField(
                controller: BioTextController,
                hinText: widget.user.bio,
                obscureText: false),
          )
        ],
      ),
    );
  }
}
