import 'package:capstone2_project_management_app/views/stats/stats.dart';
import 'package:capstone2_project_management_app/views/subs/db_side_menu.dart';
import 'package:flutter/material.dart';
import 'package:comment_box/comment/comment.dart';

class task_detail extends StatefulWidget {
  const task_detail({super.key});

  @override
  State<task_detail> createState() => _task_detailState();
}

List<String> allMembers = [
  'User 1',
  'User 2',
  'User 3',
];

List<String> currentList = [
  'Vincent',
  'Jackie',
  'David'
];

List<String> comments = [
  'How is the tasks',
  'Not so great',
  'Then hurry up',
  'I am trying',
  'You know what ? YOURE FIRED',
  'KEKW I always want to get the hell outa here'
];

class _task_detailState extends State<task_detail> {

  Widget commentChild(data) {
    return ListView(
      children: [
        for (var i = 0; i < data.length; i++)
          Padding(
            padding: const EdgeInsets.fromLTRB(2.0, 8.0, 2.0, 0.0),
            child: ListTile(
              leading: GestureDetector(
                onTap: () async {
                  // Display the image in large form.
                  print("Comment Clicked");
                },
                child: Container(
                  height: 50.0,
                  width: 50.0,
                  decoration: new BoxDecoration(
                      color: Colors.blue,
                      borderRadius: new BorderRadius.all(Radius.circular(50))),
                  child: CircleAvatar(
                      radius: 50,
                      backgroundImage: CommentBox.commentImageParser(
                          imageURLorPath: data[i]['pic'])),
                ),
              ),
              title: Text(
                data[i]['name'],
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(data[i]['message']),
              trailing: Text(data[i]['date'], style: TextStyle(fontSize: 10)),
            ),
          )
      ],
    );
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
                              'TASK',
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
                                  Icons.layers,
                                  color: Colors.blueAccent
                              )
                          ),
                          title: Text('Task Name: PMS', style: TextStyle(fontFamily: 'MontMed', color: Colors.black, fontSize: 13)),
                          subtitle: Text('Current State: In Progress', style: TextStyle(fontFamily: 'MontMed', fontSize: 12),),
                        ),
                        SizedBox(height: 5),
                        Container(width: 50, height: 1, color: Colors.black,),
                        SizedBox(height: 5),
                        Text('Description: Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.'
                          , style: TextStyle(fontFamily: 'MontMed', color: Colors.black87, fontSize: 12),),
                        SizedBox(height: 10),
                        Divider(),
                        ListTile(
                          leading: CircleAvatar(
                              child: Text(
                                'T',
                                style: TextStyle(fontFamily: 'MontMed'),
                              )
                          ),
                          title: Text('Assigned by: ', style: TextStyle(fontFamily: 'MontMed', fontSize: 12, color: Colors.black54)),
                          subtitle: Text('THONG B', style: TextStyle(fontFamily: 'MontMed', fontSize: 14)),
                          trailing: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 8),
                                Text('Priority: ', style: TextStyle(fontFamily: 'MontMed', fontSize: 12, color: Colors.black54)),
                                Padding(
                                  padding: EdgeInsets.fromLTRB(0, 0, 40, 0),
                                  child: Text('HIGH', style: TextStyle(fontFamily: 'MontMed', color: Colors.red, fontWeight: FontWeight.bold, fontSize: 14)),
                                )
                              ]
                          ),
                        ),
                        Divider(),
                        ListTile(
                          leading: CircleAvatar(
                            child: Icon(Icons.calendar_month),
                          ),
                          title: Text('Start Date: ', style: TextStyle(fontFamily: 'MontMed', fontSize: 12, color: Colors.black54)),
                          subtitle: Text('22/10/2023', style: TextStyle(fontFamily: 'MontMed', fontSize: 14)),
                          trailing: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 8),
                                Text('End Date: ', style: TextStyle(fontFamily: 'MontMed', fontSize: 12, color: Colors.black54)),
                                Text('22/10/2077', style: TextStyle(fontFamily: 'MontMed', fontSize: 14))
                              ]
                          ),
                        ),
                        Divider(),
                        ListTile(
                          leading: CircleAvatar(
                            child: Icon(Icons.comment),
                          ),
                          title: Text('Comments Related: ', style: TextStyle(fontFamily: 'MontMed', fontSize: 12, color: Colors.black54)),
                          subtitle: Text('4 comments ', style: TextStyle(fontFamily: 'MontMed', fontSize: 14)),
                          trailing: TextButton(onPressed: (){_showStateBottomSheet2(context);}, child: Text('View All ', style: TextStyle(fontFamily: 'MontMed', fontSize: 14))),
                        ),
                        Divider(),
                        ListTile(
                          leading: CircleAvatar(
                            child: Icon(Icons.people),
                          ),
                          title: Text('Participants: ', style: TextStyle(fontFamily: 'MontMed', fontSize: 12, color: Colors.black54)),
                          subtitle: Text('4 members ', style: TextStyle(fontFamily: 'MontMed', fontSize: 14)),
                          trailing: TextButton(onPressed: (){_showStateBottomSheet(context);}, child: Text('View All ', style: TextStyle(fontFamily: 'MontMed', fontSize: 14))),
                        ),
                        Divider(),
                        ListTile(
                          leading: CircleAvatar(
                            child: Icon(Icons.settings),
                          ),
                          title: Text('Task Modification: ', style: TextStyle(fontFamily: 'MontMed', fontSize: 12, color: Colors.black54)),
                          subtitle: Text('Advanced Options', style: TextStyle(fontFamily: 'MontMed', fontSize: 14)),
                          trailing: TextButton(onPressed: (){_showStateBottomSheet3(context);}, child: Text('View All ', style: TextStyle(fontFamily: 'MontMed', fontSize: 14))),
                        ),
                        Divider(),
                        ListTile(
                          leading: CircleAvatar(
                            child: Icon(Icons.check),
                          ),
                          title: Text('Task Submit: ', style: TextStyle(fontFamily: 'MontMed', fontSize: 12, color: Colors.black54)),
                          subtitle: Text('Finalize This Task', style: TextStyle(fontFamily: 'MontMed', fontSize: 14)),
                        ),
                        Divider(),
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

  void _showStateBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return StatefulBottomSheetWidget();
      },
    );
  }

  void _showStateBottomSheet2(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return StatefulBottomSheetWidget2();
      },
    );
  }

  void _showStateBottomSheet3(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return StatefulBottomSheetWidget3();
      },
    );
  }
}

class StatefulBottomSheetWidget extends StatefulWidget {

  @override
  _StatefulBottomSheetWidgetState createState() =>
      _StatefulBottomSheetWidgetState();
}

class _StatefulBottomSheetWidgetState extends State<StatefulBottomSheetWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
      child: Column(
        children: [
          SizedBox(height: 20),
          Row(
            children: [
              SizedBox(width: 25),
              Text('Members:', style: TextStyle(fontFamily: 'MontMed', fontSize: 16)),
            ],
          ),
          SizedBox(height: 5),
          Divider(),
          Container(
              child: TextButton(
                onPressed: _showMemberSelectionDialog,
                child: const Row(
                  children: [
                    Icon(Icons.add, color: Colors.blueAccent,),
                    SizedBox(width: 10),
                    Text(
                      'Assign New Member',
                      style: TextStyle(fontFamily: 'MontMed', color: Colors.blueAccent),
                    ),
                  ],
                ),
              )
          ),
          SizedBox(height: 10),
          Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: ListTile.divideTiles(
                    context: context,  // Make sure to provide the BuildContext if this code is inside a widget build method
                    tiles: currentList.map((member) {
                      return ListTile(
                        leading: const CircleAvatar(
                          child: Icon(
                            Icons.person,
                          ),
                        ),
                        title: Text(member, style: TextStyle(fontFamily: 'MontMed', fontSize: 13)),
                        subtitle: Text(
                          '3 Tasks Involved',
                          style: const TextStyle(fontFamily: 'MontMed', fontSize: 12),
                        ),
                        trailing: TextButton(
                            onPressed: (){
                              setState(() {
                                currentList.remove(member);
                              });
                            },
                            child: Text('Remove', style: TextStyle(fontFamily: 'MontMed', fontSize: 12))
                        ),
                      );
                    }),
                  ).toList(),
                ),
              )
          ),
        ],
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
                        child: Icon(
                          Icons.person,
                        ),
                      ),
                      title: Text(user, style: TextStyle(fontFamily: 'MontMed', fontSize: 13)),
                      subtitle: Text(
                        '2 Tasks Involved',
                        style: TextStyle(fontFamily: 'MontMed', fontSize: 12),
                      ),
                      onTap: () {
                        setState(() {
                          currentList.add(user);
                        });
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
}

class StatefulBottomSheetWidget2 extends StatefulWidget {

  @override
  _StatefulBottomSheetWidget2State createState() =>
      _StatefulBottomSheetWidget2State();
}

class _StatefulBottomSheetWidget2State extends State<StatefulBottomSheetWidget2> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
      child: Column(
        children: [
          SizedBox(height: 20),
          Row(
            children: [
              SizedBox(width: 25),
              Text('Comments:', style: TextStyle(fontFamily: 'MontMed', fontSize: 16)),
            ],
          ),
          SizedBox(height: 5),
          Divider(),
          Row(
            children: [

            ],
          ),
          ListTile(
              leading: CircleAvatar(
                  child: Icon(
                      Icons.person
                  )
              ),
              title: TextField(
                style: TextStyle(
                  color: Colors.black,
                  fontFamily: 'MontMed',
                  fontWeight: FontWeight.normal,
                  fontSize: 12,
                ),
                decoration: InputDecoration(
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFFD9D9D9)),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black54),
                  ),
                  labelText: 'Post a Comment',
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
              trailing: IconButton(
                onPressed: (){},
                icon: Icon(Icons.send),
              )
          ),
          Divider(),
          Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: ListTile.divideTiles(
                    context: context,  // Make sure to provide the BuildContext if this code is inside a widget build method
                    tiles: comments.map((comment) {
                      return ListTile(
                          leading: const CircleAvatar(
                            child: Icon(
                              Icons.person,
                            ),
                          ),
                          title: Text('Name', style: TextStyle(fontFamily: 'MontMed', fontSize: 12, fontWeight: FontWeight.bold)),
                          subtitle: Text(
                            comment,
                            style: const TextStyle(fontFamily: 'MontMed', fontSize: 13, color: Colors.black),
                          ),
                          trailing: Text('2024-10-20 | 7:00', style: TextStyle(fontFamily: 'MontMed'))
                      );
                    }),
                  ).toList(),
                ),
              )
          ),
        ],
      ),
    );
  }
}

class StatefulBottomSheetWidget3 extends StatefulWidget {

  @override
  _StatefulBottomSheetWidget3State createState() =>
      _StatefulBottomSheetWidget3State();
}

class _StatefulBottomSheetWidget3State extends State<StatefulBottomSheetWidget3> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
      child: Column(
        children: [
          SizedBox(height: 20),
          Row(
            children: [
              SizedBox(width: 25),
              Text('Task Modification:', style: TextStyle(fontFamily: 'MontMed', fontSize: 16)),
            ],
          ),
          SizedBox(height: 5),
          Divider(),
          ListTile(
            leading: CircleAvatar(
              child: Icon(Icons.playlist_add_check),
            ),
            title: Text('Mark as Done', style: TextStyle(fontFamily: 'MontMed', fontSize: 13)),
            subtitle: Text('Task Completion and Storage', style: TextStyle(fontFamily: 'MontMed', fontSize: 12)),
            onTap: (){},
          ),
          Divider(),
          ListTile(
            leading: CircleAvatar(
              child: Icon(Icons.playlist_remove),
            ),
            title: Text('Relaunch Task', style: TextStyle(fontFamily: 'MontMed', fontSize: 13)),
            subtitle: Text('Mark as Undone and Redo Task', style: TextStyle(fontFamily: 'MontMed', fontSize: 12)),
            onTap: (){},
          ),
          Divider(),
          ListTile(
            leading: CircleAvatar(
              child: Icon(Icons.delete_outline),
            ),
            title: Text('Dispose Task', style: TextStyle(fontFamily: 'MontMed', fontSize: 13)),
            subtitle: Text('Delete Task and Remove from Storage', style: TextStyle(fontFamily: 'MontMed', fontSize: 12)),
            onTap: (){},
          ),
          Divider(),
        ],
      ),
    );
  }
}
