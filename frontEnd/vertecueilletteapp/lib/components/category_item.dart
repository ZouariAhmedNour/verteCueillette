import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class CategoryItem extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool selected;

  const CategoryItem({
    super.key,
    required this.label,
    required this.icon,
    this.selected = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 74,
          height: 74,
          decoration: BoxDecoration(
            color: selected ? AppColors.lightGreen : Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: selected ? AppColors.primary : AppColors.border),
          ),
          child: Icon(icon, color: selected ? AppColors.primary : const Color(0xFF97A4B8), size: 32),
        ),
        const SizedBox(height: 8),
        Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
      ],
    );
  }
}