import 'package:flutter/material.dart';

/// Return a nice [InputDecoration] for our login and signup forms
InputDecoration customInputDecorator({
  String? labelText,
  String? hintText,
  IconData? icon,
}) =>
    InputDecoration(
      //fillColor: Colors.white,
      filled: true,
      enabledBorder: const OutlineInputBorder(
        borderSide: BorderSide(
          //color: Color.fromARGB(148, 33, 149, 243),
          width: 2,
        ),
      ),
      focusedBorder: const OutlineInputBorder(
        borderSide: BorderSide(
          //color: Colors.blue,
          width: 2,
        ),
      ),
      errorBorder: const OutlineInputBorder(
        borderSide: BorderSide(
          //  color: Colors.red,
          width: 2,
        ),
      ),
      labelText: labelText,
      hintText: hintText,
      prefixIcon: icon != null ? Icon(icon) : null,
    );

/// Return a standard space for form fields
const SizedBox formFieldSpace = SizedBox(height: 15);
