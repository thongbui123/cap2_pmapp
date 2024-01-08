import 'package:flutter/material.dart';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:ndialog/ndialog.dart';

import '../models/user_model.dart';
import '../services/image_services.dart';
import 'package:capstone2_project_management_app/views/stats/stats.dart';
import 'package:capstone2_project_management_app/views/subs/db_side_menu.dart';

class profile_screen extends StatefulWidget {
  const profile_screen({Key? key}) : super(key: key);

  @override
  State<profile_screen> createState() => _profile_screenState();
}

class _profile_screenState extends State<profile_screen> {
  User? user;
  UserModel? userModel;
  DatabaseReference? userRef;
  int _selectedIndex = 0;
  File? imageFile;
  bool showLocalFile = false;
  ImageServices? imageServices;
  String defaulAvatar =
      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQGrQoGh518HulzrSYOTee8UO517D_j6h4AYQ&usqp=CAU';
  _getUserDetails() async {
    DatabaseEvent snapshot = await userRef!.once();

    userModel = UserModel.fromMap(
        Map<String, dynamic>.from(snapshot.snapshot.value as dynamic));

    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      userRef = FirebaseDatabase.instance.ref().child('users').child(user!.uid);
    }
    _getUserDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: userModel == null
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  db_side_menu(),
                  Expanded(
                      child: Padding(
                    padding: EdgeInsets.all(defaultPadding),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'PROFLE',
                            style: TextStyle(
                              fontFamily: 'Anurati',
                              fontSize: 30,
                            ),
                          ),
                          Divider(),
                          SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircleAvatar(
                                radius: 70,
                                backgroundColor: Colors.lightBlue,
                                child: userModel!.profileImage == ''
                                    ? Text(
                                        getFirstLetter(userModel!.userFirstName
                                            .toString()),
                                        style: const TextStyle(
                                            fontFamily: 'Mounted',
                                            fontSize: 80,
                                            color: Colors.white),
                                      )
                                    : CircleAvatar(
                                        radius: 66,
                                        backgroundColor: Colors.white,
                                        backgroundImage: showLocalFile
                                            ? FileImage(imageFile!)
                                                as ImageProvider
                                            : NetworkImage(
                                                userModel!.profileImage)),
                              ),
                              Container(
                                width: 10,
                                height: 2,
                                color: Colors.lightBlue,
                              ),
                              Ink(
                                decoration: const ShapeDecoration(
                                  color: Colors.lightBlue,
                                  shape: CircleBorder(),
                                ),
                                child: IconButton(
                                  icon: const Icon(
                                    Icons.camera_alt,
                                    size: 16,
                                  ),
                                  color: Colors.white,
                                  onPressed: () {
                                    showModalBottomSheet(
                                        context: context,
                                        builder: (context) {
                                          return Padding(
                                            padding: const EdgeInsets.all(10),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                ListTile(
                                                  leading:
                                                      const Icon(Icons.image),
                                                  title: const Text(
                                                      'From Gallery'),
                                                  onTap: () {
                                                    _pickImageFromGallery;
                                                    Navigator.of(context).pop();
                                                  },
                                                ),
                                                ListTile(
                                                  leading: const Icon(
                                                      Icons.camera_alt),
                                                  title:
                                                      const Text('From Camera'),
                                                  onTap: () {
                                                    _pickImageFromCamera(
                                                        ImageSource.camera);
                                                    Navigator.of(context).pop();
                                                  },
                                                ),
                                              ],
                                            ),
                                          );
                                        });
                                  },
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          Divider(),
                          SizedBox(height: 10),
                          Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.0),
                              color: Color(
                                  0xFFD9D9D9), // Creates uniformly rounded corners
                            ),
                            child: Row(
                              children: [
                                SizedBox(width: 10),
                                Icon(
                                  Icons.person,
                                  size: 20,
                                ),
                                SizedBox(width: 20),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text('Name:',
                                          style: TextStyle(
                                              fontFamily: 'MontMed',
                                              color: Colors.black38)),
                                      Text(
                                          '${userModel?.userFirstName} ${userModel?.userLastName}',
                                          style: TextStyle(
                                              fontFamily: 'MontMed',
                                              fontSize: 16)),
                                    ],
                                  ),
                                ),
                                SizedBox(width: 10),
                                IconButton(
                                  onPressed: () {},
                                  icon: Icon(
                                    Icons.border_color,
                                    size: 17,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 10),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.0),
                              color: Color(
                                  0xFFD9D9D9), // Creates uniformly rounded corners
                            ),
                            padding: EdgeInsets.all(10),
                            child: Row(
                              children: [
                                SizedBox(width: 10),
                                Icon(
                                  Icons.email,
                                  size: 20,
                                ),
                                SizedBox(width: 20),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text('Email:',
                                          style: TextStyle(
                                              fontFamily: 'MontMed',
                                              color: Colors.black38)),
                                      Text('${userModel?.userEmail}',
                                          style: TextStyle(
                                              fontFamily: 'MontMed',
                                              fontSize: 16)),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                IconButton(
                                  onPressed: () {},
                                  icon: Icon(
                                    Icons.border_color,
                                    size: 17,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 10),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.0),
                              color: Color(0xFFD9D9D9),
                            ),
                            padding: EdgeInsets.all(10),
                            child: Row(
                              children: [
                                SizedBox(width: 10),
                                Icon(
                                  Icons.phone,
                                  size: 22,
                                ),
                                SizedBox(width: 20),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text('Mobile:',
                                          style: TextStyle(
                                              fontFamily: 'MontMed',
                                              color: Colors.black38)),
                                      Text('+84 444 131 49',
                                          style: TextStyle(
                                              fontFamily: 'MontMed',
                                              fontSize: 16)),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                IconButton(
                                  onPressed: () {},
                                  icon: Icon(
                                    Icons.border_color,
                                    size: 17,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 10),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.0),
                              color: Color(
                                  0xFFD9D9D9), // Creates uniformly rounded corners
                            ),
                            padding: EdgeInsets.all(10),
                            child: Row(
                              children: [
                                SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text('About Yourself:',
                                          style: TextStyle(
                                              fontFamily: 'MontMed',
                                              color: Colors.black38)),
                                      Divider(),
                                      Text(
                                          'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nulla tempus mollis odio, et feugiat sem tincidunt sed. Integer at porttitor massa. Ut ullamcorper eros non orci porta posuere.',
                                          style: TextStyle(
                                              fontFamily: 'MontMed',
                                              fontSize: 16)),
                                      SizedBox(
                                        height: 10,
                                      ),
                                    ],
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {},
                                  icon: Icon(
                                    Icons.border_color,
                                    size: 17,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  )),
                ],
              ),
            ),
    );
  }

  String getHumanReadableDate(int dt) {
    DateTime dateTime = DateTime.fromMicrosecondsSinceEpoch(dt);
    return DateFormat('dd MMM yyyy').format(dateTime);
  }

  String getYearExp(int dt) {
    DateTime dateTime = DateTime.fromMicrosecondsSinceEpoch(dt);
    int getYear = DateTime.now().year - dateTime.year;
    if (getYear < 1) {
      return '< 1';
    }
    return '$getYear';
  }

  get _pickImageFromGallery async {
    XFile? xFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (xFile == null) return;
    final tempImage = File(xFile.path);
    imageFile = tempImage;
    showLocalFile = true;
    setState(() {});
    _uploadFirebaseStorage;
  }

  get _uploadFirebaseStorage async {
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
          .child(userModel!.userId);
      await userRef.update({'profileImage': profileImageUrl});
      progressDialog.dismiss();
    } catch (e) {
      progressDialog.dismiss();
      print(e.toString());
    }
  }

  _pickImageFromCamera(ImageSource source) async {
    XFile? xFile = await ImagePicker().pickImage(source: source);
    if (xFile == null) return;
    final tempImage = File(xFile.path);
    imageFile = tempImage;
    showLocalFile = true;
    setState(() {});
    _uploadFirebaseStorage;
  }

  String getFirstLetter(String myString) => myString.substring(0, 1);
}
