import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:to_do_list/Utilities/localnotifcation.dart';
import 'home.dart';
import 'package:timezone/data/latest.dart' as tz;


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  tz.initializeTimeZones();
  await LocalNotifications.init();
  runApp(const MyApp());
}




class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(statusBarColor: Colors.transparent));
    return  const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'To Do List',
      home: Home(),
    );
  }
}