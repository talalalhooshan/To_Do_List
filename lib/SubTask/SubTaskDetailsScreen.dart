import 'package:flutter/material.dart';
import 'SubTask.dart';
class SubTaskDetailsScreen extends StatefulWidget {
  final SubTask subtask;

  const SubTaskDetailsScreen({super.key, required this.subtask});

  @override
  State<SubTaskDetailsScreen> createState() => _TaskDetailsScreenState();
}

class _TaskDetailsScreenState extends State<SubTaskDetailsScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: const Text('Sub-Task Details'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
        ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        tileColor: Colors.white,
        title:Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10,),
            Text('Task Name: ${widget.subtask.SubTaskName}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold,),
            ),
                        const SizedBox(height: 10),
                        Text(
                          'Details: ${widget.subtask.SubTaskDetails}',
                          style: const TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Date: ${widget.subtask.SubTaskDateTime}',
                          style: const TextStyle(fontSize: 16),
                        ),
            ],)
        ),
       ], )
    )
    );
  }
}
