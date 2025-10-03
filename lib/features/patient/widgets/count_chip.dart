import 'package:flutter/material.dart';

class CountChip extends StatelessWidget {
  const CountChip({super.key, required this.label, required this.value});
  final String label;
  final int value;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFF1B5E20),
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Color(0xFFE5E7EB)),
          ),
          child: Text(
            '$value',
            style: const TextStyle(
              color: Color(0xFF1B5E20),
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}
