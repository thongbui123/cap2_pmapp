import 'package:capstone2_project_management_app/models/user_model.dart';
import 'package:capstone2_project_management_app/views/stats/stats.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class Dashboard_main_v1 extends StatefulWidget {
  const Dashboard_main_v1({Key? key}) : super(key: key);

  @override
  State<Dashboard_main_v1> createState() => _Dashboard_main_v1State();
}

class _Dashboard_main_v1State extends State<Dashboard_main_v1> {
  User? user;
  UserModel? currentUserModel;
  DatabaseReference? userRef;
  DatabaseReference? projectRef;
  List<Project> projects = [
    Project(name: 'Project A', numOfPeople: 5, color: Colors.blue),
    Project(name: 'Project B', numOfPeople: 3, color: Colors.green),
    Project(name: 'Project C', numOfPeople: 7, color: Colors.yellow),
    Project(name: 'Project D', numOfPeople: 7, color: Colors.redAccent),
  ];

  _getUserDetails() async {
    DatabaseEvent snapshot = await userRef!.once();

    currentUserModel = UserModel.fromMap(
        Map<String, dynamic>.from(snapshot.snapshot.value as dynamic));

    setState(() {});
  }

  @override
  void initState() {
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
                                  '14 In Progress',
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
                                '2 Ongoing',
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
                                'CAUTION',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'MontMed',
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 5),
                          Divider(),
                          Row(
                            children: <Widget>[
                              TextButton(
                                onPressed: () {
                                  // Add the action you want to perform when the TextButton is pressed
                                },
                                child: Text(
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
                          Divider(),
                          Row(
                            children: <Widget>[
                              TextButton(
                                onPressed: () {
                                  // Add the action you want to perform when the TextButton is pressed
                                },
                                child: Text(
                                  '2 Projects Overdue',
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
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Container(
                  height: 200,
                  color: Color(0xFFD9D9D9),
                  child: Dashboard_chart(),
                ),
              ),
              Container(
                width: 150,
                height: 200,
                color: Color(0xFFD9D9D9),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 45),
                    Text(
                      'THIS WEEK TASKS',
                      style: TextStyle(
                        fontFamily: 'MontMed',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 15),
                    Row(
                      children: [
                        Container(
                          width: 14,
                          height: 14,
                          color: Colors.redAccent,
                        ),
                        SizedBox(width: 10),
                        Text(
                          'Overdue',
                          style: TextStyle(fontFamily: 'MontMed', fontSize: 12),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Container(
                          width: 14,
                          height: 14,
                          color: Colors.blueAccent,
                        ),
                        SizedBox(width: 10),
                        Text(
                          'In Progress',
                          style: TextStyle(fontFamily: 'MontMed', fontSize: 12),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Container(
                          width: 14,
                          height: 14,
                          color: Colors.green,
                        ),
                        SizedBox(width: 10),
                        Text(
                          'Done',
                          style: TextStyle(fontFamily: 'MontMed', fontSize: 12),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          Container(
            height: 340,
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
