import 'dart:convert';


import 'package:flutter_app/MainScreen.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/all.dart';

import '../connectivitychecker.dart';
import '../main.dart';
import '../providers.dart';
import '../savetojson.dart';
import 'cloudModel.dart';
import 'package:timezone/data/latest.dart' as timezone;
import 'package:timezone/timezone.dart' as timezone;

class SyncHandler extends StateNotifier<bool> {
  final Reader read;
  SyncHandler(this.read) : super(false);

   updateToDo(AddToDoData data) async {
  if(data != null) {

    state = true;
    int index = -1;
    final onGoingNotificationIdOfToDo =  read(listStateProvider.state)[data.index].ongoingNotificationId;
    int ongoingNotificationIndex = onGoingNotificationIdOfToDo != -1 ? onGoingNotificationIdOfToDo : - 1;
    if (data.tobeShownInNotification) {
      final jsonVar = {
        "1": [data.task,]
      };
      String temp = json.encode(jsonVar);
      if(ongoingNotificationIndex != -1)
        flutterLocalNotificationsPlugin.cancel(ongoingNotificationIndex);
      ongoingNotificationIndex = await setUpNotification(temp);
    }
    else{
      if(data.ongoingNotificationId != -1) await flutterLocalNotificationsPlugin.cancel(data.ongoingNotificationId);
    }

    if ( data.datetime.toString() != "NO" ) {
      if (data.isNotificationScheduled && data.notificationId != -1) {
        await flutterLocalNotificationsPlugin.cancel(data.notificationId);
        index = await setupScheduledNotification(data.task, data.datetime,);
      } else {
        index = await setupScheduledNotification(data.task, data.datetime,);
      }
    }
    read(listStateProvider).updateValue(
        data.index, data.task, data.priority, data.datetime ?? "NO",
        data.tobeShownInNotification, index,ongoingNotificationIndex);
    await SaveToLocal().save(read(listStateProvider.state));
    if (await SheetChecker().isSheetSet() && ConnectivityStatus.isConnected) {
      await CloudNotes().updateCloudNote(
        task: data.task,
        priority: data.priority,
        dateTime: data.datetime.toString(),
        index: data.index,
      );
    }
  }
    state = false;
    read(editDateTimeProvider).resetDate();
  }

  Future uploadToDo(
      {bool tobeShownNotification,
      String task,
      int priority,
        bool isNotificationScheduled,
      DateTime modelDateTime}) async {
    state = true;
    final todoList = read(listStateProvider.state);

    int notificationIndex  = -1;
    int ongoingNotificationIndex = -1;
    if (modelDateTime != null) {
   notificationIndex =  await setupScheduledNotification(task, modelDateTime);
    }
    if (tobeShownNotification) {

      final jsonVar = {
        "1": [task,]
      };
      String temp = json.encode(jsonVar);
      ongoingNotificationIndex =await   setUpNotification(temp);
    }
    final listProvider =read(listStateProvider);
    int cloudIndex = listProvider.addValue(task, priority, modelDateTime ?? "NO",isNotificationScheduled,notificationIndex,ongoingNotificationIndex);
    await SaveToLocal().save(todoList);

    if (await SheetChecker().isSheetSet() && ConnectivityStatus.isConnected) {
      await CloudNotes().uploadCloudNote(
          index: cloudIndex + 1,
          task: task,
          priority: priority,
          dateTime: modelDateTime != null ? modelDateTime.toString() : "NO");
    }

    state = false;
  }
  Future<int> setupScheduledNotification(String task,DateTime modelDateTime,) async{
    List<PendingNotificationRequest> pendingNotifications =await flutterLocalNotificationsPlugin.pendingNotificationRequests();
    await flutterLocalNotificationsPlugin.zonedSchedule(
        pendingNotifications.length,
        "ToDo",
        task,
        timezone.TZDateTime.from(modelDateTime, timezone.local),
        const NotificationDetails(
            android: AndroidNotificationDetails('1', 'Scheduled Notifications', 'Show ToDos')),
        uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime,
        androidAllowWhileIdle: true);
    return pendingNotifications.length;
  }
  setUpNotification(String payload) async {
    final tempJSON = json.decode(payload);
    final List<ActiveNotification> activeNotifications =await flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.getActiveNotifications();
    final NotificationDetails platformChannelDetails =
        NotificationDetails(android: notificationDetails);
    await flutterLocalNotificationsPlugin.show(
        activeNotifications.length + 1, "ToDo", tempJSON["1"][0], platformChannelDetails);
    return activeNotifications.length + 1;
  }
  Future deleteLocalToDo(int index)async{
     state = true;
     final listProvider = read(listStateProvider);
     if(listProvider.state[index].notificationId != -1)
      await flutterLocalNotificationsPlugin.cancel(listProvider.state[index].notificationId);

     if(listProvider.state[index].ongoingNotificationId != -1)
     await flutterLocalNotificationsPlugin.cancel(listProvider.state[index].ongoingNotificationId);

     listProvider.removeValue(index);
     await SaveToLocal().save(listProvider.state);
     state = false;
  }
  Future clearAll() async{
     state = true;
     await flutterLocalNotificationsPlugin.cancelAll();
     read(listStateProvider).removeAll();
     await SaveToLocal().save(read(listStateProvider.state));
     state = false;
  }
}
