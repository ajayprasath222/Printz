import 'package:flutter/material.dart';

class CustomRadioButton extends StatelessWidget {
  final List<String> options;
  final String selectedOption;
  final ValueChanged<String> onChanged;

  const CustomRadioButton({super.key, 
    required this.options,
    required this.selectedOption,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: options.map((option) {
        return Row(
          children: [
            Radio(
              value: option,
              groupValue: selectedOption,
              onChanged: (value) => onChanged(value!),
            ),
            Text(option),
          ],
        );
      }).toList(),
    );
  }
}
