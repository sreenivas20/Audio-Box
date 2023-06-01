import 'package:flutter/material.dart';
import 'package:musicplayer/application/splashscreen_provider.dart';

import 'package:provider/provider.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) { 
    Provider.of<SplashScreenProvider>(context)
        .requestStoragePermission(context);
    return Scaffold(
      backgroundColor: const Color(0xFF3A376A),
      body: Container( 
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.blueGrey.shade300,
              Colors.black,
              Colors.black,
              Colors.black
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(50),
            child: Image.asset(
              'assets/logo_music_player-removebg-preview.png',
              width: 330,
            ),
          ),
        ),
      ),
    );
  }
}
