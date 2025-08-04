import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async';


class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  double _progress = 0;

  @override
  void initState() {
   super.initState();
    WidgetsBinding.instance.addPostFrameCallback((ctx) {
      precacheImage(const AssetImage('assets/images/home_logo.png'), context);
      precacheImage(const AssetImage('assets/images/Logo@2x-8.png'), context).then((ctx) {
        Timer.periodic(const Duration(milliseconds: 60), (timer) {
          if (_progress >= 1.0) {
            timer.cancel();
            Future.delayed(const Duration(milliseconds: 300), () {
              if (mounted) {
                Navigator.pushReplacementNamed(context, '/home');
              }
            });
          } else {
            setState(() {
              _progress += 0.01;
            });
          }
        });
      });
    });
  }


  @override
  Widget build(BuildContext context) {
    final barWidth = MediaQuery.of(context).size.width * 0.8;
    final barHeight = 20.0;

    return Scaffold(
      backgroundColor: Color(0xFF90E0EF),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
           SizedBox(height: 50),
                Image.asset('assets/images/Logo@2x-8.png',
                 height: 250,
                 width: 250,
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.only(bottom: 48.0),
                  child: Stack(
                    alignment: Alignment.centerLeft,
                    children: [
                      Container(
                        width: barWidth,
                        height: barHeight,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.transparent,
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black45,
                              offset: Offset(2, 2),
                              blurRadius: 4,
                            )
                          ],
                        ),
                      ),
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 100),
                        width: barWidth * _progress,
                        height: barHeight,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                        ),
                      ),
                      Positioned(
                        left: (barWidth * _progress).clamp(0, barWidth - 20),
                        child: Image.asset(
                          'assets/images/logoo.png',
                          height: 20,
                        ),
                      ),
                      Positioned.fill(
                        child: Center(
                          child: Text(
                            '${(_progress * 100).toInt()}%',
                            style: GoogleFonts.poppins(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
        ),
      ),
    );
  }
}
