import 'package:flutter/material.dart';

class LetterSpace extends StatelessWidget {
  final String letter;
  final VoidCallback onTap;
  final Color borderColor;
  final bool shouldShake;

  const LetterSpace({
    required this.letter,
    required this.onTap,
    required this.borderColor,
    this.shouldShake = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final bool isEmpty = letter.isEmpty;
    return GestureDetector(
      onTap: letter.isEmpty ? null : onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: 50,
        height: 50,
        margin: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: isEmpty ? Colors.black12.withOpacity(0.1) : Colors.white,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: borderColor, width: 2),
          boxShadow: isEmpty
              ? [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ]
              : [
                  BoxShadow(
                    color: Colors.black45,
                    blurRadius: 6,
                    offset: Offset(0, 4),
                  ),
                ],
        ),
        alignment: Alignment.center,
        child: isEmpty
            ? null
            : Text(
                letter,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
      ),
    );
  }
}
