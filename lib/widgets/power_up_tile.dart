import 'package:flutter/material.dart';

class PowerUpTile extends StatelessWidget {
  final IconData icon;
  final int price;
  final VoidCallback onTap;
  final Color color;

  const PowerUpTile({
    super.key,
    required this.icon,
    required this.price,
    required this.onTap,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40, // small size
            height: 40,
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: color, width: 2),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '$price',
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              const SizedBox(width: 4),
              Icon(Icons.monetization_on, color: color, size: 16),
            ],
          ),
        ],
      ),
    );
  }
}
