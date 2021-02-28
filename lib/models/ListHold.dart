import 'dart:core';

import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/all.dart';

class ToDo {
  String task;
  int priority;
  dynamic dateTime;
  final bool isNotificationScheduled;
  final int ongoingNotificationId;
  final int notificationId;
  ToDo(this.task, this.priority, this.dateTime,
      {this.ongoingNotificationId,
      this.isNotificationScheduled,
      this.notificationId});
  // ToDo.fromJson(Map<String, dynamic> json) {
  //   task = json['task'];
  //   priority = json['priority'];
  //   dateTime = json['dateTime'];
  // }
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

  int addValue(
      String task,
      int priority,
      dynamic val,
      bool isNotificationScheduled,
      int notificationId,
      int ongoingNotificationId) {
    //Todo: edit datetime after
    // state = [...state, To(task, priority, val)];
    List<ToDo> tempList = state;
    int index = 0;
    bool ifSamePriorityElementExists =
        tempList.indexWhere((element) => element.priority == priority) != -1;
    if (ifSamePriorityElementExists) {
      index = tempList.indexWhere((element) => element.priority == priority);
      tempList.insert(
          index,
          ToDo(task, priority, val ?? "NO",
              isNotificationScheduled: isNotificationScheduled,
              notificationId: notificationId,ongoingNotificationId: ongoingNotificationId));
    } else {
      final tempIndex =
          tempList.indexWhere((element) => element.priority < priority);
      if (tempIndex != -1) {
        // bool isPriorityHigher =
        //     tempList.lastIndexWhere((element) => element.priority < priority) !=
        //         -1;
        index = tempIndex;
        tempList.insert(
            priority == 5 ? 0 : index,
            ToDo(task, priority, val ?? "NO",
                isNotificationScheduled: isNotificationScheduled,
                notificationId: notificationId,ongoingNotificationId: ongoingNotificationId));
      } else {
        tempList.add(ToDo(task, priority, val ?? "NO",
            isNotificationScheduled: isNotificationScheduled,
            notificationId: notificationId,ongoingNotificationId: ongoingNotificationId));
      }
    }
    state = tempList;
    return index;
  }

  addBatch(List<ToDo> todoList) {
    state = todoList;
    // for (int i = 0; i < todoList.length; i++) {
    //   _todoList.add(
    //       ToDo(todoList[i].task, todoList[i].priority, todoList[i].dateTime,isNotificationScheduled: todoList[i].isNotificationScheduled,notificationId: to));
    //
    //   // if (todoList[i].dateTime != "NO") {
    //   //   DateTime temp = DateTime.parse(todoList[i].dateTime);
    //   //   if (temp.isAfter(DateTime.now())) {
    //   //     _todoList.add(ToDO(
    //   //         todoList[i].task, todoList[i].priority, todoList[i].dateTime));
    //   //   }
    //   // } else {
    //   //
    //   // }
    // }
    // state = _todoList;
  }

  removeValue(int index) {
    List<ToDo> _temp = state;
    _temp.removeAt(index);
    state = _temp;
    // notifyListeners();
  }

  removeAll() {
    state = [];
  }

  updateValue(int index, String task, int priority, dynamic dateTime,
      bool isNotificationScheduled, int notificationId,int ongoingNotificationId) {
    // var tempVal = _todoList[index].dateTime;
    List<ToDo> _temp = state;

    _temp.removeAt(index);
    _temp.insert(
        index,
        ToDo(task, priority, dateTime,
            isNotificationScheduled: isNotificationScheduled,
            notificationId: notificationId,ongoingNotificationId: ongoingNotificationId));
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
