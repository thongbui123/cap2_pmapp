import 'dart:io';

import 'package:capstone2_project_management_app/models/user_model.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ndialog/ndialog.dart';

class ImageServices {
  pickImageFromGallery(File? imageFile, bool showLocalFile,
      BuildContext context, UserModel? userModel) async {
    XFile? xFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (xFile == null) return;
    final tempImage = File(xFile.path);
    imageFile = tempImage;
    showLocalFile = true;
    uploadFirebaseStorage(context, userModel, imageFile);
  }

  uploadFirebaseStorage(
      BuildContext context, UserModel? userModel, File? imageFile) async {
    ProgressDialog progressDialog = ProgressDialog(
      context,
      title: const Text('Uploading !!!'),
      message: const Text('Please wait'),
    );
    progressDialog.show();
    try {
      var fileName = '${userModel!.userEmail}.jpg';
      UploadTask uploadTask = FirebaseStorage.instance
          .ref()
          .child('profile_images')
          .child(fileName)
          .putFile(imageFile!);
      TaskSnapshot snapshot = await uploadTask;
      String profileImageUrl = await snapshot.ref.getDownloadURL();
      print(profileImageUrl);
      DatabaseReference userRef = FirebaseDatabase.instance
          .ref()
          .child('users')
          .child(userModel.userId);
      await userRef.update({'profileImage': profileImageUrl});
      progressDialog.dismiss();
    } catch (e) {
      progressDialog.dismiss();
      print(e.toString());
    }
  }

  pickImageFromCamera(ImageSource source, File? imageFile, bool showLocalFile,
      BuildContext context, UserModel? userModel) async {
    XFile? xFile = await ImagePicker().pickImage(source: source);
    if (xFile == null) return;
    final tempImage = File(xFile.path);
    imageFile = tempImage;
    showLocalFile = true;
    uploadFirebaseStorage(context, userModel, imageFile);
  }
}
