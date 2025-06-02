import 'package:uuid/uuid.dart';

enum MuscleGroup {
  chest,
  back,
  shoulders,
  biceps,
  triceps,
  legs,
  abs,
  glutes,
  forearms,
  calves,
  fullBody
}

enum Difficulty {
  beginner,
  intermediate,
  advanced
}

class Exercise {
  final String id;
  final String name;
  final String description;
  final List<MuscleGroup> primaryMuscles;
  final List<MuscleGroup> secondaryMuscles;
  final Difficulty difficulty;
  final List<String> steps;
  final List<String> tips;
  final String? imageUrl;
  final bool requiresEquipment;
  final int recommendedTime; // in seconds
  final int recommendedReps;
  final int recommendedSets;
  final int restBetweenSets; // in seconds
  final int caloriesBurned; // estimated per minute

  Exercise({
    String? id,
    required this.name,
    required this.description,
    required this.primaryMuscles,
    this.secondaryMuscles = const [],
    required this.difficulty,
    required this.steps,
    this.tips = const [],
    this.imageUrl,
    this.requiresEquipment = false,
    this.recommendedTime = 0,
    this.recommendedReps = 0,
    this.recommendedSets = 3,
    this.restBetweenSets = 60,
    this.caloriesBurned = 0,
  }) : id = id ?? const Uuid().v4();
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'primaryMuscles': primaryMuscles.map((e) => e.toString().split('.').last).toList(),
      'secondaryMuscles': secondaryMuscles.map((e) => e.toString().split('.').last).toList(),
      'difficulty': difficulty.toString().split('.').last,
      'steps': steps,
      'tips': tips,
      'imageUrl': imageUrl,
      'requiresEquipment': requiresEquipment,
      'recommendedTime': recommendedTime,
      'recommendedReps': recommendedReps,
      'recommendedSets': recommendedSets,
      'restBetweenSets': restBetweenSets,
      'caloriesBurned': caloriesBurned,
    };
  }
  
  factory Exercise.fromJson(Map<String, dynamic> json) {
    return Exercise(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      primaryMuscles: (json['primaryMuscles'] as List)
          .map((e) => MuscleGroup.values.firstWhere(
              (element) => element.toString() == 'MuscleGroup.$e'))
          .toList(),
      secondaryMuscles: (json['secondaryMuscles'] as List)
          .map((e) => MuscleGroup.values.firstWhere(
              (element) => element.toString() == 'MuscleGroup.$e'))
          .toList(),
      difficulty: Difficulty.values.firstWhere(
          (element) => element.toString() == 'Difficulty.${json['difficulty']}'),
      steps: List<String>.from(json['steps']),
      tips: List<String>.from(json['tips']),
      imageUrl: json['imageUrl'],
      requiresEquipment: json['requiresEquipment'],
      recommendedTime: json['recommendedTime'],
      recommendedReps: json['recommendedReps'],
      recommendedSets: json['recommendedSets'],
      restBetweenSets: json['restBetweenSets'],
      caloriesBurned: json['caloriesBurned'],
    );
  }
  
  @override
  String toString() {
    return 'Exercise{name: $name, primaryMuscles: $primaryMuscles}';
  }
}
