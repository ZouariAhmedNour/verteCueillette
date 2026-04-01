import 'package:flutter/material.dart';

class PromoBanner extends StatelessWidget {
  const PromoBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 210,
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: const LinearGradient(
          colors: [Color(0xFF6EE37D), Color(0xFFA8F3B7)],
        ),
        image: const DecorationImage(
          image: NetworkImage('https://images.unsplash.com/photo-1610832958506-aa56368176cf?q=80&w=1200&auto=format&fit=crop'),
          fit: BoxFit.cover,
          opacity: 0.22,
        ),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Chip(
            label: Text('NEW SEASON'),
            backgroundColor: Colors.white,
          ),
          SizedBox(height: 14),
          Text(
            'Fresh Harvest\nDiscount 20%',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
          ),
          SizedBox(height: 8),
          Text(
            'Only this weekend',
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}