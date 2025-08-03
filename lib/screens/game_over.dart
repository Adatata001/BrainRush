import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:provider/provider.dart';
import 'package:brainrush/models/category.dart';
import 'package:brainrush/models/level.dart';
import 'package:brainrush/screens/game.dart';
import 'package:brainrush/utils/progress.dart';
import 'package:brainrush/utils/sound.dart';

class GameOverScreen extends StatefulWidget {
  final Category category;
  final Level level;
  final int unlockedLevel;
  final Color levelColor;
  final int points;

  const GameOverScreen({
    super.key,
    required this.category,
    required this.level,
    required this.unlockedLevel,
    required this.levelColor,
    required this.points,
  });

  @override
  State<GameOverScreen> createState() => _GameOverScreenState();
}

class _GameOverScreenState extends State<GameOverScreen> 
    with TickerProviderStateMixin {
  late AnimationController _retryController;
  late AnimationController _quitController;
  late Animation<double> _retryScale;
  late Animation<double> _quitScale;
  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    _initAnimations();
  }

  void _initAnimations() {
    _retryController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    _quitController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    
    _retryScale = Tween<double>(begin: 1.0, end: 0.95).animate(_retryController);
    _quitScale = Tween<double>(begin: 1.0, end: 0.95).animate(_quitController);
  }

  Future<void> _quit(BuildContext context) async {
    final soundService = Provider.of<SoundService>(context, listen: false);
    
    if (soundService.isSfxOn) {
      await _audioPlayer.play(AssetSource('sounds/tap.mp3'));
    }
    

    await ProgressManager.setCategoryPoints(widget.category.id, widget.points);
      
    final currentUnlocked = await ProgressManager.getUnlockedLevel(widget.category.id);
    
    if (!context.mounted) return;
     Navigator.pushNamedAndRemoveUntil(
      context,
      '/level',
      ModalRoute.withName('/category'),
      arguments: {
        'category': widget.category,
        'totalLevels': widget.category.totalLevels,
        'unlockedLevel': currentUnlocked,
        'levelColor': widget.levelColor,
        'categoryPoints': widget.points,
      },
    );
  }

  Widget _buildAnimatedButton({
    required String label,
    required Color color,
    required VoidCallback onTap,
    required AnimationController controller,
    required Animation<double> scale,
  }) {
    return ScaleTransition(
      scale: scale,
      child: GestureDetector(
        onTapDown: (ctx) => controller.forward(),
        onTapUp: (ctx) {
          controller.reverse();
          onTap();
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
              )
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
    _retryController.dispose();
    _quitController.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final soundService = Provider.of<SoundService>(context);

    return Scaffold(
      backgroundColor: const Color(0xFF90E0EF),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'assets/images/gameover.png',
              height: 200,
              width: 200,
            ),
            const SizedBox(height: 20),
            Text(
              'GAME OVER',
              style: GoogleFonts.poppins(
                fontSize: 30,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildAnimatedButton(
                  label: 'Retry',
                  color: Colors.yellow.shade700,
                  onTap: () async {
                    if (soundService.isSfxOn) {
                      await _audioPlayer.play(AssetSource('sounds/tap.mp3'));
                    }
                    if (!context.mounted) return;
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (ctx) => GameScreen(
                          category: widget.category,
                          level: widget.level,
                          initialPoints: widget.points,
                          levelColor: widget.levelColor,
                        ),
                      ),
                    );
                  },
                  controller: _retryController,
                  scale: _retryScale,
                ),
                const SizedBox(width: 12),
                _buildAnimatedButton(
                  label: 'Quit',
                  color: Colors.red,
                  onTap: () => _quit(context),
                  controller: _quitController,
                  scale: _quitScale,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}