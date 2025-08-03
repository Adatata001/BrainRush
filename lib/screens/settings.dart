import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:brainrush/utils/sound.dart';
import 'package:audioplayers/audioplayers.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final soundService = Provider.of<SoundService>(context);

    return Scaffold(
      backgroundColor: const Color(0xFF90E0EF),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
            child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                  child: Stack(
                    children: [
                      Center(
                        child: Text(
                            'SETTINGS',
                            style: GoogleFonts.poppins(
                              fontSize: 22,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                    Positioned(
                     left: 0,
                     child: GestureDetector(
                      onTap: () {
                        if (soundService.isSfxOn) {
                          HapticFeedback.lightImpact();
                        }
                        Navigator.pop(context, true);
                       },
                       child: const Icon(Icons.arrow_back_ios_new,
                       color: Colors.black, size: 22),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'SFX',
                        style: GoogleFonts.poppins(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Switch(
                        value: soundService.isSfxOn,
                        onChanged: (value) async {
                          await soundService.setSfx(value);
                          if (value) {
                            final player = AudioPlayer();
                            await player.play(AssetSource('sounds/tap.mp3'));
                          }
                        },
                        activeColor: Colors.green,
                        inactiveTrackColor: Colors.red[200],
                        inactiveThumbColor: Colors.red,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      )
    );
  }
}