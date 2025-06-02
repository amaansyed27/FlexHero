# Workout Generation Logic

This document explains how FlexHero generates personalized workout routines for users.

## Overview

The workout generation system in FlexHero creates customized workout routines based on:

1. User profile (fitness level, goals, body metrics)
2. Targeted muscle groups
3. Available time
4. Exercise variety and progression

The main component responsible for workout generation is the `ExerciseDatabase` class, which works alongside the `WorkoutService`.

## Core Components

### 1. Exercise Database

The `ExerciseDatabase` contains a comprehensive collection of bodyweight exercises categorized by:

- Primary/secondary muscle groups 
- Difficulty levels
- Recommended repetitions and sets
- Estimated calorie burn

```dart
class ExerciseDatabase {
  // This class provides a database of exercises available in the app
  
  static List<Exercise> getHomeExercises() {
    // Return list of all available exercises
  }
  
  static List<Workout> getPredefinedWorkouts(List<Exercise> exercises) {
    // Return predefined workouts using exercises from database
  }
  
  static Workout generateCustomWorkout(UserProfile profile, List<Exercise> exercises) {
    // Generate workout based on user profile
  }
}
```

### 2. Workout Generation Algorithm

The workout generation process follows these steps:

#### Step 1: Exercise Selection

Exercises are selected based on:

```dart
// Example of exercise selection logic
List<Exercise> selectExercisesForWorkout(UserProfile profile) {
  // Filter exercises by fitness level
  var appropriateExercises = exercises.where((e) {
    if (profile.fitnessLevel == FitnessLevel.beginner) {
      return e.difficulty == Difficulty.beginner;
    } else if (profile.fitnessLevel == FitnessLevel.intermediate) {
      return e.difficulty != Difficulty.advanced;
    }
    return true; // For advanced users, include all difficulties
  }).toList();
  
  // Filter based on goals and target muscle groups
  // ...
}
```

#### Step 2: Workout Structure Creation

The workout structure is built considering:

- Warm-up exercises
- Main exercises targeting the selected muscle groups
- Cool-down/stretching exercises
- Appropriate rest periods

```dart
// Example of workout structure creation
Workout createWorkoutStructure(List<Exercise> selectedExercises, UserProfile profile) {
  // Determine workout duration based on user preference
  int targetDuration = profile.workoutDuration * 60; // Convert to seconds
  
  // Create workout with appropriate exercises, sets, and reps
  // ...
}
```

#### Step 3: Workout Customization

The workout is then customized based on:

- User fitness goals (strength, endurance, weight loss)
- Available workout time
- Workout history to provide variety

## Difficulty Scaling

The system adjusts workout intensity based on user fitness level:

1. **Beginner**:
   - Lower repetitions and sets
   - Longer rest periods
   - Basic exercise variations

2. **Intermediate**:
   - Moderate repetitions and sets
   - Standard rest periods
   - Some advanced variations

3. **Advanced**:
   - Higher repetitions and sets
   - Shorter rest periods
   - More challenging exercise variations

## Training Volume Calculation

Training volume is calculated to ensure effectiveness without overtraining:

```dart
// Example of volume calculation
int calculateTrainingVolume(List<WorkoutExercise> exercises) {
  int volume = 0;
  for (var exercise in exercises) {
    volume += exercise.sets * exercise.reps * getDifficultyMultiplier(exercise.exercise.difficulty);
  }
  return volume;
}
```

## Rest Period Management

Rest periods are dynamically adjusted:

- Between exercises: 30-90 seconds (depending on intensity)
- Between sets: 15-60 seconds (depending on exercise type)

## Progression Logic

The system provides progression by:

1. Increasing repetitions over time
2. Decreasing rest periods
3. Introducing more challenging exercise variations
4. Increasing the number of sets

## Workout Types

The app can generate various workout types:

- **Full Body**: Targets all major muscle groups
- **Upper Body**: Focuses on chest, back, shoulders, and arms
- **Lower Body**: Targets legs, glutes, and calves
- **Core**: Emphasizes abdominal and lower back muscles
- **HIIT**: High-intensity interval training with cardio elements
- **Custom**: Generated based on user-selected muscle groups

## Sample Workout Generation

Here's an example of how a workout is generated for a beginner user focusing on weight loss:

1. Select appropriate exercises from the database
2. Structure a 30-minute workout with:
   - 5-minute warm-up (dynamic stretches, light cardio)
   - 20-minute main workout (mix of strength and cardio)
   - 5-minute cool-down (stretching)
3. Set appropriate repetitions, sets, and rest periods
4. Calculate estimated calorie burn and difficulty rating

The resulting workout is returned as a `Workout` object containing all necessary information for the user interface to display and guide the user through the workout.

# Advanced Workout Filtering

FlexHero now implements a sophisticated workout generation system using the `WorkoutFilter` model. This allows for highly customized workouts based on user preferences.

## Workout Filter Model

The `WorkoutFilter` class encapsulates all criteria used to generate a workout:

```dart
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
  
  // Constructor, methods, etc.
}
```

## Workout Generation Algorithm

The workout service uses a sophisticated algorithm to generate workouts:

1. **Exercise Selection**: Filters the exercise database based on user criteria
   - Matches difficulty level
   - Filters by target muscle groups
   - Considers equipment requirements
   - Respects user's fitness goals
   
2. **Balanced Workout Construction**: Ensures a proper balance of exercises
   - If balanced workout is requested, selects exercises from different muscle groups
   - If specific muscle groups are targeted, prioritizes those exercises
   - Includes specifically requested exercises
   - Excludes unwanted exercises
   
3. **Set & Rep Calculation**: Adjusts volume based on difficulty and goals
   - Beginner: Lower reps/sets
   - Advanced: Higher reps/sets
   - Adjusts based on intensity level
   
4. **Duration Management**: Calculates appropriate number of exercises based on target duration
   - Estimates time per exercise (including rest periods)
   - Adjusts number of exercises to fit the target duration
   
5. **Workout Type Determination**: Analyzes the selected exercises to determine the workout type
   - Counts primary and secondary muscle involvement
   - Categorizes workout (full body, upper body, legs, etc.)
   
6. **Title & Description Generation**: Creates descriptive title based on workout focus
   - Names based on target muscles (e.g., "Chest Workout", "Leg Day")
   - Names based on goals (e.g., "Fat Burning Workout", "Endurance Booster")
   - Names based on difficulty (e.g., "Beginner Workout")

## Sample Implementation

```dart
// Generate a custom workout based on specified filter
Workout generateWorkoutWithFilter(WorkoutFilter filter) {
  // 1. Get filtered exercises
  List<Exercise> exercisePool = _filterExercises(filter);
  
  // 2. Calculate exercise count based on duration
  final int targetDuration = filter.durationMinutes ?? 30;
  final int avgExerciseDuration = 3; // Average minutes per exercise
  final int exercisesCount = max(3, targetDuration ~/ avgExerciseDuration);
  
  // 3. Select exercises with proper balance
  List<Exercise> selectedExercises = [];
  
  // Add included exercises
  // Add balanced exercises from different muscle groups
  // Add exercises from target muscle groups
  
  // 4. Create workout sets
  List<WorkoutExercise> workoutExercises = selectedExercises.map((exercise) {
    // Calculate reps and sets based on difficulty and intensity
    return WorkoutExercise(
      exercise: exercise,
      reps: calculatedReps,
      sets: calculatedSets,
    );
  }).toList();
  
  // 5. Create and return the workout
  return Workout(
    name: generatedTitle,
    description: generatedDescription,
    type: determinedType,
    difficulty: filter.difficulty ?? Difficulty.intermediate,
    exercises: workoutExercises,
    // Other properties
  );
}
```

This advanced filtering mechanism creates a truly personalized workout experience for users with varied fitness levels and goals.

## Implementation Details

The core implementation of workout generation can be found in the `ExerciseDatabase.generateCustomWorkout()` method in the `exercise_database.dart` file.
