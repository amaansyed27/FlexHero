import 'package:uuid/uuid.dart';

enum FitnessLevel {
  beginner,
  intermediate,
  advanced
}

enum FitnessGoal {
  loseWeight,
  gainMuscle,
  improveEndurance,
  improveFlexibility,
  stayHealthy
}

class UserProfile {
  final String id;
  final String name;
  final int age;
  final double weight; // in kg
  final double height; // in cm
  final bool isMale;
  final FitnessLevel fitnessLevel;
  final FitnessGoal primaryGoal;
  final List<FitnessGoal> secondaryGoals;
  final List<String> completedWorkoutIds;
  final int weeklyWorkoutTarget; // number of workouts per week
  final int workoutDuration; // preferred workout duration in minutes
  
  UserProfile({
    String? id,
    required this.name,
    required this.age,
    required this.weight,
    required this.height,
    required this.isMale,
    required this.fitnessLevel,
    required this.primaryGoal,
    this.secondaryGoals = const [],
    this.completedWorkoutIds = const [],
    this.weeklyWorkoutTarget = 3,
    this.workoutDuration = 30,
  }) : id = id ?? const Uuid().v4();
  
  double get bmi => weight / ((height / 100) * (height / 100));
  
  String get bmiCategory {
    if (bmi < 18.5) return "Underweight";
    if (bmi < 25) return "Normal";
    if (bmi < 30) return "Overweight";
    return "Obese";
  }
  
  // Calculate daily calorie needs using the Harris-Benedict equation
  double get dailyCalorieNeeds {
    double bmr;
    if (isMale) {
      bmr = 88.362 + (13.397 * weight) + (4.799 * height) - (5.677 * age);
    } else {
      bmr = 447.593 + (9.247 * weight) + (3.098 * height) - (4.330 * age);
    }
    
    // Activity multiplier based on fitness level
    double activityMultiplier;
    switch (fitnessLevel) {
      case FitnessLevel.beginner:
        activityMultiplier = 1.375; // Lightly active
        break;
      case FitnessLevel.intermediate:
        activityMultiplier = 1.55; // Moderately active
        break;
      case FitnessLevel.advanced:
        activityMultiplier = 1.725; // Very active
        break;
    }
    
    return bmr * activityMultiplier;
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'age': age,
      'weight': weight,
      'height': height,
      'isMale': isMale,
      'fitnessLevel': fitnessLevel.toString().split('.').last,
      'primaryGoal': primaryGoal.toString().split('.').last,
      'secondaryGoals': secondaryGoals.map((e) => e.toString().split('.').last).toList(),
      'completedWorkoutIds': completedWorkoutIds,
      'weeklyWorkoutTarget': weeklyWorkoutTarget,
      'workoutDuration': workoutDuration,
    };
  }
  
  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'],
      name: json['name'],
      age: json['age'],
      weight: json['weight'],
      height: json['height'],
      isMale: json['isMale'],
      fitnessLevel: FitnessLevel.values.firstWhere(
          (element) => element.toString() == 'FitnessLevel.${json['fitnessLevel']}'),
      primaryGoal: FitnessGoal.values.firstWhere(
          (element) => element.toString() == 'FitnessGoal.${json['primaryGoal']}'),
      secondaryGoals: (json['secondaryGoals'] as List)
          .map((e) => FitnessGoal.values.firstWhere(
              (element) => element.toString() == 'FitnessGoal.$e'))
          .toList(),
      completedWorkoutIds: List<String>.from(json['completedWorkoutIds']),
      weeklyWorkoutTarget: json['weeklyWorkoutTarget'],
      workoutDuration: json['workoutDuration'],
    );
  }
  
  UserProfile copyWith({
    String? name,
    int? age,
    double? weight,
    double? height,
    bool? isMale,
    FitnessLevel? fitnessLevel,
    FitnessGoal? primaryGoal,
    List<FitnessGoal>? secondaryGoals,
    List<String>? completedWorkoutIds,
    int? weeklyWorkoutTarget,
    int? workoutDuration,
  }) {
    return UserProfile(
      id: this.id,
      name: name ?? this.name,
      age: age ?? this.age,
      weight: weight ?? this.weight,
      height: height ?? this.height,
      isMale: isMale ?? this.isMale,
      fitnessLevel: fitnessLevel ?? this.fitnessLevel,
      primaryGoal: primaryGoal ?? this.primaryGoal,
      secondaryGoals: secondaryGoals ?? this.secondaryGoals,
      completedWorkoutIds: completedWorkoutIds ?? this.completedWorkoutIds,
      weeklyWorkoutTarget: weeklyWorkoutTarget ?? this.weeklyWorkoutTarget,
      workoutDuration: workoutDuration ?? this.workoutDuration,
    );
  }
}
