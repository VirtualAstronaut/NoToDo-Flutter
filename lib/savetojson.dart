import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_app/models/ListHold.dart';
import 'package:flutter_app/main.dart';
import 'package:path_provider/path_provider.dart';
import 'providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SaveToLocal {
  Map _todoListJson = Map<String, dynamic>();
  Map get todoListJson => _todoListJson;
  Future<void> save(List<ToDO> listOfToDos) async {
    await writeToJSON(convertToJson(listOfToDos));
  }

  Future<File> _localFile() async {
    final path = await _localpath();
    return File('$path/todoJSon.txt');
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

  Future<File> writeToJSON( Map<String,dynamic> jsonMap) async {
    final file = await _localFile();
    final jsonVar = jsonEncode(jsonMap);
    return file.writeAsString(jsonVar);
  }

   convertToJson(List<ToDO> tempList)  {
    var jsonMap = Map<String, dynamic>();
    for (int i = 0; i < tempList.length; i++) {
      jsonMap[i.toString()] = [
        tempList[i].task,
        tempList[i].priority,
        tempList[i].dateTime.toString()
      ];
    }
    return jsonMap;
  }
  // Builder(
  //   builder: (context) {
  //
  //     print(model.myList[0]);
  //   },
  // );
  // Consumer<MyList>(
  //   builder: (context, value, child) {
  //     print(value.myList[0]);
  //     for (int i = 0; i < value.myList.length; i++) {
  //       _todoListJson[i] = {value.myList[i], value.priority[i]};
  //       print(value.myList[i]);
  //     }
  //   },
  // );
}
