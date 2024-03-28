import 'package:capstone2_project_management_app/views/stats/stats.dart';
import 'package:capstone2_project_management_app/views/subs/db_side_menu.dart';
import 'package:flutter/material.dart';
import 'dart:io';

class employee_screen extends StatefulWidget {
  const employee_screen({Key? key}) : super(key: key);

  @override
  State<employee_screen> createState() => _employee_screenState();
}

List<String> allMember = [
  'Member A',
  'Member B',
  'Member C',
];

List<String> allLeader = [
  'Leader A',
  'Leader B',
];

List<String> allManager = [
  'Manager A',
  'Manager B',
];

bool _customTileExpanded0 = true;
bool _customTileExpanded1 = true;
bool _customTileExpanded2 = true;

class _employee_screenState extends State<employee_screen> {

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
            db_side_menu(),
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
                              'LIST OF USERS',
                              style: const TextStyle(
                                fontFamily: 'MontMed',
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                        const Divider(),
                        SizedBox(height: 5),
                        Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.indigo[50],
                            borderRadius: BorderRadius.circular(5.0),  // Set the border radius
                          ),
                          child: ExpansionTile(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.zero,
                            ),
                            initiallyExpanded: true,
                            title: Row(
                              children: [
                                Icon(Icons.people, color: Colors.indigo),
                                SizedBox(width: 10),
                                Text('Member(s)', style: TextStyle(fontFamily: 'MontMed', fontSize: 13)),
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
                                  children: allMember.map((project) {
                                    return ListTile(
                                      leading: const CircleAvatar(
                                        child: Text('T'),
                                      ),
                                      title: Text('${project}', maxLines: 2, overflow: TextOverflow.ellipsis, style: TextStyle(fontFamily: 'MontMed', fontSize: 13)),
                                      subtitle: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Icon(Icons.people, size: 13,),
                                              SizedBox(width: 5),
                                              Text('Projects Joined: 3', style: TextStyle(fontFamily: 'MontMed', fontSize: 12))
                                            ],
                                          ),
                                        ],
                                      ),
                                      trailing: IconButton(
                                          icon: Icon(Icons.border_color, size: 14,),
                                          onPressed: (){_showStateDrawer(context);}
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
                            borderRadius: BorderRadius.circular(5.0),  // Set the border radius
                          ),
                          child: ExpansionTile(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.zero,
                            ),
                            initiallyExpanded: true,
                            title: Row(
                              children: [
                                Icon(Icons.person, color: Colors.indigo),
                                SizedBox(width: 10),
                                Text('Leader(s)', style: TextStyle(fontFamily: 'MontMed', fontSize: 13)),
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
                                  children: allLeader.map((task) {
                                    return ListTile(
                                      leading: const CircleAvatar(
                                          child: Text('T')
                                      ),
                                      title: Text(task, maxLines: 2, overflow: TextOverflow.ellipsis, style: TextStyle(fontFamily: 'MontMed', fontSize: 13)),
                                      subtitle: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Icon(Icons.folder_open_sharp, size: 13,),
                                              SizedBox(width: 5),
                                              Text('Project Joined: 3', style: TextStyle(fontFamily: 'MontMed', fontSize: 12))
                                            ],
                                          ),
                                        ],
                                      ),
                                      trailing: IconButton(
                                          icon: Icon(Icons.border_color, size: 14,),
                                          onPressed: (){_showStateDrawer(context);}
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
                            borderRadius: BorderRadius.circular(5.0),  // Set the border radius
                          ),
                          child: ExpansionTile(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.zero,
                            ),
                            initiallyExpanded: true,
                            title: Row(
                              children: [
                                Icon(Icons.person, color: Colors.indigo),
                                SizedBox(width: 10),
                                Text('Manager(s)', style: TextStyle(fontFamily: 'MontMed', fontSize: 13)),
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
                                  children: allManager.map((project) {
                                    return ListTile(
                                      leading: const CircleAvatar(
                                        child: Text('H'),
                                      ),
                                      title: Text(project, maxLines: 2, overflow: TextOverflow.ellipsis, style: TextStyle(fontFamily: 'MontMed', fontSize: 13)),
                                      subtitle: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Icon(Icons.folder_open_sharp, size: 13,),
                                              SizedBox(width: 5),
                                              Text('Project Created: 3', style: TextStyle(fontFamily: 'MontMed', fontSize: 12))
                                            ],
                                          ),
                                        ],
                                      ),
                                      trailing: IconButton(
                                          icon: Icon(Icons.border_color, size: 14,),
                                          onPressed: (){_showStateDrawer(context);}
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
                )
            ),
          ],
        ),
      ),
    );
  }

  bool member = true;
  bool leader = false;
  bool manager = false;
  void _showStateDrawer(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          // Your bottom drawer content goes here
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 20),
              Row(
                children: [
                  SizedBox(width: 25),
                  Text('Change Role:', style: TextStyle(fontFamily: 'MontMed', fontSize: 16)),
                ],
              ),
              SizedBox(height: 5),
              Divider(),
              ListTile(
                  leading: Icon(Icons.people),
                  title: Text('Member', style: TextStyle(fontFamily: 'MontMed', fontSize: 14)),
                  onTap: () {
                    member = true;
                    leader = false;
                    manager = false;
                    Navigator.pop(context);
                  },
                  trailing: Container(
                      child: Visibility(
                        visible: member,
                        child: Icon(Icons.check),
                      )
                  )
              ),
              ListTile(
                  leading: Icon(Icons.person),
                  title: Text('Incompleted', style: TextStyle(fontFamily: 'MontMed', fontSize: 14)),
                  onTap: () {
                    member = false;
                    leader = true;
                    manager = false;
                    Navigator.pop(context);
                  },
                  trailing: Container(
                      child: Visibility(
                        visible: leader,
                        child: Icon(Icons.check),
                      )
                  )
              ),
              ListTile(
                  leading: Icon(Icons.star),
                  title: Text('Manager', style: TextStyle(fontFamily: 'MontMed', fontSize: 14)),
                  onTap: () {
                    member = false;
                    leader = false;
                    manager = true;
                    Navigator.pop(context);
                  },
                  trailing: Container(
                      child: Visibility(
                        visible: manager,
                        child: Icon(Icons.check),
                      )
                  )
              ),
            ],
          ),
        );
      },
    );
  }
}