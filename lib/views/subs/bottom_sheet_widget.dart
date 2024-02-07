import 'package:capstone2_project_management_app/models/project_model.dart';
import 'package:capstone2_project_management_app/models/user_model.dart';
import 'package:capstone2_project_management_app/services/project_services.dart';
import 'package:capstone2_project_management_app/services/user_services.dart';
import 'package:capstone2_project_management_app/views/project_detail_screen.dart';
import 'package:capstone2_project_management_app/views/subs/sub_widgets.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class StatefulBottomSheetWidget extends StatefulWidget {
  final ProjectModel projectModel;
  final String message;
  final List<UserModel> allMembers;
  final List<String> currentList;
  final Map<String, dynamic> userMap;
  final Map<dynamic, dynamic> projectMap;
  StatefulBottomSheetWidget(
      {required this.message,
      required this.allMembers,
      required this.currentList,
      required this.userMap,
      required this.projectMap,
      required this.projectModel});

  @override
  _StatefulBottomSheetWidgetState createState() =>
      _StatefulBottomSheetWidgetState();
}

class _StatefulBottomSheetWidgetState extends State<StatefulBottomSheetWidget> {
  late ProjectModel projectModel;
  late List<UserModel> allMembers;
  late List<String> currentList;
  late Map<String, dynamic> userMap;
  Map<String, String> mapName = {};
  UserServices userServices = UserServices();
  late Map<dynamic, dynamic> projectMap;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    allMembers = widget.allMembers;
    currentList = widget.currentList;
    userMap = widget.userMap;
    projectMap = widget.projectMap;
    projectModel = widget.projectModel;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          const SizedBox(height: 10),
          Container(
              child: TextButton(
            onPressed: _showMemberSelectionDialog,
            child: const Row(
              children: [
                Icon(
                  Icons.add,
                  color: Colors.blueAccent,
                ),
                SizedBox(width: 10),
                Text(
                  'Add New Participant',
                  style: TextStyle(
                      fontFamily: 'MontMed', color: Colors.blueAccent),
                ),
              ],
            ),
          )),
          const SizedBox(height: 10),
          Expanded(
            child: Column(
              children: ListTile.divideTiles(
                context:
                    context, // Make sure to provide the BuildContext if this code is inside a widget build method
                tiles: currentList.map((member) {
                  return ListTile(
                    leading: avatar(userMap, member),
                    title: Text(userServices.getNameFromId(userMap, member),
                        style: const TextStyle(
                            fontFamily: 'MontMed', fontSize: 13)),
                    subtitle: Text(
                      'Joined project numbers: ${ProjectServices().getJoinedProjectNumber(projectMap, member)}',
                      style: TextStyle(fontFamily: 'MontMed', fontSize: 12),
                    ),
                    trailing: Ink(
                      decoration: const ShapeDecoration(
                        color: Colors.transparent,
                        shape: CircleBorder(),
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.delete),
                        color: Colors.red,
                        onPressed: () {
                          _showDeleteMemberDialog(member);
                        },
                      ),
                    ),
                  );
                }),
              ).toList(),
            ),
          ),
        ],
      ),
    );
  }

  // CircleAvatar avatar(String member) {
  //   return CircleAvatar(
  //     child: userServices.getAvatarFromId(userMap, member) == ''
  //         ? Text(
  //             userServices.getFirstLetter(
  //                 userServices.getNameFromId(userMap, member).toString()),
  //             style: const TextStyle(fontFamily: 'MontMed'),
  //           )
  //         : CircleAvatar(
  //             radius: 66,
  //             backgroundColor: Colors.white,
  //             backgroundImage: userServices.showLocalFile
  //                 ? FileImage(userServices.imageFile!) as ImageProvider
  //                 : NetworkImage(
  //                     userServices.getAvatarFromId(userMap, member)!,
  //                   ),
  //           ),
  //   );
  // }

  Future<void> _showMemberSelectionDialog() async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'MEMBERS',
            style: TextStyle(fontFamily: 'Anurati'),
          ),
          content: SingleChildScrollView(
            child: Column(
              children: allMembers.map((user) {
                return Column(
                  children: <Widget>[
                    ListTile(
                      leading: avatar(userMap, user.userId),
                      title: Text(
                          userServices.getNameFromId(userMap, user.userId)),
                      subtitle: Text(
                        '${ProjectServices().getJoinedProjectNumber(projectMap, user.userId)} Project(s) Involved',
                        style: const TextStyle(fontFamily: 'MontMed'),
                      ),
                      onTap: () async {
                        setState(() {
                          currentList.add(user.userId);
                          DatabaseReference memberRef = FirebaseDatabase
                              .instance
                              .ref()
                              .child('projects')
                              .child(projectModel.projectId);
                          memberRef.update({
                            'projectMembers': currentList,
                          });
                        });
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: (context) => projectDetailScreen(
                                projectModel: projectModel,
                                userMap: userMap,
                                projectMap: projectMap)));
                        // Close the dialog
                      },
                    ),
                    const Divider(height: 0),
                  ],
                );
              }).toList(),
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'Cancel',
                style: TextStyle(fontFamily: 'MontMed'),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showDeleteMemberDialog(String member) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('REMOVE MEMBER'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Do You Want To Remove This Member?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('YES'),
              onPressed: () {
                setState(() {
                  currentList.remove(member);
                  DatabaseReference memberRef = FirebaseDatabase.instance
                      .ref()
                      .child('projects')
                      .child(projectModel.projectId);
                  memberRef.update({
                    'projectMembers': currentList,
                  });
                });
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => projectDetailScreen(
                        projectModel: projectModel,
                        userMap: userMap,
                        projectMap: projectMap)));
              },
            ),
            TextButton(
              child: const Text('NO'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
