import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_app/Drawer.dart';
import 'package:flutter_app/connectivitychecker.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:flutter_app/RandomColors.dart';
import 'package:flutter_app/design.dart';
import 'package:flutter_app/models/ListHold.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_app/models/cloudModel.dart';
import 'package:flutter_app/providers.dart';

class SettingsScreen extends StatelessWidget {
  final TextEditingController sheetIDController = TextEditingController();

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text('Settings').whiteText(),
        backgroundColor: CustomColors.backgroundColor,
        shadowColor: Colors.transparent,
      ),
      backgroundColor: CustomColors.backgroundColor,
      body: Padding(
        padding:  EdgeInsets.symmetric(vertical: 5, horizontal: 15),
        child: Column(

          children: [
            const Text('Setup Google Sheet Deployment Link',
                style: TextStyle(fontSize: 20, color: Colors.white)),
            Container(
              height: 200,
              width: MediaQuery.of(context).size.width ,
              margin: EdgeInsets.only(top: 10),
              child: Card(
                child: Column(
                  children: [
                    // Align(
                    //     alignment: Alignment.centerLeft,
                    //     child: Text('Setup Google').whiteText()),
                    Container(
                      width: MediaQuery.of(context).size.width / 1.5,
                      margin: EdgeInsets.symmetric(vertical: 5,horizontal: 10),
                      child: CustomTextFormInput(
                        validator: normalValidator,
                        borderColor: Colors.black,
                        helperText: 'Enter as shown in Github',
                        textColor: Colors.black,
                        icon: Icons.book,
                        textEditingController: sheetIDController,
                      ),
                    ),
                    OutlinedButton.icon(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(CustomColors.backgroundColor)
                      ),
                        onLongPress: () async {
                          await SheetChecker().remoteSheet();
                          await SheetChecker().removeKey();
                        },
                        onPressed: () async {
                          FocusScope.of(context).unfocus();
                          bool isListEmpty =
                              context.read(listStateProvider.state).isEmpty;

                          await SheetChecker()
                              .setSheetID(sheetIDController.text);

                          _scaffoldKey.currentState.showSnackBar(SnackBar(
                            backgroundColor: Colors.black45,
                            content: Text(isListEmpty
                                    ? 'Saved!'
                                    : 'Uploading Local Notes To Sheet')
                                .whiteText(),
                          ));

                          if (!isListEmpty) {
                            await CloudNotes().uploadBatchNotes(
                                context.read(listStateProvider.state));
                            _scaffoldKey.currentState.showSnackBar(SnackBar(
                                backgroundColor: Colors.black54,
                                content: const Text('Uploaded')));
                          }
                        },
                        icon: const Icon(
                          Icons.cloud,
                          color: Colors.white,
                        ),
                        label: const Text('Save').whiteText())
                  ],
                ),
              ),
            ),
          FlatButton(onPressed: ()async{
            final data = await SheetChecker().getSheetID();
            showDialog(context: context,builder: (context){
              return AlertDialog(
                content: Container(
                  width: 200,
                  height: 200,
                  child: QrImage(
                    data:  data,
                    size: 200,
                    version: QrVersions.auto,
                  ),
                ),
              );
            });
          }, child: Text('ok'))
          ],
        ),
      ),
    );
  }
}
