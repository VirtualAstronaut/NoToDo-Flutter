import 'package:flutter/material.dart';

Text whiteText(String data) {
  return Text(
    data,
    style: const TextStyle(color: Colors.white),
  );
}

class CustomTextFormInput extends StatelessWidget {
  final String initialValue;
  final Function validator;
  final TextEditingController textEditingController;
  final IconData icon;
  final Color textColor;
  final Color borderColor;
  final String helperText;
  final String labelText;
  CustomTextFormInput(
      {this.initialValue,
      this.validator,
      this.textEditingController,
      this.icon,
      this.helperText,
      this.textColor,
      this.borderColor,
      this.labelText});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: initialValue,
      validator: validator,
      controller: textEditingController,
      cursorColor: textColor ?? Colors.white,
      style: TextStyle(color: textColor ?? Colors.white),
      decoration: InputDecoration(
          labelText: labelText,
          labelStyle: TextStyle(color: textColor ?? Colors.white),
          helperText: helperText,
          helperStyle: TextStyle(color: textColor ?? Colors.white),
          floatingLabelBehavior: FloatingLabelBehavior.auto,
          errorBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.red.shade500)),
          errorStyle: TextStyle(color: Colors.red.shade50),
          focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: borderColor ?? Colors.white)),
          enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.grey))),
    );
  }
}

Function normalValidator = (String val) {
  if (val.isEmpty) {
    return "Don't leave this Empty";
  }
  return null;
};

UnderlineInputBorder underlineInputBorder() {
  return const UnderlineInputBorder(
      borderSide: BorderSide(color: Colors.white));
}

extension CustomText on Text {
  Text whiteText() {
    return Text(this.data, style: const TextStyle(color: Colors.white));
  }

  Widget whiteCenterText() {
    return Center(
        child: Text(
      this.data,
      style: const TextStyle(color: Colors.white),
    ));
  }

  Text blackText() {
    return Text(this.data, style: const TextStyle(color: Colors.black));
  }
}

class ConditionWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
