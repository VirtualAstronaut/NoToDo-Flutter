import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_app/design.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_app/main.dart';
import 'providers.dart';
import 'package:flutter_riverpod/all.dart';

class CustomContainer extends StatelessWidget {
  final String _task;
  final Color _color;
  final int priority;
  final double _width;
  final int _index;
  final dynamic dateTime;
  const CustomContainer(
      this._task, this._color, this._width, this._index, this.dateTime,
      {this.priority});

  updateCloudNote(BuildContext context) async {
    Map<String, dynamic> dialogResponse = await showDialog(
        context: context,
        builder: (context) => EditNoteScreen(
              _index,
              _task,
              _color,
              dateTime,
              priority: priority,
            ));
    if (dialogResponse != null) {
      context.read(syncProvider).updateToDo(
          priority: dialogResponse["priority"],
          index: dialogResponse["index"],
          task: dialogResponse["task"],
          dateTime: "NO");//TODO:add Logic for DateTime
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.all(Radius.circular(10)),
        child: InkWell(
          radius: 10,
          splashColor: Colors.white54,
          onLongPress: () {
            updateCloudNote(context);
          },
          onDoubleTap: () async {
            updateCloudNote(context);
          },
          child: Ink(
            decoration: BoxDecoration(
                color: _color,
                // boxShadow: [
                //    BoxShadow(
                //       color: Colors.black54,
                //       spreadRadius: 5,
                //       blurRadius: 25,
                //       offset: Offset(20, 10))
                // ],
                borderRadius: BorderRadius.circular(10)
            ),
            child: Column(
              children: [
                Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.transparent),
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10))),
                    width: _width,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            _task,
                            style: const TextStyle(
                                fontSize: 25, color: Colors.white),
                          ),
                        ),
                        // IconButton(
                        //   icon: Icon(
                        //     Icons.delete,
                        //     color: Colors.white,
                        //   ),
                        //   onPressed: () {
                        //     if(priority != null){
                        //     context.read(listProvider).removeValue(_index);
                        //     SaveToLocal().save();
                        //     }
                        //     else{
                        //       context.read(notesProvider).removeValueAt(_index);
                        //     }
                        //   },
                        // )
                      ],
                    )),
                Container(
                    padding: EdgeInsets.only(bottom: 10, left: 10),
                    alignment: Alignment.centerLeft,
                    child: priority != null
                        ? Text(
                            "Priority " + priority.toString(),
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          )
                        : Container())
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class EditNoteScreen extends StatefulWidget {
  final int index;
  final String note;
  final int priority;
  final Color _color;
  final dynamic dateTime;
  EditNoteScreen(this.index, this.note, this._color, this.dateTime,
      {this.priority});

  @override
  _EditNoteScreenState createState() => _EditNoteScreenState();
}

class _EditNoteScreenState extends State<EditNoteScreen> {
  final TextEditingController noteField = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  // FlutterLocalNotificationsPlugin flutterLocalPermission =
  //     new FlutterLocalNotificationsPlugin();
  @override
  void initState() {
    super.initState();
    // loadNotifications();
    noteField.text = widget.note;
  }

  // loadNotifications() async {
  //   AndroidInitializationSettings androidSettings =
  //       new AndroidInitializationSettings('assests/avatar.jpg');
  //   final InitializationSettings initializationSettings =
  //       new InitializationSettings(android: androidSettings);
  //   await flutterLocalPermission.initialize(initializationSettings);
  // }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: AlertDialog(
        backgroundColor: widget._color,
        contentTextStyle: const TextStyle(color: Colors.white),
        title: const Text('Edit Note').whiteText(),
        content: Container(
          height: MediaQuery.of(context).size.height / 3,
          child: Column(
            children: [
              CustomTextFormInput(
                validator: normalValidator,
                textEditingController: noteField,
                icon: Icons.notes_rounded,
              ),
              // TextFormField(
              //   controller: noteField,
              //   cursorColor: Colors.white,
              //   style: TextStyle(color: Colors.white),
              //   maxLines: 1,
              //   decoration: InputDecoration(
              //       errorBorder: UnderlineInputBorder(
              //           borderSide: BorderSide(color: Colors.red.shade500)),
              //       errorStyle: TextStyle(color: Colors.red.shade50),
              //       suffixIcon: Icon(
              //         Icons.notes_rounded,
              //         color: Colors.white,
              //       ),
              //       focusedBorder: underlineInputBorder(),
              //       enabledBorder: underlineInputBorder()),
              //
              widget.priority != null
                  ? Consumer(
                      builder: (context, watch, child) {
                        final model = watch(sliderProvider);
                        return Container(
                          margin: const EdgeInsets.symmetric(vertical: 10),
                          child: Column(
                            children: [
                              const Text('Change Priority').whiteText(),
                              Slider(
                                  activeColor: Colors.white,
                                  value: model.sliderValue,
                                  divisions: 4,
                                  min: 1,
                                  max: 5,
                                  label: model.sliderValue.toString(),
                                  onChanged: (value) {
                                    model.updateValue(value);
                                  }),
                              whiteText(widget.dateTime != "NO"
                                  ? "This Note will Expire in ${DateTime.parse(widget.dateTime).difference(DateTime.now()).inDays.toString()} days "
                                  : "This Note has no expiry")
                            ],
                          ),
                        );
                      },
                    )
                  : Container()
            ],
          ),
        ),
        actions: [
          TextButton(
              onPressed: () async {
                final sliderVal = context.read(sliderProvider).sliderValue;
                if (_formKey.currentState.validate()) {
                  if (widget.priority != null) {
                    context.read(listStateProvider).updateValue(
                        widget.index, noteField.text, sliderVal.toInt());
                  } else {
                    context
                        .read(notesProvider)
                        .updateValueAt(noteField.text, widget.index);
                  }

                  Navigator.pop(context, {
                    "task": noteField.text,
                    "priority": sliderVal.toInt(),
                    "isOperationCanceled": false,
                    "index": widget.index
                    // "isDateSet" :checkValue,
                    //  "dateTime": _modelDateTime ?? "NO"
                  });
                }
              },
              child: const Text('update').whiteText()),
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel').whiteText())
        ],
      ),
    );
  }
}

class EditNoteFromNotification extends StatelessWidget {
  final String payloadIndex;

  EditNoteFromNotification(this.payloadIndex);

  @override
  Widget build(BuildContext context) {
    final tempJSON = jsonDecode(payloadIndex);
    return Scaffold(
      body: AlertDialog(
        title: Text('Remove Note From Notification?'),
        actions: [
          TextButton(
              onPressed: () async {
                await flutterLocalNotificationsPlugin
                    .cancel(int.parse(tempJSON["1"][1]));
              },
              child: Text('Yes')),
          TextButton(
              onPressed: () => Navigator.pop(context), child: Text('No')),
        ],
      ),
    );
  }
}
