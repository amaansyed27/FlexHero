import 'package:flutter/foundation.dart';
import 'exercise.dart';
import 'user_profile.dart';

/// A class that defines filters for workout generation
class WorkoutFilter {
  /// The target duration of the workout in minutes
  final int? durationMinutes;
  
  /// The target difficulty of the workout
  final Difficulty? difficulty;
  
  /// List of muscle groups to target in this workout
  final List<MuscleGroup> targetMuscleGroups;
  
  /// Whether to exclude equipment-based exercises
  final bool bodyweightOnly;
  
  /// The primary goal of this workout
  final FitnessGoal? primaryGoal;
  
  /// The intensity level of the workout (1-10)
  final int? intensityLevel;
  
  /// If true, will select balanced exercises across muscle groups
  final bool balancedWorkout;
  
  /// Specific exercises to include in the workout
  final List<String> includedExerciseIds;
  
  /// Specific exercises to exclude from the workout
  final List<String> excludedExerciseIds;
  
  /// Create a new workout filter
  const WorkoutFilter({
    this.durationMinutes,
    this.difficulty,
    this.targetMuscleGroups = const [],
    this.bodyweightOnly = true,
    this.primaryGoal,
    this.intensityLevel,
    this.balancedWorkout = true,
    this.includedExerciseIds = const [],
    this.excludedExerciseIds = const [],
  });
  
  /// Create a default filter from user profile
  factory WorkoutFilter.fromUserProfile(UserProfile profile) {
    return WorkoutFilter(
      durationMinutes: profile.workoutDuration,
      difficulty: profile.fitnessLevel == FitnessLevel.beginner
          ? Difficulty.beginner
          : profile.fitnessLevel == FitnessLevel.intermediate
              ? Difficulty.intermediate
              : Difficulty.advanced,
      bodyweightOnly: true,
      primaryGoal: profile.primaryGoal,
      intensityLevel: profile.fitnessLevel == FitnessLevel.beginner
          ? 3
          : profile.fitnessLevel == FitnessLevel.intermediate
              ? 6
              : 8,
    );
  }
  
  /// Create a copy with modified properties
  WorkoutFilter copyWith({
    int? durationMinutes,
    Difficulty? difficulty,
    List<MuscleGroup>? targetMuscleGroups,
    bool? bodyweightOnly,
    FitnessGoal? primaryGoal,
    int? intensityLevel,
    bool? balancedWorkout,
    List<String>? includedExerciseIds,
    List<String>? excludedExerciseIds,
  }) {
    return WorkoutFilter(
      durationMinutes: durationMinutes ?? this.durationMinutes,
      difficulty: difficulty ?? this.difficulty,
      targetMuscleGroups: targetMuscleGroups ?? this.targetMuscleGroups,
      bodyweightOnly: bodyweightOnly ?? this.bodyweightOnly,
      primaryGoal: primaryGoal ?? this.primaryGoal,
      intensityLevel: intensityLevel ?? this.intensityLevel,
      balancedWorkout: balancedWorkout ?? this.balancedWorkout,
      includedExerciseIds: includedExerciseIds ?? this.includedExerciseIds,
      excludedExerciseIds: excludedExerciseIds ?? this.excludedExerciseIds,
    );
  }
  
  /// Convert to a Map for JSON serialization
  Map<String, dynamic> toJson() {
    return {
      'durationMinutes': durationMinutes,
      'difficulty': difficulty?.index,
      'targetMuscleGroups': targetMuscleGroups.map((mg) => mg.index).toList(),
      'bodyweightOnly': bodyweightOnly,
      'primaryGoal': primaryGoal?.index,
      'intensityLevel': intensityLevel,
      'balancedWorkout': balancedWorkout,
      'includedExerciseIds': includedExerciseIds,
      'excludedExerciseIds': excludedExerciseIds,
    };
  }
  
  /// Create from a JSON Map
  factory WorkoutFilter.fromJson(Map<String, dynamic> json) {
    return WorkoutFilter(
      durationMinutes: json['durationMinutes'],
      difficulty: json['difficulty'] != null 
          ? Difficulty.values[json['difficulty']] 
          : null,
      targetMuscleGroups: (json['targetMuscleGroups'] as List<dynamic>?)
              ?.map((e) => MuscleGroup.values[e])
              ?.toList() ??
          [],
      bodyweightOnly: json['bodyweightOnly'] ?? true,
      primaryGoal: json['primaryGoal'] != null 
          ? FitnessGoal.values[json['primaryGoal']] 
          : null,
      intensityLevel: json['intensityLevel'],
      balancedWorkout: json['balancedWorkout'] ?? true,
      includedExerciseIds: (json['includedExerciseIds'] as List<dynamic>?)
              ?.map((e) => e.toString())
              ?.toList() ??
          [],
      excludedExerciseIds: (json['excludedExerciseIds'] as List<dynamic>?)
              ?.map((e) => e.toString())
              ?.toList() ??
          [],
    );
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    
    return other is WorkoutFilter &&
        other.durationMinutes == durationMinutes &&
        other.difficulty == difficulty &&
        listEquals(other.targetMuscleGroups, targetMuscleGroups) &&
        other.bodyweightOnly == bodyweightOnly &&
        other.primaryGoal == primaryGoal &&
        other.intensityLevel == intensityLevel &&
        other.balancedWorkout == balancedWorkout &&
        listEquals(other.includedExerciseIds, includedExerciseIds) &&
        listEquals(other.excludedExerciseIds, excludedExerciseIds);
  }
  
  @override
  int get hashCode {
    return durationMinutes.hashCode ^
        difficulty.hashCode ^
        Object.hashAll(targetMuscleGroups) ^
        bodyweightOnly.hashCode ^
        primaryGoal.hashCode ^
        intensityLevel.hashCode ^
        balancedWorkout.hashCode ^
        Object.hashAll(includedExerciseIds) ^
        Object.hashAll(excludedExerciseIds);
  }
}
