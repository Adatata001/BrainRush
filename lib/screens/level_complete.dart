import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:brainrush/models/category.dart';
import 'package:brainrush/models/level.dart';
import 'package:brainrush/utils/progress.dart';
import 'package:brainrush/utils/sound.dart';
import 'package:provider/provider.dart';

class LevelCompleteScreen extends StatefulWidget {
  final int points;
  final int levelNumber;
  final int totalPoints;  
  final Category category;
  final Color levelColor;

  const LevelCompleteScreen({
    super.key,
    required this.points,
    required this.levelNumber,
    required this.category,
    required this.totalPoints,
    required this.levelColor,
  });

  @override
  State<LevelCompleteScreen> createState() => _LevelCompleteScreenState();
}

class _LevelCompleteScreenState extends State<LevelCompleteScreen> 
    with TickerProviderStateMixin {
  int animatedScore = 0;
  int displayedTotalScore = 0;
  final AudioPlayer player = AudioPlayer();
  late SoundService soundService;
  
  // Animation controllers for buttons
  late AnimationController _retryController;
  late AnimationController _nextController;
  late AnimationController _quitController;
  late Animation<double> _retryScale;
  late Animation<double> _nextScale;
  late Animation<double> _quitScale;

  @override
  void initState() {
    super.initState();
    displayedTotalScore = widget.totalPoints - widget.points;
    soundService = Provider.of<SoundService>(context, listen: false);
    _animateScore();
    _initAnimations();
  }

  void _initAnimations() {
    _retryController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    _nextController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    _quitController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    
    _retryScale = Tween<double>(begin: 1.0, end: 0.95).animate(_retryController);
    _nextScale = Tween<double>(begin: 1.0, end: 0.95).animate(_nextController);
    _quitScale = Tween<double>(begin: 1.0, end: 0.95).animate(_quitController);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    soundService = Provider.of<SoundService>(context, listen: false);
    displayedTotalScore = widget.totalPoints;
    _animateScore();
  }

  Future<void> _animateScore() async {
    if (soundService.isSfxOn) {
      await player.play(AssetSource('sounds/counting.mp3'));
    }
    
    for (int i = 0; i <= widget.points; i++) {
      await Future.delayed(const Duration(milliseconds: 30));
      if (!mounted) return;
      setState(() {
        animatedScore = i;
        displayedTotalScore = (widget.totalPoints - widget.points) + i;
      });
    }
  }

  Level? get currentLevel => getLevel(widget.category.id, widget.levelNumber);
  Level? get nextLevel => getLevel(widget.category.id, widget.levelNumber + 1);

  Future<void> _retry() async {
    if (currentLevel == null) return;
    
    // Play sound before navigation if SFX is enabled
    if (soundService.isSfxOn) {
      await player.play(AssetSource('sounds/tap.mp3'));
    }
  
    if (!mounted) return;
    Navigator.pushReplacementNamed(
      context,
      '/game',
        arguments: {
        'category': widget.category,
        'level': currentLevel!, // Your method to get next level
        'levelColor': widget.levelColor,
        'initialPoints': widget.totalPoints,
        'currentUnlockedLevel': widget.levelNumber,
      },
    );
  }

  Future<void> _next() async {
    // Play sound before navigation if SFX is enabled
    if (soundService.isSfxOn) {
      await player.play(AssetSource('sounds/tap.mp3'));
    }
    
    await ProgressManager.setUnlockedLevel(
      widget.category.id, 
      widget.levelNumber + 1
    );
    
    

    if (nextLevel == null) {
      await _quit();
    } else {
      if (!mounted) return;

      Navigator.pushNamed(
        context,
        '/game',
        arguments: {
          'category': widget.category,
          'level': nextLevel!,
          'levelColor': widget.levelColor,
          'initialPoints': widget.totalPoints,
          'currentUnlockedLevel': widget.levelNumber + 1,
        },
      );
    }
  }

  Future<void> _quit() async {
    // Play sound before navigation if SFX is enabled
    if (soundService.isSfxOn) {
      await player.play(AssetSource('sounds/tap.mp3'));
    }

     await ProgressManager.setCategoryPoints(
      widget.category.id, 
      widget.totalPoints,
    );
    
    final currentUnlocked = await ProgressManager.getUnlockedLevel(widget.category.id);
    if (!mounted) return;
    Navigator.pushNamedAndRemoveUntil(
      context,
      '/level',
      ModalRoute.withName('/category'),
      arguments: {
        'category': widget.category,
        'totalLevels': widget.category.totalLevels,
        'unlockedLevel': currentUnlocked,
        'levelColor': widget.levelColor,
      },
    );
  }

  Widget _buildAnimatedButton(String label, Color color, Future<void> Function() onTap, 
    AnimationController controller, Animation<double> scale) {
    return ScaleTransition(
      scale: scale,
      child: GestureDetector(
        onTapDown: (ctx) => controller.forward(),
        onTapUp: (ctx) async {
          controller.reverse();
          await onTap(); // Wait for sound to play and navigation to complete
        },
        onTapCancel: () => controller.reverse(),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                offset: const Offset(4, 4),
                blurRadius: 6,
              ),
            ],
          ),
          child: Text(
            label,
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    player.dispose();
    _retryController.dispose();
    _nextController.dispose();
    _quitController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF90E0EF),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'assets/images/confetti.png', 
              width: 200,
              height: 200,
            ),
            const SizedBox(height: 20),
            Text(
              'LEVEL COMPLETE',
              style: GoogleFonts.poppins(
                fontSize: 30,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 14),
            Text(
              '+$animatedScore pts',
              style: GoogleFonts.poppins(
                fontSize: 20,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildAnimatedButton(
                  'Retry', 
                  Colors.yellow.shade700, 
                  _retry,
                  _retryController,
                  _retryScale,
                ),
                const SizedBox(width: 14),
                _buildAnimatedButton(
                  'Next', 
                  Colors.green, 
                  _next,
                  _nextController,
                  _nextScale,
                ),
              ],
            ),
            const SizedBox(height: 14),
            _buildAnimatedButton(
              'Quit', 
              Colors.red, 
              _quit,
              _quitController,
              _quitScale,
            ),
          ],
        ),
      ),
    );
  }
}