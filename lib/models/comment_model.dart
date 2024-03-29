// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class CommentModel {
  String commentId;
  String commentContent;
  String commentAuthor;
  String commentDate;
  String taskId;
  CommentModel({
    required this.commentId,
    required this.commentContent,
    required this.commentAuthor,
    required this.commentDate,
    required this.taskId,
  });

  CommentModel copyWith({
    String? commentId,
    String? commentContent,
    String? commentAuthor,
    String? commentDate,
    String? taskId,
  }) {
    return CommentModel(
      commentId: commentId ?? this.commentId,
      commentContent: commentContent ?? this.commentContent,
      commentAuthor: commentAuthor ?? this.commentAuthor,
      commentDate: commentDate ?? this.commentDate,
      taskId: taskId ?? this.taskId,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'commentId': commentId,
      'commentContent': commentContent,
      'commentAuthor': commentAuthor,
      'commentDate': commentDate,
      'taskId': taskId,
    };
  }

  factory CommentModel.fromMap(Map<String, dynamic> map) {
    return CommentModel(
      commentId: map['commentId'] as String,
      commentContent: map['commentContent'] as String,
      commentAuthor: map['commentAuthor'] as String,
      commentDate: map['commentDate'] as String,
      taskId: map['taskId'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory CommentModel.fromJson(String source) =>
      CommentModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'CommentModel(commentId: $commentId, commentContent: $commentContent, commentAuthor: $commentAuthor, commentDate: $commentDate, taskId: $taskId)';
  }

  @override
  bool operator ==(covariant CommentModel other) {
    if (identical(this, other)) return true;

    return other.commentId == commentId &&
        other.commentContent == commentContent &&
        other.commentAuthor == commentAuthor &&
        other.commentDate == commentDate &&
        other.taskId == taskId;
  }

  @override
  int get hashCode {
    return commentId.hashCode ^
        commentContent.hashCode ^
        commentAuthor.hashCode ^
        commentDate.hashCode ^
        taskId.hashCode;
  }
}
