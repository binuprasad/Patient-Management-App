import 'package:flutter/material.dart';

class DialogCounterRow extends StatelessWidget {
  const DialogCounterRow({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
  });
  final String label;
  final int value;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    const green = Color(0xFF1B5E20);
    const greyBorder = Color(0xFFE5E7EB);
    const greyFill = Color(0xFFF3F4F6);
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            decoration: BoxDecoration(
              color: greyFill,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: greyBorder),
            ),
            child: Text(label),
          ),
        ),
        const SizedBox(width: 12),
        _CircleIconButton(
          icon: Icons.remove,
          onTap: () {
            if (value > 0) onChanged(value - 1);
          },
        ),
        const SizedBox(width: 8),
        Container(
          width: 36,
          height: 36,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: greyBorder),
          ),
          child: Text(
            '$value',
            style: const TextStyle(color: green, fontWeight: FontWeight.w600),
          ),
        ),
        const SizedBox(width: 8),
        _CircleIconButton(
          icon: Icons.add,
          onTap: () => onChanged(value + 1),
        ),
      ],
    );
  }
}

class _CircleIconButton extends StatelessWidget {
  const _CircleIconButton({required this.icon, required this.onTap});
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      customBorder: const CircleBorder(),
      child: Ink(
        decoration: const ShapeDecoration(
          shape: CircleBorder(),
          color: Color(0xFF1B5E20),
        ),
        child: Padding(
          padding: const EdgeInsets.all(6.0),
          child: Icon(icon, size: 18, color: Colors.white),
        ),
      ),
    );
  }
}
