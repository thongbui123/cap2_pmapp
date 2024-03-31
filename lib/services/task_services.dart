import 'package:capstone2_project_management_app/models/task_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:fluttertoast/fluttertoast.dart';

class TaskService {
  DatabaseReference taskRef = FirebaseDatabase.instance.ref().child('tasks');
  late String realTaskId;
  Future<void> addTask(
    String taskName,
    String taskDescription,
    String taskPriority,
    String taskStartDate,
    String taskEndDate,
    String projectId,
    String assignById,
    String phraseId,
    List<String> taskMembers,
  ) async {
    if (taskName.isEmpty) {
      Fluttertoast.showToast(msg: 'Please provide task name');
    }
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DatabaseReference taskRef =
          FirebaseDatabase.instance.ref().child('tasks');
      String? taskId = taskRef.push().key;
      realTaskId = taskId!;
      await taskRef.child(taskId).set({
        'taskId': taskId,
        'taskName': taskName,
        'taskStartDate': taskStartDate,
        'taskEndDate': taskEndDate,
        'taskPriority': taskPriority,
        'taskStatus': 'Incomplete',
        'projectId': projectId,
        'phraseId': phraseId,
        'assignById': assignById,
        'taskDescription': taskDescription,
        'taskMembers': taskMembers,
        'timestamp': ServerValue.timestamp
      });
      Fluttertoast.showToast(msg: 'New task has been created successfully');
    }
  }

  List<TaskModel> getJoinedTaskListFromProject(
      Map<dynamic, dynamic> taskMap, String memberId, String projectId) {
    List<TaskModel> listAllTasks = [];
    for (var task in taskMap.values) {
      TaskModel taskModel = TaskModel.fromMap(Map<String, dynamic>.from(task));
      DateTime now = DateTime.now();
      DateTime endDate = DateTime.parse(taskModel.taskEndDate);
      if ((taskModel.taskMembers.contains(memberId) ||
              taskModel.assignById == memberId) &&
          taskModel.projectId == projectId) {
        if (taskModel.taskStatus != 'Complete' && now.isBefore(endDate)) {
          listAllTasks.add(taskModel);
        }
      }
    }
    return listAllTasks;
  }

  List<TaskModel> getTaskListOnlyContainUser(
      Map<dynamic, dynamic> taskMap, String memberId) {
    List<TaskModel> listAllTasks = [];
    for (var task in taskMap.values) {
      TaskModel taskModel = TaskModel.fromMap(Map<String, dynamic>.from(task));
      if ((taskModel.taskMembers.contains(memberId) ||
          taskModel.assignById == memberId)) {
        listAllTasks.add(taskModel);
      }
    }
    return listAllTasks;
  }

  List<TaskModel> getJoinedTaskListFromUser(
      Map<dynamic, dynamic> taskMap, String memberId) {
    List<TaskModel> listAllTasks = [];
    for (var task in taskMap.values) {
      TaskModel taskModel = TaskModel.fromMap(Map<String, dynamic>.from(task));
      DateTime now = DateTime.now();
      DateTime endDate = DateTime.parse(taskModel.taskEndDate);
      if ((taskModel.taskMembers.contains(memberId) ||
              taskModel.assignById == memberId) &&
          endDate.isAfter(now) &&
          (taskModel.taskStatus == 'Incomplete')) {
        listAllTasks.add(taskModel);
      }
    }
    return listAllTasks;
  }

  int getTaskNumberHasFromProject(
      Map<dynamic, dynamic> taskMap, String projectId) {
    int count = 0;
    for (var task in taskMap.values) {
      TaskModel taskModel = TaskModel.fromMap(Map<String, dynamic>.from(task));
      if (taskModel.projectId == projectId) {
        count++;
      }
    }
    return count;
  }

  int getJoinedTaskNumber(Map<dynamic, dynamic> taskMap, String memberId) {
    int count = 0;
    for (var task in taskMap.values) {
      TaskModel taskModel = TaskModel.fromMap(Map<String, dynamic>.from(task));
      if ((taskModel.taskMembers.contains(memberId) ||
          taskModel.assignById == memberId)) {
        count++;
      }
    }
    return count;
  }

  int getJoinedTaskNumberFromProject(
      Map<dynamic, dynamic> taskMap, String memberId, String projectId) {
    int count = 0;
    for (var task in taskMap.values) {
      TaskModel taskModel = TaskModel.fromMap(Map<String, dynamic>.from(task));
      if ((taskModel.taskMembers.contains(memberId) ||
              taskModel.assignById == memberId) &&
          taskModel.projectId == projectId) {
        count++;
      }
    }
    return count;
  }

  List<TaskModel> getOverdouTaskList(Map<dynamic, dynamic> taskMap, String id) {
    List<TaskModel> listOverdou = [];
    for (var task in taskMap.values) {
      TaskModel taskModel = TaskModel.fromMap(Map<String, dynamic>.from(task));
      DateTime now = DateTime.now();
      DateTime endDate = DateTime.parse(taskModel.taskEndDate);
      if ((taskModel.taskMembers.contains(id) || taskModel.assignById == id) &&
          now.isAfter(endDate)) {
        if (taskModel.taskStatus == 'Incomplete') {
          listOverdou.add(taskModel);
        }
      }
    }
    return listOverdou;
  }

  List<TaskModel> getOverdouTaskListFromProject(
      Map<dynamic, dynamic> taskMap, String id, String projectId) {
    List<TaskModel> listOverdou = [];
    for (var task in taskMap.values) {
      TaskModel taskModel = TaskModel.fromMap(Map<String, dynamic>.from(task));
      DateTime now = DateTime.now();
      DateTime endDate = DateTime.parse(taskModel.taskEndDate);
      if ((taskModel.taskMembers.contains(id) || taskModel.assignById == id) &&
          now.isAfter(endDate) &&
          taskModel.projectId == projectId) {
        if (taskModel.taskStatus == 'Incomplete') {
          listOverdou.add(taskModel);
        }
      }
    }
    return listOverdou;
  }

  List<TaskModel> getCompleteTaskList(
      Map<dynamic, dynamic> taskMap, String id) {
    List<TaskModel> listOverdou = [];
    for (var task in taskMap.values) {
      TaskModel taskModel = TaskModel.fromMap(Map<String, dynamic>.from(task));
      if ((taskModel.taskMembers.contains(id) || taskModel.assignById == id)) {
        if (taskModel.taskStatus == 'Complete') {
          listOverdou.add(taskModel);
        }
      }
    }
    return listOverdou;
  }

  List<TaskModel> getCompleteTaskListByProject(
      Map<dynamic, dynamic> taskMap, String id, String projectId) {
    List<TaskModel> listOverdou = [];
    for (var task in taskMap.values) {
      TaskModel taskModel = TaskModel.fromMap(Map<String, dynamic>.from(task));
      if ((taskModel.taskMembers.contains(id) || taskModel.assignById == id) &&
          taskModel.projectId == projectId) {
        if (taskModel.taskStatus == 'Complete') {
          listOverdou.add(taskModel);
        }
      }
    }
    return listOverdou;
  }

  int getOverdouTaskNumber(Map<dynamic, dynamic> taskMap, String id) {
    int count = 0;
    for (var task in taskMap.values) {
      TaskModel taskModel = TaskModel.fromMap(Map<String, dynamic>.from(task));
      DateTime now = DateTime.now();
      DateTime endDate = DateTime.parse(taskModel.taskEndDate);
      if ((taskModel.taskMembers.contains(id) || taskModel.assignById == id) &&
          now.isAfter(endDate)) {
        count++;
      }
    }
    return count;
  }

  int getAllOverdouTaskNumber(Map<dynamic, dynamic> taskMap) {
    int count = 0;
    for (var task in taskMap.values) {
      TaskModel taskModel = TaskModel.fromMap(Map<String, dynamic>.from(task));
      DateTime now = DateTime.now();
      DateTime endDate = DateTime.parse(taskModel.taskEndDate);
      if (now.isAfter(endDate)) {
        count++;
      }
    }
    return count;
  }

  int getCompleteTaskNumber(Map<dynamic, dynamic> taskMap, String id) {
    int count = 0;
    for (var task in taskMap.values) {
      TaskModel taskModel = TaskModel.fromMap(Map<String, dynamic>.from(task));
      if ((taskModel.taskMembers.contains(id) || taskModel.assignById == id) &&
          taskModel.taskStatus == 'Complete') {
        count++;
      }
    }
    return count;
  }

  int getAllCompleteTaskNumber(Map<dynamic, dynamic> taskMap) {
    int count = 0;
    for (var task in taskMap.values) {
      TaskModel taskModel = TaskModel.fromMap(Map<String, dynamic>.from(task));
      if (taskModel.taskStatus == 'Complete') {
        count++;
      }
    }
    return count;
  }

  Future<void> updateTaskList(
      String projectId, String phraseId, List<String> listTasks) async {
    DatabaseReference taskRef = FirebaseDatabase.instance.ref().child('tasks');
    taskRef.child(projectId).child(phraseId).update({
      'listTasks': listTasks,
    });
    Fluttertoast.showToast(
        msg: 'Phrase task list has been updated successfully');
  }

  Future<void> updateTaskSubmit(String taskId) async {
    DatabaseReference taskRef = FirebaseDatabase.instance.ref().child('tasks');
    taskRef.child(taskId).update({
      'taskStatus': 'Complete',
    });
    Fluttertoast.showToast(msg: 'This task has been submited successfully');
  }

  Future<void> updateTaskStatusOverdue(String taskId) async {
    DatabaseReference taskRef =
        FirebaseDatabase.instance.ref().child('tasks').child(taskId);
    //String? teamId = teamRef.push().key;
    await taskRef.update({
      'taskStatus': 'Overdue',
    });
  }

  String updateOverdueOrNot(TaskModel taskModel) {
    DateTime now = DateTime.now();
    DateTime endDate = DateTime.parse(taskModel.taskEndDate);
    if (now.isAfter(endDate)) {
      taskModel.taskStatus = 'Overdue';
    }
    return taskModel.taskStatus;
  }
}
