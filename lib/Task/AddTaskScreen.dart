import 'package:flutter/material.dart';
import 'Task.dart';
import 'package:omni_datetime_picker/omni_datetime_picker.dart';
import 'package:intl/intl.dart';

DateTime scheduleTime = DateTime.now();
int taskidCounter = 0;

class AddTaskScreen extends StatefulWidget {
  final List<String> categories;

  const AddTaskScreen({super.key, required this.categories});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _detailsController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _priorityController = TextEditingController();
  String? selectedCategory;
  String? selectedPriority;
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
      _dateController.text = formattedDateTime;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: const Text('Add Task'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Task Name',
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _detailsController,
              decoration: const InputDecoration(
                labelText: 'Task Details',
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                DropdownButton<String>(
                  value: selectedCategory,
                  hint: const Text('Select Category'),
                  onChanged: (String? value) {
                    setState(() {
                      selectedCategory = value;
                      _categoryController.text = value.toString();
                    });
                  },
                  items: widget.categories.map((String category) {
                    return DropdownMenuItem<String>(
                      value: category,
                      child: Text(category),
                    );
                  }).toList(),
                ),
                DropdownButton<String>(
                  value: selectedPriority,
                  hint: const Text('Assign Priority'),
                  onChanged: (String? value) {
                    setState(() {
                      selectedPriority = value;
                      _priorityController.text = value.toString();
                    });
                  },
                  items:const [
                    DropdownMenuItem(child: Text("1  (Highest Priority)"), value: "1"),
                    DropdownMenuItem(child: Text("2"), value: "2"),
                    DropdownMenuItem(child: Text("3"), value: "3"),
                    DropdownMenuItem(child: Text("4"), value: "4"),
                    DropdownMenuItem(child: Text("5  (Least Priority)"), value: "5"),
                  ]
                ),
              ],
            ),
            TextField(
                controller: _dateController,
                decoration: const InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  prefixIcon: Icon(Icons.calendar_today),
                  labelText: 'Task Date',
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
                onPressed: () {
                  if (_nameController.text == "") {
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
                                  'The Task Name Cannot be Empty!',
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
                    setState(() {
                      Navigator.pop(
                        context,
                          Task(
                            taskId: taskidCounter++,
                            name: _nameController.text,
                            details: _detailsController.text,
                            dateTime: _dateController.text,
                            category: _categoryController.text,
                            priority: _priorityController.text,
                          ),
                      );
                    });
                  }
                },
                child: const Text(
                  'Add Task',
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
