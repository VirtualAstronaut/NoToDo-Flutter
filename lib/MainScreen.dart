import 'dart:async';

import 'package:animations/animations.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_app/AddToDoScreen.dart';
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
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:io' show Platform;
import 'package:timezone/timezone.dart' as timezone;
import 'package:timezone/data/latest.dart' as timezone;
import 'design.dart';
import 'savetojson.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

final listKey = GlobalKey<AnimatedListState>();

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  var listenFalseModel;
  AnimationController animationController;
  Animation<Color> animColors;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  // Future<Map<String, dynamic>> getData(BuildContext context) async {
  //   var data;
  //   data = await SaveToLocal()
  //       .readFromStorage()
  //       .catchError((onError) => context.read(progressProvider).setProgress());
  //   return data;
  // }

  @override
  void initState() {
    timezone.initializeTimeZones();
    if (!context.read(progressProvider).isDone) getDataAsync();
    animationController =
        AnimationController(vsync: this, duration: Duration(seconds: 3))
          ..repeat(
            reverse: true,
          );

    animColors = AnimatedColors.circleColor.animate(animationController);
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      if (result == ConnectivityResult.none) {
        ConnectivityStatus.setDisconnectedConnectivity();
      } else {
        if (ConnectivityStatus.isConnected) {
          ConnectivityStatus.setConnectivityStatus();
          syncWithCloud();
        }
      }
    });
    super.initState();
  }

  // Stream<List<ToDo>> getTodoStream()async*{
  //   final list = context.read(listStateProvider.state);
  //   yield list;
  // }
  Future<void> syncWithCloud() async {
    // await CloudNotes()
    //     .syncLocalNotesWithCloud(context.read(listStateProvider.state));
  }
  Future<void> getTodos() async {
    final sheetChecker = SheetChecker();
    if (await sheetChecker.isSheetSet() && ConnectivityStatus.isConnected) {
      final todoList =
          await CloudNotes().getNotes(await sheetChecker.getSheetID());
      return todoList;
    } else {
      Map<String, dynamic> localMapList;
      await SaveToLocal().readFromStorage().catchError((onError) {});
      if (localMapList.isEmpty) return;
      if (localMapList != null) {
        List<ToDo> todoList;
        todoList = localMapList.entries.map((element) {
          return ToDo(
              element.value[0],
              element.value[1],
              element.value[2] != "NO"
                  ? DateTime.parse(element.value[2])
                  : "NO",
              isNotificationScheduled: element.value[3],
              notificationId: element.value[4],
              ongoingNotificationId: element.value[5]);
        }).toList();
        todoList
            .sort((todoA, todoB) => todoB.priority.compareTo(todoA.priority));
        context.read(listStateProvider).addBatch(todoList);
      }
    }
  }

  Future<void> getDataAsync() async {
    final sheetChecker = SheetChecker();
    if (await sheetChecker.isSheetSet() && ConnectivityStatus.isConnected) {
      final todoList =
          await CloudNotes().getNotes(await sheetChecker.getSheetID());
      context.read(listStateProvider).addBatch(todoList);
      context.read(progressProvider).setProgress();
    } else {
      final localMapList =
          await SaveToLocal().readFromStorage().catchError((onError) {
        SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
          context.read(progressProvider).setProgress();
        });
      });
      if (localMapList != null) {
        List<ToDo> todoList;
        todoList = localMapList.entries.map((element) {
          return ToDo(
              element.value[0],
              element.value[1],
              element.value[2] != "NO"
                  ? DateTime.parse(element.value[2])
                  : "NO",
              isNotificationScheduled: element.value[3],
              notificationId: element.value[4],
              ongoingNotificationId: element.value[5]);
        }).toList();
        todoList
            .sort((todoA, todoB) => todoB.priority.compareTo(todoA.priority));
        context.read(listStateProvider).addBatch(todoList);
        SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
          context.read(progressProvider).setProgress();
        });
      }
    }
  }

  Future<void> saveToLocalorCloud(String task, int priority, dateTime,
      bool tobeShownNotification, bool isNotificationScheduled) async {
    final DateTime _modelDateTime = context.read(dateTimeProvider).dateTime;
    final syncProviderVar = context.read(syncProvider);
    await syncProviderVar.uploadToDo(
        priority: priority,
        task: task,
        modelDateTime: _modelDateTime,
        isNotificationScheduled: isNotificationScheduled,
        tobeShownNotification: tobeShownNotification);
  }

  void onClosed(AddToDoData data) async {
    if (data != null)
      await saveToLocalorCloud(data.task, data.priority, data.datetime,
          data.tobeShownInNotification, data.isNotificationScheduled);
    context.read(dateTimeProvider).resetDate();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      extendBody: true,
      drawer: SideDrawer(
        isNotes: false,
      ),
      backgroundColor: CustomColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: CustomColors.backgroundColor,
        shadowColor: Colors.transparent,
        title: Consumer(
          builder: (context, watch, child) {
            final syncProgress = watch(syncProvider.state);
            if (!syncProgress) {
              return const Text(
                'To-Do List',
              ).whiteText();
            } else {
              return Row(
                children: [
                  const Text('Syncing..').whiteText(),
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
        actions: [
          IconButton(
              icon: Icon(
                Icons.clear_all_rounded,
                color: Colors.white,
              ),
              onPressed: () async {
                showDialog(
                  context: context,
                  builder: (context) {
                    return  AlertDialog(
                      backgroundColor: CustomColors.backgroundColor,
                      title: const Text('Clear All').whiteText(),
                      actions: [
                        TextButton(
                            onPressed: () {
                              context.read(syncProvider).clearAll();
                              Navigator.of(context).pop();
                            },
                            child:const Text('Yes').whiteText()),
                        TextButton(
                            onPressed: () => Navigator.pop(context),
                            child:const Text('No').whiteText())
                      ],
                    );
                  },
                );
              })
        ],
      ),
      floatingActionButton: OpenContainer<AddToDoData>(
          openColor: Colors.transparent,
          closedColor: Colors.transparent,
          closedShape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
          onClosed: onClosed,
          closedBuilder: (context, action) {
            return FloatingActionButton(
                child: Icon(Icons.add), onPressed: action);
          },
          openBuilder: (context, action) {
            return AddToDoScreen(
              action: action,
            );
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
                      final todoList = watch(listStateProvider.state);
                      final progressModel = watch(progressProvider).isDone;
                      if (!progressModel)
                        return Center(
                            child: CircularProgressIndicator(
                          valueColor: animColors,
                        ));
                      else if ( todoList.length == 0) {
                        return Center(
                          child: whiteText('No ToDo yet'),
                        );
                      } else  {
                        return ListView.builder(
                          physics: BouncingScrollPhysics(),
                          key: listKey,
                          itemCount: todoList.length,
                          // itemCount: ,
                          itemBuilder: (context, index) {
                            final items = todoList;
                            final item = items[index];
                            return Dismissible(
                              key: Key(item.task),
                              background: Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                alignment: AlignmentDirectional.centerStart,
                                child: const Icon(
                                  Icons.delete,
                                  color: Colors.white,
                                ),
                              ),
                              secondaryBackground: Container(
                                padding: EdgeInsets.symmetric(horizontal: 20),
                                alignment: AlignmentDirectional.centerEnd,
                                child: Icon(
                                  Icons.delete,
                                  color: Colors.white,
                                ),
                              ),
                              dismissThresholds: {
                                DismissDirection.endToStart: 0.5
                              },
                              onDismissed: (direction) async {
                                await context
                                    .read(syncProvider)
                                    .deleteLocalToDo(index);
                                // await CloudNotes().deleteAtIndex(index);
                              },
                              child: CustomContainer(
                                todoList[index].task,
                                CustomColors
                                    .tileColors[todoList[index].priority - 1],
                                MediaQuery.of(context).size.width,
                                index,
                                todoList[index].dateTime,
                                priority: todoList[index].priority,
                                notificationId: todoList[index].notificationId,
                                ongoingNotificationId:
                                    todoList[index].ongoingNotificationId,
                              ),
                            );
                          },
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
    super.dispose();
    animationController.dispose();
  }
}

class AddToDoData {
  final String task;
  final int priority;
  final dynamic datetime;
  final int index;
  final int notificationId;
  final int ongoingNotificationId;
  final bool isNotificationScheduled;
  final bool tobeShownInNotification;
  AddToDoData(
      {this.ongoingNotificationId,
      this.notificationId,
      this.task,
      this.isNotificationScheduled,
      this.priority,
      this.index,
      this.datetime,
      this.tobeShownInNotification = false});
}
