import 'dart:ui';
import 'package:flutter/material.dart';

class GlassContainer extends StatelessWidget {
  final double? width;
  final double? height;
  final Widget child;
  final BorderRadius? borderRadius;
  final double blur;
  final double borderOpacity;
  final double fillOpacity;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final VoidCallback? onTap;
  final Color borderColor;
  final Color color;

  const GlassContainer({
    super.key,
    required this.child,
    this.width,
    this.height,
    this.borderRadius,
    this.blur = 5.0,
    this.borderOpacity = 0.1,
    this.fillOpacity = 0.05,
    this.padding,
    this.margin,
    this.onTap,
    this.borderColor = Colors.white,
    this.color = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    final br = borderRadius ?? BorderRadius.circular(20);

    Widget content = Container(
      width: width,
      height: height,
      margin: margin,
      decoration: BoxDecoration(
        borderRadius: br,
        // Optional Border
        border: borderOpacity > 0
            ? Border.all(
                color: borderColor.withValues(alpha: borderOpacity),
                width: 1.5,
              )
            : null,
        // Fill
        color: blur == 0 ? color.withValues(alpha: fillOpacity) : null,
        gradient: blur > 0
            ? LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  color.withValues(alpha: fillOpacity),
                  color.withValues(
                    alpha: fillOpacity * 0.8,
                  ), // Reduced drop-off
                ],
              )
            : null,
      ),
      child: blur > 0
          ? ClipRRect(
              borderRadius: br,
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
                child: Padding(
                  padding: padding ?? const EdgeInsets.all(16.0),
                  child: child,
                ),
              ),
            )
          : Padding(
              padding: padding ?? const EdgeInsets.all(16.0),
              child: child,
            ),
    );

    if (onTap != null) {
      return GestureDetector(onTap: onTap, child: content);
    }
    return content;
  }
}
