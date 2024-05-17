class SubTask {
  late int SubTaskId;
  late String SubTaskName;
  late String SubTaskDetails;
  late bool isCompleted;
  late String SubTaskDateTime;

  SubTask(
      {required this.SubTaskId,
      required this.SubTaskName,
      required this.SubTaskDetails,
      required this.SubTaskDateTime,
      this.isCompleted = false});
}
