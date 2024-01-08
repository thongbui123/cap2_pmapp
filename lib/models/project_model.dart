// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

class ProjectModel {
  String projectId;
  String projectName;
  String projecctDescription;
  String startDate;
  String startEnd;
  String status;
  String managerId;
  List<String> projectMembers;
  List<String> memberId;
  ProjectModel({
    required this.projectId,
    required this.projectName,
    required this.projecctDescription,
    required this.startDate,
    required this.startEnd,
    required this.status,
    required this.managerId,
    required this.projectMembers,
    required this.memberId,
  });

  ProjectModel copyWith({
    String? projectId,
    String? projectName,
    String? projecctDescription,
    String? startDate,
    String? startEnd,
    String? status,
    String? managerId,
    List<String>? projectMembers,
    List<String>? memberId,
  }) {
    return ProjectModel(
      projectId: projectId ?? this.projectId,
      projectName: projectName ?? this.projectName,
      projecctDescription: projecctDescription ?? this.projecctDescription,
      startDate: startDate ?? this.startDate,
      startEnd: startEnd ?? this.startEnd,
      status: status ?? this.status,
      managerId: managerId ?? this.managerId,
      projectMembers: projectMembers ?? this.projectMembers,
      memberId: memberId ?? this.memberId,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'projectId': projectId,
      'projectName': projectName,
      'projecctDescription': projecctDescription,
      'startDate': startDate,
      'startEnd': startEnd,
      'status': status,
      'managerId': managerId,
      'projectMembers': projectMembers,
      'memberId': memberId,
    };
  }

  factory ProjectModel.fromMap(Map<String, dynamic> map) {
    return ProjectModel(
      projectId: map['projectId'] as String,
      projectName: map['projectName'] as String,
      projecctDescription: map['projecctDescription'] as String,
      startDate: map['startDate'] as String,
      startEnd: map['startEnd'] as String,
      status: map['status'] as String,
      managerId: map['managerId'] as String,
      projectMembers:
          List<String>.from((map['projectMembers'] as List<String>)),
      memberId: List<String>.from((map['memberId'] as List<String>)),
    );
  }

  String toJson() => json.encode(toMap());

  factory ProjectModel.fromJson(String source) =>
      ProjectModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ProjectModel(projectId: $projectId, projectName: $projectName, projecctDescription: $projecctDescription, startDate: $startDate, startEnd: $startEnd, status: $status, managerId: $managerId, projectMembers: $projectMembers, memberId: $memberId)';
  }

  @override
  bool operator ==(covariant ProjectModel other) {
    if (identical(this, other)) return true;

    return other.projectId == projectId &&
        other.projectName == projectName &&
        other.projecctDescription == projecctDescription &&
        other.startDate == startDate &&
        other.startEnd == startEnd &&
        other.status == status &&
        other.managerId == managerId &&
        listEquals(other.projectMembers, projectMembers) &&
        listEquals(other.memberId, memberId);
  }

  @override
  int get hashCode {
    return projectId.hashCode ^
        projectName.hashCode ^
        projecctDescription.hashCode ^
        startDate.hashCode ^
        startEnd.hashCode ^
        status.hashCode ^
        managerId.hashCode ^
        projectMembers.hashCode ^
        memberId.hashCode;
  }
}
