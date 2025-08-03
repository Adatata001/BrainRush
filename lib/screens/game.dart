import 'dart:async';
import 'dart:math';
import 'package:audioplayers/audioplayers.dart';
import 'package:brainrush/models/category.dart';
import 'package:brainrush/models/level.dart';
import 'package:brainrush/screens/settings.dart';
import 'package:brainrush/utils/progress.dart';
import 'package:brainrush/widgets/letter_space.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:brainrush/utils/sound.dart';
import 'package:provider/provider.dart';

class GameScreen extends StatefulWidget {
  final Category category;
  final Level level;
  final int initialPoints;
  final Color levelColor;

  const GameScreen({
    super.key, 
    required this.category, 
    required this.level,
    this.initialPoints = 0,
    required this.levelColor,
  });

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> with TickerProviderStateMixin {
  late List<String> displayTiles;
  late List<String> answerSpaces;
  late List<bool> isFilled;
  late Timer timer;
  late int displayedPoints;
  int remainingTime = 0;
  int _hintedIndex = -1;
  bool isCriticalTime = false;
  bool isPaused = false;
  bool isGameOver = false;
  bool _showIncorrectFeedback = false;
  bool isLevelComplete = false;
  Color feedbackColor = Colors.transparent;
  bool shouldShakeLetters = false;
  bool shouldLightUpGreen = false;
  int _timeAddedCount = 0; 
  bool _showNotification = false; 
  String _notificationMessage = ''; 
  final List<bool> _tileShadows = List.filled(12, false);
  List<int> movedTileIndices = [];
  IconData get _playPauseIcon => isPaused ? Icons.play_circle_filled : Icons.pause_circle_filled;


  final List<Map<String, dynamic>> powerUps = [
    {
      'icon': Icons.shuffle,
      'cost': 0,
      'color': Colors.orange,
      'name': 'Shuffle',
    },
    {
      'icon': Icons.lightbulb_outline,
      'cost': 20,
      'color': Colors.green,
      'name': 'Hint',
    },
    {
      'icon': Icons.timer,
      'cost': 50,
      'color': Colors.green,
      'name': '+10 Sec',
    },
    {
      'icon': Icons.delete,
      'cost': 30,
      'color': Colors.red,
      'name': 'Remove 2',
    },
  ];

  
  final AudioPlayer _audioPlayer = AudioPlayer();
  final AudioPlayer _tickerPlayer = AudioPlayer();
  final Random _random = Random();
  late SoundService _soundService;


  late AnimationController _resumeController;
  late AnimationController _quitController;
  late AnimationController _settingsController;
  late Animation<double> _resumeScale;
  late Animation<double> _quitScale;
  late Animation<double> _settingsScale;
  late AnimationController _hintController;
  late Animation<double> _hintFade;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    displayedPoints = widget.initialPoints;
  }

  void _initializeAnimations() {
    _resumeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    _quitController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    _settingsController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    _hintController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _hintFade = CurvedAnimation(
      parent: _hintController,
      curve: Curves.easeIn,
    );

    _resumeScale = Tween<double>(begin: 1.0, end: 0.95).animate(_resumeController);
    _quitScale = Tween<double>(begin: 1.0, end: 0.95).animate(_quitController);
    _settingsScale = Tween<double>(begin: 1.0, end: 0.95).animate(_settingsController);
    _hintFade = Tween<double>(begin: 0.0, end: 1.0).animate(_hintController);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _soundService = Provider.of<SoundService>(context, listen: false);
     if (widget.initialPoints == 0) {
    ProgressManager.getCategoryPoints(widget.category.id).then((points) {
      if (mounted) {
        setState(() {
          displayedPoints = points;
        });
      }
    });
  } else {
    displayedPoints = widget.initialPoints;
  }
    setupLevel();
    startTimer();
    _preloadSounds();
  }

  Future<void> _preloadSounds() async {
    await _tickerPlayer.setSource(AssetSource('sounds/ticker.mp3'));
    await _audioPlayer.setSource(AssetSource('sounds/wrong_answer.mp3'));
    await _audioPlayer.setSource(AssetSource('sounds/level_complete.mp3'));
    await _audioPlayer.setSource(AssetSource('sounds/tap.mp3'));
    await _audioPlayer.setSource(AssetSource('sounds/error.mp3'));
  }

  void setupLevel() {
    final word = widget.level.word.toUpperCase();
    final allDistractors = widget.level.distractors.map((d) => d.toUpperCase()).toList();
    
    final neededDistractors = 12 - word.length;
    final selectedDistractors = <String>[];
    
    if (neededDistractors > 0) {
      allDistractors.shuffle();
      selectedDistractors.addAll(
        allDistractors.take(min(neededDistractors, allDistractors.length))
      );
      
      if (selectedDistractors.length < neededDistractors) {
        final letters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'.split('');
        while (selectedDistractors.length < neededDistractors) {
          final randomLetter = letters[_random.nextInt(letters.length)];
          if (!word.contains(randomLetter) && !selectedDistractors.contains(randomLetter)) {
            selectedDistractors.add(randomLetter);
          }
        }
      }
    }

    displayTiles = [...word.split(''), ...selectedDistractors];
    displayTiles.shuffle();

    answerSpaces = List.filled(word.length, '');
    isFilled = List.filled(word.length, false);

    remainingTime = widget.level.timeLimit;
  }

void startTimer() {
  timer = Timer.periodic(const Duration(seconds: 1), (timer) {
    if (!isPaused && mounted) {
      setState(() {
        if (remainingTime > 0) {
          remainingTime--;
          
          if (remainingTime <= 10) {
            if (!isCriticalTime) {
              isCriticalTime = true;
            }
            if (!isPaused) {
              _playTickerSound();
            }
          }
        } else {
          playSound('wrong_answer.mp3');
          Future.delayed(const Duration(milliseconds: 500), () {
            gameOver();
          });
        }
      });
    }
  });
}

  Future<void> _playTickerSound() async {
  if (!_soundService.isSfxOn || isPaused) return;
  
  try {
    await _tickerPlayer.stop();
    await _tickerPlayer.play(AssetSource('sounds/ticker.mp3'));
  } catch (e) {
    debugPrint('Error playing ticker sound: $e');
  }
}

  Future<void> playSound(String fileName) async {
    if (!_soundService.isSfxOn) return;
    
    try {
      await _audioPlayer.play(AssetSource('sounds/$fileName'));
    } catch (e) {
      debugPrint('Error playing sound: $e');
    }
  }

  void gameOver() async {
    timer.cancel();
    setState(() {
      isGameOver = true;
    });

    final currentUnlocked = await ProgressManager.getUnlockedLevel(widget.category.id);

   if (!mounted) return; // Ensure widget is still mounted before navigating
   Navigator.pushReplacementNamed(
      context,
      '/gameover',
      arguments: {
        'category': widget.category,
        'level': widget.level,
        'unlockedLevel': currentUnlocked,
        'levelColor': widget.levelColor,
        'points': displayedPoints,
      },
    );
  }

  Future<bool> checkAnswer() async {
    final word = widget.level.word.toUpperCase();
    final answer = answerSpaces.join();

    if (answer == word) {
      final int earnedPoints = remainingTime;
      final newTotalPoints = displayedPoints + earnedPoints;
      
      setState(() {
        isLevelComplete = true;
        feedbackColor = Colors.green;
        shouldLightUpGreen = true;
      });

      if (_soundService.isSfxOn) {
        await playSound('level_complete.mp3');
      }

      timer.cancel();
      await Future.delayed(const Duration(milliseconds: 800));


      await ProgressManager.setCategoryPoints(
        widget.category.id,
        newTotalPoints,
      );
      
      if (!mounted) return true; // Return boolean directly
      
      Navigator.pushReplacementNamed(
        context,
        '/levelcomplete',
        arguments: {
          'points': earnedPoints,
          'levelNumber': widget.level.levelNumber,
          'category': widget.category,
          'totalPoints': newTotalPoints,
          'levelColor': widget.levelColor,
        },
      ).then((ctx) {
        // Return points to level screen
        Navigator.pop(context, newTotalPoints);
      });
      
      await ProgressManager.addCategoryPoints(widget.category.id, earnedPoints);
      return true; // Explicit return for correct answer
    } else {
      setState(() {
        feedbackColor = Colors.red;
        shouldShakeLetters = true;
        _showIncorrectFeedback = true; // Set feedback flag
      });
      
      try {
      if (_soundService.isSfxOn) {
        await _audioPlayer.stop(); // Stop any existing sound
        await _audioPlayer.play(AssetSource('sounds/wrong_answer.mp3'));
      }
    } catch (e) {
      debugPrint('Error playing sound: $e');
    }
      
      await Future.delayed(const Duration(seconds: 1));
      
      setState(() {
        _showIncorrectFeedback = false; // Clear feedback flag
        for (int i = 0; i < answerSpaces.length; i++) {
          if (answerSpaces[i].isNotEmpty) {
            final emptyIndex = displayTiles.indexOf('');
            if (emptyIndex != -1) {
              displayTiles[emptyIndex] = answerSpaces[i];
              answerSpaces[i] = '';
              isFilled[i] = false;
            }
          }
        }
        movedTileIndices.clear();
      });
      return false;
    }
  }

void onTileTapped(int index) async {
  if (displayTiles[index].isEmpty) return;
  
  setState(() {
    _tileShadows[index] = true; // Activate shadow for this position
  });

  if (_soundService.isSfxOn) {
    await playSound('tap.mp3');
  }
  
  for (int i = 0; i < answerSpaces.length; i++) {
    if (!isFilled[i]) {
      setState(() {
        answerSpaces[i] = displayTiles[index];
        isFilled[i] = true;
        displayTiles[index] = '';
        movedTileIndices.add(index);
      });
      if (!answerSpaces.contains('')) {
        await checkAnswer();
      }
      break;
    }
  }
}

  Future<void> _usePowerUp(int index) async {
    
    if (index == 0) { 
      if (_soundService.isSfxOn) {
        await _audioPlayer.play(AssetSource('sounds/shuffle.mp3'));
      }
    } else {
      if (_soundService.isSfxOn) {
        await _audioPlayer.play(AssetSource('sounds/tap.mp3'));
      }
    }

    final powerUp = powerUps[index];
    
    // Check if player has enough points
    if (displayedPoints < powerUp['cost']) {
      if (_soundService.isSfxOn) {
        await _audioPlayer.play(AssetSource('sounds/error.mp3'));
      }
       _showErrorNotification('Not enough points!');
       return;
    }

    setState(() {
      displayedPoints -= powerUp['cost'] as int;
    });

     await ProgressManager.setCategoryPoints(
      widget.category.id, 
      displayedPoints,
    );

    switch (index) {
      case 0: // Shuffle
        _shuffleTiles();
        break;
      case 1: // Hint
        await _showHint();
        break;
      case 2: // Time
        _addTime();
        break;
      case 3: // Delete
        _removeDistractors();
        break;
    }
  }

  void _shuffleTiles() {
    setState(() {
      displayTiles..removeWhere((tile) => tile.isEmpty)
       ..shuffle();
      // Fill empty spaces
      while (displayTiles.length < 12) {
        displayTiles.add('');
      }
    });
  }

  Future<void> _showHint() async {
  final emptyIndex = answerSpaces.indexWhere((letter) => letter.isEmpty);
  if (emptyIndex == -1) return;

  final correctLetter = widget.level.word[emptyIndex].toUpperCase();
 
  int letterIndex = -1;
  for (int i = 0; i < displayTiles.length; i++) {
    if (displayTiles[i] == correctLetter) {
      letterIndex = i;
      break;
    }
  }
  
  if (letterIndex == -1) return; // Letter not found in display tiles

   setState(() {
     _tileShadows[letterIndex] = true;
     _hintedIndex = emptyIndex;
    });

  // Start fade animation
  _hintController.reset();
  await _hintController.forward();
  
  setState(() {
    // Move the letter from display to answer
    answerSpaces[emptyIndex] = displayTiles[letterIndex];
    isFilled[emptyIndex] = true;
    displayTiles[letterIndex] = '';
    movedTileIndices.add(letterIndex);
    _hintedIndex = -1; // Reset hinted index
  });

   if (!answerSpaces.contains('')) {
    await checkAnswer();
  }
}

  void _addTime() {
  if (_timeAddedCount >= 3) {
    _showErrorNotification('Max Time Limit Reached!');
    return;
  }
  
  setState(() {
    remainingTime += 10;
    _timeAddedCount++;
  });
}

  void _removeDistractors() {
  final word = widget.level.word.toUpperCase();
  final distractors = displayTiles.where(
    (tile) => tile.isNotEmpty && !word.contains(tile)
  ).toList();
  
  if (distractors.isEmpty) {
    _showErrorNotification('No Distractors Left!');
    return;
  }
  
  setState(() {
    if (distractors.length >= 2) {
      displayTiles.remove(distractors[0]);
      displayTiles.remove(distractors[1]);
    } else {
      displayTiles.remove(distractors[0]);
    }
    // Fill empty spaces
    while (displayTiles.length < 12) {
      displayTiles.add('');
    }
  });
}

  void togglePause() async {
  if (_soundService.isSfxOn) {
    await playSound('tap.mp3');
  }
  
  setState(() {
    isPaused = !isPaused;
  });
  
  if (isPaused) {
    // Pause the ticker sound if playing
    try {
      await _tickerPlayer.pause();
    } catch (e) {
      debugPrint('Error pausing ticker: $e');
    }
    showDialog(
      context: context,
      builder: (context) => _buildPauseDialog(),
    );
  } else {
    // Resume ticker sound if we're in critical time
    if (remainingTime <= 10 && remainingTime > 0) {
      try {
        await _tickerPlayer.resume();
      } catch (e) {
        debugPrint('Error resuming ticker: $e');
      }
    }
  }
}

  Widget _buildPauseDialog() {
    return AlertDialog(
      contentPadding: const EdgeInsets.all(35),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      title: Center(
        child: Text(
          'Game Paused',
          style: GoogleFonts.poppins(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 16),
          // Resume Button
          ScaleTransition(
            scale: _resumeScale,
            child: GestureDetector(
              onTapDown: (ctx) => _resumeController.forward(),
              onTapUp: (ctx) {
                _resumeController.reverse();
                if (_soundService.isSfxOn) {
                  playSound('tap.mp3');
                }
                setState(() {
                  isPaused = false;
                });
                Navigator.pop(context);
              },
              onTapCancel: () => _resumeController.reverse(),
              child: Material(
                elevation: 4,
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.green[400],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    child: Center(
                      child: Text(
                        'Resume',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          // Quit Button
          ScaleTransition(
            scale: _quitScale,
            child: GestureDetector(
              onTapDown: (ctx) => _quitController.forward(),
              onTapUp: (ctx) async {
                _quitController.reverse();
                if (_soundService.isSfxOn) {
                  playSound('tap.mp3');
                }
                
                await ProgressManager.setCategoryPoints(widget.category.id, displayedPoints);
                final currentUnlocked = await ProgressManager.getUnlockedLevel(widget.category.id);
                
                if (!mounted) return;
                Navigator.pop(context);
                Navigator.of(context).pop(displayedPoints);
                  
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
              },
              onTapCancel: () => _quitController.reverse(),
              child: Material(
                elevation: 4,
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.red[400],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    child: Center(
                      child: Text(
                        'Quit',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          // Settings Button
          ScaleTransition(
            scale: _settingsScale,
            child: GestureDetector(
              onTapDown: (ctx) => _settingsController.forward(),
              onTapUp: (ctx) {
                _settingsController.reverse();
                if (_soundService.isSfxOn) {
                  playSound('tap.mp3');
                }
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SettingsScreen(),
                  ),
                );
              },
              onTapCancel: () => _settingsController.reverse(),
              child: Material(
                elevation: 4,
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.yellow[600],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    child: Center(
                      child: Text(
                        'Settings',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

 Widget _buildPowerUpTile(int index) {
  final powerUp = powerUps[index];
  final isHint = index == 1;
  final hintAvailable = isHint ? _isHintAvailable() : true;

  return GestureDetector(
    onTap: isPaused || (isHint && !hintAvailable) 
        ? null 
        : () => _usePowerUp(index),
    child: Container(
      margin: const EdgeInsets.all(1),
      decoration: BoxDecoration(
        color: hintAvailable ? powerUp['color'] : Colors.grey,
        borderRadius: BorderRadius.circular(6),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 1,
            offset: const Offset(0, 1),
          )
        ],
      ),
      child: Center(
        child: index == 0 // Shuffle tile
            ? Icon(powerUp['icon'], color: Colors.white, size: 24)
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(powerUp['icon'], 
                      color: Colors.white, 
                      size: 20),
                  if (index != 0) ...[
                    const SizedBox(height: 2),
                    Text(
                      '${powerUp['cost']}',
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        );
      }

    bool _isHintAvailable() {
      final wordLetters = widget.level.word.toUpperCase().split('');
      return displayTiles.any((tile) => wordLetters.contains(tile));
    }

  Widget _buildTileShadow(int index) {
    return IgnorePointer(
      child: AnimatedOpacity(
        opacity: _tileShadows[index] && displayTiles[index].isEmpty ? 0.5 : 0.0,
        duration: Duration(milliseconds: 200),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.grey[400],
            borderRadius: BorderRadius.circular(6),
          ),
        ),
      ),
    );
  }

Widget _buildDisplayTile(int index) {
  final letter = index < displayTiles.length ? displayTiles[index] : '';
  return Stack(
    children: [
      Positioned.fill(child: _buildTileShadow(index)),
      if (letter.isNotEmpty)
        GestureDetector(
          onTap: isPaused ? null : () => onTileTapped(index),
          child: Container(
            margin: EdgeInsets.all(1),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(6),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 1,
                  offset: Offset(0, 1),
                )
              ],
            ),
            alignment: Alignment.center,
            child: Text(
              letter,
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
        )
      else
        Container(), // Empty container for empty spaces
    ],
  );
}

Widget _buildLetterSpace(int index) {
  return AnimatedBuilder(
    animation: _hintFade,
    builder: (context, child) {
      return Opacity(
        opacity: index == _hintedIndex ? _hintFade.value : 1.0,
        child: LetterSpace(
          letter: answerSpaces[index],
          onTap: () => isPaused ? null : onLetterSpaceTapped(index),
          borderColor: getLetterBorderColor(index),
          shouldShake: shouldShakeLetters,
        ),
      );
    },
  );
}

  void onLetterSpaceTapped(int index) {
    if (answerSpaces[index].isEmpty) return;
    
    if (_soundService.isSfxOn) {
      playSound('tap.mp3');
    }
    
    final letter = answerSpaces[index];
    if (letter.isNotEmpty) {
      setState(() {
        final emptyIndex = displayTiles.indexOf('');
        if (emptyIndex != -1) {
          displayTiles[emptyIndex] = letter;
          answerSpaces[index] = '';
          isFilled[index] = false;
          movedTileIndices.removeWhere((i) => i == emptyIndex);
        }
      });
    }
  }

  Future<void> _showErrorNotification(String message) async {
  if (_soundService.isSfxOn) {
    await playSound('error.mp3');
  }
  
  setState(() {
    _notificationMessage = message;
    _showNotification = true;
  });
  
  await Future.delayed(Duration(seconds: 2));
  
  if (mounted) {
    setState(() {
      _showNotification = false;
    });
  }
}



  Color getLetterBorderColor(int index) {
    if (_showIncorrectFeedback && answerSpaces[index].isNotEmpty) {
      return Colors.red; 
    }
    if (feedbackColor == Colors.green && shouldLightUpGreen && answerSpaces[index].isNotEmpty) {
      return Colors.green;
    }
    return Colors.white70;
  }

  @override
  void dispose() {
    timer.cancel();
    _audioPlayer.dispose();
    _tickerPlayer.dispose();
    _resumeController.dispose();
    _quitController.dispose();
    _settingsController.dispose();
    _hintController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final word = widget.level.word.toUpperCase();
    final clue = widget.level.clue;


    return Scaffold(
      backgroundColor: const Color(0xFF90E0EF),
      body: SafeArea(
        child: Column(
          children: [
            if (_showNotification)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: AnimatedOpacity(
                  opacity: _showNotification ? 1.0 : 0.0,
                  duration: Duration(milliseconds: 300),
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(25),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 10,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Text(
                      _notificationMessage,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            // Header Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(_playPauseIcon, size: 32, color: Colors.black),
                    onPressed: () async {
                      if (_soundService.isSfxOn) {
                        await _audioPlayer.play(AssetSource('sounds/tap.mp3'));
                      }
                      togglePause();
                    },
                  ),
                  Column(
                    children: [
                      Text(
                        widget.category.name,
                        style: GoogleFonts.poppins(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        'Level ${widget.level.levelNumber}',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 40), 
                ],
              ),
            ),

            // Timer and Points Display
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text(
                        'Timer: ',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        '$remainingTime',
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: isCriticalTime ? Colors.red : Colors.green.shade800,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    'Points: $displayedPoints',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),

            // Clue Section
            Spacer(flex: 2),
            Expanded(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Text(
                    'Clue: $clue?',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),

            // Answer Spaces
            Spacer(flex: 2),
            Container(
              height: 50,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              margin: const EdgeInsets.only(bottom: 8),
              child: LayoutBuilder(
                builder: (ctx, constraints) {
                  final maxWidth = constraints.maxWidth;
                  final letterWidth = (maxWidth / word.length).clamp(30.0, 50.0);
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      word.length,
                      (index) => SizedBox(
                        width: letterWidth,
                        height: 38,
                        child: _buildLetterSpace(index)
                      ),
                    ),
                  );
                },
                ),
              ),
            // Display Tiles
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
                child: GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: 16,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 8, 
                    mainAxisSpacing: 2,
                    crossAxisSpacing: 2,
                    childAspectRatio: 1,
                  ),
                  itemBuilder: (context, index) {
                    if (index < 6) {
                      return _buildDisplayTile(index);
                    }
                    else if (index < 8) {
                      return _buildPowerUpTile(index - 6);
                    }
                    else if (index < 14) {
                      final letterIndex = index - 2; 
                      return _buildDisplayTile(letterIndex);
                    }
                    else {
                      return _buildPowerUpTile(index - 12);
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}