

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  
  static final FlutterLocalNotificationsPlugin plugin=FlutterLocalNotificationsPlugin();

  static Future<void> init() async {

    const android = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );

    const settings = InitializationSettings(
      android: android,
    );

    await plugin.initialize(settings);


    final androidPlugin =
    plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();

    await androidPlugin?.requestNotificationsPermission();
  }
  static Future<void> scheduleDailyReminder() async {


    await plugin.zonedSchedule(

      1,

      "Keep your streak alive 🔥",

      "Don't forget to track your calories today",

      _nextInstanceOfTime(20,0),

      const NotificationDetails(

        android: AndroidNotificationDetails(
          'daily_reminder',
          'Daily reminders',
          channelDescription:
          'Daily calorie tracking reminders',

          importance: Importance.high,
          priority: Priority.high,
        ),
      ),

      androidScheduleMode:
      AndroidScheduleMode.exactAllowWhileIdle,

      matchDateTimeComponents:
      DateTimeComponents.time,

    );


  }



  static tz.TZDateTime _nextInstanceOfTime(
      int hour,
      int minute
      ){

    final now = tz.TZDateTime.now(tz.local);


    var scheduled =
    tz.TZDateTime(
        tz.local,
        now.year,
        now.month,
        now.day,
        hour,
        minute
    );


    if(scheduled.isBefore(now)){
      scheduled = scheduled.add(
          const Duration(days:1)
      );
    }


    return scheduled;

  }



  static Future<void> cancelAll() async{

    await plugin.cancelAll();

  }

  }