import 'dart:io';

import 'package:capstone2_project_management_app/views/stats/stats.dart';
import 'package:capstone2_project_management_app/views/subs/db_side_menu.dart';
import 'package:capstone2_project_management_app/views/subs/sub_widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:ndialog/ndialog.dart';

import '../models/user_model.dart';
import '../services/image_services.dart';

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
          ? Center(child: loader())
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
                            fontFamily: 'MontMed',
                            fontSize: 16,
                          ),
                        ),
                        Divider(),
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircleAvatar(
                              radius: 70,
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
                        ListTile(
                          leading: CircleAvatar(
                            child: Icon(Icons.person),
                          ),
                          title: Text('Full Name : ', style: TextStyle(fontFamily: 'MontMed', fontSize: 12, color: Colors.black54)),
                          subtitle: Text('${userModel?.userFirstName} ${userModel?.userLastName}', style: TextStyle(fontFamily: 'MontMed', fontSize: 14)),
                        ),
                        Divider(),
                        ListTile(
                          leading: CircleAvatar(
                            child: Icon(Icons.star),
                          ),
                          title: Text('User Role : ', style: TextStyle(fontFamily: 'MontMed', fontSize: 12, color: Colors.black54)),
                          subtitle: Text('Member', style: TextStyle(fontFamily: 'MontMed', fontSize: 14)),
                          trailing: IconButton(
                            onPressed: () {},
                            icon: Icon(
                              Icons.border_color,
                              size: 15,
                            ),
                          ),
                        ),
                        Divider(),
                        ListTile(
                          leading: CircleAvatar(
                            child: Icon(Icons.mail),
                          ),
                          title: Text('Contact Email : ', style: TextStyle(fontFamily: 'MontMed', fontSize: 12, color: Colors.black54)),
                          subtitle: Text('${userModel?.userEmail}', style: TextStyle(fontFamily: 'MontMed', fontSize: 14)),
                        ),
                        Divider(),
                        ListTile(
                          leading: CircleAvatar(
                            child: Icon(Icons.phone),
                          ),
                          title: Text('Mobile Number : ', style: TextStyle(fontFamily: 'MontMed', fontSize: 12, color: Colors.black54)),
                          subtitle: Text('+84 444 131 49', style: TextStyle(fontFamily: 'MontMed', fontSize: 14)),
                          trailing: IconButton(
                            onPressed: () {},
                            icon: Icon(
                              Icons.border_color,
                              size: 15,
                            ),
                          ),
                        ),
                        Divider(),
                        ListTile(
                          title: Text('About yourself : ', style: TextStyle(fontFamily: 'MontMed', fontSize: 12, color: Colors.black54)),
                          subtitle: Text(
                              'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nulla tempus mollis odio, et feugiat sem tincidunt sed. Integer at porttitor massa. Ut ullamcorper eros non orci porta posuere.',
                              style: TextStyle(fontFamily: 'MontMed', fontSize: 14)),
                          trailing: IconButton(
                            onPressed: () {},
                            icon: Icon(
                              Icons.border_color,
                              size: 15,
                            ),
                          ),
                        ),
                        Divider(),
                        ListTile(
                          leading: CircleAvatar(
                            child: Icon(Icons.folder),
                          ),
                          title: Text('Projects Related : ', style: TextStyle(fontFamily: 'MontMed', fontSize: 12, color: Colors.black54)),
                          subtitle: Text('3 Projects Participated', style: TextStyle(fontFamily: 'MontMed', fontSize: 14)),
                          trailing: IconButton(
                            onPressed: () {},
                            icon: Icon(
                              Icons.info,
                              size: 20,
                            ),
                          ),
                        ),
                        Divider(),
                        ListTile(
                          leading: CircleAvatar(
                            child: Icon(Icons.layers),
                          ),
                          title: Text('Tasks Related : ', style: TextStyle(fontFamily: 'MontMed', fontSize: 12, color: Colors.black54)),
                          subtitle: Text('12 Tasks Participated', style: TextStyle(fontFamily: 'MontMed', fontSize: 14)),
                          trailing: IconButton(
                            onPressed: () {},
                            icon: Icon(
                              Icons.info,
                              size: 20,
                            ),
                          ),
                        ),
                        Divider(),
                      ],
                    ),
                  ),
                )
            ),
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

  bool member = true;
  bool leader = false;
  bool manager = false;
  void _showStateDrawer(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          // Your bottom drawer content goes here
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 20),
              Row(
                children: [
                  SizedBox(width: 25),
                  Text('Change Role:', style: TextStyle(fontFamily: 'MontMed', fontSize: 16)),
                ],
              ),
              SizedBox(height: 5),
              Divider(),
              ListTile(
                  leading: Icon(Icons.people),
                  title: Text('Member', style: TextStyle(fontFamily: 'MontMed', fontSize: 14)),
                  onTap: () {
                    member = true;
                    leader = false;
                    manager = false;
                    Navigator.pop(context);
                  },
                  trailing: Container(
                      child: Visibility(
                        visible: member,
                        child: Icon(Icons.check),
                      )
                  )
              ),
              ListTile(
                  leading: Icon(Icons.person),
                  title: Text('Incompleted', style: TextStyle(fontFamily: 'MontMed', fontSize: 14)),
                  onTap: () {
                    member = false;
                    leader = true;
                    manager = false;
                    Navigator.pop(context);
                  },
                  trailing: Container(
                      child: Visibility(
                        visible: leader,
                        child: Icon(Icons.check),
                      )
                  )
              ),
              ListTile(
                  leading: Icon(Icons.star),
                  title: Text('Manager', style: TextStyle(fontFamily: 'MontMed', fontSize: 14)),
                  onTap: () {
                    member = false;
                    leader = false;
                    manager = true;
                    Navigator.pop(context);
                  },
                  trailing: Container(
                      child: Visibility(
                        visible: manager,
                        child: Icon(Icons.check),
                      )
                  )
              ),
            ],
          ),
        );
      },
    );
  }
}
