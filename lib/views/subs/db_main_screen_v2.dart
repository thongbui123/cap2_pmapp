import 'dart:ui';

import 'package:capstone2_project_management_app/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:capstone2_project_management_app/views/stats/stats.dart';
import 'package:intl/intl.dart';

class Dashboard_main_v2 extends StatefulWidget {
  const Dashboard_main_v2({Key? key}) : super(key: key);

  @override
  State<Dashboard_main_v2> createState() => _Dashboard_main_v2State();
}

class _Dashboard_main_v2State extends State<Dashboard_main_v2> {
  User? user;
  UserModel? currentUserModel;
  DatabaseReference? userRef;

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
  Widget build(BuildContext context) {
    return SafeArea(
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
                  Expanded(
                    child: TextField(
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'MontMed',
                        fontWeight: FontWeight.normal,
                        fontSize: 16,
                      ),
                      decoration: InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFFD9D9D9)),
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
                  SizedBox(width: 10),
                  Container(
                    height: 50,
                    child: ElevatedButton(
                        onPressed: () {}, child: Icon(Icons.search_rounded)),
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
                    //height: 125,
                    color: Color(0xFFD9D9D9),
                    child: Padding(
                      padding: EdgeInsets.all(15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(height: 5),
                          Row(
                            children: <Widget>[
                              Container(
                                child: Icon(
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
                              TextButton(
                                onPressed: () {},
                                child: Text(
                                  '2 This Week',
                                  style: TextStyle(
                                    fontFamily: 'MontMed',
                                    fontWeight: FontWeight.normal,
                                    color: Colors.black,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    )),
              ),
              SizedBox(width: 10),
              Expanded(
                child: Container(
                  //height: 125,
                  color: Color(0xFFD9D9D9),
                  child: Padding(
                    padding: EdgeInsets.all(15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(height: 5),
                        Row(
                          children: <Widget>[
                            Container(
                              child: Icon(
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
                            TextButton(
                              onPressed: () {},
                              child: Text(
                                '2 Joined',
                                style: TextStyle(
                                  fontFamily: 'MontMed',
                                  fontWeight: FontWeight.normal,
                                  color: Colors.black,
                                  fontSize: 12,
                                ),
                              ),
                            ),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: Container(
                    height: 60,
                    color: Color(0xFFD9D9D9),
                    child: Padding(
                      padding: EdgeInsets.all(15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(height: 5),
                          Row(
                            children: <Widget>[
                              Container(
                                child: Icon(
                                  Icons.gpp_maybe,
                                  color: Colors.red,
                                ),
                              ),
                              SizedBox(width: 10),
                              Text(
                                'CAUTION: You have 2 overdue tasks',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'MontMed',
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    )),
              ),
            ],
          ),
          SizedBox(height: 10),
          Container(
            height: 175 * tasks.length.toDouble(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: ListView.separated(
                    itemCount: tasks.length,
                    itemBuilder: (BuildContext context, int index) {
                      final task = tasks[index];
                      String message =
                          DateFormat('yyyy-MM-dd').format(task.date);
                      message += ' ' +
                          '(' +
                          calculateDeadlineStatus(task.date, DateTime.now()) +
                          ')';
                      return Container(
                        padding: EdgeInsets.all(20),
                        color: Color(0xFFD9D9D9),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextButton(
                              onPressed: () {},
                              child: Text(
                                task.name,
                                style: TextStyle(
                                  fontFamily: 'MontMed',
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  fontSize: 14,
                                ),
                              ),
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
                                    width: 20, height: 20, color: task.level),
                                SizedBox(width: 10),
                                Text(
                                  'PRIORITY: ${task.priority}',
                                  style: TextStyle(
                                      fontFamily: 'MontMed',
                                      color: task.level,
                                      fontWeight: FontWeight.bold),
                                )
                              ],
                            ),
                            SizedBox(height: 10),
                            Text(
                              message,
                              style: TextStyle(
                                  fontFamily: 'MontMed',
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold),
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
          Container(
            height: 255,
            decoration: BoxDecoration(
              color: Color(0xFFD9D9D9),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(20, 20, 8, 0),
                  child: Row(
                    children: [
                      Icon(
                        Icons.folder,
                        size: 20,
                      ),
                      SizedBox(
                          width:
                              8), // Add a small space between the icon and text
                      Text(
                        'PROJECTS',
                        style: TextStyle(
                          fontSize: 15,
                          fontFamily: 'MontMed',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                Divider(),
                SizedBox(height: 10),
                Expanded(
                  child: ListView.builder(
                    itemCount: projects.length,
                    itemBuilder: (context, index) {
                      final project = projects[index];
                      return ListTile(
                        leading: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: project.color,
                          ),
                          child: Icon(
                            Icons.list,
                            color: Colors.white,
                          ),
                        ),
                        title: Text(
                          project.name,
                          style: TextStyle(
                            fontSize: 14,
                            fontFamily: 'MontMed',
                            color: Colors.black,
                          ),
                        ),
                        subtitle: Text(
                          '${project.numOfPeople} Members',
                          style: TextStyle(
                            fontSize: 12,
                            fontFamily: 'Consolas',
                            color: Colors.black54,
                          ),
                        ),
                        onTap: () {
                          // Handle project item tap
                        },
                      );
                    },
                  ),
                ),
              ],
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
