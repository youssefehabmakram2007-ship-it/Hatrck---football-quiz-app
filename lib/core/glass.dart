import 'dart:ui';
import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Gradient + blurred orbs behind every screen (what the glass blurs).
class GlassBackground extends StatelessWidget {
  final Widget child;
  const GlassBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColors.bgNavy, AppColors.bgPitch, AppColors.bgDark],
          ),
        ),
        child: Stack(children: [
          _orb(-80, -60, 260, AppColors.green),
          _orb(240, 420, 300, AppColors.blue),
          _orb(30, 600, 200, AppColors.gold),
          SafeArea(child: child),
        ]),
      ),
    );
  }

  Widget _orb(double left, double top, double size, Color c) => Positioned(
        left: left,
        top: top,
        child: Container(
          width: size,
          height: size,
          decoration:
              BoxDecoration(shape: BoxShape.circle, color: c.withValues(alpha: 0.35)),
        ),
      );
}

/// Frosted glass panel.
class Glass extends StatelessWidget {
  final Widget child;
  final EdgeInsets padding;
  final double radius;
  final Color? tint;
  const Glass({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.radius = 24,
    this.tint,
  });

  @override
  Widget build(BuildContext context) {
    final base = tint ?? Colors.white;
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(radius),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [base.withValues(alpha: 0.22), base.withValues(alpha: 0.06)],
            ),
            border: Border.all(color: Colors.white.withValues(alpha: 0.28)),
          ),
          child: child,
        ),
      ),
    );
  }
}

class GlassButton extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  final Color tint;
  const GlassButton({
    super.key,
    required this.label,
    this.onTap,
    this.tint = AppColors.green,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Glass(
        tint: tint,
        radius: 18,
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
        child: Text(label,
            style: const TextStyle(
                fontWeight: FontWeight.w800, letterSpacing: 2, fontSize: 16)),
      ),
    );
  }
}
