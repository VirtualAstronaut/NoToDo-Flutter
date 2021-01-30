import 'package:flutter/foundation.dart';

class DateTimeNotifier extends ChangeNotifier {
  DateTime _dateTime;

  DateTime get dateTime => _dateTime;

  updateDate(DateTime dateTime) {
    _dateTime = dateTime;
    notifyListeners();
  }

  resetDate() {
    _dateTime = null;
  }
}
