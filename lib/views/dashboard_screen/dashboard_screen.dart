import 'package:capstone2_project_management_app/models/user_model.dart';
import 'package:capstone2_project_management_app/services/notification_services.dart';
import 'package:capstone2_project_management_app/services/stream_builder_service.dart';
import 'package:capstone2_project_management_app/views/dashboard_screen/db_main_screen.dart';
import 'package:capstone2_project_management_app/views/dashboard_screen/db_main_screen_v2.dart';
import 'package:capstone2_project_management_app/views/project_screen/project_create_step1.dart';
import 'package:capstone2_project_management_app/views/subs/db_side_menu.dart';
import 'package:capstone2_project_management_app/views/subs/sub_widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  User? user;
  UserModel? userModel;
  DatabaseReference? userRef;
  DatabaseReference? projectRef;
  late Map<String, dynamic> projectMap;
  late Map<String, dynamic> taskMap;
  final databaseReference = FirebaseDatabase.instance.ref();
  StreamBuilderService streamBuilderService = StreamBuilderService();
  _getUserDetails() async {
    DatabaseEvent snapshot = await userRef!.once();

    userModel = UserModel.fromMap(
        Map<String, dynamic>.from(snapshot.snapshot.value as dynamic));

    setState(() {});
  }

  Future<Map<String, dynamic>> _getProjectValues() async {
    DatabaseEvent databaseEvent =
        await databaseReference.child('projects').once();
    if (databaseEvent.snapshot.value != null) {
      return Map.from(databaseEvent.snapshot.value as dynamic);
    }
    return {};
  }

  Future<Map<String, dynamic>> _getTaskValues() async {
    DatabaseEvent databaseEvent = await databaseReference.child('tasks').once();
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
      //projectRef = databaseReference.child('projects');
    }
    _getUserDetails();
  }

  @override
  Widget build(BuildContext context) {
    return userModel == null
        ? loader()
        : Scaffold(
            body: StreamBuilder<List<Object>>(
                stream: CombineLatestStream.list([
                  NotificationService().databaseReference.onValue,
                  //UserServices().databaseReference.child(user!.uid).onValue,
                ]),
                builder: (context, snapshot) {
                  if (snapshot.hasError || !snapshot.hasData) {
                    return loader();
                  }
                  // userModel = streamBuilderService.getUserModelFromSnapshotList(
                  //     snapshot, 1);
                  Map notifiMap =
                      streamBuilderService.getMapFromSnapshotList(snapshot, 0);
                  int numNr = NotificationService()
                      .getListAllNotRead(notifiMap, userModel!.userId)
                      .length;
                  return SafeArea(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        DbSideMenu(
                          userModel: userModel!,
                          numNotRead: numNr,
                        ),
                        FutureBuilder<List<Map<String, dynamic>>>(
                          future: Future.wait(
                              [_getProjectValues(), _getTaskValues()]),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Expanded(child: loader());
                            } else if (snapshot.hasError) {
                              return Center(
                                  child: Text('Error: ${snapshot.error}'));
                            } else {
                              projectMap = snapshot.data![0];
                              taskMap = snapshot.data![1];
                              return Expanded(
                                child: userModel?.userRole == "User"
                                    ? DashboardMainV2(
                                        userModel: userModel,
                                        projectMap: projectMap,
                                        taskMap: taskMap,
                                      )
                                    : DashboardMainV1(
                                        currentUserModel: userModel!,
                                      ),
                              );
                            }
                          },
                        ),
                        // Expanded(
                        //   child: userModel?.userRole == "User"
                        //       ? const DashboardMainV2()
                        //       : DashboardMainV1(
                        //           currentUserModel: userModel,
                        //           projectMap: projectMap),
                        // ),
                      ],
                    ),
                  );
                }),
            floatingActionButton: Visibility(
              visible: userModel?.userRole == 'Admin' ||
                  userModel?.userRole == 'Manager',
              child: FloatingActionButton(
                onPressed: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) {
                    return ProjectCreateStep1(
                      currentUserModel: userModel,
                      projectMap: projectMap,
                    );
                  }));
                },
                backgroundColor: Colors.deepOrangeAccent,
                tooltip:
                    'Add Project', // Optional tooltip text shown on long-press
                child: Icon(
                  Icons.create_new_folder,
                  color: Colors.white,
                ), // Updated icon for the FAB
              ),
            ));
  }
}
