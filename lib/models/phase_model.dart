// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

class PhaseModel {
  String phaseId;
  String projectId;
  String phaseName;
  String phaseDescription;
  List<String> listTasks;
  PhaseModel({
    required this.phaseId,
    required this.projectId,
    required this.phaseName,
    required this.phaseDescription,
    required this.listTasks,
  });

  PhaseModel copyWith({
    String? phaseId,
    String? projectId,
    String? phaseName,
    String? phaseDescription,
    List<String>? listTasks,
  }) {
    return PhaseModel(
      phaseId: phaseId ?? this.phaseId,
      projectId: projectId ?? this.projectId,
      phaseName: phaseName ?? this.phaseName,
      phaseDescription: phaseDescription ?? this.phaseDescription,
      listTasks: listTasks ?? this.listTasks,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'phaseId': phaseId,
      'projectId': projectId,
      'phaseName': phaseName,
      'phaseDescription': phaseDescription,
      'listTasks': listTasks,
    };
  }

  factory PhaseModel.fromMap(Map<String, dynamic> map) {
    return PhaseModel(
        phaseId: map['phaseId'] as String,
        projectId: map['projectId'] as String,
        phaseName: map['phaseName'] as String,
        phaseDescription: map['phaseDescription'] as String,
        listTasks: List<String>.from(
          (map['listTasks'] as List<dynamic>?)
                  ?.map((task) => task as String)
                  .toList() ??
              [],
        ));
  }

  String toJson() => json.encode(toMap());

  factory PhaseModel.fromJson(String source) =>
      PhaseModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'PhaseModel(phaseId: $phaseId, projectId: $projectId, phaseName: $phaseName, phaseDescription: $phaseDescription, listTasks: $listTasks)';
  }

  @override
  bool operator ==(covariant PhaseModel other) {
    if (identical(this, other)) return true;

    return other.phaseId == phaseId &&
        other.projectId == projectId &&
        other.phaseName == phaseName &&
        other.phaseDescription == phaseDescription &&
        listEquals(other.listTasks, listTasks);
  }

  @override
  int get hashCode {
    return phaseId.hashCode ^
        projectId.hashCode ^
        phaseName.hashCode ^
        phaseDescription.hashCode ^
        listTasks.hashCode;
  }
}
