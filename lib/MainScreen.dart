import 'dart:async';
import 'dart:convert';
import 'package:flutter_app/connectivitychecker.dart';

import 'package:flutter_app/models/ListHold.dart';

import 'animatedcolors.dart';
import 'providers.dart';

import 'package:flutter/material.dart';

import 'package:flutter_app/CustomContainers.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter_app/Drawer.dart';

import 'package:flutter_app/RandomColors.dart';
import 'package:flutter_app/models/cloudModel.dart';
import 'package:flutter_app/main.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/all.dart';

import 'design.dart';
import 'savetojson.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

// class BuildMenu extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return SingleChildScrollView(
//       padding: const EdgeInsets.symmetric(vertical: 50.0),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Padding(
//             padding: const EdgeInsets.only(left: 8.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.only(left: 8.0),
//                   child: Column(
//                     children: [
//                       CircleAvatar(
//                         backgroundColor: Colors.white,
//                         backgroundImage: AssetImage('assests/avatar.jpg'),
//                         radius: 40,
//                       ),
//                       SizedBox(height: 36.0),
//                       RichText(
//                         text:
//                             TextSpan(style: TextStyle(fontSize: 25), children: [
//                           TextSpan(
//                               text: "Virtual \nAstronaut",
//                               style: TextStyle(fontWeight: FontWeight.bold))
//                         ]),
//                       ),
//                     ],
//                   ),
//                 ),
//                 SizedBox(height: 20.0),
//                 SizedBox(
//                   width: 200,
//                   height: 500,
//                   child: ListView(
//                     padding: EdgeInsets.zero,
//                     children: [
//                       ListTile(
//                         leading: Icon(
//                           Icons.bookmark,
//                           color: Colors.white,
//                         ),
//                         title: whiteText('Save List'),
//                         onTap: () {},
//                       ),
//                       ListTile(
//                         leading: Icon(
//                           Icons.cloud,
//                           color: Colors.white,
//                         ),
//                         title: whiteText('Upload To Cloud'),
//                       ),
//                       ListTile(
//                         leading: Icon(
//                           Icons.exit_to_app,
//                           color: Colors.white,
//                         ),
//                         title: whiteText('Exit'),
//                       )
//                     ],
//                   ),
//                 )
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

final mainScreenScaffoldKey = GlobalKey<ScaffoldState>();

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  var listenFalseModel;
  AnimationController animationController;
  Animation<Color> animColors;

  Future<Map<String, dynamic>> getData(BuildContext context) async {
    var data;
    data = await SaveToLocal()
        .readFromStorage()
        .catchError((onError) => context.read(progressProvider).setProgress());
    return data;
  }

  @override
  void initState() {
    if (!context.read(progressProvider).isDone) getDataAsync();
    animationController =
        AnimationController(vsync: this, duration: Duration(seconds: 3))
          ..repeat(
            reverse: true,
          );

    animColors = AnimatedColors.circleColor.animate(animationController);
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      if(result == ConnectivityResult.none){
      ConnectivityStatus.setDisconnectedConnectivity();}
      else{

        if (ConnectivityStatus.isConnected){
          ConnectivityStatus.setConnectivityStatus();
        print('kekekkekekeee');
      syncWithCloud();
      }

      }
    });
    super.initState();

  }
  Future<void>syncWithCloud()async{

    await  CloudNotes().syncLocalNotesWithCloud(
      context.read(listStateProvider.state)
    );
  }
  Future<void> getDataAsync() async {
    final sheetChecker = SheetChecker();
    print(ConnectivityStatus.isConnected);
    if (await sheetChecker.isSheetSet() &&
        ConnectivityStatus.isConnected) {
      var todoList =
          await CloudNotes().getNotes(await sheetChecker.getSheetID());
      context.read(listStateProvider).addBatch(todoList);
    } else {
      var localMapList =
          await SaveToLocal().readFromStorage().catchError((onError) {
        context.read(progressProvider).setProgress();
      });
      if (localMapList != null) {
        List<ToDo> todoList;
        todoList = localMapList.entries.map((element) {
          return ToDo(element.value[0], element.value[1], element.value[2]);
        }).toList();
        todoList.sort((todoA,todoB) => todoB.priority.compareTo(todoA.priority));
        context.read(listStateProvider).addBatch(todoList);
      } else {
        context.read(progressProvider).setProgress();
      }
    }
    context.read(progressProvider).setProgress();
  }

  setUpNotification(String payload) async {
    var tempJSON = json.decode(payload);


    final NotificationDetails platformChannelDetails =
    NotificationDetails(android: notificationDetails);
    await flutterLocalNotificationsPlugin.show(
        tempJSON["1"][1], "ToDo", tempJSON["1"][0], platformChannelDetails);
  }

  Future<void> saveToLocalorCloud(String task, int priority, dateTime, bool tobeShownNotification,) async{
    context.read(syncProgressProvider).setSyncing();
    DateTime _modelDateTime = context.read(dateTimeProvider).dateTime;

  final model = context.read(listStateProvider);
   int index=  model.addValue(task, priority,
        _modelDateTime ?? "NO");

    await SaveToLocal().save(model.todoList);


    if (tobeShownNotification) {
      var jsonVar = {
        "1": [task, model.todoList.length - 1]
      };
      String temp = json.encode(jsonVar);
      setUpNotification(temp);
    }

    if (await SheetChecker().isSheetSet() &&
        ConnectivityStatus.isConnected) {
       await CloudNotes().uploadCloudNote(
         index: index +1 ,
          task:task,
          priority: priority,
          dateTime: _modelDateTime != null
              ? _modelDateTime.toString()
              : "NO");
    }

    context.read(dateTimeProvider).resetDate();
    context.read(syncProgressProvider).syncProgressDone();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: mainScreenScaffoldKey,
      drawer: SideDrawer(
        isNotes: false,
      ),
      backgroundColor: CustomColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: CustomColors.backgroundColor,
        shadowColor: Colors.transparent,
        title: Consumer(
          builder: (context, watch, child) {
            var syncProgress = watch(syncProgressProvider.state);
            if (!syncProgress) {
              return const Text('To-Do List');
            } else {
              return Row(
                children: [
                  const Text('Syncing..'),
                  Container(
                    margin: const EdgeInsets.only(left: 10),
                    width: 25,
                    height: 25,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: animColors,
                    ),
                  )
                ],
              );
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () async {
            Map<String, dynamic> alertdataMap =
                await showDialog(context: context, builder: (con) => AddToDo());
            if (alertdataMap != null) {
              String task = alertdataMap["task"];
              int priority = alertdataMap["priority"];
              bool isDateSet = alertdataMap["isDateSet"];
               dynamic dateTime = alertdataMap["dateTime"];
              await saveToLocalorCloud(task,priority,dateTime,isDateSet);
            }

          }),
      body: Column(
        children: [
          Container(padding: EdgeInsets.all(5), child: Container()),
          Expanded(
            child: Container(
              child: Column(
                children: [
                  Expanded(
                    child: Consumer(builder: (context, watch, child) {
                      // var kek = watch(cloudTodoProvider.stream);
                      var todoList = watch(listStateProvider.state);
                      var progressModel = watch(progressProvider).isDone;

                      if (!progressModel)
                        return Center(
                            child: CircularProgressIndicator(
                          valueColor: animColors,
                        ));
                      else if (progressModel && todoList.length == 0) {
                        return Center(
                          child: whiteText('No ToDo yet'),
                        );
                      } else if (progressModel && todoList.length != 0) {
                        return AnimationLimiter(
                          child: ListView.builder(
                            itemCount: todoList.length,
                            // itemCount: ,
                            itemBuilder: (context, index) {
                              final items = todoList;
                              final item = items[index];
                              return AnimationConfiguration.staggeredList(
                                duration: const Duration(milliseconds: 500),
                                position: index,
                                child: FadeInAnimation(
                                  child: ScaleAnimation(
                                    scale: 0.5,
                                    child: Dismissible(
                                      key: Key(item.task),
                                      background: Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20),
                                        alignment:
                                            AlignmentDirectional.centerStart,
                                        child: const Icon(
                                          Icons.delete,
                                          color: Colors.white,
                                        ),
                                      ),
                                      secondaryBackground: Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 20),
                                        alignment:
                                            AlignmentDirectional.centerEnd,
                                        child: Icon(
                                          Icons.delete,
                                          color: Colors.white,
                                        ),
                                      ),
                                      dismissThresholds: {
                                        DismissDirection.endToStart: 0.5
                                      },
                                      onDismissed: (direction) async{
                                        todoList.removeAt(index);
                                        context.read(listStateProvider).removeValue(index);
                                        await CloudNotes().deleteAtIndex(index);
                                      },
                                      child: CustomContainer(
                                        todoList[index].task,
                                        CustomColors.tileColors[
                                            todoList[index].priority - 1],
                                        MediaQuery.of(context).size.width,
                                        index,
                                        todoList[index].dateTime,
                                        priority: todoList[index].priority,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      } else {
                        return Center(
                          child: Text('nothing'),
                        );
                      }

                    }),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }




}

class AddToDo extends StatefulWidget {
  @override
  _AddToDoState createState() => _AddToDoState();
}

class _AddToDoState extends State<AddToDo> {
  final TextEditingController _todoText = TextEditingController();

  final String randomWord = RandomWords.getRandomWord();
  bool checkValue = false;
  final _formKey = GlobalKey<FormState>();

  setUpNotification(String payload) async {
    var tempJSON = json.decode(payload);


    final NotificationDetails platformChannelDetails =
        NotificationDetails(android: notificationDetails);
    await flutterLocalNotificationsPlugin.show(
        tempJSON["1"][1], "ToDo", tempJSON["1"][0], platformChannelDetails);
  }

  void setDate(BuildContext context) async {
    DateTime _tempVar = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime(2025));
    context.read(dateTimeProvider).updateDate(_tempVar);
  }

  @override
  Widget build(BuildContext context) {
    final query = MediaQuery.of(context).size;
    return AlertDialog(
      title: Text('Add Todo'),
      content: Container(
        height: query.height / 2.5,
        alignment: Alignment.center,
        child: Column(
          children: [
            Form(
              key: _formKey,
              child: TextField(
                controller: _todoText,
                decoration: InputDecoration(
                    floatingLabelBehavior: FloatingLabelBehavior.auto,
                    labelText: randomWord),
              ),
            ),
            Container(
                margin: EdgeInsets.only(
                  top: 25,
                ),
                child: Text('Priority')),
            Container(
              child: Consumer(
                builder: (context, watch, child) {
                  var model = watch(sliderProvider);
                  return Slider(
                      value: model.sliderValue,
                      divisions: 4,
                      min: 1,
                      max: 5,
                      label: model.sliderValue.toString(),
                      onChanged: (value) {
                        context.read(sliderProvider).updateValue(value);
                      });
                },
              ),
            ),
            Container(
              child: FlatButton(
                  onPressed: () async {
                    setDate(context);
                  },
                  child: Text('Pick Date')),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Show In Notification?'),
                Checkbox(
                    value: checkValue,
                    onChanged: (newVal) {
                      setState(() {
                        checkValue = newVal;
                      });
                    })
              ],
            ),
          ],
        ),
      ),
      actions: [
        FlatButton(
            onPressed: () => Navigator.pop(context), child: Text('Cancel')),
        FlatButton(
            onPressed: () async {
              final sliderValueProvider = context.read(sliderProvider).sliderValue.round();
              // context.read(syncProgressProvider).setSyncing();
              DateTime _modelDateTime = context.read(dateTimeProvider).dateTime;
              // print(_modelDateTime);
              //
              // // scaffoldKey.currentState.showSnackBar(SnackBar(
              // //     backgroundColor: CustomColors.backgroundColor,
              // //     content: const Text(
              // //       'Saving To Cloud',
              // //       style: TextStyle(color: Colors.white),
              // //     ),
              // //     duration: Duration(seconds: 1)));
              // var model = context.read(listStateProvider);
              // var listModel = context.read(sliderProvider);
              //
              // model.addValue(_todoText.text, listModel.sliderValue.round(),
              //     _modelDateTime ?? "NO");
              //
              // await SaveToLocal().save(model.todoList);
              // // model.setTempDate("NO");
              // // listModel.resetSlider();
              // if (checkValue) {
              //   var jsonVar = {
              //     "1": [_todoText.text, model.todoList.length - 1]
              //   };
              //   String temp = json.encode(jsonVar);
              //   setUpNotification(temp);
              // }
              //
              // Response res;

              // print(ConnectivityStatus.isConnected);
              // print(await SheetChecker().isSheetSet());

              // if (await SheetChecker().isSheetSet() &&
              //     ConnectivityStatus.isConnected) {
              //   res = await CloudNotes().uploadCloudNote(
              //       task: _todoText.text,
              //       priority: listModel.sliderValue.round(),
              //       dateTime: _modelDateTime != null
              //           ? _modelDateTime.toString()
              //           : "NO");
              // }
              //
              // // scaffoldKey.currentState.hideCurrentSnackBar();
              // // http.Response kek = await http.post(
              // //     'https://script.google.com/macros/s/AKfycbxNV_2TtQCi3IljkBVCPHaoOuogeDUEYLdnEJMk1wjaPZ_NyNrmNJjQ/exec',
              // //     body: {
              // //       "task": _todoText.text,
              // //       "priority": listModel.sliderValue.round().toString(),
              // //       "dateTime":
              // //           _selectedDate != null ? _selectedDate.toString() : "NO"
              // //     }).then((value) async {
              // //   if (value.statusCode == 302) {
              // //     var newUrl = value.headers['location'];
              // //     await http.get(newUrl);
              // //   }
              // // });
              // context.read(dateTimeProvider).resetDate();

              Navigator.pop(context, {
                "task": _todoText.text,
                "priority": sliderValueProvider,
                "isDateSet" :checkValue,
                "dateTime": _modelDateTime ?? "NO"
              });
              context.read(syncProgressProvider).syncProgressDone();
            },
            child: Text('ADD')),
      ],
    );
  }

  Future onSelectNotification(String payload) {
    //TODO:Implement on tap handling of notification
    //Navigator.push(context, MaterialPageRoute(builder: (_) => EditNoteFromNotification(payload)));
  }
}
//
// class _AddToDoState extends State<AddToDo> {
//
// }
