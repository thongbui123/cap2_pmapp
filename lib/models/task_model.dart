// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class TaskModel {
  String taskId;
  String taskName;
  String description;
  String status;
  String projectId;
  String phraseId;
  TaskModel({
    required this.taskId,
    required this.taskName,
    required this.description,
    required this.status,
    required this.projectId,
    required this.phraseId,
  });

  TaskModel copyWith({
    String? taskId,
    String? taskName,
    String? description,
    String? status,
    String? projectId,
    String? phraseId,
  }) {
    return TaskModel(
      taskId: taskId ?? this.taskId,
      taskName: taskName ?? this.taskName,
      description: description ?? this.description,
      status: status ?? this.status,
      projectId: projectId ?? this.projectId,
      phraseId: phraseId ?? this.phraseId,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'taskId': taskId,
      'taskName': taskName,
      'description': description,
      'status': status,
      'projectId': projectId,
      'phraseId': phraseId,
    };
  }

  factory TaskModel.fromMap(Map<String, dynamic> map) {
    return TaskModel(
      taskId: map['taskId'] as String,
      taskName: map['taskName'] as String,
      description: map['description'] as String,
      status: map['status'] as String,
      projectId: map['projectId'] as String,
      phraseId: map['phraseId'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory TaskModel.fromJson(String source) =>
      TaskModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'TaskModel(taskId: $taskId, taskName: $taskName, description: $description, status: $status, projectId: $projectId, phraseId: $phraseId)';
  }

  @override
  bool operator ==(covariant TaskModel other) {
    if (identical(this, other)) return true;

    return other.taskId == taskId &&
        other.taskName == taskName &&
        other.description == description &&
        other.status == status &&
        other.projectId == projectId &&
        other.phraseId == phraseId;
  }

  @override
  int get hashCode {
    return taskId.hashCode ^
        taskName.hashCode ^
        description.hashCode ^
        status.hashCode ^
        projectId.hashCode ^
        phraseId.hashCode;
  }
}
