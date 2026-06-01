import 'package:flutter/material.dart';
import 'dart:ui';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(32),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
            child: Container(
              width: 300,
              height: 200,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.18),
                borderRadius: BorderRadius.circular(32),
                border: Border.all(color: Colors.white.withOpacity(0.3), width: 1.5),
              ),
              alignment: Alignment.center,
              child: Text('Splash Screen', style: TextStyle(fontSize: 28, color: Colors.black87, fontWeight: FontWeight.bold)),
            ),
          ),
        ),
      ),
    );
  }
} 