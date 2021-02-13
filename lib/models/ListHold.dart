
import 'dart:core';

import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/all.dart';


class ToDo {
  String task;
  int priority;
  dynamic dateTime;
  ToDo(this.task, this.priority, this.dateTime);
  ToDo.fromJson(Map<String, dynamic> json) {
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

class MyList extends StateNotifier<List<ToDo>> {
  List<ToDo> _todoList = [];

  MyList() : super([]);

  List<ToDo> get todoList => _todoList;
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

  // dynamic getDateTimeAtIndex(int a) {
  //   if (state[a].dateTime != "NO") {
  //     return state[a].dateTime;
  //   }
  //   return "NO";
  // }

  int addValue(String task, int priority, dynamic val) {
    // state = [...state, To(task, priority, val)];
    List<ToDo> tempList = state;
    int index = 0;
    if (tempList.isNotEmpty) {
      bool ifSamePriorityElementExists =
          tempList.indexWhere((element) => element.priority == priority) != -1;
      if (ifSamePriorityElementExists) {
        index = tempList.indexWhere((element) => element.priority == priority);
        tempList.insert(
          index ,
            ToDo(task, priority, val));
      } else {
        index = tempList.indexWhere(
                (element) => element.priority < priority);
        bool isPriorityHigher = tempList.lastIndexWhere((element) => element.priority < priority ) != -1;
        print(isPriorityHigher);
        tempList.insert(
            priority == 5 ? 0 : index ,
            ToDo(task, priority, "NO"));
      }
    } else {
      tempList.add(ToDo(task, priority, "NO"));
    }
    print (index);
    state = tempList;
  return index;
  }
  addBatch(List<ToDo> todoList) {
    for (int i = 0; i < todoList.length; i++) {
      _todoList.add(
          ToDo(todoList[i].task, todoList[i].priority, todoList[i].dateTime));

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

  }

  removeValue(int index) {
    List<ToDo> _temp = state;
    _temp.removeAt(index);
    state = _temp;
    // notifyListeners();
  }

  updateValue(int index, String task, int priority) {
    // var tempVal = _todoList[index].dateTime;
    List<ToDo> _temp = state;
    _temp.removeAt(index);
    _temp.insert(index, ToDo(task, priority, "NO"));
    _temp.sort((todoA, todoB) => todoB.priority.compareTo(todoA.priority));

    state = [..._temp];
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
