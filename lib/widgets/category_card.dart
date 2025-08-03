import 'package:flutter/material.dart';
import 'package:brainrush/models/category.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:provider/provider.dart';
import 'package:brainrush/utils/sound.dart';

class CategoryCard extends StatefulWidget {
  final Category category;
  final Color color;
  final VoidCallback onTap;

  const CategoryCard({
    required this.category,
    required this.color,
    required this.onTap,
    super.key,
  });

  @override
  State<CategoryCard> createState() => _CategoryCardState();
}

class _CategoryCardState extends State<CategoryCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnim;
  final AudioPlayer _audioPlayer = AudioPlayer();
  late SoundService _soundService;
  bool _isProcessingTap = false;
  DateTime? _lastTapTime;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    _scaleAnim = Tween<double>(begin: 1.0, end: 0.93).animate(_controller);
    _audioPlayer.setReleaseMode(ReleaseMode.release); // Ensure clean sound playback
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _soundService = Provider.of<SoundService>(context);
  }

  Future<void> _playTapSound() async {
    if (!_soundService.isSfxOn || _isProcessingTap) return;
    
    try {
      await _audioPlayer.stop();
      await _audioPlayer.play(AssetSource('sounds/tap.mp3'));
    } catch (e) {
      debugPrint('Error playing sound: $e');
    }
  }

  void _onTapDown(TapDownDetails _) {
    final now = DateTime.now();
    if (_lastTapTime != null && now.difference(_lastTapTime!) < Duration(milliseconds: 300)) {
      return; // Ignore rapid successive taps
    }
    _lastTapTime = now;
    _controller.forward();
  }

  Future<void> _onTapUp(TapUpDetails _) async {
    if (_isProcessingTap) return;
    _isProcessingTap = true;
    
    _controller.reverse();
    await _playTapSound();
    
    // Execute the tap action after a small delay
    await Future.delayed(const Duration(milliseconds: 50));
    if (mounted) {
      widget.onTap();
    }
    
    _isProcessingTap = false;
  }

  void _onTapCancel() {
    _controller.reverse();
    _isProcessingTap = false;
  }

  @override
  void dispose() {
    _controller.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ScaleTransition(
          scale: _scaleAnim,
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTapDown: _onTapDown,
            onTapUp: _onTapUp,
            onTapCancel: _onTapCancel,
            child: Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: LinearGradient(
                  colors: [
                    widget.color.withOpacity(0.85),
                    widget.color,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                border: Border.all(
                  color: widget.color.withOpacity(0.8),
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: widget.color.withOpacity(0.6),
                    blurRadius: 6,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Center(
                child: Icon(
                  widget.category.icon,
                  size: 34,
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            widget.category.name,
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
      ],
    );
  }
}