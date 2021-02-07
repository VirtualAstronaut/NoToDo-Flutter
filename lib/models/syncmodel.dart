
import 'package:flutter_riverpod/all.dart';

class SyncProgressModel extends StateNotifier<bool>{

  SyncProgressModel() : super(false);
  syncProgressDone(){
    state =false;
  }
  setSyncing(){
    state =true;
  }
}