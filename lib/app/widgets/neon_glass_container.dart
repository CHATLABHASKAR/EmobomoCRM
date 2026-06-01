import 'package:flutter/material.dart';
import 'dart:ui';
import '../themes/app_colors.dart';

class NeonGlassContainer extends StatelessWidget {
  final Widget child;
  final double width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final BorderRadiusGeometry borderRadius;

  const NeonGlassContainer({
    required this.child,
    this.width = 500,
    this.height,
    this.padding,
    this.borderRadius = BorderRadius.zero,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ClipRRect(
        borderRadius: borderRadius,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
          child: Container(
            width: width,
            height: height,
            padding: padding ?? EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.card.withOpacity(0.13),
                  AppColors.cardBorder.withOpacity(0.08),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: borderRadius,
              border: Border.all(
                color: AppColors.cardBorder.withOpacity(0.5),
                width: 2.0,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.cardBorder.withOpacity(0.18),
                  blurRadius: 32,
                  spreadRadius: 2,
                  offset: Offset(0, 8),
                ),
              ],
            ),
            child: child,
          ),
        ),
      ),
    );
  }
} 