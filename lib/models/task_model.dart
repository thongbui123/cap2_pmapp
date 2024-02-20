// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

class TaskModel {
  String taskId;
  String taskName;
  String taskDescription;
  String taskStatus;
  String taskPriority;
  String taskStartDate;
  String taskEndDate;
  String projectId;
  String phraseId;
  List<String> taskMembers;
  TaskModel({
    required this.taskId,
    required this.taskName,
    required this.taskDescription,
    required this.taskStatus,
    required this.taskPriority,
    required this.taskStartDate,
    required this.taskEndDate,
    required this.projectId,
    required this.phraseId,
    required this.taskMembers,
  });

  TaskModel copyWith({
    String? taskId,
    String? taskName,
    String? taskDescription,
    String? taskStatus,
    String? taskPriority,
    String? taskStartDate,
    String? taskEndDate,
    String? projectId,
    String? phraseId,
    List<String>? taskMembers,
  }) {
    return TaskModel(
      taskId: taskId ?? this.taskId,
      taskName: taskName ?? this.taskName,
      taskDescription: taskDescription ?? this.taskDescription,
      taskStatus: taskStatus ?? this.taskStatus,
      taskPriority: taskPriority ?? this.taskPriority,
      taskStartDate: taskStartDate ?? this.taskStartDate,
      taskEndDate: taskEndDate ?? this.taskEndDate,
      projectId: projectId ?? this.projectId,
      phraseId: phraseId ?? this.phraseId,
      taskMembers: taskMembers ?? this.taskMembers,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'taskId': taskId,
      'taskName': taskName,
      'taskDescription': taskDescription,
      'taskStatus': taskStatus,
      'taskPriority': taskPriority,
      'taskStartDate': taskStartDate,
      'taskEndDate': taskEndDate,
      'projectId': projectId,
      'phraseId': phraseId,
      'taskMembers': taskMembers,
    };
  }

  factory TaskModel.fromMap(Map<String, dynamic> map) {
    return TaskModel(
      taskId: map['taskId'] as String,
      taskName: map['taskName'] as String,
      taskDescription: map['taskDescription'] as String,
      taskStatus: map['taskStatus'] as String,
      taskPriority: map['taskPriority'] as String,
      taskStartDate: map['taskStartDate'] as String,
      taskEndDate: map['taskEndDate'] as String,
      projectId: map['projectId'] as String,
      phraseId: map['phraseId'] as String,
      taskMembers: List<String>.from(
        (map['taskMembers'] as List<dynamic>?)
                ?.map((task) => task as String)
                .toList() ??
            [],
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory TaskModel.fromJson(String source) =>
      TaskModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'TaskModel(taskId: $taskId, taskName: $taskName, taskDescription: $taskDescription, taskStatus: $taskStatus, taskPriority: $taskPriority, taskStartDate: $taskStartDate, taskEndDate: $taskEndDate, projectId: $projectId, phraseId: $phraseId, taskMembers: $taskMembers)';
  }

  @override
  bool operator ==(covariant TaskModel other) {
    if (identical(this, other)) return true;

    return other.taskId == taskId &&
        other.taskName == taskName &&
        other.taskDescription == taskDescription &&
        other.taskStatus == taskStatus &&
        other.taskPriority == taskPriority &&
        other.taskStartDate == taskStartDate &&
        other.taskEndDate == taskEndDate &&
        other.projectId == projectId &&
        other.phraseId == phraseId &&
        listEquals(other.taskMembers, taskMembers);
  }

  @override
  int get hashCode {
    return taskId.hashCode ^
        taskName.hashCode ^
        taskDescription.hashCode ^
        taskStatus.hashCode ^
        taskPriority.hashCode ^
        taskStartDate.hashCode ^
        taskEndDate.hashCode ^
        projectId.hashCode ^
        phraseId.hashCode ^
        taskMembers.hashCode;
  }
}
