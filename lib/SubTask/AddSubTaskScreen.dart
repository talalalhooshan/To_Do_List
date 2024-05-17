import 'package:flutter/material.dart';
import 'SubTask.dart';
import 'package:omni_datetime_picker/omni_datetime_picker.dart';
import 'package:intl/intl.dart';
import '../Task/Task.dart';

DateTime scheduleTime = DateTime.now();
int SubTaskidCounter = 0;

class AddSubTaskScreen extends StatefulWidget {
  final Task task;

  const AddSubTaskScreen({super.key, required this.task});

  @override
  State<AddSubTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddSubTaskScreen> {
  final TextEditingController _SubTasknameController = TextEditingController();
  final TextEditingController _SubTaskdetailsController =
      TextEditingController();
  final TextEditingController _SubTaskdateController = TextEditingController();

  showDatePicker() async {
    DateTime? dateTime = await showOmniDateTimePicker(
      theme: ThemeData(
        colorScheme: const ColorScheme.light(
          brightness: Brightness.dark,
          primary: Colors.teal,
          onPrimary: Colors.white,
          onSurface: Colors.black,
        ),
      ),
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1600).subtract(const Duration(days: 3652)),
      lastDate: DateTime.now().add(
        const Duration(days: 3652),
      ),
      is24HourMode: false,
      isShowSeconds: false,
      minutesInterval: 1,
      secondsInterval: 1,
      borderRadius: const BorderRadius.all(Radius.circular(16)),
      constraints: const BoxConstraints(
        maxWidth: 350,
        maxHeight: 650,
      ),
      transitionBuilder: (context, anim1, anim2, child) {
        return FadeTransition(
          opacity: anim1.drive(
            Tween(
              begin: 0,
              end: 1,
            ),
          ),
          child: child,
        );
      },
      transitionDuration: const Duration(milliseconds: 200),
      barrierDismissible: true,
      selectableDayPredicate: (dateTime) {
        // Disable 25th Feb 2023
        if (dateTime == DateTime(2023, 2, 25)) {
          return false;
        } else {
          return true;
        }
      },
    );
    setState(() {
      scheduleTime = dateTime ?? DateTime.now();
      String dateandTime = dateTime.toString();
      DateTime t = DateTime.parse(dateandTime);
      String formattedDateTime = DateFormat('yyyy-MM-dd HH:mm').format(t);
      _SubTaskdateController.text = formattedDateTime;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: const Text('Add SubTask'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            TextField(
              controller: _SubTasknameController,
              decoration: const InputDecoration(
                labelText: 'SubTask Name',
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _SubTaskdetailsController,
              decoration: const InputDecoration(
                labelText: 'SubTask Details',
              ),
            ),
            const SizedBox(height: 10),
            TextField(
                controller: _SubTaskdateController,
                decoration: const InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  prefixIcon: Icon(Icons.calendar_today),
                  labelText: 'SubTask Date',
                  enabledBorder:
                      OutlineInputBorder(borderSide: BorderSide.none),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.teal),
                  ),
                ),
                readOnly: true,
                onTap: () {
                  showDatePicker();
                }),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                ),
                onPressed: () async {
                  if (_SubTasknameController.text == "") {
                    setState(() {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) => AlertDialog(
                                backgroundColor: Colors.grey[200],
                                title: const Text(
                                  'Title is Empty!',
                                  style: TextStyle(color: Colors.black),
                                ),
                                content: const Text(
                                  'The SubTask Name Cannot be Empty!',
                                  style: TextStyle(color: Colors.black),
                                ),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    style: TextButton.styleFrom(
                                        backgroundColor: Colors.teal),
                                    child: const Center(
                                      child: Text('ok',
                                          style:
                                              TextStyle(color: Colors.white)),
                                    ),
                                  ),
                                ],
                              ));
                    });
                  } else {
                    SubTask newSubTask = SubTask(
                        SubTaskId: SubTaskidCounter++,
                        SubTaskName: _SubTasknameController.text,
                        SubTaskDetails: _SubTaskdetailsController.text,
                        SubTaskDateTime: _SubTaskdateController.text);
                    widget.task.subtasks.add(newSubTask);
                    Navigator.pop(context, newSubTask);
                  }
                },
                child: const Text(
                  'Add SubTask',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
//TODO: Implement Red Astrik Symbol on required fields after submit button is pressed
