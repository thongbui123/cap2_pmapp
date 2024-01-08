// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

class ProjectModel {
  String projectId;
  String projectName;
  String projecctDescription;
  String startDate;
  String endDate;
  String projectStatus;
  String managerId;
  String leaderId;
  List<String> projectMembers;
  ProjectModel({
    required this.projectId,
    required this.projectName,
    required this.projecctDescription,
    required this.startDate,
    required this.endDate,
    required this.projectStatus,
    required this.managerId,
    required this.leaderId,
    required this.projectMembers,
  });

  ProjectModel copyWith({
    String? projectId,
    String? projectName,
    String? projecctDescription,
    String? startDate,
    String? endDate,
    String? projectStatus,
    String? managerId,
    String? leaderId,
    List<String>? projectMembers,
  }) {
    return ProjectModel(
      projectId: projectId ?? this.projectId,
      projectName: projectName ?? this.projectName,
      projecctDescription: projecctDescription ?? this.projecctDescription,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      projectStatus: projectStatus ?? this.projectStatus,
      managerId: managerId ?? this.managerId,
      leaderId: leaderId ?? this.leaderId,
      projectMembers: projectMembers ?? this.projectMembers,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'projectId': projectId,
      'projectName': projectName,
      'projecctDescription': projecctDescription,
      'startDate': startDate,
      'endDate': endDate,
      'projectStatus': projectStatus,
      'managerId': managerId,
      'leaderId': leaderId,
      'projectMembers': projectMembers,
    };
  }

  factory ProjectModel.fromMap(Map<String, dynamic> map) {
    return ProjectModel(
        projectId: map['projectId'] as String,
        projectName: map['projectName'] as String,
        projecctDescription: map['projecctDescription'] as String,
        startDate: map['startDate'] as String,
        endDate: map['endDate'] as String,
        projectStatus: map['projectStatus'] as String,
        managerId: map['managerId'] as String,
        leaderId: map['leaderId'] as String,
        projectMembers: List<String>.from(
          (map['projectMembers']),
        ));
  }

  String toJson() => json.encode(toMap());

  factory ProjectModel.fromJson(String source) =>
      ProjectModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ProjectModel(projectId: $projectId, projectName: $projectName, projecctDescription: $projecctDescription, startDate: $startDate, endDate: $endDate, projectStatus: $projectStatus, managerId: $managerId, leaderId: $leaderId, projectMembers: $projectMembers)';
  }

  @override
  bool operator ==(covariant ProjectModel other) {
    if (identical(this, other)) return true;

    return other.projectId == projectId &&
        other.projectName == projectName &&
        other.projecctDescription == projecctDescription &&
        other.startDate == startDate &&
        other.endDate == endDate &&
        other.projectStatus == projectStatus &&
        other.managerId == managerId &&
        other.leaderId == leaderId &&
        listEquals(other.projectMembers, projectMembers);
  }

  @override
  int get hashCode {
    return projectId.hashCode ^
        projectName.hashCode ^
        projecctDescription.hashCode ^
        startDate.hashCode ^
        endDate.hashCode ^
        projectStatus.hashCode ^
        managerId.hashCode ^
        leaderId.hashCode ^
        projectMembers.hashCode;
  }
}
