import 'package:capstone2_project_management_app/views/subs/bottom_sheet_widget.dart';
import 'package:flutter/material.dart';

class DeleteMemberDialog extends State<StatefulBottomSheetWidget> {
  final String member;
  final List<String> currentList;

  DeleteMemberDialog({required this.member, required this.currentList});

  showDeleteMemberDialog(BuildContext context) async {
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
                currentList.remove(member);
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

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
