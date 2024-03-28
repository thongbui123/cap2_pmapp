import 'package:capstone2_project_management_app/views/dashboard_screen.dart';
import 'package:capstone2_project_management_app/views/notification_screen.dart';
import 'package:capstone2_project_management_app/views/profile_screen.dart';
import 'package:capstone2_project_management_app/views/statistics_screen.dart';
import 'package:capstone2_project_management_app/views/subs/sign_out_dialog.dart';
import 'package:capstone2_project_management_app/views/team_screen.dart';
import 'package:flutter/material.dart';

class db_side_menu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
                return const profile_screen();
              }));
              // Handle menu item tap
            },
          ),
          ListTile(
            leading: const Icon(Icons.dashboard, color: Colors.white),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                return const Dashboard_screen();
              }));
              // Handle menu item tap
            },
          ),
          ListTile(
            leading: const Icon(Icons.group, color: Colors.white),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                return const TeamScreen();
              }));
              // Handle menu item tap
            },
          ),
          Stack(
            children: [
              ListTile(
                leading: const Icon(Icons.notifications, color: Colors.white),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => notification_screen(),
                    ),
                  );
                  // Handle menu item tap
                },
              ),
              Positioned(
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
                    '2',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                    ),
                    textAlign: TextAlign.center,
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
                  builder: (context) => statistic_screen(),
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
