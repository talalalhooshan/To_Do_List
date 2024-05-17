import 'package:flutter/material.dart';
import 'Task.dart';
import '../Utilities/localnotifcation.dart';
import '../Utilities/AlertWidget.dart';
import '../SubTask/AddSubTaskScreen.dart';
import '../SubTask/SubTaskDetailsScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
class TaskDetailsScreen extends StatefulWidget {
  final Task task;

  const TaskDetailsScreen({super.key, required this.task});

  @override
  State<TaskDetailsScreen> createState() => _TaskDetailsScreenState();
}

class _TaskDetailsScreenState extends State<TaskDetailsScreen> {
  late String _notificationStateKey;
  bool showSubTasks=false;

  @override
  void initState() {
    super.initState();
    _notificationStateKey = 'notificationState_${widget.task.taskId}';
    _loadNotificationState();
  }

  void _loadNotificationState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? notificationState = prefs.getBool(_notificationStateKey);
    setState(() {
      widget.task.notificationIsScheduled = notificationState ?? false;
    });
  }

  void _saveNotificationState(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_notificationStateKey, value);
  }

  void toggleShowSubTasks(){
    setState(() {
      showSubTasks=!showSubTasks;
    });
  }

  void toggleSilentMode() {
    setState(() {
      widget.task.notificationIsScheduled = !widget.task.notificationIsScheduled;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: ListTile(
        title:const Center(child: Text('Task Details',
        style: TextStyle(fontSize: 20,color: Colors.black),)),
          trailing: IconButton(
                  icon: Icon(
                    widget.task.notificationIsScheduled ? Icons.notifications : Icons.notifications_off,
                    color: widget.task.notificationIsScheduled ? Colors.grey[800] : Colors.red[400],
                  ),
                  onPressed:(){
                    toggleSilentMode();
                   _saveNotificationState(widget.task.notificationIsScheduled);
                    DateTime schedule_notification =DateTime.parse(widget.task.dateTime);
                    DateTime currentTime=DateTime.now();
                    if(widget.task.notificationIsScheduled){
                      if (!currentTime.isAfter(schedule_notification)) {
                        LocalNotifications localNotifications = LocalNotifications();
                        localNotifications.scheduleNotification(
                            id: widget.task.taskId,
                            title: 'Task: ${widget.task.name}',
                            body: "Details: ${widget.task.details}\n"
                                "Due Date: ${widget.task.dateTime}",
                            payLoad:widget.task.details,
                            scheduledNotificationDateTime: schedule_notification);
                        print("Scheduling Notification for this task");
                      } else {
                        showDialog(
                            context: context, builder: (BuildContext context) =>
                            AlertDialog(
                              backgroundColor: Colors.grey[200],
                              title: const Text('Cannot Schedule Notification!',
                                style: TextStyle(color: Colors.black),),
                              content: const Text(
                                'The Scheduled Date has already passed!',
                                style: TextStyle(color: Colors.black),),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  style: TextButton.styleFrom(
                                      backgroundColor: Colors.teal),
                                  child: const Center(
                                    child: Text('ok',
                                        style: TextStyle(color: Colors.white)),
                                  ),
                                ),
                              ],
                            ));
                      }
                    }if (!widget.task.notificationIsScheduled){
                       LocalNotifications.cancelNotifications(widget.task.taskId);
                       showDialog(
                         context: context,
                         builder: (context) {
                           return const AlertWidget();
                         },
                       );                    }
                      },
                    ),
                    ),
                    backgroundColor: Colors.teal,
                    ),
                    body: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                    const SizedBox(height: 10,),
                    ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      tileColor: Colors.white,
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                          'Task Name: ${widget.task.name}',
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold,),
                          ),

                          const SizedBox(height: 10),
                          Text(
                          'Details: ${widget.task.details}',
                                        style: const TextStyle(fontSize: 16),
                                      ),
                                      const SizedBox(height: 10),
                                      Text(
                                        'Date: ${widget.task.dateTime}',
                                        style: const TextStyle(fontSize:16),
                                      ),
                        ],
                      ),
                    ),
                      const SizedBox(height:20),
                       ListTile(
                         leading: IconButton(
                            icon: Icon(
                                showSubTasks ? Icons.keyboard_arrow_down_rounded : Icons.keyboard_arrow_up_rounded
                            ),
                          onPressed:toggleShowSubTasks,
                        ),
                        trailing:IconButton(
                          icon: const Icon(
                              Icons.add_rounded,
                              color: Colors.green
                          ),
                            onPressed: (){
                              setState(() {
                                Navigator.push(context, MaterialPageRoute(builder: (context) => AddSubTaskScreen(task: widget.task)));
                              });
                            },
                        ),
                        title: const Text(
                          'SubTasks',
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                         shape: RoundedRectangleBorder(
                           borderRadius: BorderRadius.circular(20),
                         ),
                         contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                         tileColor: Colors.white,
                      ),
                      Visibility(
                        visible: showSubTasks,
                        child: Expanded(
                          child: ListView.builder(
                            itemCount: widget.task.subtasks.length,
                            itemBuilder: (context, index) {
                              return showSubTasks ? Container(
                                margin: const EdgeInsets.only(
                                  top: 15,
                                  right: 5,
                                  left: 5,
                                ),
                                child: ListTile(
                                  title: Text(
                                    widget.task.subtasks[index].SubTaskName,
                                    style: TextStyle(
                                      decoration: widget.task.subtasks[index].isCompleted? TextDecoration.lineThrough : TextDecoration.none,
                                      fontSize: 16,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  leading: Checkbox(
                                    value: widget.task.subtasks[index].isCompleted,
                                    onChanged: (value) {
                                      setState(() {
                                        widget.task.subtasks[index].isCompleted = value!;
                                      });
                                    },
                                    fillColor: MaterialStateColor.resolveWith((states) =>
                                    widget.task.subtasks[index].isCompleted ? Colors.green : Colors.transparent),
                                    checkColor: widget.task.subtasks[index].isCompleted ? Colors.white : Colors.transparent,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                                  tileColor: Colors.white,
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => SubTaskDetailsScreen(subtask: widget.task.subtasks[index]),
                                      ),
                                    );
                                  },
                                ),
                              ) : const SizedBox.shrink(); // Hides the list if showSubTasks is false
                            },
                          ),
                        ),
                      ),
                    ],),
      ),
    );
  }
}
