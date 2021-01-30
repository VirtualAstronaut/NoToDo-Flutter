import 'package:flutter/material.dart';

class AddTaskScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final TextEditingController _taskDesc = TextEditingController();

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
              margin: EdgeInsets.symmetric(horizontal: 50),
              child: TextField(
                controller: _taskDesc,
                decoration: InputDecoration(hintText: 'Task'),
              )),
          RaisedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('Add'),
          )
        ],
      ),
    );
  }
}
