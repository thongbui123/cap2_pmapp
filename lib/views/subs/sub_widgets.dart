import 'package:capstone2_project_management_app/services/user_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

String uid = FirebaseAuth.instance.currentUser!.uid;

ColoredBox loader() {
  return const ColoredBox(
    color: Colors.white,
    child: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          CircularProgressIndicator(),
          SizedBox(
              height: 16), // Space between CircularProgressIndicator and Text
          Text(
            'Please Wait...',
            style: TextStyle(
                fontSize: 15,
                fontFamily: 'MontMed',
                color: Colors.black,
                decoration: TextDecoration.none),
          ),
        ],
      ),
    ),
  );
}

CircleAvatar avatar(Map<String, dynamic> userMap, String member) {
  UserServices userServices = UserServices();
  return CircleAvatar(
    child: userServices.getAvatarFromId(userMap, member) == ''
        ? Text(
            userServices.getFirstLetter(
                userServices.getNameFromId(userMap, member).toString()),
            style: const TextStyle(fontFamily: 'MontMed'),
          )
        : CircleAvatar(
            radius: 66,
            backgroundColor: Colors.white,
            backgroundImage: userServices.showLocalFile
                ? FileImage(userServices.imageFile!) as ImageProvider
                : NetworkImage(
                    userServices.getAvatarFromId(userMap, member)!,
                  ),
          ),
  );
}

Future<void> showDateDialog(
    DateTime selectedDate, BuildContext buildContext) async {
  return showDialog<void>(
    context: buildContext,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Selected Date'),
        content: Text('You selected: $selectedDate'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('OK'),
          ),
        ],
      );
    },
  );
}
