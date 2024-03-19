import 'package:capstone2_project_management_app/models/user_model.dart';
import 'package:capstone2_project_management_app/services/project_services.dart';
import 'package:capstone2_project_management_app/views/list_of_project_screen.dart';
import 'package:capstone2_project_management_app/views/list_of_tasks_screen.dart';
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

  bool _customTileExpanded0 = true;
  bool _customTileExpanded1 = true;

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
  }

  @override
  Widget build(BuildContext context) {
    return currentUserModel == null
        ? const Center(child: CircularProgressIndicator())
        : SafeArea(
            child: SingleChildScrollView(
            padding: EdgeInsets.all(defaultPadding),
            child: Column(
              children: [
                Row(
                  children: [
                    Text(
                      'WELCOME BACK, ${currentUserModel?.userFirstName.toUpperCase()}',
                      style: TextStyle(
                        fontFamily: 'MontMed',
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                Divider(),
                SizedBox(height: 10),
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
                              onPressed: () {},
                              icon: Icon(Icons.search),
                            )),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 10),
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
                            padding: EdgeInsets.all(15),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                SizedBox(height: 5),
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
                                      icon: Icon(
                                        Icons.layers,
                                        color: Colors.blueAccent,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 5),
                                Row(
                                  children: <Widget>[
                                    Container(
                                      child: Text(
                                        'TASKS',
                                        style: TextStyle(
                                            fontFamily: 'MontMed',
                                            fontWeight: FontWeight.w900),
                                      ),
                                    ),
                                  ],
                                ),
                                Divider(),
                                Row(
                                  children: <Widget>[
                                    Text(
                                      '4 Task in Progress',
                                      style: TextStyle(
                                          fontSize: 12, fontFamily: 'MontMed'),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          )),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.deepOrange[50],
                          borderRadius: BorderRadius.circular(
                              5.0), // Set the border radius
                        ),
                        //height: 125,
                        child: Padding(
                          padding: EdgeInsets.all(15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              SizedBox(height: 5),
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
                                    icon: Icon(
                                      Icons.folder,
                                      color: Colors.deepOrangeAccent,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 5),
                              Row(
                                children: <Widget>[
                                  Container(
                                    child: Text(
                                      'PROJECTS',
                                      style: TextStyle(
                                          fontFamily: 'MontMed',
                                          fontWeight: FontWeight.w900),
                                    ),
                                  ),
                                ],
                              ),
                              Divider(),
                              Row(
                                children: <Widget>[
                                  Text(
                                    '${projectServices.getJoinedProjectNumber(projectMap, currentUserModel!.userId)} Project(s) Joined',
                                    style: TextStyle(
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
                SizedBox(height: 10),
                Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.indigo[50],
                    borderRadius:
                        BorderRadius.circular(5.0), // Set the border radius
                  ),
                  child: ExpansionTile(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero,
                    ),
                    initiallyExpanded: true,
                    title: Row(
                      children: [
                        Icon(
                          Icons.sim_card_alert_outlined,
                          color: Colors.red,
                        ),
                        SizedBox(width: 10),
                        Text('Overdue Tasks (3)',
                            style:
                                TextStyle(fontFamily: 'MontMed', fontSize: 13)),
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
                          children: allTasks.map((project) {
                            return ListTile(
                              leading: const CircleAvatar(
                                  child:
                                      Icon(Icons.layers, color: Colors.blue)),
                              title: Text('Task Name: ${project}',
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontFamily: 'MontMed', fontSize: 13)),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
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
                              trailing: Column(
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
                SizedBox(height: 10),
                Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.indigo[50],
                    borderRadius:
                        BorderRadius.circular(5.0), // Set the border radius
                  ),
                  child: ExpansionTile(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero,
                    ),
                    initiallyExpanded: true,
                    title: Container(
                      child: Row(
                        children: [
                          Icon(
                            Icons.task_outlined,
                            color: Colors.blue,
                          ),
                          SizedBox(width: 10),
                          Text('Recent Tasks (3)',
                              style: TextStyle(
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
                      Divider(),
                      Container(
                        child: Column(
                          children: allTasks.map((project) {
                            return ListTile(
                              leading: const CircleAvatar(
                                  child:
                                      Icon(Icons.layers, color: Colors.blue)),
                              title: Text('Task Name: ${project}',
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontFamily: 'MontMed', fontSize: 13)),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
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
                              trailing: Column(
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
                SizedBox(height: 10),
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
                        SizedBox(height: 15),
                        Row(
                          children: [
                            SizedBox(width: 20),
                            Text('RECENT PROJECTS',
                                style: TextStyle(
                                    fontFamily: 'MontMed',
                                    fontWeight: FontWeight.bold))
                          ],
                        ),
                        SizedBox(height: 5),
                        Padding(
                          padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                          child: Divider(),
                        ),
                        Column(
                          children: projects.map((project) {
                            return ListTile(
                              leading: const CircleAvatar(
                                backgroundColor: Colors.black12,
                                child: Icon(Icons.folder, color: Colors.orange),
                              ),
                              title: Text(project.name,
                                  style: TextStyle(
                                      fontFamily: 'MontMed', fontSize: 13)),
                              subtitle: Text(
                                '2 Participants',
                                style: const TextStyle(
                                    fontFamily: 'MontMed', fontSize: 12),
                              ),
                            );
                          }).toList(),
                        ),
                        SizedBox(height: 15),
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
