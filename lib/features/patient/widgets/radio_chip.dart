import 'package:flutter/material.dart';

class RadioChip extends StatelessWidget {
  const RadioChip({
    super.key,
    required this.label,
    required this.groupValue,
    required this.value,
    required this.onChanged,
  });
  final String label;
  final String? groupValue;
  final String value;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onChanged(value),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Radio<String>(
            value: value,
            groupValue: groupValue,
            onChanged: onChanged,
          ),
          Text(label),
        ],
      ),
    );
  }
}
