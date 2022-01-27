import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class AppNotification {
  // static AppNotification? _appNotification;
  //
  // factory AppNotification() {
  //   return _appNotification ??= AppNotification._Init();
  // }
  //
  // AppNotification._Init();

  static FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  static init() {
    const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('app_icon');
    final IOSInitializationSettings initializationSettingsIOS =
        IOSInitializationSettings(onDidReceiveLocalNotification: (id, value, value1, value2) {});
    final InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
    _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onSelectNotification: (value){}
    );
  }

  static showDialog({String? data}) {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =  AndroidNotificationDetails(
        "com.id.id",
        "name chanel",
        importance: Importance.max,
        playSound: true,
        showProgress: true,
        priority: Priority.high,
        ticker: 'test ticker',
        autoCancel: false,
        tag: "tag"
    );
    _flutterLocalNotificationsPlugin.show(
      10010,
      "Beacon ",
      "$data",
      const NotificationDetails(
        android: androidPlatformChannelSpecifics,
      ),
    );

  }
}
