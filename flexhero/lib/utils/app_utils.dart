import 'package:flutter/material.dart';
import '../models/workout.dart';
import '../models/exercise.dart';
import '../models/user_profile.dart';

class AppColors {
  static const primary = Color(0xFF4A90E2);
  static const secondary = Color(0xFF58C0EB);
  static const accent = Color(0xFFFF7D54);
  static const background = Color(0xFFF8F9FA);
  static const cardBackground = Colors.white;
  static const lightGrey = Color(0xFFE0E0E0);
  static const textDark = Color(0xFF242A37);
  static const textLight = Color(0xFF7B7F9E);
  static const success = Color(0xFF4CAF50);
  static const error = Color(0xFFE53935);
  static const warning = Color(0xFFFFB74D);
}

class AppConstants {
  static const double defaultPadding = 16.0;
  static const double defaultBorderRadius = 12.0;
  static const double smallBorderRadius = 8.0;
  static const double largeBorderRadius = 20.0;
}

class AppUtils {
  // Format seconds into mm:ss
  static String formatSeconds(int seconds) {
    final mins = (seconds / 60).floor().toString().padLeft(2, '0');
    final secs = (seconds % 60).toString().padLeft(2, '0');
    return '$mins:$secs';
  }
  
  // Format seconds into human-readable duration
  static String formatDuration(int seconds) {
    if (seconds < 60) {
      return '$seconds seconds';
    } else if (seconds < 3600) {
      final mins = (seconds / 60).floor();
      final remainingSeconds = seconds % 60;
      final secsFormatted = remainingSeconds > 0 ? ' $remainingSeconds seconds' : '';
      return '$mins ${mins == 1 ? 'minute' : 'minutes'}$secsFormatted';
    } else {
      final hours = (seconds / 3600).floor();
      final mins = ((seconds % 3600) / 60).floor();
      final minsFormatted = mins > 0 ? ' $mins ${mins == 1 ? 'minute' : 'minutes'}' : '';
      return '$hours ${hours == 1 ? 'hour' : 'hours'}$minsFormatted';
    }
  }
  
  // Convert difficulty to user-friendly string
  static String difficultyToString(Difficulty difficulty) {
    switch (difficulty) {
      case Difficulty.beginner:
        return 'Beginner';
      case Difficulty.intermediate:
        return 'Intermediate';
      case Difficulty.advanced:
        return 'Advanced';
      default:
        return 'Unknown';
    }
  }
  
  // Convert workout type to user-friendly string
  static String workoutTypeToString(WorkoutType type) {
    switch (type) {
      case WorkoutType.fullBody:
        return 'Full Body';
      case WorkoutType.upperBody:
        return 'Upper Body';
      case WorkoutType.lowerBody:
        return 'Lower Body';
      case WorkoutType.core:
        return 'Core';
      case WorkoutType.cardio:
        return 'Cardio';
      case WorkoutType.hiit:
        return 'HIIT';
      case WorkoutType.custom:
        return 'Custom';
      default:
        return 'Unknown';
    }
  }
  
  // Convert muscle group to user-friendly string
  static String muscleGroupToString(MuscleGroup group) {
    switch (group) {
      case MuscleGroup.chest:
        return 'Chest';
      case MuscleGroup.back:
        return 'Back';
      case MuscleGroup.shoulders:
        return 'Shoulders';
      case MuscleGroup.biceps:
        return 'Biceps';
      case MuscleGroup.triceps:
        return 'Triceps';
      case MuscleGroup.legs:
        return 'Legs';
      case MuscleGroup.abs:
        return 'Abs';
      case MuscleGroup.glutes:
        return 'Glutes';
      case MuscleGroup.forearms:
        return 'Forearms';
      case MuscleGroup.calves:
        return 'Calves';
      case MuscleGroup.fullBody:
        return 'Full Body';
      default:
        return 'Unknown';
    }
  }
  
  // Convert fitness level to user-friendly string
  static String fitnessLevelToString(FitnessLevel level) {
    switch (level) {
      case FitnessLevel.beginner:
        return 'Beginner';
      case FitnessLevel.intermediate:
        return 'Intermediate';
      case FitnessLevel.advanced:
        return 'Advanced';
      default:
        return 'Unknown';
    }
  }
  
  // Convert fitness goal to user-friendly string
  static String fitnessGoalToString(FitnessGoal goal) {
    switch (goal) {
      case FitnessGoal.loseWeight:
        return 'Lose Weight';
      case FitnessGoal.gainMuscle:
        return 'Gain Muscle';
      case FitnessGoal.improveEndurance:
        return 'Improve Endurance';
      case FitnessGoal.improveFlexibility:
        return 'Improve Flexibility';
      case FitnessGoal.stayHealthy:
        return 'Stay Healthy';
      default:
        return 'Unknown';
    }
  }
  
  // Get muscleGroup icon
  static IconData getMuscleGroupIcon(MuscleGroup group) {
    switch (group) {
      case MuscleGroup.chest:
        return Icons.accessibility_new;
      case MuscleGroup.back:
        return Icons.accessibility_new;
      case MuscleGroup.shoulders:
        return Icons.accessibility_new;
      case MuscleGroup.biceps:
        return Icons.fitness_center;
      case MuscleGroup.triceps:
        return Icons.fitness_center;
      case MuscleGroup.legs:
        return Icons.directions_walk;
      case MuscleGroup.abs:
        return Icons.rectangle;
      case MuscleGroup.glutes:
        return Icons.directions_walk;
      case MuscleGroup.forearms:
        return Icons.fitness_center;
      case MuscleGroup.calves:
        return Icons.directions_walk;
      case MuscleGroup.fullBody:
        return Icons.accessibility_new;
      default:
        return Icons.accessibility_new;
    }
  }
  
  // Get workout type icon
  static IconData getWorkoutTypeIcon(WorkoutType type) {
    switch (type) {
      case WorkoutType.fullBody:
        return Icons.accessibility_new;
      case WorkoutType.upperBody:
        return Icons.fitness_center;
      case WorkoutType.lowerBody:
        return Icons.directions_walk;
      case WorkoutType.core:
        return Icons.rectangle;
      case WorkoutType.cardio:
        return Icons.favorite;
      case WorkoutType.hiit:
        return Icons.timer;
      case WorkoutType.custom:
        return Icons.edit;
      default:
        return Icons.sports_gymnastics;
    }
  }
}
