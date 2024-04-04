import 'package:capstone2_project_management_app/models/phase_model.dart';
import 'package:capstone2_project_management_app/models/project_model.dart';
import 'package:capstone2_project_management_app/models/task_model.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import '../models/user_model.dart';

class StreamBuilderService {
  bool getCondition(AsyncSnapshot<List<Object>> snapshot) {
    return !snapshot.hasData ||
        snapshot.hasError ||
        snapshot.connectionState == ConnectionState.waiting;
  }

  Map getMapFromSnapshot(AsyncSnapshot<Object> snapshot) {
    var event = snapshot.data as DatabaseEvent;
    var value = event.snapshot.value as dynamic;
    return Map.from(value);
  }

  Map getMapFromSnapshotList(AsyncSnapshot<List<Object>> snapshot, int index) {
    var event = snapshot.data?[index] as DatabaseEvent;
    var value = event.snapshot.value as dynamic;
    return Map.from(value);
  }

  ProjectModel getProjectModelFromSnapshotList(
      AsyncSnapshot<List<Object>> snapshot, int index) {
    var event = snapshot.data![index] as DatabaseEvent;
    var value = event.snapshot.value as dynamic;
    Map<String, dynamic> map = Map.from(value);
    return ProjectModel.fromMap(map);
  }

  ProjectModel getProjectModelFromSnapshot(
      AsyncSnapshot<List<Object>> snapshot) {
    var event = snapshot.data! as DatabaseEvent;
    var value = event.snapshot.value as dynamic;
    Map<String, dynamic> map = Map.from(value);
    return ProjectModel.fromMap(map);
  }

  TaskModel getTaskModelFromSnapshotList(
      AsyncSnapshot<List<Object>> snapshot, int index) {
    var event = snapshot.data![index] as DatabaseEvent;
    var value = event.snapshot.value as dynamic;
    Map<String, dynamic> map = Map.from(value);
    return TaskModel.fromMap(map);
  }

  TaskModel getTaskModelFromSnapshot(AsyncSnapshot<List<Object>> snapshot) {
    var event = snapshot.data! as DatabaseEvent;
    var value = event.snapshot.value as dynamic;
    Map<String, dynamic> map = Map.from(value);
    return TaskModel.fromMap(map);
  }

  PhaseModel getPhaseModelFromSnapshotList(
      AsyncSnapshot<List<Object>> snapshot, int index) {
    var event = snapshot.data![index] as DatabaseEvent;
    var value = event.snapshot.value as dynamic;
    Map<String, dynamic> map = Map.from(value);
    return PhaseModel.fromMap(map);
  }

  PhaseModel getPhaseModelFromSnapshot(AsyncSnapshot<List<Object>> snapshot) {
    var event = snapshot.data! as DatabaseEvent;
    var value = event.snapshot.value as dynamic;
    Map<String, dynamic> map = Map.from(value);
    return PhaseModel.fromMap(map);
  }

  UserModel getUserModelFromSnapshotList(
      AsyncSnapshot<List<Object>> snapshot, int index) {
    var event = snapshot.data![index] as DatabaseEvent;
    var value = event.snapshot.value as dynamic;
    Map<String, dynamic> map = Map.from(value);
    return UserModel.fromMap(map);
  }

  UserModel getUserModelFromSnapshot(AsyncSnapshot<List<Object>> snapshot) {
    var event = snapshot.data! as DatabaseEvent;
    var value = event.snapshot.value as dynamic;
    Map<String, dynamic> map = Map.from(value);
    return UserModel.fromMap(map);
  }
}
