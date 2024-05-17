import '../SubTask/SubTask.dart';

class Task {
  int taskId;
  String name;
  String details;
  String dateTime;
  bool notificationIsScheduled;
  bool isCompleted;
  String category;
  String priority;
  late List<SubTask> subtasks=[];

  Task({
    required this.taskId,
    required this.name,
    required this.details,
    required this.dateTime,
    this.notificationIsScheduled = false,
    this.isCompleted = false,
    required this.category,
    required this.priority,
  });


}

