import 'dart:convert';
import 'dart:math' as math;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/workout.dart';
import '../models/user_profile.dart';
import '../models/exercise.dart';
import '../models/workout_filter.dart';
import 'exercise_database.dart';

class WorkoutService {
  static const String _userProfileKey = 'user_profile';
  static const String _workoutHistoryKey = 'workout_history';
  static const String _customWorkoutsKey = 'custom_workouts';
  
  // List of all exercises
  late List<Exercise> _exercises;
  // List of predefined workouts
  late List<Workout> _predefinedWorkouts;
  
  // Singleton instance
  static final WorkoutService _instance = WorkoutService._internal();
  
  factory WorkoutService() {
    return _instance;
  }
  
  WorkoutService._internal() {
    // Initialize the database
    _exercises = ExerciseDatabase.getHomeExercises();
    _predefinedWorkouts = ExerciseDatabase.getPredefinedWorkouts(_exercises);
  }
  
  // Get all available exercises
  List<Exercise> get allExercises => _exercises;
  
  // Get all predefined workouts
  List<Workout> get predefinedWorkouts => _predefinedWorkouts;
  
  // Save user profile
  Future<void> saveUserProfile(UserProfile profile) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userProfileKey, jsonEncode(profile.toJson()));
  }
  
  // Get user profile
  Future<UserProfile?> getUserProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final profileJson = prefs.getString(_userProfileKey);
    
    if (profileJson == null) {
      return null;
    }
    
    try {
      return UserProfile.fromJson(jsonDecode(profileJson));
    } catch (e) {
      print('Error loading user profile: $e');
      return null;
    }
  }
  
  // Generate a custom workout based on user profile
  Workout generateWorkoutForUser(UserProfile profile) {
    final filter = WorkoutFilter.fromUserProfile(profile);
    return generateWorkoutWithFilter(filter);
  }

  // Generate a custom workout based on specified filter
  Workout generateWorkoutWithFilter(WorkoutFilter filter) {
    // First, get a pool of exercises matching the filter criteria
    List<Exercise> exercisePool = _filterExercises(filter);
    
    if (exercisePool.isEmpty) {
      // Fallback to all exercises if filter is too restrictive
      exercisePool = _exercises;
    }
    
    // Calculate the appropriate number of exercises based on duration
    final int targetDuration = filter.durationMinutes ?? 30;
    final int avgExerciseDuration = 3; // Average minutes per exercise
    final int exercisesCount = math.max(3, targetDuration ~/ avgExerciseDuration);
    
    // Select exercises based on filter criteria
    List<Exercise> selectedExercises = [];
    
    // First add any specifically included exercises
    if (filter.includedExerciseIds.isNotEmpty) {
      for (String id in filter.includedExerciseIds) {
        final exercise = _exercises.firstWhere(
          (e) => e.id == id,
          orElse: () => _exercises.first,
        );
        selectedExercises.add(exercise);
      }
    }
    
    // If we need balanced workout, ensure we get exercises from different groups
    if (filter.balancedWorkout && filter.targetMuscleGroups.isEmpty) {
      // Create a map of muscle groups with their exercises
      Map<MuscleGroup, List<Exercise>> exercisesByMuscle = {};
      for (MuscleGroup group in MuscleGroup.values) {
        exercisesByMuscle[group] = exercisePool.where(
          (e) => e.primaryMuscles.contains(group)
        ).toList();
      }
      
      // Get exercises from different groups
      List<MuscleGroup> muscleGroups = MuscleGroup.values.toList();
      muscleGroups.shuffle();
      
      for (MuscleGroup group in muscleGroups) {
        if (selectedExercises.length >= exercisesCount) break;
        
        if (exercisesByMuscle[group]!.isNotEmpty) {
          // Get a random exercise from this group
          exercisesByMuscle[group]!.shuffle();
          final exercise = exercisesByMuscle[group]!.first;
          
          // Only add if not already in selected exercises
          if (!selectedExercises.contains(exercise)) {
            selectedExercises.add(exercise);
          }
        }
      }
    }
    
    // If we have specific target muscle groups, prioritize those
    if (filter.targetMuscleGroups.isNotEmpty) {
      // Filter exercises by target muscle groups
      List<Exercise> targetExercises = exercisePool.where((e) {
        return e.primaryMuscles.any((m) => filter.targetMuscleGroups.contains(m));
      }).toList();
      
      targetExercises.shuffle();
      
      // Add up to half of the exercises from target muscle groups
      int targetCount = math.min(targetExercises.length, exercisesCount ~/ 2);
      for (int i = 0; i < targetCount; i++) {
        if (!selectedExercises.contains(targetExercises[i])) {
          selectedExercises.add(targetExercises[i]);
        }
      }
    }
    
    // Fill the rest with random exercises
    exercisePool.shuffle();
    for (Exercise exercise in exercisePool) {
      if (selectedExercises.length >= exercisesCount) break;
      if (!selectedExercises.contains(exercise) && 
          !filter.excludedExerciseIds.contains(exercise.id)) {
        selectedExercises.add(exercise);
      }
    }
      // Create workout exercises based on exercise difficulty
    List<WorkoutExercise> workoutExercises = selectedExercises.map((exercise) {
      int reps = exercise.recommendedReps;
      int sets = exercise.recommendedSets;
      
      // Adjust based on difficulty
      if (filter.difficulty == Difficulty.beginner) {
        reps = math.max(5, reps - 2);
        sets = math.max(2, sets - 1);
      } else if (filter.difficulty == Difficulty.advanced) {
        reps = reps + 2;
        sets = sets + 1;
      }
      
      // Adjust based on intensity level
      if (filter.intensityLevel != null) {
        final factor = filter.intensityLevel! / 5.0; // Scale to 1-2x
        reps = (reps * factor).round();
        sets = math.max(2, (sets * (factor * 0.7 + 0.3)).round()); // Less impact on sets
      }
      
      return WorkoutExercise(
        exercise: exercise,
        reps: reps,
        sets: sets,
      );
    }).toList();
    
    // Create a title based on filter
    String title = 'Custom Workout';
    if (filter.targetMuscleGroups.isNotEmpty) {
      if (filter.targetMuscleGroups.length == 1) {        switch (filter.targetMuscleGroups.first) {
          case MuscleGroup.chest:
            title = 'Chest Workout';
            break;
          case MuscleGroup.back:
            title = 'Back Workout';
            break;
          case MuscleGroup.legs:
            title = 'Leg Day';
            break;
          case MuscleGroup.abs:
            title = 'Core Crusher';
            break;
          case MuscleGroup.shoulders:
            title = 'Shoulder Builder';
            break;
          case MuscleGroup.biceps:
          case MuscleGroup.triceps:
            title = 'Arm Blaster';
            break;
          case MuscleGroup.fullBody:
            title = 'Full Body Workout';
            break;
          case MuscleGroup.glutes:
            title = 'Glutes Workout';
            break;
          case MuscleGroup.forearms:
            title = 'Forearms Workout';
            break;
          case MuscleGroup.calves:
            title = 'Calves Workout';
            break;
        }
      } else {
        title = 'Mixed Muscle Group Workout';
      }    } else if (filter.primaryGoal != null) {
      switch (filter.primaryGoal!) {
        case FitnessGoal.loseWeight:
          title = 'Fat Burning Workout';
          break;
        case FitnessGoal.gainMuscle:
          title = 'Muscle Building Workout';
          break;
        case FitnessGoal.improveEndurance:
          title = 'Endurance Booster';
          break;
        case FitnessGoal.stayHealthy:
          title = 'General Fitness Workout';
          break;
        case FitnessGoal.improveFlexibility:
          title = 'Flexibility Enhancer';
          break;
      }
    } else if (filter.difficulty != null) {
      switch (filter.difficulty!) {
        case Difficulty.beginner:
          title = 'Beginner Workout';
          break;
        case Difficulty.intermediate:
          title = 'Intermediate Workout';
          break;
        case Difficulty.advanced:
          title = 'Advanced Workout';
          break;
      }
    }
      // Calculate estimated duration and calories
    int estimatedDuration = workoutExercises.fold(0, (sum, exercise) {
      // 45 seconds per set plus rest time
      return sum + (exercise.sets * (45 + 30));
    });
    estimatedDuration = estimatedDuration ~/ 60; // Convert to minutes
    
    int estimatedCaloriesBurn = workoutExercises.fold(0, (sum, exercise) {
      // Calculate based on exercise calorie value, reps and sets
      return sum + (exercise.exercise.caloriesBurned * exercise.reps * exercise.sets);
    });
    
    // Create the workout
    return Workout(
      name: title,
      description: 'Custom workout generated based on your preferences',
      difficulty: filter.difficulty ?? Difficulty.intermediate,
      type: _determineWorkoutType(workoutExercises),
      estimatedDuration: estimatedDuration,
      estimatedCaloriesBurn: estimatedCaloriesBurn,
      exercises: workoutExercises,
    );
  }
  
  // Helper method to filter exercises based on filter criteria
  List<Exercise> _filterExercises(WorkoutFilter filter) {
    return _exercises.where((exercise) {
      // Filter by difficulty
      bool difficultyMatch = filter.difficulty == null || 
          exercise.difficulty == filter.difficulty;
      
      // Filter by excluded exercises
      bool notExcluded = !filter.excludedExerciseIds.contains(exercise.id);
      
      // Filter by bodyweight only
      bool bodyweightMatch = !filter.bodyweightOnly || !exercise.requiresEquipment;
      
      // Filter by target muscle groups
      bool muscleGroupMatch = filter.targetMuscleGroups.isEmpty ||
          exercise.primaryMuscles.any((m) => filter.targetMuscleGroups.contains(m)) ||
          exercise.secondaryMuscles.any((m) => filter.targetMuscleGroups.contains(m));
      
      // Combined filter
      return difficultyMatch && notExcluded && bodyweightMatch && muscleGroupMatch;
    }).toList();
  }
    // Helper method to determine workout type based on exercises
  WorkoutType _determineWorkoutType(List<WorkoutExercise> exercises) {
    // Count occurrences of each muscle group
    Map<MuscleGroup, int> groupCount = {};
    
    for (WorkoutExercise workout in exercises) {
      for (MuscleGroup group in workout.exercise.primaryMuscles) {
        groupCount[group] = (groupCount[group] ?? 0) + 2; // Primary counts double
      }
      for (MuscleGroup group in workout.exercise.secondaryMuscles) {
        groupCount[group] = (groupCount[group] ?? 0) + 1;
      }
    }
    
    // Find the most common muscle group
    MuscleGroup? dominantGroup;
    int maxCount = 0;
    
    groupCount.forEach((group, count) {
      if (count > maxCount) {
        maxCount = count;
        dominantGroup = group;
      }
    });
    
    // Check if it's balanced or focused on specific group
    bool isBalanced = true;
    if (dominantGroup != null) {
      int totalCount = groupCount.values.fold(0, (sum, count) => sum + count);
      double dominantRatio = maxCount / totalCount;
      
      if (dominantRatio > 0.5) {
        // More than half focused on one muscle group
        isBalanced = false;
      }
    }
    
    // Determine type based on dominant muscle groups
    if (isBalanced) {
      return WorkoutType.fullBody;
    } else {
      // Map muscle groups to workout types
      if (dominantGroup == MuscleGroup.chest || 
          dominantGroup == MuscleGroup.back || 
          dominantGroup == MuscleGroup.shoulders) {
        return WorkoutType.upperBody;
      } else if (dominantGroup == MuscleGroup.legs || 
                dominantGroup == MuscleGroup.glutes || 
                dominantGroup == MuscleGroup.calves) {
        return WorkoutType.lowerBody;
      } else if (dominantGroup == MuscleGroup.abs) {
        return WorkoutType.core;
      } else {
        return WorkoutType.fullBody;
      }
    }
  }
  
  // Save a completed workout to history
  Future<void> saveWorkoutToHistory(String workoutId, DateTime completedDate, int duration, int caloriesBurned) async {
    final prefs = await SharedPreferences.getInstance();
    final historyJson = prefs.getString(_workoutHistoryKey) ?? '[]';
    
    final List<dynamic> history = jsonDecode(historyJson);
    
    history.add({
      'workoutId': workoutId,
      'completedDate': completedDate.toIso8601String(),
      'duration': duration,
      'caloriesBurned': caloriesBurned,
    });
    
    await prefs.setString(_workoutHistoryKey, jsonEncode(history));
    
    // Update user profile with completed workout
    final profile = await getUserProfile();
    if (profile != null) {
      final updatedCompletedWorkouts = [...profile.completedWorkoutIds, workoutId];
      final updatedProfile = profile.copyWith(
        completedWorkoutIds: updatedCompletedWorkouts,
      );
      await saveUserProfile(updatedProfile);
    }
  }
  
  // Get workout history
  Future<List<Map<String, dynamic>>> getWorkoutHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final historyJson = prefs.getString(_workoutHistoryKey) ?? '[]';
    
    final List<dynamic> history = jsonDecode(historyJson);
    return List<Map<String, dynamic>>.from(history);
  }
  
  // Save a custom workout
  Future<void> saveCustomWorkout(Workout workout) async {
    final prefs = await SharedPreferences.getInstance();
    final customWorkoutsJson = prefs.getString(_customWorkoutsKey) ?? '[]';
    
    final List<dynamic> customWorkouts = jsonDecode(customWorkoutsJson);
    
    // Check if workout already exists, update if it does
    int existingIndex = customWorkouts.indexWhere((w) => w['id'] == workout.id);
    if (existingIndex >= 0) {
      customWorkouts[existingIndex] = workout.toJson();
    } else {
      customWorkouts.add(workout.toJson());
    }
    
    await prefs.setString(_customWorkoutsKey, jsonEncode(customWorkouts));
  }
  
  // Get all custom workouts
  Future<List<Workout>> getCustomWorkouts() async {
    final prefs = await SharedPreferences.getInstance();
    final customWorkoutsJson = prefs.getString(_customWorkoutsKey) ?? '[]';
    
    final List<dynamic> customWorkouts = jsonDecode(customWorkoutsJson);
    return customWorkouts
        .map<Workout>((json) => Workout.fromJson(json, _exercises))
        .toList();
  }
  
  // Get workout by ID (combines predefined and custom workouts)
  Future<Workout?> getWorkoutById(String id) async {
    // Check predefined workouts first
    try {
      return _predefinedWorkouts.firstWhere((w) => w.id == id);
    } catch (_) {
      // Not found in predefined, check custom workouts
      final customWorkouts = await getCustomWorkouts();
      try {
        return customWorkouts.firstWhere((w) => w.id == id);
      } catch (_) {
        return null;
      }
    }
  }
  
  // Get workouts by type
  List<Workout> getWorkoutsByType(WorkoutType type) {
    return _predefinedWorkouts.where((workout) => workout.type == type).toList();
  }
  
  // Get workouts by difficulty
  List<Workout> getWorkoutsByDifficulty(Difficulty difficulty) {
    return _predefinedWorkouts.where((workout) => workout.difficulty == difficulty).toList();
  }
  
  // Get exercises by muscle group
  List<Exercise> getExercisesByMuscleGroup(MuscleGroup muscleGroup) {
    return _exercises.where((exercise) => 
      exercise.primaryMuscles.contains(muscleGroup) || 
      exercise.secondaryMuscles.contains(muscleGroup)
    ).toList();
  }
}
