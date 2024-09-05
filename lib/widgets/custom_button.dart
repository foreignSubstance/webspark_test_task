import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final void Function()? func;
  final String label;
  const CustomButton({super.key, required this.func, required this.label});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: func,
      style: TextButton.styleFrom(
        backgroundColor: const Color(0xff40c4ff),
        shape: RoundedRectangleBorder(
          side: const BorderSide(
            color: Color(0xff448aff),
          ),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: Text(
        label,
        style: const TextStyle(color: Colors.black),
      ),
    );
  }
}
