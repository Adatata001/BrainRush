import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:brainrush/widgets/category_card.dart';
import 'package:brainrush/models/category.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:brainrush/screens/settings.dart';
import 'package:brainrush/utils/progress.dart';
import 'package:brainrush/utils/sound.dart';
import 'package:audioplayers/audioplayers.dart';

final List<Color> categoryColors = [
  const Color.fromARGB(255, 163, 194, 7),
  const Color.fromARGB(255, 197, 54, 10),
  const Color.fromARGB(255, 122, 7, 142),
  const Color.fromARGB(255, 204, 214, 224),
  const Color.fromARGB(255, 164, 13, 114),
  const Color.fromARGB(255, 118, 32, 0),
  const Color.fromARGB(255, 162, 47, 62),
  const Color.fromARGB(255, 101, 42, 63),
];

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> with TickerProviderStateMixin {
  final Map<String, int> unlockedLevels = {};
  bool isLoading = true;
  late SoundService soundService;
  final AudioPlayer _audioPlayer = AudioPlayer();
  late AnimationController _settingsController;
  late Animation<double> _settingsScale;

  @override
  void initState() {
    super.initState();
    _loadUnlockedLevels();
    _initAnimations();
  }

  void _initAnimations() {
    _settingsController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    _settingsScale = Tween<double>(begin: 1.0, end: 0.9).animate(_settingsController);
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    _settingsController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    soundService = Provider.of<SoundService>(context, listen: true);
  }

  Future<void> _loadUnlockedLevels() async {
    for (final category in categories) {
      final unlocked = await ProgressManager.getUnlockedLevel(category.id);
      unlockedLevels[category.id] = unlocked;
    }
    setState(() {
      isLoading = false;
    });
  }

  Future<void> _playTapSound() async {
    if (soundService.isSfxOn) {
      await _audioPlayer.play(AssetSource('sounds/tap.mp3'));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF90E0EF),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              // Header with centered text and settings button
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Stack(
                  children: [
                    Center(
                      child: Column(
                        children: [
                          Text(
                            'SELECT',
                            style: GoogleFonts.poppins(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              letterSpacing: 1.5,
                            ),
                          ),
                          Text(
                            'CATEGORY',
                            style: GoogleFonts.poppins(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              letterSpacing: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      right: 0,
                      child: ScaleTransition(
                        scale: _settingsScale,
                        child: GestureDetector(
                          onTapDown: (ctx) => _settingsController.forward(),
                          onTapUp: (ctx) async {
                            _settingsController.reverse();
                            await _playTapSound();
                            if (mounted) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const SettingsScreen(),
                                ),
                              );
                            }
                          },
                          onTapCancel: () => _settingsController.reverse(),
                          child: const Icon(
                            Icons.settings,
                            size: 28,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Category grid
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final double maxWidth = 600;
                    final double actualWidth = constraints.maxWidth > maxWidth
                        ? maxWidth
                        : constraints.maxWidth;

                    return Center(
                      child: SizedBox(
                        width: actualWidth,
                        child: AnimationLimiter(
                          child: GridView.builder(
                            physics: const BouncingScrollPhysics(),
                            itemCount: categories.length,
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              crossAxisSpacing: 12,
                              mainAxisSpacing: 12,
                              childAspectRatio: 1,
                            ),
                            itemBuilder: (context, index) {
                              final category = categories[index];
                              final color = categoryColors[index % categoryColors.length];
                              final unlockedLevel = unlockedLevels[category.id] ?? 1;

                              return AnimationConfiguration.staggeredGrid(
                                position: index,
                                columnCount: 3,
                                duration: const Duration(milliseconds: 400),
                                child: SlideAnimation(
                                  verticalOffset: 50.0,
                                  child: FadeInAnimation(
                                    child: CategoryCard(
                                      category: category,
                                      color: color,
                                      onTap: () async {
                                        if (soundService.isSfxOn) {
                                          HapticFeedback.lightImpact();
                                          await _playTapSound();
                                        }
                                        Navigator.pushNamed(
                                          context,
                                          '/level',
                                          arguments: {
                                            'category': category,
                                            'totalLevels': category.totalLevels,
                                            'unlockedLevel': unlockedLevel,
                                            'levelColor': color,
                                          },
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}