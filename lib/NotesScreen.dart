import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_app/CustomContainers.dart';
import 'package:flutter_app/Drawer.dart';
import 'package:flutter_app/RandomColors.dart';
import 'package:flutter_app/main.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'providers.dart';
import 'design.dart';

class NotesScreen extends StatefulWidget {
  @override
  _NotesScreenState createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.backgroundColor,
      floatingActionButton: FloatingButton(),
      drawer: SideDrawer(
        isNotes: true,
      ),
      appBar: AppBar(
        shadowColor: Colors.transparent,
        title: Text(
          'Notes',
        ),
        backgroundColor: CustomColors.backgroundColor,
      ),
      body: Consumer(
        builder: (context, watch, child) {
          var list = watch(notesProvider.state);

          return list.isNotEmpty
              ? ListView.builder(
                  itemCount: list.length,
                  itemBuilder: (context, index) {
                    return CustomContainer(
                        list[index].noteName,
                        list[index].noteColor,
                        MediaQuery.of(context).size.width,
                        index,
                        list[index].noteExpiryDate);
                  },
                )
              : Text(
                  'No Notes Yet',
                  style: const TextStyle(fontSize: 20),
                ).whiteCenterText();
        },
      ),
    );
  }
}

class FloatingButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () =>
          showDialog(context: context, builder: (_) => AddNoteScreen()),
      child: Icon(Icons.add),
    );
  }
}

class AddNoteScreen extends StatefulWidget {
  @override
  _AddNoteScreenState createState() => _AddNoteScreenState();
}

class _AddNoteScreenState extends State<AddNoteScreen> {
  final noteController = TextEditingController();

  DateTime _selectedDate;
  bool checkBoxValue = false;

  var checkBoxKey = GlobalKey();
  ColorValue colorValue = ColorValue.blue;
  Color selectedColor = CustomColors.tileColors.first;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Add Note'),
      content: Container(
        height: MediaQuery.of(context).size.height / 2,
        alignment: Alignment.center,
        child: Column(
          children: [
            TextField(
              controller: noteController,
              decoration: InputDecoration(
                  suffixIcon: Icon(Icons.notes_rounded), labelText: 'Note'),
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('This note has expiry'),
                Checkbox(
                    key: checkBoxKey,
                    value: checkBoxValue,
                    onChanged: (newValue) {
                      if (!checkBoxValue) setDate(context, newValue);
                      if (_selectedDate != null)
                        setState(() {
                          checkBoxValue = newValue;
                          _selectedDate = null;
                        });
                    })
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Text('Choose Color for note'),
            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width / 1.6,
                  height: 50,
                  child: Theme(
                    data: Theme.of(context)
                        .copyWith(unselectedWidgetColor: Colors.white),
                    child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: 5,
                        itemBuilder: (con, index) {
                          return Container(
                            width: 50,
                            height: 50,
                            color: CustomColors.tileColors[index],
                            child: Radio(
                              value: ColorValue.values[index],
                              groupValue: colorValue,
                              onChanged: (ColorValue str) {
                                setState(() {
                                  colorValue = str;
                                  selectedColor =
                                      CustomColors.tileColors[index];
                                });
                              },
                              activeColor: CustomColors.tileColors[index],
                            ),
                          );
                        }),
                  ),
                )
              ],
            )
          ],
        ),
      ),
      actions: [
        FlatButton(
            onPressed: () {
              context.read(notesProvider).addNoteToModel(
                  noteController.text, selectedColor, _selectedDate ?? "NO");
              Navigator.pop(context);
            },
            child: Text('Add')),
        FlatButton(
            onPressed: () => Navigator.pop(context), child: Text('Cancel')),
      ],
    );
  }

  setDate(BuildContext context, bool checkBoxVal) async {
    DateTime _tempVar = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime(2025));
    setState(() {
      _selectedDate = _tempVar;
    });
    if (_selectedDate != null)
      checkBoxKey.currentState.setState(() {
        checkBoxValue = checkBoxVal;
      });
  }
}

class CircleColorChooser extends StatelessWidget {
  final Color color;
  CircleColorChooser(this.color);
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 5),
      width: 30,
      height: 15,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: color,
      ),
    );
  }
}
