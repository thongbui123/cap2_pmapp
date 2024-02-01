import 'package:capstone2_project_management_app/views/dashboard_screen.dart';
import 'package:capstone2_project_management_app/views/profile_screen.dart';
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
                return const dashboard_screen();
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
          ListTile(
            leading: const Icon(Icons.notifications, color: Colors.white),
            onTap: () {
              // Handle menu item tap
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings, color: Colors.white),
            onTap: () {
              // Handle menu item tap
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
