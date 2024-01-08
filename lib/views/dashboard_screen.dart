import 'package:capstone2_project_management_app/models/user_model.dart';
import 'package:capstone2_project_management_app/views/subs/add_project_screen.dart';
import 'package:capstone2_project_management_app/views/subs/db_main_screen.dart';
import 'package:capstone2_project_management_app/views/subs/db_main_screen_v2.dart';
import 'package:capstone2_project_management_app/views/subs/db_side_menu.dart';
import 'package:capstone2_project_management_app/views/subs/project_create_step1.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class dashboard_screen extends StatefulWidget {
  const dashboard_screen({Key? key}) : super(key: key);

  @override
  State<dashboard_screen> createState() => _dashboard_screenState();
}

class _dashboard_screenState extends State<dashboard_screen> {
  User? user;
  UserModel? userModel;
  DatabaseReference? userRef;
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
        body: SafeArea(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              db_side_menu(),
              Expanded(
                child: userModel?.userRole == "User"
                    ? Dashboard_main_v2()
                    : Dashboard_main_v1(),
              ),
            ],
          ),
        ),
        floatingActionButton: Visibility(
          visible: userModel?.userRole == "User" ? false : true,
          child: FloatingActionButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                return const projectCreateStep1();
              }));
            },
            backgroundColor: Colors.deepOrangeAccent,
            tooltip: 'Add Project', // Optional tooltip text shown on long-press
            child: Icon(Icons.create_new_folder), // Updated icon for the FAB
          ),
        ));
  }
}
