import 'package:capstone2_project_management_app/models/comment_model.dart';
import 'package:capstone2_project_management_app/models/phase_model.dart';
import 'package:capstone2_project_management_app/models/project_model.dart';
import 'package:capstone2_project_management_app/models/task_model.dart';
import 'package:capstone2_project_management_app/models/user_model.dart';
import 'package:capstone2_project_management_app/services/comment_service.dart';
import 'package:capstone2_project_management_app/services/phase_services.dart';
import 'package:capstone2_project_management_app/services/project_services.dart';
import 'package:capstone2_project_management_app/services/task_services.dart';
import 'package:capstone2_project_management_app/services/user_services.dart';
import 'package:capstone2_project_management_app/views/list_of_tasks_screen.dart';
import 'package:capstone2_project_management_app/views/stats/stats.dart';
import 'package:capstone2_project_management_app/views/subs/db_side_menu.dart';
import 'package:capstone2_project_management_app/views/subs/sub_widgets.dart';
import 'package:comment_box/comment/comment.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

import '../services/notification_services.dart';

class TaskDetailScreen extends StatefulWidget {
  final Map<String, dynamic> userMap;
  final TaskModel taskModel;
  final Map taskMap;
  final Map commentMap;
  final UserModel userModel;
  final PhaseModel phaseModel;
  const TaskDetailScreen(
      {super.key,
      required this.taskModel,
      required this.userMap,
      required this.taskMap,
      required this.commentMap,
      required this.userModel,
      required this.phaseModel});

  @override
  State<TaskDetailScreen> createState() => _TaskDetailScreenState();
}

List<String> allMembers = [];

List<String> currentList = [];

List<String> comments = [
  'How is the tasks',
  'Not so great',
  'Then hurry up',
  'I am trying',
  'You know what ? YOURE FIRED',
  'KEKW I always want to get the hell outa here'
];

Map commentMap = {};

class _TaskDetailScreenState extends State<TaskDetailScreen> {
  late TaskModel taskModel;
  late Map<String, dynamic> userMap;
  late Map taskMap;
  late Map commentMap;
  User? user;
  DatabaseReference? userRef;
  UserModel? currentUserModel;
  late List<CommentModel> listComments;
  late PhaseModel phaseModel;
  //final databaseReference = FirebaseDatabase.instance.ref();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    taskModel = widget.taskModel;
    phaseModel = widget.phaseModel;
    //userMap = widget.userMap;
    //taskMap = widget.taskMap;
    commentMap = widget.commentMap;
    currentUserModel = widget.userModel;
    listComments =
        CommentService().getListAllComments(commentMap, taskModel.taskId);
  }

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
                      borderRadius:
                          new BorderRadius.all(const Radius.circular(50))),
                  child: CircleAvatar(
                      radius: 50,
                      backgroundImage: CommentBox.commentImageParser(
                          imageURLorPath: data[i]['pic'])),
                ),
              ),
              title: Text(
                data[i]['name'],
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(data[i]['message']),
              trailing:
                  Text(data[i]['date'], style: const TextStyle(fontSize: 10)),
            ),
          )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Object>>(
        stream: CombineLatestStream.list([
          CommentService().databaseReference.onValue,
          TaskService().taskRef.onValue,
          UserServices().databaseReference.onValue,
          TaskService().taskRef.child(taskModel.taskId).onValue,
          NotificationService().databaseReference.onValue
        ]),
        builder: (context, snapshot) {
          if (snapshot.hasError || !snapshot.hasData) {
            return loader();
          }
          var eventComment = snapshot.data![0] as DatabaseEvent;
          var eventTask = snapshot.data![1] as DatabaseEvent;
          var eventUser = snapshot.data![2] as DatabaseEvent;
          var eventTaskModel = snapshot.data![3] as DatabaseEvent;
          var dynamicComment = eventComment.snapshot.value as dynamic;
          var dynamicTask = eventTask.snapshot.value as dynamic;
          var dynamicUser = eventUser.snapshot.value as dynamic;
          var dynamicTaskModel = eventTaskModel.snapshot.value as dynamic;
          var notifiEvent = snapshot.data![4] as DatabaseEvent;
          var notifiValue = notifiEvent.snapshot.value as dynamic;
          Map notifiMap = Map<String, dynamic>.from(notifiValue);
          //NotificationService().databaseReference.onValue
          int numNr = NotificationService()
              .getListAllNotRead(notifiMap, currentUserModel!.userId)
              .length;
          commentMap = Map.from(dynamicComment);
          taskMap = Map.from(dynamicTask);
          userMap = Map.from(dynamicUser);
          if (dynamicTaskModel == null) {
            return StreamBuilder<Object>(
                stream: ProjectServices().reference.onValue,
                builder: (context, snapshot) {
                  if (snapshot.hasError || !snapshot.hasData) {
                    return loader();
                  }
                  var event = snapshot.data! as DatabaseEvent;
                  var value = event.snapshot.value as dynamic;
                  return ListOfTaskScreen(
                      userModel: currentUserModel!,
                      projectMap: Map.from(value),
                      taskMap: taskMap);
                });
          }
          taskModel = TaskModel.fromMap(Map.from(dynamicTaskModel));
          listComments =
              CommentService().getListAllComments(commentMap, taskModel.taskId);
          return Scaffold(
            body: SafeArea(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DbSideMenu(
                    userModel: currentUserModel!,
                    numNotRead: numNr,
                  ),
                  Expanded(
                      child: Padding(
                    padding: const EdgeInsets.all(defaultPadding),
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
                              const Text(
                                'TASK',
                                style: TextStyle(
                                    fontFamily: 'MontMed',
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          const Divider(),
                          ListTile(
                            leading: const CircleAvatar(
                                child: Icon(Icons.layers,
                                    color: Colors.blueAccent)),
                            title: Text(
                                'Task Name: ${taskModel.taskName.toUpperCase()}',
                                style: const TextStyle(
                                    fontFamily: 'MontMed',
                                    color: Colors.black,
                                    fontSize: 13)),
                            subtitle: Text(
                              'Current State: ${taskModel.taskStatus}',
                              style: const TextStyle(
                                  fontFamily: 'MontMed', fontSize: 12),
                            ),
                          ),
                          const SizedBox(height: 5),
                          Container(
                            width: 50,
                            height: 1,
                            color: Colors.black,
                          ),
                          const SizedBox(height: 5),
                          Text(
                            '${taskModel.taskDescription}',
                            style: const TextStyle(
                                fontFamily: 'MontMed',
                                color: Colors.black87,
                                fontSize: 12),
                          ),
                          const SizedBox(height: 10),
                          const Divider(),
                          ListTile(
                            leading: avatar(userMap, taskModel.assignById),
                            title: const Text('Assigned by: ',
                                style: TextStyle(
                                    fontFamily: 'MontMed',
                                    fontSize: 12,
                                    color: Colors.black54)),
                            subtitle: Text(
                                '${UserServices().getNameFromId(userMap, taskModel.assignById)}',
                                style: const TextStyle(
                                    fontFamily: 'MontMed', fontSize: 14)),
                            trailing: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 8),
                                  const Text('Priority: ',
                                      style: TextStyle(
                                          fontFamily: 'MontMed',
                                          fontSize: 12,
                                          color: Colors.black54)),
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 0, 40, 0),
                                    child: Text(
                                        taskModel.taskPriority.toUpperCase(),
                                        style: TextStyle(
                                            fontFamily: 'MontMed',
                                            color:
                                                taskModel.taskPriority == 'High'
                                                    ? Colors.red
                                                    : (taskModel.taskPriority ==
                                                            'Medium'
                                                        ? Colors.yellow
                                                        : Colors.blueAccent),
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14)),
                                  )
                                ]),
                          ),
                          const Divider(),
                          ListTile(
                            leading: const CircleAvatar(
                              child: Icon(Icons.calendar_month),
                            ),
                            title: const Text('Start Date: ',
                                style: TextStyle(
                                    fontFamily: 'MontMed',
                                    fontSize: 12,
                                    color: Colors.black54)),
                            subtitle: Text('${taskModel.taskStartDate}',
                                style: const TextStyle(
                                    fontFamily: 'MontMed', fontSize: 14)),
                            trailing: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 8),
                                  const Text('End Date: ',
                                      style: TextStyle(
                                          fontFamily: 'MontMed',
                                          fontSize: 12,
                                          color: Colors.black54)),
                                  Text('${taskModel.taskEndDate}',
                                      style: const TextStyle(
                                          fontFamily: 'MontMed', fontSize: 14))
                                ]),
                          ),
                          const Divider(),
                          ListTile(
                            leading: const CircleAvatar(
                              child: Icon(Icons.comment),
                            ),
                            title: const Text('Comments Related: ',
                                style: TextStyle(
                                    fontFamily: 'MontMed',
                                    fontSize: 12,
                                    color: Colors.black54)),
                            subtitle: Text(
                                '${CommentService().getListAllCommentLength(commentMap, taskModel.taskId)} comment(s) ',
                                style: const TextStyle(
                                    fontFamily: 'MontMed', fontSize: 14)),
                            trailing: TextButton(
                                onPressed: () {
                                  _showStateCommentSheet(context, commentMap);
                                },
                                child: const Text('View All ',
                                    style: TextStyle(
                                        fontFamily: 'MontMed', fontSize: 14))),
                          ),
                          const Divider(),
                          ListTile(
                            leading: const CircleAvatar(
                              child: Icon(Icons.people),
                            ),
                            title: const Text('Participants: ',
                                style: TextStyle(
                                    fontFamily: 'MontMed',
                                    fontSize: 12,
                                    color: Colors.black54)),
                            subtitle: Text(
                                '${taskModel.taskMembers.length} members ',
                                style: const TextStyle(
                                    fontFamily: 'MontMed', fontSize: 14)),
                            trailing: TextButton(
                                onPressed: () {
                                  currentList = taskModel.taskMembers;

                                  _showStateBottomSheet(context);
                                },
                                child: const Text('View All ',
                                    style: TextStyle(
                                        fontFamily: 'MontMed', fontSize: 14))),
                          ),
                          const Divider(),
                          ListTile(
                            leading: const CircleAvatar(
                              child: Icon(Icons.settings),
                            ),
                            title: const Text('Task Modification: ',
                                style: TextStyle(
                                    fontFamily: 'MontMed',
                                    fontSize: 12,
                                    color: Colors.black54)),
                            subtitle: const Text('Advanced Options',
                                style: TextStyle(
                                    fontFamily: 'MontMed', fontSize: 14)),
                            trailing: TextButton(
                                onPressed: () {
                                  _showStateBottomSheet3(context);
                                },
                                child: const Text('View All ',
                                    style: TextStyle(
                                        fontFamily: 'MontMed', fontSize: 14))),
                          ),
                          const Divider(),
                          ListTile(
                            leading: const CircleAvatar(
                              child: Icon(Icons.check),
                            ),
                            title: const Text('Task Submit: ',
                                style: TextStyle(
                                    fontFamily: 'MontMed',
                                    fontSize: 12,
                                    color: Colors.black54)),
                            subtitle: const Text('Finalize This Task',
                                style: TextStyle(
                                    fontFamily: 'MontMed', fontSize: 14)),
                            trailing: TextButton(
                                onPressed: () {
                                  _showYesNoDialog(context);
                                },
                                child: Text(
                                    taskModel.taskStatus != 'Complete'
                                        ? 'SUBMIT'
                                        : 'UNSUBMIT',
                                    style: const TextStyle(
                                        fontFamily: 'MontMed', fontSize: 14))),
                          ),
                          const Divider(),
                        ],
                      ),
                    ),
                  )),
                ],
              ),
            ),
          );
        });
  }

  void _showYesNoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Task Submit Confirmation'),
          content: const Text('Do you want to submit this task?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                // Handle 'Yes' button tap
                _updateTaskStatus();
                Navigator.of(context).pop(true);
              },
              child: const Text('Yes'),
            ),
            TextButton(
              onPressed: () {
                // Handle 'No' button tap
                Navigator.of(context).pop(false);
              },
              child: const Text('No'),
            ),
          ],
        );
      },
    ).then((result) {
      if (result != null && result) {
        // Handle 'Yes' button response
        print('User clicked Yes');
      } else {
        // Handle 'No' button response
        print('User clicked No');
      }
    });
  }

  Future<void> _updateTaskStatus() async {
    DatabaseReference taskRef = FirebaseDatabase.instance.ref().child('tasks');
    String result = "";
    if (taskModel.taskStatus == 'Complete') {
      result = 'Incomplete';
    } else {
      result = 'Complete';
    }
    taskRef.child(taskModel.taskId).update({
      'taskStatus': result,
    });
    DatabaseEvent snapshot = await taskRef.once();
    DatabaseEvent databaseEventModel =
        await taskRef.child(taskModel.taskId).once();
    if (snapshot.snapshot.value != null && snapshot.snapshot.value is Map) {
      setState(() {
        taskMap = Map.from(snapshot.snapshot.value as dynamic);
        taskModel = TaskModel.fromMap(Map<String, dynamic>.from(
            databaseEventModel.snapshot.value as dynamic));
      });
    }
  }

  void _showStateBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return StatefulBottomSheetWidget(
          taskModel: taskModel,
          userMap: userMap,
          taskMap: taskMap,
          currentUserModel: currentUserModel!,
        );
      },
    );
  }

  void _showStateCommentSheet(BuildContext context, Map commentMap) async {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return StatefulCommentSheetWidget(
          userMap: userMap,
          taskId: taskModel.taskId,
          commentMap: commentMap,
          listComments: listComments,
        );
      },
    );
  }

  void _showStateBottomSheet3(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return StatefulBottomSheetWidget3(
          taskModel: taskModel,
          phaseModel: phaseModel,
        );
      },
    );
  }
}

class StatefulBottomSheetWidget extends StatefulWidget {
  final TaskModel taskModel;
  final Map<String, dynamic> userMap;
  final Map taskMap;
  final UserModel currentUserModel;
  const StatefulBottomSheetWidget(
      {super.key,
      required this.taskModel,
      required this.userMap,
      required this.taskMap,
      required this.currentUserModel});
  @override
  _StatefulBottomSheetWidgetState createState() =>
      _StatefulBottomSheetWidgetState();
}

class _StatefulBottomSheetWidgetState extends State<StatefulBottomSheetWidget> {
  late TaskModel taskModel;
  late Map<String, dynamic> userMap;
  late Map taskMap;
  late UserModel currentUserModel;
  late ProjectModel projectModel;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    taskModel = widget.taskModel;
    userMap = widget.userMap;
    taskMap = widget.taskMap;
    currentUserModel = widget.currentUserModel;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Object>>(
        stream: CombineLatestStream.list([
          UserServices().databaseReference.onValue,
          TaskService().taskRef.onValue,
          ProjectServices().reference.child(taskModel.projectId).onValue,
        ]),
        builder: (context, snapshot) {
          if (snapshot.hasError || !snapshot.hasData) return loader();
          var eventUser = snapshot.data![0] as DatabaseEvent;
          var eventTask = snapshot.data![1] as DatabaseEvent;
          var eventProjectModel = snapshot.data![2] as DatabaseEvent;
          var dynamicUser = eventUser.snapshot.value as dynamic;
          var dynamicTask = eventTask.snapshot.value as dynamic;
          var dynamicProjectModel = eventProjectModel.snapshot.value as dynamic;
          userMap = Map.from(dynamicUser);
          taskMap = Map.from(dynamicTask);
          projectModel = ProjectModel.fromMap(Map.from(dynamicProjectModel));
          return Container(
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
            child: Column(
              children: [
                const SizedBox(height: 20),
                const Row(
                  children: [
                    SizedBox(width: 25),
                    Text('Members:',
                        style: TextStyle(fontFamily: 'MontMed', fontSize: 16)),
                  ],
                ),
                const SizedBox(height: 5),
                const Divider(),
                Visibility(
                  visible: (currentUserModel.userRole == 'Team Leader' ||
                      currentUserModel.userRole == 'Admin'),
                  child: TextButton(
                    onPressed: () {
                      setState(() {
                        allMembers = projectModel.projectMembers;
                        currentList = taskModel.taskMembers;
                        for (var member in currentList) {
                          if (allMembers.contains(member)) {
                            allMembers.remove(member);
                          }
                        }
                      });
                      showMemberSelectionDialog(userMap, taskMap, taskModel);
                    },
                    child: const Row(
                      children: [
                        Icon(
                          Icons.add,
                          color: Colors.blueAccent,
                        ),
                        SizedBox(width: 10),
                        Text(
                          'Assign New Member',
                          style: TextStyle(
                              fontFamily: 'MontMed', color: Colors.blueAccent),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Expanded(
                    child: SingleChildScrollView(
                  child: Column(
                    children: ListTile.divideTiles(
                      context:
                          context, // Make sure to provide the BuildContext if this code is inside a widget build method
                      tiles: currentList.map((member) {
                        return ListTile(
                          leading: avatar(userMap, member),
                          title: Text(
                              UserServices().getNameFromId(userMap, member),
                              style: const TextStyle(
                                  fontFamily: 'MontMed', fontSize: 13)),
                          subtitle: Text(
                            '${TaskService().getJoinedTaskNumber(taskMap, member)} Tasks Involved',
                            style: const TextStyle(
                                fontFamily: 'MontMed', fontSize: 12),
                          ),
                          trailing: Visibility(
                            visible: currentUserModel.userRole != 'User',
                            child: TextButton(
                                onPressed: () {
                                  setState(() {
                                    _showDeleteMemberDialog(member);
                                  });
                                  TaskService()
                                      .taskRef
                                      .child(taskModel.taskId)
                                      .update({
                                    'taskMembers': currentList,
                                  });
                                },
                                child: const Text('Remove',
                                    style: TextStyle(
                                        fontFamily: 'MontMed', fontSize: 12))),
                          ),
                        );
                      }),
                    ).toList(),
                  ),
                )),
              ],
            ),
          );
        });
  }

  Future<void> showMemberSelectionDialog(
      Map<String, dynamic> userMap, Map taskMap, TaskModel taskModel) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'MEMBERS',
            style: TextStyle(fontFamily: 'Anurati'),
          ),
          content: allMembers.isEmpty
              ? const Text('There is no member here',
                  style: TextStyle(fontSize: 16))
              : SingleChildScrollView(
                  child: Column(
                    children: allMembers.map((member) {
                      return Column(
                        children: <Widget>[
                          ListTile(
                            leading: avatar(userMap, member),
                            title: Text(
                                UserServices().getNameFromId(userMap, member),
                                style: const TextStyle(
                                    fontFamily: 'MontMed', fontSize: 13)),
                            subtitle: Text(
                              '${TaskService().getJoinedTaskListFromProject(taskMap, member, projectModel.projectId).length} Task(s) Involved',
                              style: const TextStyle(
                                  fontFamily: 'MontMed', fontSize: 12),
                            ),
                            onTap: () {
                              setState(() {
                                currentList.add(member);
                                allMembers.remove(member);
                              });
                              TaskService()
                                  .taskRef
                                  .child(taskModel.taskId)
                                  .update({
                                'taskMembers': currentList,
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

  Future<void> _showDeleteMemberDialog(String member) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('REMOVE MEMBER'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Do You Want To Remove This Member?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('YES'),
              onPressed: () {
                setState(() {
                  currentList.remove(member);
                  allMembers.add(member);
                });
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('NO'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

class StatefulCommentSheetWidget extends StatefulWidget {
  final Map<String, dynamic> userMap;
  final String taskId;
  final Map commentMap;
  final List<CommentModel> listComments;
  const StatefulCommentSheetWidget(
      {super.key,
      required this.userMap,
      required this.taskId,
      required this.commentMap,
      required this.listComments});

  @override
  _StatefulCommentSheetWidgetState createState() =>
      _StatefulCommentSheetWidgetState();
}

class _StatefulCommentSheetWidgetState
    extends State<StatefulCommentSheetWidget> {
  User? user;
  late Map<String, dynamic> userMap;
  late Map commentMap;
  late String taskId;
  var commentController = TextEditingController();
  List<CommentModel> listComments = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    userMap = widget.userMap;
    taskId = widget.taskId;
    commentMap = widget.commentMap;
    listComments = widget.listComments;
    user = FirebaseAuth.instance.currentUser;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Object>(
        stream: CommentService().databaseReference.onValue,
        builder: (context, snapshot) {
          if (snapshot.hasError || !snapshot.hasData) {
            return loader();
          }
          var commentEvent = snapshot.data as DatabaseEvent;
          var commentDynamic = commentEvent.snapshot.value as dynamic;
          commentMap = Map.from(commentDynamic);
          Map<String, dynamic> map = {};
          commentMap.forEach((key, value) {
            map[key.toString()] = value;
          });
          commentMap = CommentService().sortedMap(map);
          listComments =
              CommentService().getListAllComments(commentMap, taskId);
          return Container(
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
            child: Column(
              children: [
                const SizedBox(height: 20),
                const Row(
                  children: [
                    SizedBox(width: 25),
                    Text('Comments:',
                        style: TextStyle(fontFamily: 'MontMed', fontSize: 16)),
                  ],
                ),
                const SizedBox(height: 5),
                const Divider(),
                ListTile(
                    leading: avatar(userMap, user!.uid),
                    title: TextField(
                      controller: commentController,
                      style: const TextStyle(
                        color: Colors.black,
                        fontFamily: 'MontMed',
                        fontWeight: FontWeight.normal,
                        fontSize: 12,
                      ),
                      decoration: const InputDecoration(
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
                      onPressed: () async {
                        if (commentController.text != "") {
                          await addComment();
                          setState(() {
                            commentController.text = "";
                          });
                        }
                      },
                      icon: const Icon(Icons.send),
                    )),
                const Divider(),
                Expanded(
                    child: SingleChildScrollView(
                  child: Column(
                    children: ListTile.divideTiles(
                      context:
                          context, // Make sure to provide the BuildContext if this code is inside a widget build method
                      tiles: listComments.map((comment) {
                        return ListTile(
                            leading: avatar(userMap, comment.commentAuthor),
                            title: Text(
                                UserServices().getNameFromId(
                                    userMap, comment.commentAuthor),
                                style: const TextStyle(
                                    fontFamily: 'MontMed',
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold)),
                            subtitle: Text(
                              comment.commentContent,
                              style: const TextStyle(
                                  fontFamily: 'MontMed',
                                  fontSize: 13,
                                  color: Colors.black),
                            ),
                            trailing: Text('${comment.commentDate}',
                                style: const TextStyle(fontFamily: 'MontMed')));
                      }),
                    ).toList(),
                  ),
                )),
              ],
            ),
          );
        });
  }

  Future<void> addComment() async {
    CommentService commentService = CommentService();
    commentService.addComment(commentController.text, taskId);
  }
}

class StatefulBottomSheetWidget3 extends StatefulWidget {
  final TaskModel taskModel;
  final PhaseModel phaseModel;
  const StatefulBottomSheetWidget3(
      {super.key, required this.taskModel, required this.phaseModel});

  @override
  _StatefulBottomSheetWidget3State createState() =>
      _StatefulBottomSheetWidget3State();
}

class _StatefulBottomSheetWidget3State
    extends State<StatefulBottomSheetWidget3> {
  late TaskModel taskModel;
  late PhaseModel phaseModel;
  User? user;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    taskModel = widget.taskModel;
    phaseModel = widget.phaseModel;
    user = FirebaseAuth.instance.currentUser;
  }

  @override
  Widget build(BuildContext context) {
    return user == null
        ? loader()
        : StreamBuilder<List<Object>>(
            stream: CombineLatestStream.list([
              UserServices().databaseReference.child(user!.uid).onValue,
              ProjectServices().reference.onValue,
              TaskService().taskRef.onValue,
              TaskService().taskRef.child(taskModel.taskId).onValue,
              PhaseServices().phaseRef.child(phaseModel.phraseId).onValue,
            ]),
            builder: (context, snapshot) {
              if (!snapshot.hasData || snapshot.hasError) return loader();
              var userEvent = snapshot.data![0] as DatabaseEvent;
              var projectEvent = snapshot.data![1] as DatabaseEvent;
              var taskEvent = snapshot.data![2] as DatabaseEvent;
              var taskModelEvent = snapshot.data![3] as DatabaseEvent;
              var phaseEvent = snapshot.data![4] as DatabaseEvent;
              var userValue = userEvent.snapshot.value as dynamic;
              var projectValue = projectEvent.snapshot.value as dynamic;
              var taskValue = taskEvent.snapshot.value as dynamic;
              var taskModelValue = taskModelEvent.snapshot.value as dynamic;
              var phaseValue = phaseEvent.snapshot.value as dynamic;
              UserModel userModel = UserModel.fromMap(Map.from(userValue));
              Map projectMap = Map.from(projectValue);
              Map taskMap = Map.from(taskValue);
              phaseModel = PhaseModel.fromMap(Map.from(phaseValue));
              if (taskModelValue == null) {
                return ListOfTaskScreen(
                    userModel: userModel,
                    projectMap: projectMap,
                    taskMap: taskMap);
              }
              taskModel = TaskModel.fromMap(Map.from(taskModelValue));
              return Container(
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    const Row(
                      children: [
                        SizedBox(width: 25),
                        Text('Task Modification:',
                            style:
                                TextStyle(fontFamily: 'MontMed', fontSize: 16)),
                      ],
                    ),
                    const SizedBox(height: 5),
                    const Divider(),
                    ListTile(
                      leading: const CircleAvatar(
                        child: Icon(Icons.playlist_add_check),
                      ),
                      title: const Text('Mark as Done',
                          style:
                              TextStyle(fontFamily: 'MontMed', fontSize: 13)),
                      subtitle: const Text('Task Completion and Storage',
                          style:
                              TextStyle(fontFamily: 'MontMed', fontSize: 12)),
                      onTap: () {
                        TaskService()
                            .taskRef
                            .child(taskModel.taskId)
                            .update({'taskStatus': 'Complete'});
                        Navigator.of(context).pop();
                      },
                    ),
                    const Divider(),
                    ListTile(
                      leading: const CircleAvatar(
                        child: Icon(Icons.playlist_remove),
                      ),
                      title: const Text('Relaunch Task',
                          style:
                              TextStyle(fontFamily: 'MontMed', fontSize: 13)),
                      subtitle: const Text('Mark as Undone and Redo Task',
                          style:
                              TextStyle(fontFamily: 'MontMed', fontSize: 12)),
                      onTap: () {
                        TaskService()
                            .taskRef
                            .child(taskModel.taskId)
                            .update({'taskStatus': 'Incomplete'});
                        Navigator.of(context).pop();
                      },
                    ),
                    const Divider(),
                    ListTile(
                      leading: const CircleAvatar(
                        child: Icon(Icons.delete_outline),
                      ),
                      title: const Text('Dispose Task',
                          style:
                              TextStyle(fontFamily: 'MontMed', fontSize: 13)),
                      subtitle: const Text(
                          'Delete Task and Remove from Storage',
                          style:
                              TextStyle(fontFamily: 'MontMed', fontSize: 12)),
                      onTap: () async {
                        await TaskService()
                            .taskRef
                            .child(taskModel.taskId)
                            .remove();
                        await PhaseServices()
                            .deleteTaskInPhase(phaseModel, taskModel.taskId);
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return ListOfTaskScreen(
                                projectMap: projectMap,
                                userModel: userModel,
                                taskMap: taskMap,
                              );
                            },
                          ),
                          (Route<dynamic> route) => false,
                        );
                      },
                    ),
                    const Divider(),
                  ],
                ),
              );
            });
  }
}
