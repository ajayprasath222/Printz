import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String label;
  final int maxLines;
  final TextInputType keyboardType;
  final ValueChanged<String>? onChanged; // Make onChanged nullable

  const CustomTextField({
    super.key,
    required this.label,
    this.maxLines = 1,
    this.keyboardType = TextInputType.text,
    this.onChanged, // Optional onChanged
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      keyboardType: keyboardType,
      maxLines: maxLines,
      onChanged: onChanged, // Optional usage
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
    );
  }
}
