import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BouncyCard extends StatefulWidget {
  final bool isUnlocked;
  final int level;
  final Color levelColor;
  final VoidCallback onTap;

  const BouncyCard({
    required this.isUnlocked,
    required this.level,
    required this.levelColor,
    required this.onTap,
  });

  @override
  State<BouncyCard> createState() => _BouncyCardState();
}

class _BouncyCardState extends State<BouncyCard>
    with SingleTickerProviderStateMixin {
  double _scale = 1.0;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 80),
      lowerBound: 0.95,
      upperBound: 1.0,
      vsync: this,
    );

    _controller.addListener(() {
      setState(() {
        _scale = _controller.value;
      });
    });

    _controller.value = 1.0;
  }

  void _onTapDown(_) => _controller.reverse();
  void _onTapUp(_) => _controller.forward();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: () => _onTapUp(null),
      child: Transform.scale(
        scale: _scale,
        child: Container(
          decoration: BoxDecoration(
            color: widget.isUnlocked
                ? Colors.white
                : widget.levelColor.withOpacity(0.4),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.4),
                offset: const Offset(4, 4),
                blurRadius: 6,
              ),
            ],
          ),
          child: Center(
            child: widget.isUnlocked
                ? Text(
                    '${widget.level}',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.lock, size: 20, color: Colors.black),
                      Text(
                        '${widget.level}',
                        style: GoogleFonts.poppins(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}