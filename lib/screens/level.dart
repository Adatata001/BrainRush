import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:provider/provider.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:brainrush/widgets/level_card.dart';
import 'package:brainrush/models/category.dart';
import 'package:brainrush/models/level.dart';
import 'package:brainrush/utils/progress.dart';
import 'package:brainrush/utils/sound.dart';

class LevelScreen extends StatefulWidget {
  final int totalLevels;
  final int unlockedLevel;
  final Color levelColor;
  final Category category;

  const LevelScreen({
    super.key,
    required this.totalLevels,
    required this.unlockedLevel,
    required this.levelColor,
    required this.category,
  });

  @override
  State<LevelScreen> createState() => _LevelScreenState();
}

class _LevelScreenState extends State<LevelScreen> with TickerProviderStateMixin {
  final AudioPlayer player = AudioPlayer();
  late int currentUnlockedLevel;
  late AnimationController _backButtonController;
  late Animation<double> _backButtonScale;
  int categoryTotalPoints = 0;

  @override
  void initState() {
    super.initState();
    currentUnlockedLevel = widget.unlockedLevel;
    _checkForNewUnlocks();
    _loadPoints();
    
    
    // Initialize animation controller for back button
    _backButtonController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    _backButtonScale = Tween<double>(begin: 1.0, end: 0.9).animate(_backButtonController);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadPoints();
  }

  void _loadPoints() async {
    categoryTotalPoints = await ProgressManager.getCategoryPoints(widget.category.id);
    setState(() {});
  }

  Future<void> _checkForNewUnlocks() async {
    final latestUnlocked = await ProgressManager.getUnlockedLevel(widget.category.id);
    if (latestUnlocked > currentUnlockedLevel && mounted) {
      setState(() {
        currentUnlockedLevel = latestUnlocked;
      });
    }
  }

  Future<void> _playSound(String fileName) async {
    final soundService = Provider.of<SoundService>(context, listen: false);
    if (!soundService.isSfxOn) return;
    
    try {
      await player.play(AssetSource('sounds/$fileName.mp3'));
    } catch (e) {
      debugPrint('Error playing sound: $e');
    }
  }




  void _onLevelSelected(int levelNumber) async {
  await _playSound('tap');

  final level = getLevel(widget.category.id, levelNumber);
  if (level == null) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Level not found')),
      );
    }
    return;
  }

  final currentUnlockedLevel = await ProgressManager.getUnlockedLevel(widget.category.id);
  final categoryPoints = await ProgressManager.getCategoryPoints(widget.category.id);
  final result = await Navigator.pushNamed(
    context,
    '/game',
    arguments: {
      'category': widget.category,
      'level': level,
      'levelColor': widget.levelColor,
      'initialPoints': categoryPoints,  // Pass current total points
      'currentUnlockedLevel': currentUnlockedLevel,
    },
  ) as int?;  // Cast the result to int?

  // Handle the returned points
  if (result != null && mounted) {
    final updatedPoints = result;
      await ProgressManager.setCategoryPoints(
        widget.category.id, 
        updatedPoints
      );
    
    setState(() {
      categoryTotalPoints = updatedPoints;
    });
  }

  await _checkForNewUnlocks();
}

  @override
  Widget build(BuildContext context) {
    final soundService = Provider.of<SoundService>(context);

    return Scaffold(
      backgroundColor: const Color(0xFF90E0EF),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24),
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      'LEVELS',
                      style: GoogleFonts.poppins(
                        fontSize: 22,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Positioned(
                    left: 0,
                    child: ScaleTransition(
                      scale: _backButtonScale,
                      child: GestureDetector(
                        onTapDown: (ctx) => _backButtonController.forward(),
                        onTapUp: (ctx) async {
                          _backButtonController.reverse();
                          if (soundService.isSfxOn) {
                            await player.play(AssetSource('sounds/tap.mp3'));
                          }
                          Navigator.pushReplacementNamed(context, '/category');
                        },
                        onTapCancel: () => _backButtonController.reverse(),
                        child: const Icon(
                          Icons.arrow_back_ios_new,
                          color: Colors.black,
                          size: 22,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: AnimationLimiter(
                  child: GridView.builder(
                    itemCount: widget.totalLevels,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 5,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: 1,
                    ),
                    itemBuilder: (context, index) {
                      final level = index + 1;
                      final isUnlocked = level <= currentUnlockedLevel;
                      
                      return AnimationConfiguration.staggeredGrid(
                        position: index,
                        columnCount: 5,
                        duration: const Duration(milliseconds: 400),
                        child: SlideAnimation(
                          verticalOffset: 50.0,
                          child: FadeInAnimation(
                            child: BouncyCard(
                              isUnlocked: isUnlocked,
                              level: level,
                              levelColor: widget.levelColor,
                              onTap: () {
                                if (isUnlocked) {
                                  _onLevelSelected(level);
                                } else {
                                  _playSound('error');
                                }
                              },
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    player.dispose();
    _backButtonController.dispose();
    super.dispose();
  }
}