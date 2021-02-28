import 'package:flutter/material.dart';
import 'package:flutter_app/providers.dart';
import 'package:flutter_riverpod/all.dart';

import 'MainScreen.dart';
import 'RandomColors.dart';
import 'design.dart';

class AddToDoScreen extends StatelessWidget {
  final Function() action;

  final todoField = TextEditingController();

  final checkValueProvider = StateProvider<bool>((_) => false);
  final colorProvider = Provider<int>((ref) {
    return ref.watch(sliderProvider).sliderValue.toInt();
  });

  final formKey = GlobalKey<FormState>();

  final scaffoldKey = GlobalKey<ScaffoldState>();
  //TODO:add DateTIme logic
  AddToDoScreen({this.action});
  @override
  Widget build(BuildContext context) {
    // final dateTime = watch(dateTimeProvider).dateTime;

    return Scaffold(
      key: scaffoldKey,
      backgroundColor: CustomColors.backgroundColor,
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          children: [
            Consumer(
              builder: (context, watch, child) {
                return AnimatedContainer(
                  curve: Curves.easeIn,
                  decoration: BoxDecoration(
                      color: CustomColors.backgroundColor,
                      border: Border(
                          bottom: BorderSide(
                        color:
                            CustomColors.tileColors[watch(colorProvider) - 1],
                        width: 2,
                      ))),
                  duration: Duration(milliseconds: 100),
                  child: Container(
                    height: 120,
                    child: Stack(
                      overflow: Overflow.visible,
                      children: [
                        Container(
                            alignment: Alignment.bottomLeft,
                            margin: EdgeInsets.symmetric(
                                horizontal: 70, vertical: 25),
                            child: Text(
                              'Add ToDO',
                              style: const TextStyle(
                                  fontSize: 25, color: Colors.white),
                            )),
                        Positioned(
                          child: AnimatedContainer(
                            duration: Duration(milliseconds: 100),
                            height: 50,
                            width: 50,
                            curve: Curves.easeIn,
                            child: Icon(
                              Icons.sticky_note_2_outlined,
                              color: Colors.white,
                            ),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                color: CustomColors
                                    .tileColors[watch(colorProvider) - 1]),
                          ),
                          bottom: -27,
                          left: 10,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            Container(
              margin: EdgeInsets.only(top: 40, left: 20, right: 20),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                        child: Container(
                            padding: EdgeInsets.only(top: 10),
                            margin: EdgeInsets.only(right: 10),
                            child: Icon(
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
                            labelText: "note",
                            validator: normalValidator,
                            textEditingController: todoField,
                            icon: Icons.notes_rounded,
                          ),
                        ),
                        flex: 9,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                        child: Text(
                          'Priority',
                          textAlign: TextAlign.end,
                          style: TextStyle(color: Colors.white),
                        ),
                        flex: 2,
                      ),
                      Flexible(
                        child: Consumer(
                          builder: (context, watch, child) {
                            return Slider(
                                activeColor: CustomColors
                                    .tileColors[watch(colorProvider) - 1],
                                divisions: 4,
                                label: watch(sliderProvider)
                                    .sliderValue
                                    .toString(),
                                min: 1,
                                max: 5,
                                value: watch(sliderProvider).sliderValue,
                                onChanged: (val) => context
                                    .read(sliderProvider)
                                    .updateValue(val));
                          },
                        ),
                        flex: 8,
                      )
                    ],
                  ),
                  SizedBox(
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
                              return Text(
                                watch(dateTimeProvider).dateTime == null
                                    ? 'Date'
                                    : 'Scheduled at',
                                textAlign: TextAlign.end,
                              ).whiteText();
                            },
                          ),
                        ),
                        flex: 4,
                      ),
                      Flexible(
                        child: FlatButton(onPressed: () async {
                          FocusScope.of(context).unfocus();
                          setDate(context);
                        }, child: Consumer(
                          builder: (context, watch, child) {
                            return Text(watch(dateTimeProvider).dateTime == null
                                    ? 'Pick Date (Optional)'
                                    : watch(dateTimeProvider)
                                        .dateTime
                                        .toString()
                                        .substring(0, 16))
                                .whiteText();
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
                      Text('Show Ongoing Notification?').whiteText(),
                      Consumer(
                        builder: (context, watch, child) {
                          return Theme(
                            data: ThemeData(
                                unselectedWidgetColor: CustomColors
                                    .tileColors[watch(colorProvider) - 1]),
                            child: Checkbox(
                                checkColor: Colors.white,
                                activeColor: CustomColors
                                    .tileColors[watch(colorProvider) - 1],
                                value: watch(checkValueProvider).state,
                                onChanged: (newVal) {
                                  context.read(checkValueProvider).state =
                                      newVal;
                                }),
                          );
                        },
                      )
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  FlatButton.icon(
                    onPressed: () {
                    if(context.read(dateTimeProvider).dateTime.isBefore(DateTime.now())){
                      scaffoldKey.currentState.showSnackBar(SnackBar(
                        content: Text('Unfortunately, This app can\'t notify you in past :D').whiteText(),
                        backgroundColor: CustomColors.tileColors[
                        context.read(colorProvider) - 1],
                      ));}
                        else{
                          Navigator.pop(
                              context,
                              AddToDoData(
                                  task: todoField.text,
                                  priority: context
                                      .read(sliderProvider)
                                      .sliderValue
                                      .toInt(),
                                  datetime:
                                      context.read(dateTimeProvider).dateTime ??
                                          "NO",
                                  isNotificationScheduled:
                                      context.read(dateTimeProvider).dateTime !=
                                              null
                                          ? true
                                          : false,
                                  tobeShownInNotification:
                                      context.read(checkValueProvider).state));
                        }
                    },
                    icon: Icon(
                      Icons.check,
                      color: Colors.white,
                    ),
                    label: Text('Add').whiteText(),
                    padding: EdgeInsets.all(20),
                    // color: Colors.blueAccent,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
      appBar: AppBar(
        backgroundColor: CustomColors.backgroundColor,
        shadowColor: Colors.transparent,
        leading: IconButton(
          onPressed: action,
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
      ),
      // bottomNavigationBar: BottomAppBar(
      // child: Container(
      //   height: 50,
      //   child: Row(
      //     children: [
      //       IconButton(icon: Icon(Icons.arrow_back), onPressed: (){
      //       Navigator.pop(context);
      //       }),
      //     ],
      //   ),
      // ),
      // ),
    );
  }

  void setDate(BuildContext context) async {
    DateTime _tempVar = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime(2022),
    builder: (context, child) {
      return Theme(
        data: ThemeData(
          colorScheme: ColorScheme.light(primary: CustomColors.tileColors[
          context.read(sliderProvider).sliderValue.toInt() - 1]),
          textTheme: TextTheme(headline6: TextStyle()),

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
                colorScheme: ColorScheme.light(primary: CustomColors.tileColors[
                context.read(sliderProvider).sliderValue.toInt() - 1]),

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
            content: Text('Unfortunately, This app can\'t notify you in past :D').whiteText(),
            backgroundColor: CustomColors.tileColors[
                context.read(colorProvider) - 1],
          ));
        else {
          context.read(dateTimeProvider).updateDate(_tempVar);
        }
      }
    }
  }
}
