// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:capstone2_project_management_app/models/notification_model.dart';
import 'package:capstone2_project_management_app/models/user_model.dart';
import 'package:capstone2_project_management_app/services/notification_services.dart';
import 'package:capstone2_project_management_app/services/project_services.dart';
import 'package:capstone2_project_management_app/services/user_services.dart';
import 'package:capstone2_project_management_app/views/dashboard_screen/dashboard_screen.dart';
import 'package:capstone2_project_management_app/views/list_of_employee_screen.dart';
import 'package:capstone2_project_management_app/views/notification_screen.dart';
import 'package:capstone2_project_management_app/views/login_screen/profile_screen.dart';
import 'package:capstone2_project_management_app/views/statistics_screen.dart';
import 'package:capstone2_project_management_app/views/subs/sign_out_dialog.dart';
import 'package:capstone2_project_management_app/views/subs/sub_widgets.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class DbSideMenu extends StatelessWidget {
  final UserModel userModel;
  final int numNotRead;
  const DbSideMenu({
    Key? key,
    required this.userModel,
    required this.numNotRead,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int numNR = numNotRead;
    return Drawer(
      backgroundColor: Colors.black87,
      width: 65,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          ListTile(
            leading: const Icon(Icons.account_circle, color: Colors.white),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                return profile_screen(
                  userModel: userModel,
                );
              }));
              // Handle menu item tap
            },
          ),
          ListTile(
            leading: const Icon(Icons.dashboard, color: Colors.white),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                return const DashboardScreen();
              }));
              // Handle menu item tap
            },
          ),
          Visibility(
            visible: userModel.userRole == 'Admin',
            child: ListTile(
              leading: const Icon(Icons.group, color: Colors.white),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => StreamBuilder<List<Object>>(
                        stream: CombineLatestStream.list([
                          UserServices().databaseReference.onValue,
                          ProjectServices().reference.onValue
                        ]),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return loader();
                          } else if (snapshot.hasError) {
                            return Center(
                              child: Text('Error: ${snapshot.error}'),
                            );
                          } else {
                            var eventUser = snapshot.data![0] as DatabaseEvent;
                            var eventProject =
                                snapshot.data![1] as DatabaseEvent;
                            var dynamicUser =
                                eventUser.snapshot.value as dynamic;
                            var dynamicProject =
                                eventProject.snapshot.value as dynamic;
                            Map mapUser = Map.from(dynamicUser);
                            Map mapProject = Map.from(dynamicProject);
                            return EmployeeScreen(
                              userModel: userModel,
                              userMap: mapUser,
                              projectMap: mapProject,
                            );
                          }
                        }),
                  ),
                );
                // Handle menu item tap
              },
            ),
          ),
          Stack(
            children: [
              ListTile(
                leading: const Icon(Icons.notifications, color: Colors.white),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => StreamBuilder<List<Object>>(
                          stream: CombineLatestStream.list([
                            UserServices().databaseReference.onValue,
                            NotificationService().databaseReference.onValue,
                          ]),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return loader();
                            } else if (snapshot.hasError) {
                              return Center(
                                child: Text('Error: ${snapshot.error}'),
                              );
                            } else {
                              var eventUser =
                                  snapshot.data![0] as DatabaseEvent;
                              var eventNotification =
                                  snapshot.data![1] as DatabaseEvent;
                              var dynamicUser =
                                  eventUser.snapshot.value as dynamic;
                              var dynamicNotification =
                                  eventNotification.snapshot.value as dynamic;
                              Map mapUser = Map.from(dynamicUser);
                              Map mapNotification =
                                  Map.from(dynamicNotification);
                              List<NotificationModel> list =
                                  NotificationService().getListAllNotRead(
                                      mapNotification, userModel.userId);
                              numNR = list.length;
                              return NotificationScreen(
                                  userModel: userModel,
                                  notificationMap: mapNotification,
                                  userMap: mapUser);
                            }
                          }),
                    ),
                  );
                  // Handle menu item tap
                },
              ),
              Visibility(
                visible: numNR > 0,
                child: Positioned(
                  bottom: 0,
                  right: 20,
                  child: Container(
                    padding: EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    constraints: BoxConstraints(
                      minWidth: 15,
                      minHeight: 15,
                    ),
                    child: Text(
                      numNR.toString(),
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ],
          ),
          ListTile(
            leading: const Icon(Icons.analytics, color: Colors.white),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => statistic_screen(userModel: userModel),
                ),
              ); // Handle menu item tap
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout_sharp, color: Colors.white),
            onTap: () {
              SignOutDialog().showMySignOutDialog(context);
            },
          ),
        ],
      ),
    );
  }
}
