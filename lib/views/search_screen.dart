import 'package:capstone2_project_management_app/models/phase_model.dart';
import 'package:capstone2_project_management_app/models/project_model.dart';
import 'package:capstone2_project_management_app/models/task_model.dart';
import 'package:capstone2_project_management_app/models/user_model.dart';
import 'package:capstone2_project_management_app/services/phase_services.dart';
import 'package:capstone2_project_management_app/services/project_services.dart';
import 'package:capstone2_project_management_app/services/task_services.dart';
import 'package:capstone2_project_management_app/services/user_services.dart';
import 'package:capstone2_project_management_app/views/profile_screen.dart';
import 'package:capstone2_project_management_app/views/project_detail_screen.dart';
import 'package:capstone2_project_management_app/views/stats/stats.dart';
import 'package:capstone2_project_management_app/views/subs/db_side_menu.dart';
import 'package:capstone2_project_management_app/views/subs/sub_widgets.dart';
import 'package:capstone2_project_management_app/views/task_detail_screen.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class SearchScreen extends StatefulWidget {
  final UserModel userModel;
  final String output;
  const SearchScreen({
    Key? key,
    required this.userModel,
    required this.output,
  }) : super(key: key);

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
  TextEditingController editingController = TextEditingController();
  Map projectMap = {};
  Map taskMap = {};
  Map<String, dynamic> userMap = {};
  @override
  void initState() {
    super.initState();
    userModel = widget.userModel;
    editingController.text = widget.output;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Object>>(
        stream: CombineLatestStream.list([
          projectServices.reference.onValue,
          taskService.taskRef.onValue,
          userServices.databaseReference.onValue,
          PhaseServices().phaseRef.onValue,
        ]),
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.hasError) {
            return loader();
          }
          var event = snapshot.data![0] as DatabaseEvent;
          var value = event.snapshot.value as dynamic;
          projectMap = Map.from(value);
          allProjects = projectServices.getSearchedProjectList(
              projectMap, editingController.text.toString());
          var event1 = snapshot.data![1] as DatabaseEvent;
          var value1 = event1.snapshot.value as dynamic;
          taskMap = Map.from(value1);
          allTasks = taskService.getSearchTaskList(
              taskMap, editingController.text.toString());
          var event2 = snapshot.data![2] as DatabaseEvent;
          var value2 = event2.snapshot.value as dynamic;
          userMap = Map<String, dynamic>.from(value2);
          allPeople = userServices.getUserSearchedList(
              userMap, editingController.text.toString());
          var event3 = snapshot.data![3] as DatabaseEvent;
          var value3 = event3.snapshot.value as dynamic;
          Map phaseMap = Map<String, dynamic>.from(value3);

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
                    padding: const EdgeInsets.all(defaultPadding),
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
                                  Expanded(
                                    child: TextField(
                                      controller: editingController,
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontFamily: 'MontMed',
                                        fontWeight: FontWeight.normal,
                                        fontSize: 16,
                                      ),
                                      decoration: const InputDecoration(
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
                                        onPressed: () {
                                          setState(() {
                                            allProjects = projectServices
                                                .getSearchedProjectList(
                                                    projectMap,
                                                    editingController.text
                                                        .toString());
                                            allTasks =
                                                taskService.getSearchTaskList(
                                                    taskMap,
                                                    editingController.text
                                                        .toString());
                                            allPeople = userServices
                                                .getUserSearchedList(
                                                    userMap,
                                                    editingController.text
                                                        .toString());
                                          });
                                        },
                                        icon: const Icon(Icons.search),
                                      )),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 5),
                          const Divider(),
                          const SizedBox(height: 5),
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.indigo[50],
                              borderRadius: BorderRadius.circular(
                                  5.0), // Set the border radius
                            ),
                            child: ExpansionTile(
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.zero,
                              ),
                              initiallyExpanded: true,
                              title: const Row(
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
                                const Divider(),
                                Container(
                                  child: Column(
                                    children: allProjects.map((project) {
                                      return ListTile(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  ProjectDetailScreen(
                                                      userModel: userModel!,
                                                      projectModel: project,
                                                      userMap: userMap,
                                                      projectMap: projectMap,
                                                      phraseMap: phaseMap,
                                                      taskMap: taskMap),
                                            ),
                                          );
                                        },
                                        leading: const CircleAvatar(
                                            child: Icon(Icons.folder,
                                                color: Colors.orange)),
                                        title: Text(project.projectName,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                                fontFamily: 'MontMed',
                                                fontSize: 13)),
                                        subtitle: const Column(
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
                          const SizedBox(height: 10),
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.indigo[50],
                              borderRadius: BorderRadius.circular(
                                  5.0), // Set the border radius
                            ),
                            child: ExpansionTile(
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.zero,
                              ),
                              initiallyExpanded: true,
                              title: const Row(
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
                                const Divider(),
                                Container(
                                  child: Column(
                                    children: allTasks.map((task) {
                                      return ListTile(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  StreamBuilder<Object>(
                                                      stream: PhaseServices()
                                                          .phaseRef
                                                          .child(task.phraseId)
                                                          .onValue,
                                                      builder:
                                                          (context, snapshot) {
                                                        if (snapshot.hasError ||
                                                            !snapshot.hasData) {
                                                          return loader();
                                                        }
                                                        var event = snapshot
                                                                .data!
                                                            as DatabaseEvent;
                                                        var value = event
                                                            .snapshot
                                                            .value as dynamic;
                                                        PhaseModel phaseModel =
                                                            PhaseModel.fromMap(
                                                                Map.from(
                                                                    value));
                                                        return TaskDetailScreen(
                                                            taskModel: task,
                                                            userMap: userMap,
                                                            taskMap: taskMap,
                                                            commentMap:
                                                                commentMap,
                                                            userModel:
                                                                userModel!,
                                                            phaseModel:
                                                                phaseModel);
                                                      }),
                                            ),
                                          );
                                        },
                                        leading: const CircleAvatar(
                                            child: Icon(Icons.layers,
                                                color: Colors.blue)),
                                        title: Text('Task: ${task.taskName}',
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                                fontFamily: 'MontMed',
                                                fontSize: 13)),
                                        subtitle: const Column(
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
                          const SizedBox(height: 10),
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.indigo[50],
                              borderRadius: BorderRadius.circular(
                                  5.0), // Set the border radius
                            ),
                            child: ExpansionTile(
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.zero,
                              ),
                              initiallyExpanded: true,
                              title: const Row(
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
                                const Divider(),
                                Container(
                                  child: Column(
                                    children: allPeople.map((user) {
                                      return ListTile(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  profile_screen(
                                                      userModel: user),
                                            ),
                                          );
                                        },
                                        leading: avatar(userMap, user.userId),
                                        title: Text(
                                            'Name: ${user.userFirstName} ${user.userLastName}',
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                                fontFamily: 'MontMed',
                                                fontSize: 13)),
                                        subtitle: const Column(
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
