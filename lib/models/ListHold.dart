import 'dart:convert';
import 'dart:core';
import 'dart:io';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:path_provider/path_provider.dart';

class ToDO {
  String task;
  int priority;
  var dateTime;
   ToDO(this.task, this.priority, this.dateTime);
  ToDO.fromJson(Map<String, dynamic> json) {
    task = json['task'];
    priority = json['priority'];
    dateTime = json['dateTime'];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['task'] = task;
    data['priority'] = priority;
    data['dateTime  '] = dateTime;
    return data;
  }
}

class MyList extends StateNotifier<List<ToDO>> {
   List<ToDO> _todoList = [];

  MyList() : super([]);

    List<ToDO> get todoList => _todoList;
  // static List<String> _myList = [];
  // static List<int> _priority = [];
  // static List<String> _todoType = [];
  // static dynamic _tempDateTime;
  // static List<dynamic> _dateTime = [];
  Map _todoListJson = Map<String, dynamic>();

  // static List<dynamic> get dateTime => _dateTime;
  // static List<String> get todoType => _todoType;
  // static dynamic get tempDateTime => _tempDateTime;
  // List<int> get priority => _priority;
  // List<String> get myList => _myList;
  Map get todoListJson => _todoListJson;

  // setTempDate(dynamic val) {
  //   _tempDateTime = val;
  // }

  // getTempDate() {
  //   return _tempDateTime;
  // }

  // resetTempDate() {
  //   _tempDateTime = "NO";
  // }

  dynamic getDateTimeAtIndex(int a) {
    if (state[a].dateTime != "NO") {
      return state[a].dateTime;
    }
    return "NO";
  }

  addValue(String task, int priority, dynamic val) {
    state = [...state, ToDO(task, priority, val)];
    _todoList.add(ToDO(task, priority, val));
    // _myList.add(task);
    // _priority.add(priority);
    // _dateTime.add(val);
  }

  // sortByPriority() {
  //   bool swap = false;
  //   while (!swap) {
  //     swap = true;
  //     for (int i = 0; i < myList.length - 1; i++) {
  //       if (priority[i] < priority[i + 1]) {
  //         int temp = priority[i];
  //         priority[i] = priority[i + 1];
  //         priority[i + 1] = temp;
  //         String kek = myList[i];
  //         myList[i] = myList[i + 1];
  //         myList[i + 1] = kek;
  //         swap = false;
  //       }
  //     }
  //   }
  //   notifyListeners();
  // }

  addBatch(List<ToDO> todoList) {
    for (int i = 0; i < todoList.length; i++) {
      _todoList.add(
          ToDO(todoList[i].task, todoList[i].priority, todoList[i].dateTime));

      // if (todoList[i].dateTime != "NO") {
      //   DateTime temp = DateTime.parse(todoList[i].dateTime);
      //   if (temp.isAfter(DateTime.now())) {
      //     _todoList.add(ToDO(
      //         todoList[i].task, todoList[i].priority, todoList[i].dateTime));
      //   }
      // } else {
      //
      // }
    }
    state = _todoList;
    // notifyListeners();
  }

  getLists() async {
    return _todoList;
  }

  removeValue(int index) {
    List<ToDO> _temp = state;
    _temp.removeAt(index);
    state = _temp;

    // notifyListeners();
  }

  updateValue(int index, String newTask, int newPriority) {
    var tempVal = _todoList[index].dateTime;
    List<ToDO> _temp = state;
    _temp[index] = ToDO(newTask, newPriority, tempVal);
    state = [..._temp];
    state[index] = ToDO(newTask, newPriority, tempVal);
  }
}

class RandomWords {
  static const List<String> _words = [
    'Write Your Next Goal',
    'Finish What You Added',
    'Time To Work',
    'Do not Procrastinate'
  ];

  static getRandomWord() {
    return _words[Random().nextInt(4)];
  }
}

class ProgressProvider extends ChangeNotifier {
  static bool _isDone = false;

  static set setDone(bool value) {
    _isDone = value;
  }

  bool get isDone => _isDone;
  setProgress() {
    _isDone = true;
    notifyListeners();
  }
}
