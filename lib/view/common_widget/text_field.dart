import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  TextEditingController? controller;
  String? hintText;
  bool obscureText;
  String? Function(String?)? validator;
  TextInputType? keyboardType;

  MyTextField({super.key, required this.controller, required this.hintText, required this.obscureText, this.validator, required this.keyboardType});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
      child: TextFormField(
        controller: controller,
        validator: validator,
        obscureText: obscureText,
        keyboardType: keyboardType,
        textInputAction:TextInputAction.next,
        decoration: InputDecoration(
          hintText: hintText,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 18.0, vertical: 2.0),
          enabledBorder:  OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0),
            borderSide: BorderSide(color: Colors.black),
          ),
          focusedBorder:  OutlineInputBorder(
              borderRadius: BorderRadius.circular(30.0),
              borderSide: BorderSide(color: Colors.deepPurple)),
          errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide(color: Colors.red)),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30.0),
              borderSide: BorderSide(color: Colors.red)),
        ),
      ),
    );
  }
}
