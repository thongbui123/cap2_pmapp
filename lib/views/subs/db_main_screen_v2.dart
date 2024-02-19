import 'package:capstone2_project_management_app/models/user_model.dart';
import 'package:capstone2_project_management_app/services/project_services.dart';
import 'package:capstone2_project_management_app/views/list_of_project_screen.dart';
import 'package:capstone2_project_management_app/views/stats/stats.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DashboardMainV2 extends StatefulWidget {
  final UserModel? userModel;
  final Map<dynamic, dynamic> projectMap;

  const DashboardMainV2(
      {super.key, required this.userModel, required this.projectMap});

  @override
  State<DashboardMainV2> createState() => _DashboardMainV2State();
}

class _DashboardMainV2State extends State<DashboardMainV2> {
  User? user;
  UserModel? currentUserModel;
  DatabaseReference? userRef;
  ProjectServices projectServices = ProjectServices();
  late Map projectMap;
  List<Project> projects = [
    Project(name: 'Project A', numOfPeople: 5, color: Colors.blue),
    Project(name: 'Project B', numOfPeople: 3, color: Colors.green),
  ];
  List<Task> tasks = [
    Task(
        name: 'Users Story',
        description:
            'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Fusce id velit vel mauris feugiat convallis et ac lorem. Morbi id dignissim neque, id sollicitudin neque. Aliquam tincidunt neque lectus, sed elementum sem venenatis at. Nam hendrerit ligula quis venenatis maximus. Suspendisse potenti.',
        level: Colors.red,
        priority: 'HIGH',
        date: DateTime(2023, 10, 2),
        currentState: 'Overdue'),
    Task(
        name: 'Collects Requirements',
        description:
            'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Fusce id velit vel mauris feugiat convallis et ac lorem. Morbi id dignissim neque, id sollicitudin neque. Aliquam tincidunt neque lectus, sed elementum sem venenatis at. Nam hendrerit ligula quis venenatis maximus. Suspendisse potenti.',
        level: Colors.blue,
        priority: 'LOW',
        date: DateTime(2023, 10, 5),
        currentState: 'Overdue'),
  ];

  @override
  void initState() {
    super.initState();
    currentUserModel = widget.userModel;
    projectMap = widget.projectMap;
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
                          child: ElevatedButton(
                              onPressed: () {},
                              child: Icon(Icons.search_rounded)),
                        ),
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
                            border: Border.all(
                              color: Colors.grey,
                              width: 1.0,
                            ),
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
                                      onPressed: () {},
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
                          border: Border.all(
                            color: Colors.grey,
                            width: 1.0,
                          ),
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
                                            return listOfProjects(
                                              currentUserModel:
                                                  currentUserModel,
                                              projectMap: projectMap,
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
                SizedBox(height: 5),
                Divider(),
                SizedBox(height: 5),
                Row(children: [
                  Icon(
                    Icons.sentiment_dissatisfied,
                    color: Colors.redAccent,
                  ),
                  SizedBox(width: 10),
                  Text(
                    'OVERDUE TASKS (2)',
                    style: TextStyle(fontFamily: 'MontMed'),
                  )
                ]),
                SizedBox(height: 10),
                Container(
                  height: 220 * tasks.length.toDouble(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: ListView.separated(
                          shrinkWrap: true,
                          itemCount: tasks.length,
                          itemBuilder: (BuildContext context, int index) {
                            final task = tasks[index];
                            String message =
                                DateFormat('yyyy-MM-dd').format(task.date);
                            message += ' (' +
                                calculateDeadlineStatus(
                                    task.date, DateTime.now()) +
                                ')';
                            return Container(
                              padding: EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.grey,
                                  width: 1.0,
                                ),
                                borderRadius: BorderRadius.circular(
                                    5.0), // Set the border radius
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ListTile(
                                    leading: CircleAvatar(
                                      child: Icon(
                                        Icons.layers,
                                        color: Colors.black,
                                      ),
                                    ),
                                    title: Text('Task name: ',
                                        style: TextStyle(
                                            fontFamily: 'MontMed',
                                            fontSize: 12,
                                            color: Colors.black54)),
                                    subtitle: Text(task.name,
                                        style: TextStyle(
                                            fontFamily: 'MontMed',
                                            fontSize: 14)),
                                  ),
                                  Divider(),
                                  Text(
                                    task.description.length > 50
                                        ? '${task.description.substring(0, 50)}...'
                                        : task.description,
                                    style: TextStyle(
                                        fontFamily: 'MontMed', fontSize: 12),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                  ),
                                  SizedBox(height: 10),
                                  Row(
                                    children: [
                                      Container(
                                          width: 15,
                                          height: 15,
                                          color: task.level),
                                      SizedBox(width: 10),
                                      Text('${task.priority} PRIORITY',
                                          style: TextStyle(
                                            fontFamily: 'MontMed',
                                            color: task.level,
                                          ))
                                    ],
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                    'Deadline: ${message}',
                                    style: TextStyle(
                                        fontFamily: 'MontMed', fontSize: 12),
                                  ),
                                ],
                              ),
                            );
                          },
                          separatorBuilder: (BuildContext context, int index) =>
                              const SizedBox(height: 10),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                Row(children: [
                  Icon(
                    Icons.sentiment_neutral,
                    color: Colors.orange,
                  ),
                  SizedBox(width: 10),
                  Text('RECENT TASKS (2)',
                      style: TextStyle(fontFamily: 'MontMed'))
                ]),
                SizedBox(height: 10),
                Container(
                  height: 215 * tasks.length.toDouble(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: ListView.separated(
                          shrinkWrap: true,
                          itemCount: tasks.length,
                          itemBuilder: (BuildContext context, int index) {
                            final task = tasks[index];
                            String message =
                                DateFormat('yyyy-MM-dd').format(task.date);
                            message += ' (' +
                                calculateDeadlineStatus(
                                    task.date, DateTime.now()) +
                                ')';
                            return Container(
                              padding: EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.grey,
                                  width: 1.0,
                                ),
                                borderRadius: BorderRadius.circular(
                                    5.0), // Set the border radius
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ListTile(
                                    leading: CircleAvatar(
                                      child: Icon(
                                        Icons.layers,
                                        color: Colors.black,
                                      ),
                                    ),
                                    title: Text('Task name: ',
                                        style: TextStyle(
                                            fontFamily: 'MontMed',
                                            fontSize: 12,
                                            color: Colors.black54)),
                                    subtitle: Text(task.name,
                                        style: TextStyle(
                                            fontFamily: 'MontMed',
                                            fontSize: 14)),
                                  ),
                                  Divider(),
                                  Text(
                                    task.description.length > 50
                                        ? '${task.description.substring(0, 50)}...'
                                        : task.description,
                                    style: TextStyle(
                                        fontFamily: 'MontMed', fontSize: 12),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                  ),
                                  SizedBox(height: 10),
                                  Row(
                                    children: [
                                      Container(
                                          width: 15,
                                          height: 15,
                                          color: task.level),
                                      SizedBox(width: 10),
                                      Text('${task.priority} PRIORITY',
                                          style: TextStyle(
                                            fontFamily: 'MontMed',
                                            color: task.level,
                                          ))
                                    ],
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                    'Deadline: ${message}',
                                    style: TextStyle(
                                        fontFamily: 'MontMed', fontSize: 12),
                                  ),
                                ],
                              ),
                            );
                          },
                          separatorBuilder: (BuildContext context, int index) =>
                              const SizedBox(height: 10),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 5),
                Container(
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey,
                        width: 1.0,
                      ),
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
