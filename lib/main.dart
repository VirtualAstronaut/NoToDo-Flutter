import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'MainScreen.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitDown,DeviceOrientation.portraitUp]);
  runApp(ProviderScope(child: MyApp()));

}

//providers
// final notesProvider = ChangeNotifierProvider((_) => NotesModel());
// final listProvider = ChangeNotifierProvider((_) => MyList());

// final cloudTodoProvider = StreamProvider.autoDispose<List<ToDO>>((ref) async* {
//   final channel = CloudNotes();
//   await for (var value in channel.stream) {
//     yield value;
//   }
// });
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

final AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/avatar');
InitializationSettings initializationSettings =
    InitializationSettings(android: initializationSettingsAndroid);

final AndroidNotificationDetails notificationDetails =
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
