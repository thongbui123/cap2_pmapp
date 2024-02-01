import 'package:capstone2_project_management_app/models/user_model.dart';
import 'package:flutter/material.dart';

class StatefulBottomSheetWidget extends StatefulWidget {
  final String message;
  final List<UserModel> allMembers;
  final List<String> currentList;
  StatefulBottomSheetWidget(
      {required this.message,
      required this.allMembers,
      required this.currentList});

  @override
  _StatefulBottomSheetWidgetState createState() =>
      _StatefulBottomSheetWidgetState();
}

class _StatefulBottomSheetWidgetState extends State<StatefulBottomSheetWidget> {
  late List<UserModel> allMembers;
  late List<String> currentList;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    allMembers = widget.allMembers;
    currentList = widget.currentList;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          const SizedBox(height: 10),
          Container(
              child: TextButton(
            onPressed: _showMemberSelectionDialog,
            child: const Row(
              children: [
                Icon(
                  Icons.add,
                  color: Colors.blueAccent,
                ),
                SizedBox(width: 10),
                Text(
                  'Add New Participant',
                  style: TextStyle(
                      fontFamily: 'MontMed', color: Colors.blueAccent),
                ),
              ],
            ),
          )),
          const SizedBox(height: 10),
          Expanded(
            child: Column(
              children: ListTile.divideTiles(
                context:
                    context, // Make sure to provide the BuildContext if this code is inside a widget build method
                tiles: currentList.map((member) {
                  return ListTile(
                    leading: const CircleAvatar(
                      child: Icon(
                        Icons.person,
                      ),
                    ),
                    title: Text(member,
                        style: const TextStyle(
                            fontFamily: 'MontMed', fontSize: 13)),
                    subtitle: const Text(
                      'Participants: 3',
                      style: TextStyle(fontFamily: 'MontMed', fontSize: 12),
                    ),
                    trailing: Ink(
                      decoration: const ShapeDecoration(
                        color: Colors.transparent,
                        shape: CircleBorder(),
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.delete),
                        color: Colors.red,
                        onPressed: () {
                          _showDeleteMemberDialog(member);
                        },
                      ),
                    ),
                  );
                }),
              ).toList(),
            ),
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
                          child: Text(
                        'A',
                        style: TextStyle(fontFamily: 'MontMed'),
                      )),
                      title: Text(user.userId),
                      subtitle: const Text(
                        '2 Projects Involved',
                        style: TextStyle(fontFamily: 'MontMed'),
                      ),
                      onTap: () {
                        setState(() {
                          currentList.add(user.userId);
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
