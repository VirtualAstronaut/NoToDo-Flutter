import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SheetChecker {
  final FlutterSecureStorage flutterSecure = FlutterSecureStorage();
  Future<bool> isSheetSet() async {
    return await flutterSecure.containsKey(key: 'sheetID');
  }

  Future<String> getSheetID() async {
    return await flutterSecure.read(key: 'sheetID');
  }
  Future<void> setSheetID(String sheetID) async {
    return await flutterSecure.write(key: 'sheetID',value: sheetID);
  }

  remoteSheet() async{
    await flutterSecure.delete(key: 'sheetID');
  }
  removeKey() async {
    return await flutterSecure.delete(key: 'key');
  }
  readKey() async {
    return await flutterSecure.read(key: 'key');
  }
  // createKey() async{
  //   return   Key.fromLength(16);
  // }

}
class ConnectivityStatus {
  static bool isConnected = false;

  static void setConnectivityStatus() {
    isConnected =true;
  }

}
