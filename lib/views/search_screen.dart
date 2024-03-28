import 'package:capstone2_project_management_app/models/user_model.dart';
import 'package:capstone2_project_management_app/views/stats/stats.dart';
import 'package:capstone2_project_management_app/views/subs/db_side_menu.dart';
import 'package:flutter/material.dart';

class search_screen extends StatefulWidget {
  final UserModel? userModel;
  const search_screen({Key? key, this.userModel}) : super(key: key);

  @override
  State<search_screen> createState() => _search_screenState();
}

List<String> allProjects = [
  'Project A',
  'Project B',
  'Project C',
];

List<String> allTasks = [
  'Task A01',
  'Task B02',
  'Task B01',
];

List<String> allPeople = [
  'Jackie',
  'Vincent',
];

bool _customTileExpanded0 = true;
bool _customTileExpanded1 = true;
bool _customTileExpanded2 = true;

class _search_screenState extends State<search_screen> {
  late UserModel? userModel;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
                    Row(
                      children: [
                        Text(
                          'SEARCH RESULT',
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
                                          fontFamily: 'MontMed', fontSize: 13)),
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
                                          fontFamily: 'MontMed', fontSize: 13)),
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
                                          fontFamily: 'MontMed', fontSize: 13)),
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
  }
}
