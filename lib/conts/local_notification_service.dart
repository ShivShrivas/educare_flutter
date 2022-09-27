import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotificationService {

  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static void initialize(BuildContext context) {
    final InitializationSettings initializationSettings =
        InitializationSettings(
            android: AndroidInitializationSettings("@drawable/icstatwecare"));
    _notificationsPlugin.initialize(initializationSettings,onSelectNotification: (String? route) async{
      if(route != null){
        Navigator.of(context).pushNamed(route);
      }
    });
  }

  static void display(RemoteMessage message) async {
    try {
      final id = DateTime.now().millisecondsSinceEpoch ~/1000;
     // Bitmap bitmap = await Bitmap.fromProvider(NetworkImage("https://www.dw.com/image/49519617_303.jpg"));

      /*var bigPictureStyleInformation = BigPictureStyleInformation(
        DrawableResourceAndroidBitmap(bitmap),
        largeIcon: DrawableResourceAndroidBitmap("flutter_devs"),
        contentTitle: 'flutter devs',
        summaryText: 'summaryText',
      );*/


      // Notice this is an async operation
      final NotificationDetails notificationDetails = NotificationDetails(
        android: AndroidNotificationDetails(
          "easyapproach",
          "easyapproach channel",
         // "this is our channel",
          importance: Importance.max,
          priority: Priority.high,
          color: Colors.red,
          enableLights: true,
          //largeIcon: DrawableResourceAndroidBitmap("ic_app_round"),
         // largeIcon: Dr,
          styleInformation: MediaStyleInformation(),
        )
      );

     // var platformChannelSpecifics = NotificationDetails(notificationDetails, null);

      await _notificationsPlugin.show(
        id,
        message.notification?.title,
        message.notification?.body,
        notificationDetails,
       // payload: message.data["route"],
      );
    } on Exception catch (e) {
      print(e);
    }
  }


  /*Future<void> showNotificationMediaStyle() async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'easyapproach',
      'easyapproach channel',
      'this is our channel',
      color: Colors.red,
      enableLights: true,
      largeIcon: DrawableResourceAndroidBitmap("flutter_devs"),
      styleInformation: MediaStyleInformation(),
    );
    var platformChannelSpecifics = NotificationDetails(androidPlatformChannelSpecifics, null);
    await _notificationsPlugin.show(
        0, 'notification title', 'notification body', platformChannelSpecifics);
  }*/


}
