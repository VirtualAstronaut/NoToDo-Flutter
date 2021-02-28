
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app/MainScreen.dart';
import 'package:flutter_app/NotesScreen.dart';
import 'package:flutter_app/RandomColors.dart';
import 'package:flutter_app/SettingsScreen.dart';
import 'package:flutter_app/models/ListHold.dart';
import 'design.dart';

class SideDrawer extends StatelessWidget {
  final bool isNotes;

  SideDrawer({this.isNotes});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: CustomColors.backgroundColor,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              curve: Curves.easeIn,
              decoration: BoxDecoration(
                color: CustomColors.priorityOneColor,
              ),
              child: Container(
                  alignment: Alignment.bottomLeft,
                  child: Text(
                    RandomWords.getRandomWord(),
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  )),
            ),
            !isNotes
                ? ListTile(
                    leading: Icon(
                      Icons.notes_rounded,
                      color: Colors.white,
                    ),
                    title: Text("Notes").whiteText(),
                    onTap: () => Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (_) => NotesScreen()))
            )
                : ListTile(
                    leading: Icon(
                      Icons.notes_rounded,
                      color: Colors.white,
                    ),
                    title: Text("ToDO").whiteText(),
                    onTap: () => Navigator.pushReplacement(
                        context, MaterialPageRoute(builder: (_) => HomePage())),
                  ),
            ListTile(
              title: Text('Settings').whiteText(),
              leading: Icon(
                Icons.settings,
                color: Colors.white,
              ),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => SettingsScreen()));
              },
            )
          ],
        ),
      ),
    );
  }
}
//
// extension CustomTextk on Text {
//   Widget center() {
//     return Center(
//       child: this,
//     );
//
//
//     Widget whiteCenterText() {
//       return Center(
//           child: Text(
//             this.data,
//             style: const TextStyle(color: Colors.white),
//           ));
//     }
// }
