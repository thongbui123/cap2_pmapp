import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CommentService {
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
        'taskId': taskId,
        'timestamp': ServerValue.timestamp
      });
      Fluttertoast.showToast(msg: 'New comment has been added successfully');
    }
  }
}
