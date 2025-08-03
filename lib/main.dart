import 'package:flutter/material.dart';
import 'package:brainrush/app.dart';
import 'package:brainrush/models/level.dart';
import 'package:provider/provider.dart';
import 'package:brainrush/utils/sound.dart';

void main() {
initializeLevels();
runApp(
    ChangeNotifierProvider(
      create: (context) => SoundService(),
      child: const MyApp(),
    ),
  );

}


