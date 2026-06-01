import 'package:flutter/material.dart';
import 'dart:ui';

class UserFormScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('User Form')),
      body: Center(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
            child: Container(
              width: 350,
              height: 200,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: Colors.white.withOpacity(0.2), width: 1.2),
              ),
              alignment: Alignment.center,
              child: Text('User Form Screen', style: TextStyle(fontSize: 22, color: Colors.black87, fontWeight: FontWeight.w600)),
            ),
          ),
        ),
      ),
    );
  }
} 