
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/all.dart';

import '../connectivitychecker.dart';
import '../main.dart';
import '../providers.dart';
import '../savetojson.dart';
import 'ListHold.dart';
import 'cloudModel.dart';


class SyncHandler extends StateNotifier<bool>{

  final Reader read;
  SyncHandler(this.read) : super(false);

  updateToDo({ @required int priority,@required  int index,@required  String task,@required  String dateTime}) async{
    state = true;
    await SaveToLocal().save(read(listStateProvider.state));
    if (await SheetChecker().isSheetSet() && ConnectivityStatus.isConnected) {
      await CloudNotes().updateCloudNote(
        task: task,
        priority: priority,
        dateTime: dateTime,
        index: index,
      );
    }
    state = false;
    read(dateTimeProvider).resetDate();
  }
  Future uploadToDo({bool tobeShownNotification,int index, String task,int priority, DateTime modelDateTime}) async{
    state = true;
    final todoList = read(listStateProvider.state);
    await SaveToLocal().save(todoList);
    if (tobeShownNotification) {
      var jsonVar = {
        "1": [task, todoList.length - 1]
      };
      String temp = json.encode(jsonVar);
      setUpNotification(temp);
    }
    if (await SheetChecker().isSheetSet() && ConnectivityStatus.isConnected) {
      await CloudNotes().uploadCloudNote(
          index: index + 1,
          task: task,
          priority: priority,
          dateTime: modelDateTime != null ? modelDateTime.toString() : "NO");
    }
    state = false;
  }
  setUpNotification(String payload) async {
    var tempJSON = json.decode(payload);
    final NotificationDetails platformChannelDetails =
    NotificationDetails(android: notificationDetails);
    await flutterLocalNotificationsPlugin.show(
        tempJSON["1"][1], "ToDo", tempJSON["1"][0], platformChannelDetails);
  }
}