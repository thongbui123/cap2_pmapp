import 'package:capstone2_project_management_app/models/project_model.dart';
import 'package:capstone2_project_management_app/models/user_model.dart';
import 'package:capstone2_project_management_app/services/user_services.dart';
import 'package:capstone2_project_management_app/views/project_detail_screen.dart';
import 'package:capstone2_project_management_app/views/task_create_screen.dart';
import 'package:flutter/material.dart';

Widget loader() {
  return const Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
      ),
      SizedBox(
        height: 10,
      ),
      Text(
        'Please Wait',
        style: TextStyle(fontFamily: 'MontMed', fontSize: 14),
      ),
    ],
  );
}

CircleAvatar avatar(Map<String, dynamic> userMap, String member) {
  UserServices userServices = UserServices();
  return CircleAvatar(
    child: userServices.getAvatarFromId(userMap, member) == ''
        ? Text(
            userServices.getFirstLetter(
                userServices.getNameFromId(userMap, member).toString()),
            style: const TextStyle(fontFamily: 'MontMed'),
          )
        : CircleAvatar(
            radius: 66,
            backgroundColor: Colors.white,
            backgroundImage: userServices.showLocalFile
                ? FileImage(userServices.imageFile!) as ImageProvider
                : NetworkImage(
                    userServices.getAvatarFromId(userMap, member)!,
                  ),
          ),
  );
}

class ProjectDetailWidget extends StatelessWidget {
  const ProjectDetailWidget({
    super.key,
    required this.projectModel,
    required this.userMap,
    required this.currentUserModel,
    required this.projectMap,
    required this.phraseMap,
  });

  final ProjectModel projectModel;
  final Map<String, dynamic> userMap;
  final UserModel currentUserModel;
  final Map projectMap;
  final Map phraseMap;

  @override
  Widget build(BuildContext context) {
    return ProjectDetailScreen(
      projectModel: projectModel,
      userMap: userMap,
      userModel: currentUserModel,
      projectMap: projectMap,
      phraseMap: phraseMap,
    );
  }
}

class TaskCreateWidget extends StatelessWidget {
  const TaskCreateWidget({
    super.key,
    required this.projectMap,
    required this.currentUserModel,
    required this.userMap,
  });

  final Map projectMap;
  final UserModel currentUserModel;
  final Map<String, dynamic> userMap;

  @override
  Widget build(BuildContext context) {
    return TaskCreateScreen(
      projectMap: projectMap,
      currentUserModel: currentUserModel,
      userMap: userMap,
    );
  }
}

FutureBuilder<Map<String, dynamic>> getFutureUserMap(
    Map<String, dynamic> userMap, Map projectMap, UserModel currentUserModel) {
  return FutureBuilder(
    future: UserServices().getUserDataMap(),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      } else if (snapshot.hasError) {
        return Center(child: Text('Error: ${snapshot.error}'));
      } else {
        userMap = snapshot.data ?? {};
        return Expanded(
          child: TaskCreateWidget(
              projectMap: projectMap,
              currentUserModel: currentUserModel,
              userMap: userMap),
          // ProjectDetailScreen(
          //   projectModel: projectModel,
          //   userMap: userMap,
          //   userModel: currentUserModel,
          //   projectMap: projectMap,
          //   phraseMap: phraseMap,
          // ),
        );
      }
    },
  );
}
