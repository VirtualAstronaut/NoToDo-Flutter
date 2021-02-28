import 'dart:convert';
import 'dart:io';

import 'package:flutter_app/models/ListHold.dart';

import 'package:path_provider/path_provider.dart';

class SaveToLocal {

  Future<void> save(List<ToDo> listOfToDos) async {
    await writeToJSON(convertToJson(listOfToDos));
  }

  Future<File> _localFile() async {
    final path = await _localpath();
    return File('$path/todo.txt');
  }

  Future<String> _localpath() async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<Map<String, dynamic>> readFromStorage() async {
    final file = await _localFile();
    if (file == null) throw ("File Doesn't exists");
    String listJson = await file.readAsString();
    var data = jsonDecode(listJson);
    return data;
  }

  Future<void> writeToJSON(Map<String, dynamic> jsonMap) async {
    final file = await _localFile();
    final jsonVar = jsonEncode(jsonMap);
    file.writeAsString(jsonVar);
  }

  convertToJson(List<ToDo> tempList) {
    var jsonMap = Map<String, dynamic>();
    for (int i = 0; i < tempList.length; i++) {
      jsonMap[i.toString()] = [
        tempList[i].task,
        tempList[i].priority,
        tempList[i].dateTime.toString(),
        tempList[i].isNotificationScheduled,
        tempList[i].notificationId,
        tempList[i].ongoingNotificationId
      ];
    }
    return jsonMap;
  }
}
