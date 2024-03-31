import 'package:capstone2_project_management_app/models/project_model.dart';
import 'package:capstone2_project_management_app/models/task_model.dart';
import 'package:capstone2_project_management_app/models/user_model.dart';
import 'package:capstone2_project_management_app/services/project_services.dart';
import 'package:capstone2_project_management_app/services/task_services.dart';
import 'package:capstone2_project_management_app/services/user_services.dart';
import 'package:capstone2_project_management_app/views/stats/stats.dart';
import 'package:capstone2_project_management_app/views/subs/db_side_menu.dart';
import 'package:capstone2_project_management_app/views/subs/sub_widgets.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class SearchScreen extends StatefulWidget {
  final UserModel userModel;
  final String? output;
  const SearchScreen({Key? key, required this.userModel, this.output})
      : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

List<ProjectModel> allProjects = [];

List<TaskModel> allTasks = [];

List<UserModel> allPeople = [];

bool _customTileExpanded0 = true;
bool _customTileExpanded1 = true;
bool _customTileExpanded2 = true;

class _SearchScreenState extends State<SearchScreen> {
  late UserModel? userModel;
  ProjectServices projectServices = ProjectServices();
  TaskService taskService = TaskService();
  UserServices userServices = UserServices();
  TextEditingController textEditingController = TextEditingController();
  Map projectMap = {};
  Map taskMap = {};
  Map userMap = {};
  String output = "";
  @override
  void initState() {
    super.initState();
    userModel = widget.userModel;
    output = widget.output ?? "";
    textEditingController.text = output;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Object>>(
        stream: CombineLatestStream.list([
          projectServices.reference.onValue,
          taskService.taskRef.onValue,
          userServices.databaseReference.onValue,
        ]),
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.hasError) {
            return loader();
          }
          var event = snapshot.data![0] as DatabaseEvent;
          var value = event.snapshot.value as dynamic;
          projectMap = Map.from(value);
          allProjects =
              projectServices.getSearchedProjectList(projectMap, output);
          var event1 = snapshot.data![1] as DatabaseEvent;
          var value1 = event1.snapshot.value as dynamic;
          taskMap = Map.from(value1);
          var event2 = snapshot.data![2] as DatabaseEvent;
          var value2 = event2.snapshot.value as dynamic;
          userMap = Map.from(value2);
          return Scaffold(
            body: SafeArea(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DbSideMenu(
                    userModel: userModel!,
                  ),
                  Expanded(
                      child: Padding(
                    padding: EdgeInsets.all(defaultPadding),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            children: [
                              Text(
                                'SEARCH RESULT',
                                style: TextStyle(
                                  fontFamily: 'MontMed',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                          const Divider(),
                          const SizedBox(height: 10),
                          Align(
                            child: Container(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Expanded(
                                    child: TextField(
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontFamily: 'MontMed',
                                        fontWeight: FontWeight.normal,
                                        fontSize: 16,
                                      ),
                                      decoration: InputDecoration(
                                        enabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Color(0xFFD9D9D9)),
                                        ),
                                        focusedBorder: UnderlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.black54),
                                        ),
                                        labelText: 'Search here...',
                                        labelStyle: TextStyle(
                                          color: Colors.black,
                                          fontFamily: 'MontMed',
                                          fontWeight: FontWeight.normal,
                                          fontSize: 14,
                                        ),
                                        filled: true,
                                        fillColor: Color(0xFFD9D9D9),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Container(
                                      height: 50,
                                      child: IconButton(
                                        onPressed: () {},
                                        icon: Icon(Icons.search),
                                      )),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 5),
                          Divider(),
                          SizedBox(height: 5),
                          Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.indigo[50],
                              borderRadius: BorderRadius.circular(
                                  5.0), // Set the border radius
                            ),
                            child: ExpansionTile(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.zero,
                              ),
                              initiallyExpanded: true,
                              title: Row(
                                children: [
                                  Icon(
                                    Icons.folder,
                                    color: Colors.orange,
                                  ),
                                  SizedBox(width: 10),
                                  Text('Project(s)',
                                      style: TextStyle(
                                          fontFamily: 'MontMed', fontSize: 13)),
                                ],
                              ),
                              trailing: Icon(
                                _customTileExpanded0
                                    ? Icons.arrow_drop_down_circle
                                    : Icons.arrow_drop_down,
                              ),
                              children: [
                                Divider(),
                                Container(
                                  child: Column(
                                    children: allProjects.map((project) {
                                      return ListTile(
                                        leading: const CircleAvatar(
                                            child: Icon(Icons.folder,
                                                color: Colors.orange)),
                                        title: Text('${project}',
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                                fontFamily: 'MontMed',
                                                fontSize: 13)),
                                        subtitle: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Icon(
                                                  Icons.people,
                                                  size: 13,
                                                ),
                                                SizedBox(width: 5),
                                                Text('Participants: 3',
                                                    style: TextStyle(
                                                        fontFamily: 'MontMed',
                                                        fontSize: 12))
                                              ],
                                            ),
                                          ],
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ],
                              onExpansionChanged: (bool expanded) {
                                setState(() {
                                  _customTileExpanded0 = expanded;
                                });
                              },
                            ),
                          ),
                          SizedBox(height: 10),
                          Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.indigo[50],
                              borderRadius: BorderRadius.circular(
                                  5.0), // Set the border radius
                            ),
                            child: ExpansionTile(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.zero,
                              ),
                              initiallyExpanded: true,
                              title: Row(
                                children: [
                                  Icon(Icons.layers, color: Colors.blue),
                                  SizedBox(width: 10),
                                  Text('Task(s)',
                                      style: TextStyle(
                                          fontFamily: 'MontMed', fontSize: 13)),
                                ],
                              ),
                              trailing: Icon(
                                _customTileExpanded1
                                    ? Icons.arrow_drop_down_circle
                                    : Icons.arrow_drop_down,
                              ),
                              children: [
                                Divider(),
                                Container(
                                  child: Column(
                                    children: allTasks.map((task) {
                                      return ListTile(
                                        leading: const CircleAvatar(
                                            child: Icon(Icons.layers,
                                                color: Colors.blue)),
                                        title: Text('Task: ${task}',
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                                fontFamily: 'MontMed',
                                                fontSize: 13)),
                                        subtitle: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Icon(
                                                  Icons.folder_open_sharp,
                                                  size: 13,
                                                ),
                                                SizedBox(width: 5),
                                                Text('Project:...',
                                                    style: TextStyle(
                                                        fontFamily: 'MontMed',
                                                        fontSize: 12))
                                              ],
                                            ),
                                          ],
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ],
                              onExpansionChanged: (bool expanded) {
                                setState(() {
                                  _customTileExpanded1 = expanded;
                                });
                              },
                            ),
                          ),
                          SizedBox(height: 10),
                          Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.indigo[50],
                              borderRadius: BorderRadius.circular(
                                  5.0), // Set the border radius
                            ),
                            child: ExpansionTile(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.zero,
                              ),
                              initiallyExpanded: true,
                              title: Row(
                                children: [
                                  Icon(Icons.people, color: Colors.brown),
                                  SizedBox(width: 10),
                                  Text('People(s)',
                                      style: TextStyle(
                                          fontFamily: 'MontMed', fontSize: 13)),
                                ],
                              ),
                              trailing: Icon(
                                _customTileExpanded2
                                    ? Icons.arrow_drop_down_circle
                                    : Icons.arrow_drop_down,
                              ),
                              children: [
                                Divider(),
                                Container(
                                  child: Column(
                                    children: allPeople.map((project) {
                                      return ListTile(
                                        leading: const CircleAvatar(
                                            child: Icon(Icons.person,
                                                color: Colors.brown)),
                                        title: Text('Name: ${project}',
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                                fontFamily: 'MontMed',
                                                fontSize: 13)),
                                        subtitle: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Icon(
                                                  Icons.folder_open_sharp,
                                                  size: 13,
                                                ),
                                                SizedBox(width: 5),
                                                Text('Project:...',
                                                    style: TextStyle(
                                                        fontFamily: 'MontMed',
                                                        fontSize: 12))
                                              ],
                                            ),
                                          ],
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ],
                              onExpansionChanged: (bool expanded) {
                                setState(() {
                                  _customTileExpanded2 = expanded;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  )),
                ],
              ),
            ),
          );
        });
  }
}
