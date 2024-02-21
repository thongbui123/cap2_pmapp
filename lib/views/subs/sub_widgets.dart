import 'package:capstone2_project_management_app/services/user_services.dart';
import 'package:flutter/material.dart';

Widget loader() {
  return const Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
      ),
      SizedBox(
        height: 10,
      ),
      Text(
        'Please Wait',
        style: TextStyle(fontFamily: 'MontMed', fontSize: 14),
      ),
    ],
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
