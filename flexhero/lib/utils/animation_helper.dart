import 'package:flutter/material.dart';

/// A utility class to help with animations throughout the app
class AnimationHelper {
  /// Creates a staggered animation for a list of items
  static List<Widget> createStaggeredList<T>({
    required BuildContext context,
    required List<T> items,
    required Widget Function(BuildContext, T, int, Animation<double>) itemBuilder,
    Duration? staggerDuration,
    Duration? animationDuration,
    Curve curve = Curves.easeOut,
  }) {
    final animationDur = animationDuration ?? const Duration(milliseconds: 300);
    
    // For simplicity, we'll use a simplified implementation that doesn't require AnimationController
    return List.generate(items.length, (index) {
      // Create a dummy animation for the itemBuilder to use
      final animation = AlwaysStoppedAnimation<double>(1.0);
      
      // Calculate the delay based on index for staggered effect
      final delay = Duration(milliseconds: (staggerDuration?.inMilliseconds ?? 50) * index);
      
      // Return the item with a delayed animation
      return FutureBuilder(
        future: Future.delayed(delay),
        builder: (context, snapshot) {
          return AnimatedOpacity(
            opacity: snapshot.connectionState == ConnectionState.done ? 1.0 : 0.0,
            duration: animationDur,
            curve: curve,
            child: itemBuilder(context, items[index], index, animation),
          );
        },
      );
    });
  }
  
  /// Creates a fade in animation
  static Widget fadeIn({
    required Widget child,
    Duration duration = const Duration(milliseconds: 300),
    Curve curve = Curves.easeIn,
    bool animate = true,
  }) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: animate ? 0.0 : 1.0, end: 1.0),
      duration: duration,
      curve: curve,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: child,
        );
      },
      child: child,
    );
  }
  
  /// Creates a slide in animation
  static Widget slideIn({
    required Widget child,
    Duration duration = const Duration(milliseconds: 400),
    Curve curve = Curves.easeOutQuart,
    SlideDirection direction = SlideDirection.fromBottom,
    double distance = 100.0,
    bool animate = true,
  }) {
    late final Offset begin;
    const end = Offset.zero;
    
    switch (direction) {
      case SlideDirection.fromLeft:
        begin = Offset(-distance / 100, 0);
        break;
      case SlideDirection.fromRight:
        begin = Offset(distance / 100, 0);
        break;
      case SlideDirection.fromTop:
        begin = Offset(0, -distance / 100);
        break;
      case SlideDirection.fromBottom:
        begin = Offset(0, distance / 100);
        break;
    }
    
    return TweenAnimationBuilder<Offset>(
      tween: Tween<Offset>(
        begin: animate ? begin : end,
        end: end,
      ),
      duration: duration,
      curve: curve,
      builder: (context, value, child) {
        return FractionalTranslation(
          translation: value,
          child: child,
        );
      },
      child: child,
    );
  }
  
  /// Creates a scale animation
  static Widget scale({
    required Widget child,
    Duration duration = const Duration(milliseconds: 300),
    Curve curve = Curves.easeOut,
    double begin = 0.8,
    double end = 1.0,
    bool animate = true,
  }) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(
        begin: animate ? begin : end,
        end: end,
      ),
      duration: duration,
      curve: curve,
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: child,
        );
      },
      child: child,
    );
  }
  
  /// Creates a pulse animation for drawing attention to elements
  static Widget pulse({
    required Widget child,
    Duration duration = const Duration(milliseconds: 1500),
  }) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0.0, end: 1.0),
      duration: duration,
      builder: (context, value, child) {
        final pulseValue = (Curves.elasticOut.transform(value) + 1) / 2;
        return Transform.scale(
          scale: 0.95 + (pulseValue * 0.1),
          child: child,
        );
      },
      child: child,
    );
  }
}

/// Enum for slide direction
enum SlideDirection {
  fromLeft,
  fromRight,
  fromTop,
  fromBottom,
}
