import 'package:uuid/uuid.dart';
import 'exercise.dart';

enum WorkoutType {
  fullBody,
  upperBody,
  lowerBody,
  core,
  cardio,
  hiit,
  custom
}

class Workout {
  final String id;
  final String name;
  final String description;
  final WorkoutType type;
  final Difficulty difficulty;
  final int estimatedDuration; // in minutes
  final List<WorkoutExercise> exercises;
  final int estimatedCaloriesBurn;
  final bool isCustom;
  final int restBetweenExercises; // in seconds
  
  Workout({
    String? id,
    required this.name,
    required this.description,
    required this.type,
    required this.difficulty,
    required this.exercises,
    this.estimatedDuration = 0,
    this.estimatedCaloriesBurn = 0,
    this.isCustom = false,
    this.restBetweenExercises = 30,
  }) : id = id ?? const Uuid().v4();
  
  // Calculate total duration including rest periods
  int get totalDurationInSeconds {
    int total = 0;
    
    // Add duration of all exercises
    for (var exercise in exercises) {
      if (exercise.useTime) {
        total += exercise.time * exercise.sets;
      } else {
        // Estimate time based on reps (2 seconds per rep as an approximation)
        total += exercise.reps * 2 * exercise.sets;
      }
      
      // Add rest between sets
      if (exercise.sets > 1) {
        total += exercise.restBetweenSets * (exercise.sets - 1);
      }
    }
    
    // Add rest between exercises
    if (exercises.length > 1) {
      total += restBetweenExercises * (exercises.length - 1);
    }
    
    return total;
  }
  
  // Get the workout's target muscle groups
  List<MuscleGroup> get targetMuscleGroups {
    Set<MuscleGroup> muscles = {};
    
    for (var exerciseItem in exercises) {
      muscles.addAll(exerciseItem.exercise.primaryMuscles);
    }
    
    return muscles.toList();
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'type': type.toString().split('.').last,
      'difficulty': difficulty.toString().split('.').last,
      'estimatedDuration': estimatedDuration,
      'exercises': exercises.map((e) => e.toJson()).toList(),
      'estimatedCaloriesBurn': estimatedCaloriesBurn,
      'isCustom': isCustom,
      'restBetweenExercises': restBetweenExercises,
    };
  }
  
  factory Workout.fromJson(Map<String, dynamic> json, List<Exercise> allExercises) {
    return Workout(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      type: WorkoutType.values.firstWhere(
          (element) => element.toString() == 'WorkoutType.${json['type']}'),
      difficulty: Difficulty.values.firstWhere(
          (element) => element.toString() == 'Difficulty.${json['difficulty']}'),
      estimatedDuration: json['estimatedDuration'],
      exercises: (json['exercises'] as List)
          .map((e) => WorkoutExercise.fromJson(e, allExercises))
          .toList(),
      estimatedCaloriesBurn: json['estimatedCaloriesBurn'],
      isCustom: json['isCustom'],
      restBetweenExercises: json['restBetweenExercises'],
    );
  }
}

class WorkoutExercise {
  final Exercise exercise;
  final int sets;
  final int reps;
  final int time; // in seconds
  final bool useTime; // if true, use time instead of reps
  final int restBetweenSets; // in seconds
  
  WorkoutExercise({
    required this.exercise,
    this.sets = 3,
    this.reps = 10,
    this.time = 30,
    this.useTime = false,
    this.restBetweenSets = 60,
  });
  
  Map<String, dynamic> toJson() {
    return {
      'exerciseId': exercise.id,
      'sets': sets,
      'reps': reps,
      'time': time,
      'useTime': useTime,
      'restBetweenSets': restBetweenSets,
    };
  }
  
  factory WorkoutExercise.fromJson(Map<String, dynamic> json, List<Exercise> allExercises) {
    final exercise = allExercises.firstWhere((e) => e.id == json['exerciseId']);
    return WorkoutExercise(
      exercise: exercise,
      sets: json['sets'],
      reps: json['reps'],
      time: json['time'],
      useTime: json['useTime'],
      restBetweenSets: json['restBetweenSets'],
    );
  }
}
