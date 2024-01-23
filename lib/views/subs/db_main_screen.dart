import 'package:capstone2_project_management_app/models/project_model.dart';
import 'package:capstone2_project_management_app/models/user_model.dart';
import 'package:capstone2_project_management_app/views/list_of_project_screen.dart';
import 'package:capstone2_project_management_app/views/list_of_tasks_screen.dart';
import 'package:capstone2_project_management_app/views/stats/stats.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DashboardMainV1 extends StatefulWidget {
  const DashboardMainV1({Key? key}) : super(key: key);

  @override
  State<DashboardMainV1> createState() => _DashboardMainV1State();
}

class _DashboardMainV1State extends State<DashboardMainV1> {
  User? user;
  UserModel? currentUserModel;
  DatabaseReference? userRef;
  DatabaseReference? projectRef;
  Map<String, dynamic> projectMap = {};
  List<ProjectModel> projects = [];
  int count_overduo = 0;
  _getUserDetails() async {
    DatabaseEvent event1 = await userRef!.once();
    currentUserModel = UserModel.fromMap(
        Map<String, dynamic>.from(event1.snapshot.value as dynamic));
    _getProjectDetails();
    setState(() {});
  }

  _getProjectDetails() async {
    projectRef?.onValue.listen((event) {
      setState(() {
        projectMap = Map.from(event.snapshot.value as dynamic);
        for (var project in projectMap.values) {
          ProjectModel projectModel =
              ProjectModel.fromMap(Map<String, dynamic>.from(project));
          if (projectModel.leaderId == user?.uid) {
            projects.add(projectModel);
          }
          if (projectModel.startDate != "" && projectModel.endDate != "") {
            DateFormat format = DateFormat('yyyy-MM-dd');
            DateTime getEndDate = format.parse(projectModel.endDate);
            if (DateTime.now().isAfter(getEndDate)) {
              count_overduo++;
            }
          }
        }
      });
    });
  }

  @override
  initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      userRef = FirebaseDatabase.instance.ref().child('users').child(user!.uid);
      projectRef = FirebaseDatabase.instance.ref().child('projects');
    }
    _getUserDetails();
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
                              child: const Icon(Icons.search_rounded)),
                        ),
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
                            border: Border.all(
                              color: Colors.grey,
                              width: 1.0,
                            ),
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
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) {
                                          return const listOfTasks();
                                        }));
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
                                const Row(
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
                    const SizedBox(width: 10),
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
                                          MaterialPageRoute(builder: (context) {
                                        return const listOfProjects();
                                      }));
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
                                    '${projects.length.toString()} on going',
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
                            padding: const EdgeInsets.all(15),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                const SizedBox(height: 5),
                                Row(
                                  children: <Widget>[
                                    Container(
                                      child: const Icon(
                                        Icons.mood_bad,
                                        color: Colors.red,
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    const Text(
                                      'CAUTION',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'MontMed',
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 5),
                                const Divider(),
                                Row(
                                  children: <Widget>[
                                    TextButton(
                                      onPressed: () {
                                        // Add the action you want to perform when the TextButton is pressed
                                      },
                                      child: const Text(
                                        '12 Tasks Overdue',
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
                                const Divider(),
                                Row(
                                  children: <Widget>[
                                    TextButton(
                                      onPressed: () {
                                        // Add the action you want to perform when the TextButton is pressed
                                      },
                                      child: Text(
                                        '$count_overduo Project(s) Overdue',
                                        style: const TextStyle(
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
                  ],
                ),
                const SizedBox(height: 10),
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
                            padding: const EdgeInsets.all(15),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                const SizedBox(height: 5),
                                Row(
                                  children: <Widget>[
                                    Container(
                                      child: const Icon(
                                        Icons.mood,
                                        color: Colors.green,
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    const Text(
                                      'FINALIZED',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'MontMed',
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 5),
                                const Divider(),
                                Row(
                                  children: <Widget>[
                                    TextButton(
                                      onPressed: () {
                                        // Add the action you want to perform when the TextButton is pressed
                                      },
                                      child: const Text(
                                        '12 Tasks Finalized',
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
                                const Divider(),
                                Row(
                                  children: <Widget>[
                                    TextButton(
                                      onPressed: () {
                                        // Add the action you want to perform when the TextButton is pressed
                                      },
                                      child: const Text(
                                        '2 Projects Finalized',
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
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
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
                        height: 200,
                        child: const Dashboard_chart(),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      width: 150,
                      height: 200,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 45),
                          const Text(
                            'THIS WEEK TASKS',
                            style: TextStyle(
                              fontFamily: 'MontMed',
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 15),
                          Row(
                            children: [
                              Container(
                                width: 14,
                                height: 14,
                                color: Colors.redAccent,
                              ),
                              const SizedBox(width: 10),
                              const Text(
                                'Overdue',
                                style: TextStyle(
                                    fontFamily: 'MontMed', fontSize: 12),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Container(
                                width: 14,
                                height: 14,
                                color: Colors.blueAccent,
                              ),
                              const SizedBox(width: 10),
                              const Text(
                                'In Progress',
                                style: TextStyle(
                                    fontFamily: 'MontMed', fontSize: 12),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Container(
                                width: 14,
                                height: 14,
                                color: Colors.green,
                              ),
                              const SizedBox(width: 10),
                              const Text(
                                'Done',
                                style: TextStyle(
                                    fontFamily: 'MontMed', fontSize: 12),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
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
                          children: projects.map((project) {
                            return ListTile(
                              leading: const CircleAvatar(
                                backgroundColor: Colors.black12,
                                child: Icon(
                                  Icons.folder,
                                  color: Colors.orange,
                                ),
                              ),
                              title: Text(project.projectName,
                                  style: const TextStyle(
                                      fontFamily: 'MontMed', fontSize: 13)),
                              subtitle: Text(
                                '${project.projectMembers.length.toString()} participant(s)',
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

  DateTime? stringToDateTime(
    String dateString,
  ) {
    try {
      String format = "yyyy-MM-dd";
      return DateFormat(format).parse(dateString);
    } catch (e) {
      print("Error parsing date: $e");
      return null; // or throw an exception, depending on your needs
    }
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
            centerSpaceRadius: 10,
            sections: [
              PieChartSectionData(
                  value: 2, color: Colors.green, showTitle: true, radius: 35),
              PieChartSectionData(
                  value: 5,
                  color: Colors.blueAccent,
                  showTitle: true,
                  radius: 30),
              PieChartSectionData(
                  value: 3,
                  color: Colors.redAccent,
                  showTitle: true,
                  radius: 40),
            ],
          )),
        ],
      ),
    );
  }
}
