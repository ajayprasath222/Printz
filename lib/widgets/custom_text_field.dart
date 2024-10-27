import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String? label;
  final String? hint;
  final ValueChanged<String>? onChanged;
  final int maxLines;

  const CustomTextField({super.key, 
    this.label,
    this.hint,
    this.onChanged,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        border: const OutlineInputBorder(),
      ),
      onChanged: onChanged,
      maxLines: maxLines,
    );
  }
}
