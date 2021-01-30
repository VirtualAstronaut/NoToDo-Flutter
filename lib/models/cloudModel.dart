import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_app/connectivitychecker.dart';
import 'package:flutter_app/models/ListHold.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart'
    as flutterSecureStorage;

import 'package:encrypt/encrypt.dart';

class CloudNotes {
  Future<List<ToDO>> getNotes(String sheetID) async {
    Dio dio = Dio();
    var encStringOfToDos = await dio.get(sheetID);
    List<ToDO> todoList = await getDecryptedToDos(encStringOfToDos.data);
    return todoList;
  }

  updateCloudNote(
      {String task,
      int priority,
      String dateTime,
      String update,
      int index}) async {
    Dio dio = Dio();
    Response response = await dio.post(
      'https://script.google.com/macros/s/AKfycbxNV_2TtQCi3IljkBVCPHaoOuogeDUEYLdnEJMk1wjaPZ_NyNrmNJjQ/exec',
      data: FormData.fromMap({
        "task": task,
        "update": update,
        "index": index,
        "priority": priority.toString(),
        "dateTime": dateTime
      }),
      options: Options(
        followRedirects: true,
        validateStatus: (status) {
          return status < 500;
        },
      ),
    );
    return response;
  }

   uploadCloudNote({
    String task,
    int priority,
    String dateTime,
  }) async {
    Dio dio = Dio();
    Response response;
    print('kkkkkkkkkkkkkkkkkkkkkkk');
    response = await dio.post(
      await SheetChecker().getSheetID(),
      data: FormData.fromMap(
          {"encData": await getEncryptedString(task, priority, dateTime)}),
      options: Options(
        followRedirects: false,
        validateStatus: (status) {
          return status < 500;
        },
      ),
    );

    print(response.statusCode);
    return response;
  }

   getEncryptedString(
    String task,
    int priority,
    String dateTime,
  ) async {
    flutterSecureStorage.FlutterSecureStorage flutterSecure =
        flutterSecureStorage.FlutterSecureStorage();
    var key;
    if (await flutterSecure.containsKey(key: 'key')) {

      key = Key.fromBase64(await flutterSecure.read(key: 'key'));
    } else {
       key = Key.fromSecureRandom(16);
      flutterSecure.write(key: 'key', value: key.base64);
    }
    print(key.base64);
    final iv = IV.fromLength(16);
    var jsonString =
        json.encode({"task": task, "priority": priority, "dateTime": dateTime});
    final encrypt = Encrypter(AES(key));
    final encryptedString = encrypt.encrypt(jsonString, iv: iv);
    return encryptedString.base64;
  }

  getDecryptedToDos(Map<String, dynamic> encToDos) async {

    final key = Key.fromBase64(await SheetChecker().readKey());
    print(key.base64 + "null");
    final iv = IV.fromLength(16);
    final decrypt = Encrypter(AES(key,));
    List<ToDO> listTodo = [];
    for (int i = 0; i < encToDos.length; i++) {
      String jsonString =
          decrypt.decrypt(Encrypted.fromBase64(encToDos[i.toString()]), iv: iv);
      Map<String, dynamic> todoMap = json.decode(jsonString);
      listTodo.add(ToDO(
          todoMap["task"],
          todoMap["priority"],
          todoMap["dateTime"] != "NO"
              ? DateTime.parse(todoMap["dateTime"])
              : "NO"));
    }
    return listTodo;
  }
}
