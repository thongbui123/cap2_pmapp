import 'package:capstone2_project_management_app/models/notification_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

class NotificationService {
  DatabaseReference databaseReference =
      FirebaseDatabase.instance.ref().child('notifications');

  Future<Map<String, dynamic>> getNotificationMap() async {
    Map<String, dynamic> notificationMap = {};
    DatabaseEvent databaseEvent = await databaseReference.once();
    if (databaseEvent.snapshot.value != null) {
      notificationMap = Map.from(databaseEvent.snapshot.value as dynamic);
      return getSortedMap(notificationMap);
    }
    return {};
  }

  Map<String, dynamic> getSortedMap(Map<String, dynamic> notificationMap) {
    List<MapEntry<dynamic, dynamic>> sortedEntries =
        notificationMap.entries.toList();
    sortedEntries.sort((a, b) {
      return (b.value['timestamp'] as int)
          .compareTo(a.value['timestamp'] as int);
    });
    notificationMap = Map.fromEntries(
      sortedEntries.map(
        (entry) {
          return MapEntry(
            entry.key,
            {
              'timestamp': entry.value['timestamp'],
              'notificationId': entry.value['notificationId'],
              'notificationContent': entry.value['notificationContent'],
              'notificationType': entry.value['notificationType'],
              'notificationAuth': entry.value['notificationAuth'],
              'notificationDate': entry.value['notificationDate'],
              'notificationRelatedId': entry.value['notificationRelatedId'],
              'notificationReceiver': entry.value['notificationReceiver'],
              'readOrNot': entry.value['readOrNot']
            },
          );
        },
      ),
    );
    return notificationMap;
  }

  Future<void> addNotification(
      String notificationContent,
      String notificationRelatedId,
      List<String> notificationReceiver,
      String notificationType) async {
    if (notificationContent.isEmpty) {
      Fluttertoast.showToast(msg: 'Notification cannot be empty');
    }
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DatabaseReference notificationRef =
          FirebaseDatabase.instance.ref().child('notifications');
      String? notificationId = notificationRef.push().key;
      await notificationRef.child(notificationId!).set({
        'notificationId': notificationId,
        'notificationContent': notificationContent,
        'notificationType': notificationType,
        'notificationAuth': user.uid,
        'notificationDate':
            DateFormat('yyyy-MM-dd | HH:mm').format(DateTime.now()),
        'notificationRelatedId': notificationRelatedId,
        'notificationReceiver': notificationReceiver,
        'readOrNot': 'No',
        'timestamp': ServerValue.timestamp
      });
    }
  }

  Future<void> updateReadOrNot(String notificationId) async {
    await databaseReference.child(notificationId).update({
      'readOrNot': 'Yes',
    });
  }

  List<NotificationModel> getListAllNotifications(
      Map<dynamic, dynamic> notificationMap, String relatedId) {
    List<NotificationModel> listAllNotifications = [];
    for (var task in notificationMap.values) {
      NotificationModel notificationModel =
          NotificationModel.fromMap(Map<String, dynamic>.from(task));
      if (notificationModel.notificationReceiver.contains(relatedId)) {
        listAllNotifications.add(notificationModel);
      }
    }
    return listAllNotifications;
  }

  List<NotificationModel> getListAllNotRead(
      Map<dynamic, dynamic> notificationMap, String relatedId) {
    List<NotificationModel> listAllNotifications = [];
    for (var task in notificationMap.values) {
      NotificationModel notificationModel =
          NotificationModel.fromMap(Map<String, dynamic>.from(task));
      if (notificationModel.notificationReceiver.contains(relatedId) &&
          notificationModel.readOrNot == 'No') {
        listAllNotifications.add(notificationModel);
      }
    }
    return listAllNotifications;
  }
}
