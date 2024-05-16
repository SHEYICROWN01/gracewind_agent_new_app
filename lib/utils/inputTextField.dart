import 'package:flutter/material.dart';

// ignore: must_be_immutable
class InputTextFields extends StatelessWidget {
  InputTextFields(
      {Key? key,
        required this.label,
        required this.controller,
        required this.isNumber,
        required this.icon,
        required this.enableEditing,
        required this.suffixIcon,
      })
      : super(key: key);
  String label;
  bool? isNumber = false;
  bool? enableEditing = false;
  Icon? icon;
  IconButton ? suffixIcon;
  TextEditingController controller;
  @override
  Widget build(BuildContext context) {
    //TextStyle? textStyle = Theme.of(context).textTheme.headline6;
    return Padding(
      padding: const EdgeInsets.only(
          top: 15.0, bottom: 15.0, right: 15.0, left: 15.0),
      child: SizedBox(
        height: 40,
        width: MediaQuery.of(context).size.width,
        child: TextField(
          keyboardType: isNumber! ? TextInputType.phone : TextInputType.text,
          controller: controller,
          enabled: enableEditing,
          style: const TextStyle(fontSize: 12),
          decoration: InputDecoration(
              icon: icon,
              labelText: label,
              suffixIcon: suffixIcon,
              labelStyle: const TextStyle(fontSize: 12),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0))),
        ),
      ),
    );
  }
}
