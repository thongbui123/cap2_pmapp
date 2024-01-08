// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

class PhraseModel {
  String prhaseId;
  String projectId;
  String phraseName;
  String phraseDescription;
  List<String> listTasks;
  PhraseModel({
    required this.prhaseId,
    required this.projectId,
    required this.phraseName,
    required this.phraseDescription,
    required this.listTasks,
  });

  PhraseModel copyWith({
    String? prhaseId,
    String? projectId,
    String? phraseName,
    String? phraseDescription,
    List<String>? listTasks,
  }) {
    return PhraseModel(
      prhaseId: prhaseId ?? this.prhaseId,
      projectId: projectId ?? this.projectId,
      phraseName: phraseName ?? this.phraseName,
      phraseDescription: phraseDescription ?? this.phraseDescription,
      listTasks: listTasks ?? this.listTasks,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'prhaseId': prhaseId,
      'projectId': projectId,
      'phraseName': phraseName,
      'phraseDescription': phraseDescription,
      'listTasks': listTasks,
    };
  }

  factory PhraseModel.fromMap(Map<String, dynamic> map) {
    return PhraseModel(
      prhaseId: map['prhaseId'] as String,
      projectId: map['projectId'] as String,
      phraseName: map['phraseName'] as String,
      phraseDescription: map['phraseDescription'] as String,
      listTasks: List<String>.from((map['listTasks'])),
    );
  }

  String toJson() => json.encode(toMap());

  factory PhraseModel.fromJson(String source) =>
      PhraseModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'PhraseModel(prhaseId: $prhaseId, projectId: $projectId, phraseName: $phraseName, phraseDescription: $phraseDescription, listTasks: $listTasks)';
  }

  @override
  bool operator ==(covariant PhraseModel other) {
    if (identical(this, other)) return true;

    return other.prhaseId == prhaseId &&
        other.projectId == projectId &&
        other.phraseName == phraseName &&
        other.phraseDescription == phraseDescription &&
        listEquals(other.listTasks, listTasks);
  }

  @override
  int get hashCode {
    return prhaseId.hashCode ^
        projectId.hashCode ^
        phraseName.hashCode ^
        phraseDescription.hashCode ^
        listTasks.hashCode;
  }
}
