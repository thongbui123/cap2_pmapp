import 'package:capstone2_project_management_app/models/project_model.dart';
import 'package:capstone2_project_management_app/models/task_model.dart';
import 'package:capstone2_project_management_app/models/user_model.dart';
import 'package:capstone2_project_management_app/services/project_services.dart';
import 'package:capstone2_project_management_app/services/task_services.dart';
import 'package:capstone2_project_management_app/views/list_of_project_screen.dart';
import 'package:capstone2_project_management_app/views/list_of_tasks_screen.dart';
import 'package:capstone2_project_management_app/views/search_screen.dart';
import 'package:capstone2_project_management_app/views/stats/stats.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class DashboardMainV2 extends StatefulWidget {
  final UserModel? userModel;
  final Map<dynamic, dynamic> projectMap;
  final Map<dynamic, dynamic> taskMap;
  const DashboardMainV2(
      {super.key,
      required this.userModel,
      required this.projectMap,
      required this.taskMap});

  @override
  State<DashboardMainV2> createState() => _DashboardMainV2State();
}

class _DashboardMainV2State extends State<DashboardMainV2> {
  User? user;
  UserModel? currentUserModel;
  DatabaseReference? userRef;
  ProjectServices projectServices = ProjectServices();
  late Map projectMap;
  late Map taskMap;
  List<ProjectModel> joinedProjects = [];
  List<TaskModel> overduoTaskList = [];
  List<TaskModel> joinedTaskList = [];
  bool _customTileExpanded0 = true;
  bool _customTileExpanded1 = true;
  TextEditingController textEditingController = TextEditingController();
  List<Project> projects = [
    Project(name: 'Project A', numOfPeople: 5, color: Colors.blue),
    Project(name: 'Project B', numOfPeople: 3, color: Colors.green),
  ];

  List<String> allTasks = [
    'Task A01',
    'Task B02',
    'Task B01',
  ];

  @override
  void initState() {
    super.initState();
    currentUserModel = widget.userModel;
    projectMap = widget.projectMap;
    taskMap = widget.taskMap;
    joinedProjects =
        ProjectServices().getJoinedProjectList(projectMap, currentUserModel!);
    overduoTaskList =
        TaskService().getOverdouTaskList(taskMap, currentUserModel!.userId);
    joinedTaskList = TaskService()
        .getJoinedTaskListFromUser(taskMap, currentUserModel!.userId);
  }

  @override
  Widget build(BuildContext context) {
    return currentUserModel == null
        ? const Center(child: CircularProgressIndicator())
        : SafeArea(
            child: SingleChildScrollView(
            padding: const EdgeInsets.all(defaultPadding),
            child: Column(
              children: [
                Row(
                  children: [
                    Text(
                      'WELCOME BACK, ${currentUserModel?.userFirstName.toUpperCase()}',
                      style: const TextStyle(
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
                            controller: textEditingController,
                            style: const TextStyle(
                              color: Colors.black,
                              fontFamily: 'MontMed',
                              fontWeight: FontWeight.normal,
                              fontSize: 16,
                            ),
                            decoration: const InputDecoration(
                              enabledBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Color(0xFFD9D9D9)),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.black54),
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
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => SearchScreen(
                                      userModel: currentUserModel!,
                                      output: textEditingController.text.trim(),
                                    ),
                                  ),
                                );
                              },
                              icon: const Icon(Icons.search),
                            )),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: Container(
                          decoration: BoxDecoration(
                            color: Colors.indigo[50],
                            borderRadius: BorderRadius.circular(
                                5.0), // Set the border radius
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(15),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                const SizedBox(height: 5),
                                Row(
                                  children: <Widget>[
                                    IconButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                ListOfTaskScreen(
                                                    userModel:
                                                        currentUserModel!,
                                                    projectMap: projectMap,
                                                    taskMap: taskMap),
                                          ),
                                        );
                                      },
                                      icon: const Icon(
                                        Icons.layers,
                                        color: Colors.blueAccent,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 5),
                                Row(
                                  children: <Widget>[
                                    Container(
                                      child: const Text(
                                        'TASKS',
                                        style: TextStyle(
                                            fontFamily: 'MontMed',
                                            fontWeight: FontWeight.w900),
                                      ),
                                    ),
                                  ],
                                ),
                                const Divider(),
                                Row(
                                  children: <Widget>[
                                    Text(
                                      '${TaskService().getJoinedTaskNumber(taskMap, currentUserModel!.userId)} Task in Progress',
                                      style: const TextStyle(
                                          fontSize: 12, fontFamily: 'MontMed'),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          )),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.deepOrange[50],
                          borderRadius: BorderRadius.circular(
                              5.0), // Set the border radius
                        ),
                        //height: 125,
                        child: Padding(
                          padding: const EdgeInsets.all(15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              const SizedBox(height: 5),
                              Row(
                                children: <Widget>[
                                  IconButton(
                                    onPressed: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) {
                                            return ListOfProjectScreen(
                                              currentUserModel:
                                                  currentUserModel,
                                              projectMap: projectMap,
                                              taskMap: taskMap,
                                            );
                                          },
                                        ),
                                      );
                                    },
                                    icon: const Icon(
                                      Icons.folder,
                                      color: Colors.deepOrangeAccent,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 5),
                              Row(
                                children: <Widget>[
                                  Container(
                                    child: const Text(
                                      'PROJECTS',
                                      style: TextStyle(
                                          fontFamily: 'MontMed',
                                          fontWeight: FontWeight.w900),
                                    ),
                                  ),
                                ],
                              ),
                              const Divider(),
                              Row(
                                children: <Widget>[
                                  Text(
                                    '${projectServices.getJoinedProjectNumber(projectMap, currentUserModel!.userId)} Project(s) Joined',
                                    style: const TextStyle(
                                        fontSize: 12, fontFamily: 'MontMed'),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.indigo[50],
                    borderRadius:
                        BorderRadius.circular(5.0), // Set the border radius
                  ),
                  child: ExpansionTile(
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero,
                    ),
                    initiallyExpanded: true,
                    title: Row(
                      children: [
                        const Icon(
                          Icons.sim_card_alert_outlined,
                          color: Colors.red,
                        ),
                        const SizedBox(width: 10),
                        Text(
                            'Overdue Tasks (${TaskService().getOverdouTaskNumber(taskMap, currentUserModel!.userId)})',
                            style: const TextStyle(
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
                          children: overduoTaskList.map((task) {
                            return ListTile(
                              leading: const CircleAvatar(
                                  child:
                                      Icon(Icons.layers, color: Colors.blue)),
                              title: Text('Task Name: ${task.taskName}',
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                      fontFamily: 'MontMed', fontSize: 13)),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.folder_open_sharp,
                                        size: 13,
                                      ),
                                      const SizedBox(width: 5),
                                      Expanded(
                                        child: Text(
                                            'Project: ${projectServices.getProjectNameFromId(projectMap, task.projectId)}',
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                                fontFamily: 'MontMed',
                                                fontSize: 12)),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                              trailing: const Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('Priority: ',
                                      style: TextStyle(
                                          fontFamily: 'MontMed', fontSize: 12)),
                                  Text('HIGH',
                                      style: TextStyle(
                                          fontFamily: 'MontMed',
                                          fontSize: 13,
                                          color: Colors.red))
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
                    borderRadius:
                        BorderRadius.circular(5.0), // Set the border radius
                  ),
                  child: ExpansionTile(
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero,
                    ),
                    initiallyExpanded: true,
                    title: Container(
                      child: Row(
                        children: [
                          const Icon(
                            Icons.task_outlined,
                            color: Colors.blue,
                          ),
                          const SizedBox(width: 10),
                          Text('Recent Tasks (${joinedTaskList.length})',
                              style: const TextStyle(
                                  fontFamily: 'MontMed', fontSize: 13)),
                        ],
                      ),
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
                          children: joinedTaskList.map((task) {
                            return ListTile(
                              leading: const CircleAvatar(
                                  child:
                                      Icon(Icons.layers, color: Colors.blue)),
                              title: Text('Task Name: ${task.taskName}',
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                      fontFamily: 'MontMed', fontSize: 13)),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.folder_open_sharp,
                                        size: 13,
                                      ),
                                      const SizedBox(width: 5),
                                      Expanded(
                                        child: Text(
                                            'Project: ${projectServices.getProjectNameFromId(projectMap, task.projectId)}',
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                                fontFamily: 'MontMed',
                                                fontSize: 12)),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                              trailing: const Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('Priority: ',
                                      style: TextStyle(
                                          fontFamily: 'MontMed', fontSize: 12)),
                                  Text('HIGH',
                                      style: TextStyle(
                                          fontFamily: 'MontMed',
                                          fontSize: 13,
                                          color: Colors.red))
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
                  color: Colors.deepOrange[50],
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.circular(5.0), // Set the border radius
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 15),
                        const Row(
                          children: [
                            SizedBox(width: 20),
                            Text('RECENT PROJECTS',
                                style: TextStyle(
                                    fontFamily: 'MontMed',
                                    fontWeight: FontWeight.bold))
                          ],
                        ),
                        const SizedBox(height: 5),
                        const Padding(
                          padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                          child: Divider(),
                        ),
                        Column(
                          children: joinedProjects.map((project) {
                            return ListTile(
                              leading: const CircleAvatar(
                                backgroundColor: Colors.black12,
                                child: Icon(Icons.folder, color: Colors.orange),
                              ),
                              title: Text(project.projectName,
                                  style: const TextStyle(
                                      fontFamily: 'MontMed', fontSize: 13)),
                              subtitle: Text(
                                '${project.projectMembers.length.toString()} Participants',
                                style: const TextStyle(
                                    fontFamily: 'MontMed', fontSize: 12),
                              ),
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 15),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ));
  }
}

class Dashboard_chart extends StatefulWidget {
  const Dashboard_chart({Key? key}) : super(key: key);

  @override
  State<Dashboard_chart> createState() => _Dashboard_chartState();
}

class _Dashboard_chartState extends State<Dashboard_chart> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Stack(
        children: [
          PieChart(PieChartData(
            sectionsSpace: 0,
            centerSpaceRadius: 30,
            sections: [
              PieChartSectionData(
                  value: 2, color: Colors.green, showTitle: true, radius: 34),
              PieChartSectionData(
                  value: 5,
                  color: Colors.blueAccent,
                  showTitle: true,
                  radius: 34),
              PieChartSectionData(
                  value: 3,
                  color: Colors.redAccent,
                  showTitle: true,
                  radius: 34),
            ],
          )),
        ],
      ),
    );
  }
}

class Project {
  final String name;
  final int numOfPeople;
  final Color color;

  Project({
    required this.name,
    required this.numOfPeople,
    required this.color,
  });
}

class Task {
  final String name;
  final String description;
  final Color level;
  final String priority;
  final DateTime date;
  final String currentState;

  Task(
      {required this.name,
      required this.description,
      required this.level,
      required this.priority,
      required this.date,
      required this.currentState});
}

String calculateDeadlineStatus(DateTime deadline, DateTime currentDate) {
  Duration difference = deadline.difference(currentDate);

  if (difference.isNegative) {
    return '${-difference.inDays} days overdue';
  } else {
    return '${difference.inDays} days left';
  }
}
