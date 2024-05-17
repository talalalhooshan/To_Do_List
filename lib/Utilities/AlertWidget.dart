import 'package:flutter/material.dart';

class AlertWidget extends StatefulWidget {
  const AlertWidget({super.key});

  @override
  State<AlertWidget> createState() => _AlertWidgetState();
}

class _AlertWidgetState extends State<AlertWidget> {
  @override
  void initState() {
    super.initState();
    close();
  }
  void close() {
    Future.delayed(
      const Duration(seconds: 1),
          () {
        if (mounted) {
          Navigator.pop(context);
        }
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
        children: [
        Center(
          child: Dialog(
            backgroundColor: Colors.teal,
                child: Container(
                    margin: const EdgeInsets.all(10),
                    child: const Text("Canceling Notifications for this Task",
                      style: TextStyle(
                      color: Colors.white,
                        fontSize: 16
                    ),
                    ),
                ),
              ),
        )
        ]);
  }
}