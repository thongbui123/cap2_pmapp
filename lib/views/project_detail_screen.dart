import 'package:capstone2_project_management_app/views/stats/stats.dart';
import 'package:capstone2_project_management_app/views/subs/db_side_menu.dart';
import 'package:flutter/material.dart';
import 'dart:io';

class projectScreen extends StatefulWidget {
  const projectScreen({Key? key}) : super(key: key);

  @override
  State<projectScreen> createState() => _projectScreenState();
}

class _projectScreenState extends State<projectScreen> {
  List<String> allMembers = [
    'User 1',
    'User 2',
    'User 3',
  ];

  List<String> currentList = [

  ];


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
                          IconButton(
                              icon: const Icon(Icons.arrow_back_ios),
                              onPressed: () {
                                Navigator.pop(context);
                              }),
                          Text(
                            'PROJECT',
                            style: TextStyle(
                              fontFamily: 'Anurati',
                              fontSize: 30,
                            ),
                          ),
                        ],
                      ),
                      Divider(),
                      ListTile(
                        leading: CircleAvatar(
                            child: Icon(
                                Icons.folder,
                                color: Colors.orange
                            )
                        ),
                        title: Text('Project Name: PMS', style: TextStyle(fontFamily: 'MontMed', color: Colors.black, fontSize: 13)),
                        subtitle: Text('Current State: In Development', style: TextStyle(fontFamily: 'MontMed', fontSize: 12),),
                      ),
                      SizedBox(height: 5),
                      Container(width: 50, height: 1, color: Colors.black,),
                      SizedBox(height: 5),
                      Text('Description: Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.'
                        , style: TextStyle(fontFamily: 'MontMed', color: Colors.black87, fontSize: 12),),
                      SizedBox(height: 10),
                      ListTile(
                        leading: CircleAvatar(
                            child: Text(
                              'T',
                              style: TextStyle(fontFamily: 'MontMed'),
                            )
                        ),
                        title: Text('Assigned by:', style: TextStyle(fontFamily: 'MontMed', fontSize: 12, color: Colors.black54)),
                        subtitle: Text('THONG B', style: TextStyle(fontFamily: 'MontMed', fontSize: 14)),
                      ),
                      Divider(),
                      SizedBox(height: 5),
                      Row(
                        children: [
                          Icon(Icons.people_alt_outlined, color: Colors.black87,),
                          SizedBox(width: 15),
                          Text('Participants:', style: TextStyle(fontFamily: 'MontMed', fontSize: 12),),
                        ],
                      ),
                      SizedBox(height: 5),
                      Container(
                        child: Column(
                          children: currentList.map((member) {
                            return ListTile(
                              leading: const CircleAvatar(
                                  child: Text(
                                    'A',
                                    style: TextStyle(fontFamily: 'MontMed'),
                                  )),
                              title: Text(member, style: TextStyle(fontFamily: 'MontMed', fontSize: 13)),
                              subtitle: Text(
                                '2 Projects',
                                style: const TextStyle(fontFamily: 'MontMed', fontSize: 12),
                              ),
                              trailing: Ink(
                                decoration: const ShapeDecoration(
                                  color: Colors.transparent,
                                  shape: CircleBorder(),
                                ),
                                child: IconButton(
                                  icon: const Icon(Icons.remove_circle),
                                  color: Colors.redAccent,
                                  onPressed: () {
                                    _removeMember(member);
                                  },
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                      SizedBox(height: 5),
                      Container(
                          margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
                          child: TextButton(
                            onPressed: _showMemberSelectionDialog,
                            child: const Row(
                              children: [
                                Icon(Icons.add, color: Colors.blueAccent,),
                                SizedBox(width: 10),
                                Text(
                                  'Add New Member',
                                  style: TextStyle(fontFamily: 'MontMed', color: Colors.blueAccent),
                                ),
                              ],
                            ),
                          )
                      ),
                      SizedBox(height: 10),
                      Divider(),
                      SizedBox(height: 5),
                      Row(
                        children: [
                          Icon(Icons.calendar_today, size: 19, color: Colors.black87,),
                          SizedBox(width: 10),
                          Container(width: 1, height: 36, color: Colors.grey,),
                          SizedBox(width: 15),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Start Date:', style: TextStyle(fontFamily: 'MontMed', fontSize: 12),),
                              SizedBox(height: 5),
                              Text('01/01/2024', style: TextStyle(fontFamily: 'MontMed', fontSize: 13, color: Colors.green),)
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 5),
                      Row(
                        children: [
                          Icon(Icons.calendar_today, size: 19, color: Colors.black87,),
                          SizedBox(width: 10),
                          Container(width: 1, height: 36, color: Colors.grey,),
                          SizedBox(width: 15),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Estimated End Date:', style: TextStyle(fontFamily: 'MontMed', fontSize: 12),),
                              SizedBox(height: 5),
                              Text('01/01/2024', style: TextStyle(fontFamily: 'MontMed', fontSize: 13, color: Colors.redAccent),)
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 5),
                      Row(
                        children: [
                          Icon(Icons.account_tree_outlined, color: Colors.black87,),
                          SizedBox(width: 5),
                          Container(width: 1, height: 36, color: Colors.grey,),
                          SizedBox(width: 15),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Current Phrase:', style: TextStyle(fontFamily: 'MontMed', fontSize: 12),),
                              SizedBox(height: 5),
                              Text('Requirements Gathering', style: TextStyle(fontFamily: 'MontMed', fontSize: 13, color: Colors.black),)
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Divider(),
                      Container(
                          height: 50,
                          width: 200,
                          child: TextButton(
                            onPressed: () {},
                            child: Container(
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Icon(Icons.arrow_forward_ios, size: 13),
                                  SizedBox(width: 10),
                                  Text(
                                    'Conclude Phrase',
                                    style: TextStyle(fontFamily: 'MontMed', fontSize: 13),
                                  ),
                                ],
                              ),
                            ),
                          )
                      ),
                      Divider(),
                      Container(
                          height: 50,
                          width: 200,
                          child: TextButton(
                            onPressed: () {},
                            child: Container(
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Icon(Icons.arrow_back_ios, size: 13),
                                  SizedBox(width: 10),
                                  Text(
                                    'Reverse Phrase',
                                    style: TextStyle(fontFamily: 'MontMed', fontSize: 13),
                                  ),
                                ],
                              ),
                            ),
                          )
                      ),
                      Divider(),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> _showMemberSelectionDialog() async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'MEMBERS',
            style: TextStyle(fontFamily: 'Anurati'),
          ),
          content: SingleChildScrollView(
            child: Column(
              children: allMembers.map((user) {
                return Column(
                  children: <Widget>[
                    ListTile(
                      leading: const CircleAvatar(
                          child: Text(
                            'A',
                            style: TextStyle(fontFamily: 'MontMed'),
                          )),
                      title: Text(user),
                      subtitle: Text(
                        '2 Projects Involved',
                        style: TextStyle(fontFamily: 'MontMed'),
                      ),
                      onTap: () {
                        _addMember(user);
                        Navigator.of(context).pop(); // Close the dialog
                      },
                    ),
                    const Divider(height: 0),
                  ],
                );
              }).toList(),
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'Cancel',
                style: TextStyle(fontFamily: 'MontMed'),
              ),
            ),
          ],
        );
      },
    );
  }

  void _removeMember(String member) {
    setState(() {
      currentList.remove(member);
    });
  }

  void _addMember(String member) {
    setState(() {
      currentList.add(member);
    });
  }
}
