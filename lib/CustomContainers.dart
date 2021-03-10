import 'dart:convert';

import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/design.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_app/main.dart';
import 'MainScreen.dart';
import 'RandomColors.dart';
import 'providers.dart';

class CustomContainer extends StatelessWidget {
  final String task;
  final Color _color;
  final int priority;
  final double _width;
  final int notificationId;
  final int ongoingNotificationId;
  final int index;
  final dynamic dateTime;
  const CustomContainer(
      this.task, this._color, this._width, this.index, this.dateTime,
      {this.priority, this.notificationId, this.ongoingNotificationId, });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      child: OpenContainer<AddToDoData>(
        openColor: Colors.transparent,
        closedColor: Colors.transparent,
        onClosed: context.read(syncProvider).updateToDo,
        openBuilder: (context, action) {
          return EditToDoScreen(
            index,
            task,
            _color,
            dateTime,
            priority: priority,
            notificationId: notificationId,
            ongoingNotificationId: ongoingNotificationId,
            action: action,
          );
        },
        closedBuilder: (context, action) {
          return Material(
            color: Colors.transparent,
            borderRadius:const BorderRadius.all(Radius.circular(10)),
            child: InkWell(
              radius: 10,
              splashColor: Colors.white54,
              onLongPress: action,
              onDoubleTap: action,
              child: Ink(
                decoration: BoxDecoration(
                    color: _color,
                    borderRadius: const BorderRadius.all(Radius.circular(10))),
                child: Column(
                  children: [
                    Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.transparent),
                            borderRadius:  const BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(10))),
                        width: _width,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                task,
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
                        padding: const  EdgeInsets.only(bottom: 10, left: 10),
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
          );
        },
      ),
    );
  }
}

// class EditNoteScreen extends StatefulWidget {
//   final int index;
//   final String note;
//   final int priority;
//   final Color _color;
//   final dynamic dateTime;
//   EditNoteScreen(this.index, this.note, this._color, this.dateTime,
//       {this.priority});
//
//   @override
//   _EditNoteScreenState createState() => _EditNoteScreenState();
// }
//
// class _EditNoteScreenState extends State<EditNoteScreen> {
//   final TextEditingController noteField = TextEditingController();
//
//   final _formKey = GlobalKey<FormState>();
//   // FlutterLocalNotificationsPlugin flutterLocalPermission =
//   //     new FlutterLocalNotificationsPlugin();
//   @override
//   void initState() {
//     super.initState();
//     // loadNotifications();
//     noteField.text = note;
//   }
//
//   // loadNotifications() async {
//   //   AndroidInitializationSettings androidSettings =
//   //       new AndroidInitializationSettings('assests/avatar.jpg');
//   //   final InitializationSettings initializationSettings =
//   //       new InitializationSettings(android: androidSettings);
//   //   await flutterLocalPermission.initialize(initializationSettings);
//   // }
//
//   @override
//   Widget build(BuildContext context) {
//     return Form(
//       key: _formKey,
//       child: AlertDialog(
//         backgroundColor: _color,
//         contentTextStyle: const TextStyle(color: Colors.white),
//         title: const Text('Edit Note').whiteText(),
//         content: Container(
//           height: MediaQuery.of(context).size.height / 3,
//           child: Column(
//             children: [
//               CustomTextFormInput(
//                 validator: normalValidator,
//                 textEditingController: noteField,
//                 icon: Icons.notes_rounded,
//               ),
//               // TextFormField(
//               //   controller: noteField,
//               //   cursorColor: Colors.white,
//               //   style: TextStyle(color: Colors.white),
//               //   maxLines: 1,
//               //   decoration: InputDecoration(
//               //       errorBorder: UnderlineInputBorder(
//               //           borderSide: BorderSide(color: Colors.red.shade500)),
//               //       errorStyle: TextStyle(color: Colors.red.shade50),
//               //       suffixIcon: Icon(
//               //         Icons.notes_rounded,
//               //         color: Colors.white,
//               //       ),
//               //       focusedBorder: underlineInputBorder(),
//               //       enabledBorder: underlineInputBorder()),
//               //
//               priority != null
//                   ? Consumer(
//                       builder: (context, watch, child) {
//                         final model = watch(editSliderProvider);
//                         return Container(
//                           margin: const EdgeInsets.symmetric(vertical: 10),
//                           child: Column(
//                             children: [
//                               const Text('Change Priority').whiteText(),
//                               Slider(
//                                   activeColor: Colors.white,
//                                   value: model.sliderValue,
//                                   divisions: 4,
//                                   min: 1,
//                                   max: 5,
//                                   label: model.sliderValue.toString(),
//                                   onChanged: (value) {
//                                     model.updateValue(value);
//                                   }),
//                               whiteText(dateTime != "NO"
//                                   ? "This Note will Expire in ${DateTime.parse(dateTime).difference(DateTime.now()).inDays.toString()} days "
//                                   : "This Note has no expiry")
//                             ],
//                           ),
//                         );
//                       },
//                     )
//                   : Container()
//             ],
//           ),
//         ),
//         actions: [
//           TextButton(
//               onPressed: () async {
//                 final sliderVal = context.read(editSliderProvider).sliderValue;
//                 if (_formKey.currentState.validate()) {
//                   if (priority != null) {
//                     // context.read(listStateProvider).updateValue(
//                     //     index, noteField.text, sliderVal.toInt());
//                   } else {
//                     context
//                         .read(notesProvider)
//                         .updateValueAt(noteField.text, index);
//                   }
//
//                   Navigator.pop(context, {
//                     "task": noteField.text,
//                     "priority": sliderVal.toInt(),
//                     "isOperationCanceled": false,
//                     "index": index
//                     // "isDateSet" :checkValue,
//                     //  "dateTime": _modelDateTime ?? "NO"
//                   });
//                 }
//               },
//               child: const Text('update').whiteText()),
//           TextButton(
//               onPressed: () => Navigator.pop(context),
//               child: const Text('Cancel').whiteText())
//         ],
//       ),
//     );
//   }
// }

class EditToDoScreen extends StatelessWidget {
  final Function() action;
  final int index;
  final String note;
  final int priority;
  final Color _color;
  final dynamic dateTime;
  final int notificationId;
  final formKey = GlobalKey<FormState>();
  final ongoingNotificationId;
  final scaffoldKey = GlobalKey<ScaffoldMessengerState>();

  EditToDoScreen(this.index, this.note, this._color, this.dateTime,
      {this.priority, this.action, this.notificationId, this.ongoingNotificationId});
  final todoField = TextEditingController();

  final checkValueProvider = StateProvider<bool>((_) => false);

  //TODO:add DateTIme logic

  @override
  Widget build(BuildContext context) {
    // final dateTime = watch(editDateTimeProvider).dateTime;
    context.read(editSliderProvider).updateWithoutNotify(priority.toDouble());
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: CustomColors.backgroundColor,
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          children: [
            AnimatedContainer(
              decoration: BoxDecoration(
                  color: CustomColors.tileColors[priority - 1],
                  border: Border(
                      bottom: BorderSide(
                    color: CustomColors.tileColors[priority - 1],
                    width: 2,
                  ))),
              duration:  const Duration(milliseconds: 400),
              child: SizedBox(
                height: 120,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                        alignment: Alignment.bottomLeft,
                        margin:
                            EdgeInsets.symmetric(horizontal: 70, vertical: 25),
                        child: Text(
                          'Edit ToDO',
                          style: const TextStyle(
                              fontSize: 25, color: Colors.white),
                        )),
                    Positioned(
                      child: FloatingActionButton(
                        backgroundColor: Colors.white,
                        child: Icon(
                          Icons.edit,
                          color: _color,
                        ),
                        onPressed: () {},
                      ),
                      bottom: -30,
                      left: 10,
                    ),
                  ],
                ),
              ),
            ),
            Container(
              margin:const EdgeInsets.only(top: 40, left: 20, right: 20),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                        child: Container(
                            padding: EdgeInsets.only(top: 10),
                            margin: EdgeInsets.only(right: 10),
                            child: const Icon(
                              Icons.notes_rounded,
                              size: 28,
                              color: Colors.white,
                            )),
                        flex: 3,
                      ),
                      Flexible(
                        child: Form(
                          key: formKey,
                          child: CustomTextFormInput(
                            borderColor: Colors.white,
                            labelText: (note.length > 25
                                ? note.substring(0, 25) + "..."
                                : note),
                            validator: normalValidator,
                            textEditingController: todoField,
                            icon: Icons.notes_rounded,
                          ),
                        ),
                        flex: 9,
                      ),
                    ],
                  ),
                  const  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                        child: const Text(
                          'Priority',
                          textAlign: TextAlign.end,
                          style: TextStyle(color: Colors.white),
                        ),
                        flex: 2,
                      ),
                      Flexible(
                        child: Consumer(
                          builder: (context, watch, child) {
                            final sliderVal =
                                watch(editSliderProvider).sliderValue;
                            return Slider(
                                divisions: 4,
                                activeColor: _color,
                                label: sliderVal.toString(),
                                min: 1,
                                max: 5,
                                value: sliderVal,
                                onChanged: (val) => context
                                    .read(editSliderProvider)
                                    .updateValue(val));
                          },
                        ),
                        flex: 8,
                      )
                    ],
                  ),
                  const  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                        child: Container(
                          margin: EdgeInsets.only(right: 25),
                          child: Consumer(
                            builder: (context, watch, child) {
                           if(dateTime !="NO" && dateTime.isBefore(DateTime.now()))
                             return Text('Already Shown').whiteText();
                              return Text(
                                (dateTime == null || dateTime == "NO") &&
                                        watch(editDateTimeProvider).dateTime ==
                                            null
                                    ? 'Not Scheduled'
                                    : 'Scheduled At',
                                textAlign: TextAlign.end,
                              ).whiteText();
                            },
                          ),
                        ),
                        flex: 4,
                      ),
                      Flexible(
                        child: TextButton(onPressed: () async {
                          FocusScope.of(context).unfocus();
                          setDate(context);
                        }, child: Consumer(
                          builder: (context, watch, child) {
                            //readability 0

                            if ((dateTime == null || dateTime == "NO") &&
                                watch(editDateTimeProvider).dateTime == null) {
                              return Text('Pick Date').whiteText();
                            } else {
                              if (watch(editDateTimeProvider).dateTime !=
                                  null) {
                                return Text(context
                                        .read(editDateTimeProvider)
                                        .dateTime
                                        .toString()
                                        .substring(0, 16))
                                    .whiteText();
                              } else if (dateTime != null && dateTime != "NO" ){
                                if(dateTime.isAfter(DateTime.now()))
                                return Text(
                                        dateTime.toString().substring(0, 16))
                                    .whiteText();
                                return Text('Click to Reschedule').whiteText();
                              }
                            }

                            return Container();
                          },
                        )),
                        flex: 8,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Show In Notification?').whiteText(),
                      Consumer(
                        builder: (context, watch, child) {

                          return Theme(
                            data: ThemeData(
                                unselectedWidgetColor: _color,
                                accentColor: _color),
                            child: Checkbox(
                                focusColor: Colors.grey,
                                checkColor: Colors.white,
                                value:  watch(checkValueProvider).state,
                                onChanged: (newVal) {
                                  context.read(checkValueProvider).state =
                                      newVal;
                                }),
                          );
                        },
                      )
                    ],
                  ),
                  const  SizedBox(
                    height: 30,
                  ),
                  OutlinedButton.icon(
                    onPressed: () {
                      if(context.read(editDateTimeProvider).dateTime.isBefore(DateTime.now())){
                        scaffoldKey.currentState.showSnackBar(SnackBar(
                          content: const Text('Unfortunately, This app can\'t notify you in past :D').whiteText(),
                          backgroundColor: CustomColors.tileColors[
                          context.read(editSliderProvider).sliderValue.toInt() - 1],
                        ));
                      }
                      else{
                        Navigator.pop(
                            context,
                            AddToDoData(
                                task: todoField.text.isNotEmpty
                                    ? todoField.text
                                    : note,
                                priority: context
                                    .read(editSliderProvider)
                                    .sliderValue
                                    .toInt(),
                                index: index,
                                notificationId: notificationId,
                                datetime:
                                context.read(editDateTimeProvider).dateTime ??
                                    "NO",
                                isNotificationScheduled:
                                dateTime != "NO" ? true : false,
                                tobeShownInNotification:
                                ongoingNotificationId != -1 ? true : context.read(checkValueProvider).state));
                      }

                    },
                    icon: const Icon(
                      Icons.check,
                      color: Colors.white,
                    ),
                    label:const  Text('Update').whiteText(),
                   style: ButtonStyle(
                     backgroundColor: MaterialStateProperty.all(_color),
                   ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
      appBar:  AppBar(
        backgroundColor: CustomColors.backgroundColor,
        shadowColor: Colors.transparent,
        leading: IconButton(
          onPressed: action,
          icon:const  Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  void setDate(BuildContext context) async {
    DateTime _tempVar = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime(2022), builder: (context, child) {
      return Theme(
        data: ThemeData(
          colorScheme: ColorScheme.light(primary: _color),

        ),
        child: child,
      );
    });
    if (_tempVar != null) {
      TimeOfDay time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
          builder: (context, child) {
            return Theme(
              data: ThemeData(
                colorScheme: ColorScheme.light(primary: _color),

              ),
              child: child,
            );
          }
      );
      if (time != null) {
        _tempVar = DateTime(_tempVar.year, _tempVar.month, _tempVar.day,
            time.hour, time.minute);
        if (_tempVar.isBefore(DateTime.now()))
          scaffoldKey.currentState.showSnackBar(SnackBar(
            content:
                Text('Unfortunately, This app can\'t notify you in past :D')
                    .whiteText(),
            backgroundColor: CustomColors.tileColors[
                context.read(editSliderProvider).sliderValue.toInt() - 1],
          ));
        else {
          context.read(editDateTimeProvider).updateDate(_tempVar);
        }
      }
    }
  }
  //
  // void kekmate( BuildContext context) {
  //
  //   if(ongoingNotificationId != context.read(checkValueEditProvider).state )
  //    checkValueEditProvider = StateProvider<int>((_) => ongoingNotificationId);
  // }
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
