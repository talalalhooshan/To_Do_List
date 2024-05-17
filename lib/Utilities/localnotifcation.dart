
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/rxdart.dart';
import 'package:timezone/timezone.dart' as tz;

class LocalNotifications{
static final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin=FlutterLocalNotificationsPlugin();
 static final onClickNotification = BehaviorSubject<String>();

// initialise the plugin.
static Future init() async{
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');
    final DarwinInitializationSettings initializationSettingsDarwin =
    DarwinInitializationSettings(
        requestSoundPermission: true,
        requestBadgePermission: true,
        requestAlertPermission: true,
        onDidReceiveLocalNotification: (int id, String? title, String? body, String? payload) async {});
    final LinuxInitializationSettings initializationSettingsLinux =
     LinuxInitializationSettings(
        defaultActionName: 'Open notification');
    final InitializationSettings initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid,
        iOS: initializationSettingsDarwin,
        linux: initializationSettingsLinux);
    _flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: (details)=>null,
    );
}

// on tap on any notification
//   static void onNotificationTap(NotificationResponse notificationResponse) {
//     onClickNotification.add(notificationResponse.payload!);
//   }

// Show simple Notification
// static Future showSimpleNotification({
//     required String title,
//     required String body,
//     required String payload,
// })async{
//     const AndroidNotificationDetails androidNotificationDetails =
//     AndroidNotificationDetails('your channel id', 'your channel name',
//         channelDescription: 'your channel description',
//         importance: Importance.max,
//         priority: Priority.high,
//         ticker: 'ticker');
//     const iosNotificatonDetail = DarwinNotificationDetails();
//     const NotificationDetails notificationDetails =
//     NotificationDetails(android: androidNotificationDetails, iOS: iosNotificatonDetail);
//     await _flutterLocalNotificationsPlugin.show(0, title, body, notificationDetails, payload: payload);
// }

  notificationDetails() {
    return const NotificationDetails(
        android: AndroidNotificationDetails('channelId', 'channelName',
            importance: Importance.max),
        iOS: DarwinNotificationDetails());
  }

//to Schedule a local notification
   Future scheduleNotification(
      {int id = 0,
        String? title,
        String? body,
        String? payLoad,
        required DateTime scheduledNotificationDateTime}) async {
    return _flutterLocalNotificationsPlugin.zonedSchedule(
        id,
        title,
        body,
        tz.TZDateTime.from(
          scheduledNotificationDateTime,
          tz.local,
        ),
        await notificationDetails(),
        uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime);
  }

  // close a specific channel notification
  static Future cancelNotifications(int id) async {
    await _flutterLocalNotificationsPlugin.cancel(id);
  }

}