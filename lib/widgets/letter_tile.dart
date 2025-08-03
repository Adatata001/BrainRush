import 'package:flutter/material.dart';

class LetterTile extends StatelessWidget {
  final String letter;
  final VoidCallback onTap;

  const LetterTile({
    super.key, 
    required this.letter, 
    required this.onTap
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 35,
        height: 35,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 4)],
        ),
        alignment: Alignment.center,
        child: Text(
          letter.toUpperCase(),
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}
