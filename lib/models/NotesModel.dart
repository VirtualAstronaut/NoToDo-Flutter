import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/all.dart';

class NotesModel extends StateNotifier<List<Notes>> {


  NotesModel() : super([]);
  List<Notes> _noteLists = [];
  List<Notes> get noteLists => _noteLists;

  addNoteToModel(String noteName, Color noteColor, dynamic val) {
    state = [...state,Notes(noteName, noteColor,val)];

  }

  removeValueAt(int index) {
    state.removeAt(index);
  }

  updateValueAt(String noteName, int index) {
    state[index] = Notes(noteName, _noteLists[index].noteColor,
        _noteLists[index].noteExpiryDate);
  }
}

class Notes {
  final String noteName;
  final Color noteColor;
  final dynamic noteExpiryDate;
  Notes(this.noteName, this.noteColor, this.noteExpiryDate);
}
