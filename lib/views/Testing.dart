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

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  User? user;
  UserModel? userModel;
  DatabaseReference? userRef;
  int _selectedIndex = 0;
  File? imageFile;
  bool showLocalFile = false;
  ImageServices? imageServices;

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

  static final List<Widget> _pages = [
    //MyHomePage(title: 'Profile'),
    //ExplorePage(),
    //NotificationsPage(),
    //SettingsPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      if (index == 1) {
        print('1 clicked');
      }
      if (index == 2) {
        print('2 clicked');
      }
      if (index == 3) {
        print('3 clicked');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.redAccent,
        title: const Text(
          'PROFILE',
          style: TextStyle(
            fontSize: 18,
            fontFamily: 'Bazer',
            color: Colors.white,
          ),
        ),
      ),
      body: userModel == null
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 20),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            // Add action for tapping the avatar button
                            print('Avatar button tapped');
                            // Navigate to another page to choose an avatar
                          },
                          child: Column(
                            children: [
                              CircleAvatar(
                                  radius: 60,
                                  backgroundImage: showLocalFile
                                      ? FileImage(imageFile!)
                                  as ImageProvider
                                      : userModel!.profileImage == ''
                                      ? const NetworkImage(
                                      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQGrQoGh518HulzrSYOTee8UO517D_j6h4AYQ&usqp=CAU')
                                      : NetworkImage(userModel!
                                      .profileImage) // Replace with your profile image asset
                              ),
                              IconButton(
                                icon: const Icon(Icons.camera_alt),
                                onPressed: () {
                                  showModalBottomSheet(
                                      context: context,
                                      builder: (context) {
                                        return Padding(
                                          padding:
                                          const EdgeInsets.all(10),
                                          child: Column(
                                            mainAxisSize:
                                            MainAxisSize.min,
                                            children: [
                                              ListTile(
                                                leading: const Icon(
                                                    Icons.image),
                                                title: const Text(
                                                    'From Gallery'),
                                                onTap: () {
                                                  _pickImageFromGallery;
                                                  Navigator.of(context)
                                                      .pop();
                                                },
                                              ),
                                              ListTile(
                                                leading: const Icon(
                                                    Icons.camera_alt),
                                                title: const Text(
                                                    'From Camera'),
                                                onTap: () {
                                                  _pickImageFromCamera(
                                                      ImageSource.camera);
                                                  Navigator.of(context)
                                                      .pop();
                                                },
                                              ),
                                            ],
                                          ),
                                        );
                                      }
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${userModel?.userFirstName} ${userModel?.userLastName}',
                                style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Robot',
                                    color: Colors.redAccent),
                              ),
                              const Divider(
                                color: Colors.redAccent,
                              ),
                              const SizedBox(height: 0),
                              Text(
                                '${userModel?.userRole}',
                                style: const TextStyle(
                                    fontSize: 16, fontFamily: 'Consolas'),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Divider(
                    color: Colors.redAccent,
                  ),
                  GestureDetector(
                    onTap: () {
                      // Add action for tapping the email
                      print('Email tapped');
                    },
                    child: Row(
                      children: [
                        const Icon(Icons.email),
                        const SizedBox(width: 20, height: 40),
                        Text(
                          '${userModel?.userEmail}',
                          style: const TextStyle(
                              fontSize: 16, fontFamily: 'Consolas'),
                        ),
                      ],
                    ),
                  ),
                  const Divider(),
                  const Row(
                    children: [
                      Icon(Icons.info),
                      SizedBox(width: 20, height: 40),
                      Expanded(
                        child: Text(
                          'Bio: Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
                          style: TextStyle(
                              fontSize: 16, fontFamily: 'Consolas'),
                        ),
                      ),
                    ],
                  ),
                  const Divider(),
                  Row(
                    children: [
                      const Icon(Icons.phone),
                      const SizedBox(width: 20, height: 40),
                      Text(
                        '+84 ${userModel?.userPhone}',
                        style: const TextStyle(
                            fontSize: 16, fontFamily: 'Consolas'),
                      ),
                    ],
                  ),
                  const Divider(),
                  Row(
                    children: [
                      const Icon(Icons.work),
                      const SizedBox(width: 20, height: 40),
                      Text(
                        'Years of Experience: ${getYearExp(userModel!.dt)}',
                        style: const TextStyle(
                            fontSize: 16, fontFamily: 'Consolas'),
                      ),
                    ],
                  ),
                  const Divider(),
                  Row(
                    children: [
                      const Icon(Icons.school),
                      const SizedBox(width: 20, height: 40),
                      Text(
                        'Status: ${userModel?.userRole}',
                        style: const TextStyle(
                            fontSize: 16, fontFamily: 'Consolas'),
                      ),
                    ],
                  ),
                  const Divider(
                    color: Colors.redAccent,
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildNumberWidget('Projects', '12', () {
                        // Add action for tapping Related Projects
                        print('Related Projects tapped');
                      }),
                      _buildSeparatorWidget(),
                      _buildNumberWidget('Tasks', '8', () {
                        // Add action for tapping Related Tasks
                        print('Related Tasks tapped');
                      }),
                      _buildSeparatorWidget(),
                      _buildNumberWidget('Collaborators', '4', () {
                        // Add action for tapping Related People
                        print('Related People tapped');
                      }),
                    ],
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black54,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Notifications',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        selectedLabelStyle: const TextStyle(fontSize: 14, fontFamily: 'Robot'),
        unselectedLabelStyle:
        const TextStyle(fontSize: 14, fontFamily: 'Robot'),
      ),
    );
  }

  Widget _buildNumberWidget(String label, String number, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 14, fontFamily: 'Robot'),
          ),
          const SizedBox(height: 5),
          Text(
            number,
            style: const TextStyle(
                fontSize: 24, fontWeight: FontWeight.bold, fontFamily: 'Robot'),
          ),
        ],
      ),
    );
  }

  Widget _buildSeparatorWidget() {
    return const SizedBox(
      height: 40,
      child: VerticalDivider(
        color: Colors.white12,
        thickness: 1,
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
}
