import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:be_fit/core/service/user_service.dart';

class FirebaseStorageService {
  FirebaseStorage storage = FirebaseStorage.instance;

  static Future<void> listExample() async {
    ListResult result = await FirebaseStorage.instance.ref().listAll();
    result.items.forEach((element) {
      print(element.name);
    });
  }

  static Future<String?> uploadImage({required String filePath}) async {
    File file = File(filePath);
    try {
      final User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        TaskSnapshot upload = await FirebaseStorage.instance
            .ref('user_logos/${user.uid}.png')
            .putFile(file);
        String downloadUrl = await upload.ref.getDownloadURL();
        await UserService.editPhoto(downloadUrl);

        // Update user's photo URL in Firebase Auth
        await user.updatePhotoURL(downloadUrl);

        return downloadUrl;
      }
      return null;
    } catch (e) {
      print(e);
      return null;
    }
  }
}
