import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_app/Drawer.dart';
import 'package:flutter_app/connectivitychecker.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:flutter_app/RandomColors.dart';
import 'package:flutter_app/design.dart';

class SettingsScreen extends StatelessWidget {
  final TextEditingController sheetIDController = TextEditingController();

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Settings').whiteText(),
        backgroundColor: CustomColors.backgroundColor,
        shadowColor: Colors.transparent,
      ),
      backgroundColor: CustomColors.backgroundColor,
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
        child: Column(
          children: [
            const Text('Setup Google Sheet Deployment Link',
                style: TextStyle(fontSize: 20, color: Colors.white)),
            Container(
              height: 200,
              margin: EdgeInsets.only(top: 10),
              child: Card(
                child: Column(
                  children: [
                    Align(
                        alignment: Alignment.centerLeft,
                        child: Text('Setup Google').whiteText()),
                    Container(
                      width: MediaQuery.of(context).size.width / 1.5,
                      child: CustomTextFormInput(
                        validator: normalValidator,
                        borderColor: Colors.black,
                        helperText: 'Enter as shown in Github',
                        textColor: Colors.black,
                        icon: Icons.book,
                        textEditingController: sheetIDController,
                      ),
                    ),
                    RaisedButton.icon(
                        color: CustomColors.backgroundColor,
                        onLongPress: () async{
                          await SheetChecker().remoteSheet();
                          await SheetChecker().removeKey();
                        },
                        onPressed: () async {
                          FocusScope.of(context).unfocus();
                          await SheetChecker().setSheetID(sheetIDController.text);

                          _scaffoldKey.currentState.showSnackBar(SnackBar(
                            backgroundColor: Colors.black54,
                            content: Text('Saved !').whiteText(),
                          ));
                        },
                        icon: Icon(
                          Icons.cloud,
                          color: Colors.white,
                        ),
                        label: Text('Save').whiteText())
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
