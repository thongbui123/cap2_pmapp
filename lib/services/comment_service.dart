import 'package:capstone2_project_management_app/models/comment_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

class CommentService {
  DatabaseReference databaseReference = FirebaseDatabase.instance.ref();
  Future<Map<String, dynamic>> getCommentMap() async {
    Map<String, dynamic> commentMap = {};
    DatabaseEvent databaseEvent =
        await databaseReference.child('comments').once();
    if (databaseEvent.snapshot.value != null) {
      commentMap = Map.from(databaseEvent.snapshot.value as dynamic);
      List<MapEntry<dynamic, dynamic>> sortedEntries =
          commentMap.entries.toList();
      sortedEntries.sort((a, b) {
        return (b.value['timestamp'] as int)
            .compareTo(a.value['timestamp'] as int);
      });
      commentMap = Map.fromEntries(
        sortedEntries.map(
          (entry) {
            return MapEntry(
              entry.key,
              {
                'timestamp': entry.value['timestamp'],
                'commentId': entry.value['commentId'],
                'commentContent': entry.value['commentContent'],
                'commentAuthor': entry.value['commentAuthor'],
                'commentDate': entry.value['commentDate'],
                'taskId': entry.value['taskId'],
              },
            );
          },
        ),
      );
      return commentMap;
    }
    return {};
  }

  List<CommentModel> getListAllComments(
      Map<dynamic, dynamic> commentMap, String taskId) {
    List<CommentModel> listAllComments = [];
    for (var task in commentMap.values) {
      CommentModel commentModel =
          CommentModel.fromMap(Map<String, dynamic>.from(task));
      if (commentModel.taskId == taskId) {
        listAllComments.add(commentModel);
      }
    }
    return listAllComments;
  }

  int getListAllCommentLength(Map<dynamic, dynamic> commentMap, String taskId) {
    List<CommentModel> listAllComments = [];
    for (var task in commentMap.values) {
      CommentModel commentModel =
          CommentModel.fromMap(Map<String, dynamic>.from(task));
      if (commentModel.taskId == taskId) {
        listAllComments.add(commentModel);
      }
    }
    return listAllComments.length;
  }

  Future<void> addComment(
    String commentContent,
    String taskId,
  ) async {
    if (commentContent.isEmpty) {
      Fluttertoast.showToast(msg: 'Comment cannot be empty');
    }
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DatabaseReference commentRef =
          FirebaseDatabase.instance.ref().child('comments');
      String? commentId = commentRef.push().key;
      await commentRef.child(commentId!).set({
        'commentId': commentId,
        'commentContent': commentContent,
        'commentAuthor': user.uid,
        'commentDate': DateFormat('yyyy-MM-dd | HH:mm').format(DateTime.now()),
        'taskId': taskId,
        'timestamp': ServerValue.timestamp
      });
      Fluttertoast.showToast(msg: 'New comment has been added successfully');
    }
  }
}
