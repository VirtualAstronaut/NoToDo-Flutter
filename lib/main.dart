import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'MainScreen.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await initVars();
  await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitDown,DeviceOrientation.portraitUp]);

  runApp(ProviderScope(child: MyApp()));

}

void initVars()async  {

  flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/avatar');
  initializationSettings =
      InitializationSettings(android: initializationSettingsAndroid);
  notificationDetails =
      AndroidNotificationDetails(
          '0',
          'Todo Notification',
          'Shows Constant Notification',
          importance: Importance.max,
          priority: Priority.high,
          showWhen: false,
          ongoing: true,
          icon: '@mipmap/avatar'
      );
}
FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
AndroidInitializationSettings initializationSettingsAndroid ;
InitializationSettings initializationSettings;
AndroidNotificationDetails notificationDetails;

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomePage(),
    );
  }
}
