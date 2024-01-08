// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

class TeamModel {
  String teamId;
  String teamName;
  String teamLeader;
  List<String> teamMembers;
  TeamModel({
    required this.teamId,
    required this.teamName,
    required this.teamLeader,
    required this.teamMembers,
  });

  TeamModel copyWith({
    String? teamId,
    String? teamName,
    String? teamLeader,
    List<String>? teamMembers,
  }) {
    return TeamModel(
      teamId: teamId ?? this.teamId,
      teamName: teamName ?? this.teamName,
      teamLeader: teamLeader ?? this.teamLeader,
      teamMembers: teamMembers ?? this.teamMembers,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'teamId': teamId,
      'teamName': teamName,
      'teamLeader': teamLeader,
      'teamMembers': teamMembers,
    };
  }

  factory TeamModel.fromMap(Map<String, dynamic> map) {
    return TeamModel(
        teamId: map['teamId'] as String,
        teamName: map['teamName'] as String,
        teamLeader: map['teamLeader'] as String,
        teamMembers: List<String>.from(
          (map['teamMembers']),
        ));
  }

  String toJson() => json.encode(toMap());

  factory TeamModel.fromJson(String source) =>
      TeamModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'TeamModel(teamId: $teamId, teamName: $teamName, teamLeader: $teamLeader, teamMembers: $teamMembers)';
  }

  @override
  bool operator ==(covariant TeamModel other) {
    if (identical(this, other)) return true;

    return other.teamId == teamId &&
        other.teamName == teamName &&
        other.teamLeader == teamLeader &&
        listEquals(other.teamMembers, teamMembers);
  }

  @override
  int get hashCode {
    return teamId.hashCode ^
        teamName.hashCode ^
        teamLeader.hashCode ^
        teamMembers.hashCode;
  }
}
