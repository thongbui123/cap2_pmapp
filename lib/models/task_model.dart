// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class TaskModel {
  String taskId;
  String taskName;
  String description;
  String status;
  String teamId;
  TaskModel({
    required this.taskId,
    required this.taskName,
    required this.description,
    required this.status,
    required this.teamId,
  });

  TaskModel copyWith({
    String? taskId,
    String? taskName,
    String? description,
    String? status,
    String? teamId,
  }) {
    return TaskModel(
      taskId: taskId ?? this.taskId,
      taskName: taskName ?? this.taskName,
      description: description ?? this.description,
      status: status ?? this.status,
      teamId: teamId ?? this.teamId,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'taskId': taskId,
      'taskName': taskName,
      'description': description,
      'status': status,
      'teamId': teamId,
    };
  }

  factory TaskModel.fromMap(Map<String, dynamic> map) {
    return TaskModel(
      taskId: map['taskId'] as String,
      taskName: map['taskName'] as String,
      description: map['description'] as String,
      status: map['status'] as String,
      teamId: map['teamId'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory TaskModel.fromJson(String source) =>
      TaskModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Task(taskId: $taskId, taskName: $taskName, description: $description, status: $status, teamId: $teamId)';
  }

  @override
  bool operator ==(covariant TaskModel other) {
    if (identical(this, other)) return true;

    return other.taskId == taskId &&
        other.taskName == taskName &&
        other.description == description &&
        other.status == status &&
        other.teamId == teamId;
  }

  @override
  int get hashCode {
    return taskId.hashCode ^
        taskName.hashCode ^
        description.hashCode ^
        status.hashCode ^
        teamId.hashCode;
  }
}
