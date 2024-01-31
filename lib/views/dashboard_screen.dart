import 'package:capstone2_project_management_app/models/user_model.dart';
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
  DatabaseReference? projectRef;
  late Map<String, dynamic> projectMap;
  final databaseReference = FirebaseDatabase.instance.ref();
  _getUserDetails() async {
    DatabaseEvent snapshot = await userRef!.once();
    userModel = UserModel.fromMap(
        Map<String, dynamic>.from(snapshot.snapshot.value as dynamic));
    setState(() {
      _getProjectValues();
    });
  }

  Future<Map<String, dynamic>> _getProjectValues() async {
    DatabaseEvent databaseEvent =
        await databaseReference.child('projects').once();
    if (databaseEvent.snapshot.value != null) {
      return Map.from(databaseEvent.snapshot.value as dynamic);
    }
    return {};
  }

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      userRef = databaseReference.child('users').child(user!.uid);
      _waitUntilHasData();
      //projectRef = databaseReference.child('projects');
    }
  }

  _waitUntilHasData() async {
    await _getUserDetails();
    // await _getProjectValues();
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
                    FutureBuilder(
                        future: _getProjectValues(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                                child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            return Center(
                                child: Text('Error: ${snapshot.error}'));
                          } else {
                            projectMap = snapshot.data ?? {};
                            return Expanded(
                              child: userModel?.userRole == "User"
                                  ? const DashboardMainV2()
                                  : DashboardMainV1(
                                      currentUserModel: userModel,
                                      projectMap: projectMap),
                            );
                          }
                        }),
                    // Expanded(
                    //   child: userModel?.userRole == "User"
                    //       ? const DashboardMainV2()
                    //       : DashboardMainV1(
                    //           currentUserModel: userModel,
                    //           projectMap: projectMap),
                    // ),
                  ],
                ),
              ),
        floatingActionButton: Visibility(
          visible: userModel?.userRole == "User" ? false : true,
          child: FloatingActionButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                return projectCreateStep1(
                  currentUserModel: userModel,
                  projectMap: projectMap,
                );
              }));
            },
            backgroundColor: Colors.deepOrangeAccent,
            tooltip: 'Add Project', // Optional tooltip text shown on long-press
            child: Icon(
              Icons.create_new_folder,
              color: Colors.white,
            ), // Updated icon for the FAB
          ),
        ));
  }
}
