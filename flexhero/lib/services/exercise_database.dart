import '../models/exercise.dart';
import '../models/workout.dart';
import '../models/user_profile.dart';

class ExerciseDatabase {
  // This class provides a database of exercises available in the app
  // In a real app, this would likely be loaded from a server or local database
  
  static List<Exercise> getHomeExercises() {
    return [
      // Bodyweight exercises for different muscle groups
      // Chest exercises
      Exercise(
        name: 'Push-ups',
        description: 'Classic bodyweight exercise for chest, shoulders, and triceps',
        primaryMuscles: [MuscleGroup.chest],
        secondaryMuscles: [MuscleGroup.shoulders, MuscleGroup.triceps],
        difficulty: Difficulty.beginner,
        steps: [
          'Start in a plank position with hands shoulder-width apart',
          'Lower your body until your chest nearly touches the floor',
          'Push your body back up to the starting position',
          'Repeat for desired reps'
        ],
        tips: [
          'Keep your core engaged throughout the movement',
          'Maintain a straight line from head to toe',
          'For easier version, perform on knees instead of toes'
        ],
        recommendedReps: 10,
        recommendedSets: 3,
        caloriesBurned: 7,
      ),
      Exercise(
        name: 'Decline Push-ups',
        description: 'Push-up variation with feet elevated to target upper chest',
        primaryMuscles: [MuscleGroup.chest],
        secondaryMuscles: [MuscleGroup.shoulders, MuscleGroup.triceps],
        difficulty: Difficulty.intermediate,
        steps: [
          'Place your feet on an elevated surface (chair or bench)',
          'Assume push-up position with hands on the floor, shoulder-width apart',
          'Lower your chest toward the floor while maintaining a straight body',
          'Push back up to starting position'
        ],
        tips: [
          'The higher the elevation, the more challenging the exercise',
          'Keep your core tight throughout the movement',
          'Focus on controlled movement'
        ],
        recommendedReps: 8,
        recommendedSets: 3,
        caloriesBurned: 8,
      ),

      // Back exercises
      Exercise(
        name: 'Superman Hold',
        description: 'Bodyweight exercise that targets the lower back muscles',
        primaryMuscles: [MuscleGroup.back],
        secondaryMuscles: [MuscleGroup.glutes],
        difficulty: Difficulty.beginner,
        steps: [
          'Lie face down on a mat with arms extended in front',
          'Simultaneously raise your legs and arms off the ground',
          'Hold the position while squeezing your back muscles',
          'Lower back to starting position and repeat'
        ],
        tips: [
          'Focus on lifting through your back, not just your arms and legs',
          'Keep your neck in a neutral position by looking at the floor'
        ],
        recommendedTime: 20,
        recommendedSets: 3,
        caloriesBurned: 5,
      ),
      Exercise(
        name: 'Reverse Snow Angels',
        description: 'Floor exercise that strengthens the upper back and improves posture',
        primaryMuscles: [MuscleGroup.back],
        secondaryMuscles: [MuscleGroup.shoulders],
        difficulty: Difficulty.beginner,
        steps: [
          'Lie face down on the floor with arms at your sides',
          'With thumbs pointing up, move arms in an arc up toward your head',
          'Return to starting position in a controlled manner',
          'Repeat for desired reps'
        ],
        tips: [
          'Focus on squeezing the shoulder blades together',
          'Keep your forehead on the ground throughout the movement'
        ],
        recommendedReps: 12,
        recommendedSets: 3,
        caloriesBurned: 4,
      ),

      // Shoulder exercises
      Exercise(
        name: 'Pike Push-ups',
        description: 'Vertical push-up variation that targets the shoulders',
        primaryMuscles: [MuscleGroup.shoulders],
        secondaryMuscles: [MuscleGroup.triceps, MuscleGroup.chest],
        difficulty: Difficulty.intermediate,
        steps: [
          'Start in a downward dog position with hips high and hands shoulder-width apart',
          'Bend your elbows to lower your head toward the floor',
          'Push back up to the starting position',
          'Repeat for desired reps'
        ],
        tips: [
          'Keep your core engaged throughout the movement',
          'For more intensity, elevate your feet on a chair or step'
        ],
        recommendedReps: 8,
        recommendedSets: 3,
        caloriesBurned: 6,
      ),
      Exercise(
        name: 'Arm Circles',
        description: 'Dynamic movement to warm up shoulders and improve mobility',
        primaryMuscles: [MuscleGroup.shoulders],
        difficulty: Difficulty.beginner,
        steps: [
          'Stand with feet shoulder-width apart and arms extended to the sides',
          'Make small circular motions with arms, gradually increasing circle size',
          'Reverse direction after completing desired reps',
        ],
        tips: [
          'Keep your shoulders down and relaxed',
          'Maintain good posture throughout the movement',
        ],
        recommendedTime: 30,
        recommendedSets: 2,
        caloriesBurned: 3,
      ),

      // Biceps exercises
      Exercise(
        name: 'Chair Curls',
        description: 'Bodyweight bicep exercise using a chair for resistance',
        primaryMuscles: [MuscleGroup.biceps],
        secondaryMuscles: [MuscleGroup.forearms],
        difficulty: Difficulty.beginner,
        steps: [
          'Sit on the edge of a sturdy chair with hands gripping the edge beside your hips',
          'Slide your butt off the chair, supporting your weight with your hands',
          'Bend your elbows to lower your body toward the floor',
          'Straighten your arms to return to starting position'
        ],
        tips: [
          'Keep your back close to the chair throughout the movement',
          'Focus on using your biceps to lift your body'
        ],
        recommendedReps: 10,
        recommendedSets: 3,
        caloriesBurned: 5,
      ),
      Exercise(
        name: 'Towel Curls',
        description: 'Isometric exercise for biceps using a towel',
        primaryMuscles: [MuscleGroup.biceps],
        difficulty: Difficulty.beginner,
        steps: [
          'Hold a towel with both hands in front of you',
          'Pull outward with both hands as if trying to tear the towel',
          'Hold for the recommended time while maintaining tension',
          'Release and repeat'
        ],
        tips: [
          'Focus on contracting your biceps',
          'Breathe normally throughout the hold',
        ],
        recommendedTime: 20,
        recommendedSets: 3,
        caloriesBurned: 3,
      ),

      // Triceps exercises
      Exercise(
        name: 'Diamond Push-ups',
        description: 'Push-up variation that emphasizes the triceps',
        primaryMuscles: [MuscleGroup.triceps],
        secondaryMuscles: [MuscleGroup.chest, MuscleGroup.shoulders],
        difficulty: Difficulty.intermediate,
        steps: [
          'Start in push-up position but form a diamond shape with your hands (thumbs and index fingers touching)',
          'Lower your chest toward your hands while keeping elbows close to body',
          'Push back up to starting position',
          'Repeat for desired reps'
        ],
        tips: [
          'Keep your elbows tucked in throughout the movement',
          'For easier version, perform on knees instead of toes'
        ],
        recommendedReps: 8,
        recommendedSets: 3,
        caloriesBurned: 8,
      ),
      Exercise(
        name: 'Triceps Dips',
        description: 'Effective exercise for triceps using a chair or bench',
        primaryMuscles: [MuscleGroup.triceps],
        secondaryMuscles: [MuscleGroup.shoulders, MuscleGroup.chest],
        difficulty: Difficulty.beginner,
        steps: [
          'Sit on the edge of a sturdy chair or bench',
          'Place hands at the edge of the seat, fingers pointing forward',
          'Move your hips off the seat and lower your body by bending your elbows',
          'Push back up until arms are straight',
          'Repeat for desired reps'
        ],
        tips: [
          'Keep your back close to the chair throughout the movement',
          'For more difficulty, extend your legs further out'
        ],
        recommendedReps: 12,
        recommendedSets: 3,
        caloriesBurned: 7,
      ),

      // Leg exercises
      Exercise(
        name: 'Bodyweight Squats',
        description: 'Fundamental lower body exercise targeting multiple leg muscles',
        primaryMuscles: [MuscleGroup.legs],
        secondaryMuscles: [MuscleGroup.glutes, MuscleGroup.abs],
        difficulty: Difficulty.beginner,
        steps: [
          'Stand with feet shoulder-width apart',
          'Bend your knees and lower your hips as if sitting back into a chair',
          'Lower until thighs are parallel to the ground (or as low as comfortable)',
          'Push through your heels to return to standing position',
          'Repeat for desired reps'
        ],
        tips: [
          'Keep your chest up and back straight',
          'Ensure knees track in line with toes',
          'For balance, extend arms forward as you squat down'
        ],
        recommendedReps: 15,
        recommendedSets: 3,
        caloriesBurned: 8,
      ),
      Exercise(
        name: 'Lunges',
        description: 'Unilateral leg exercise that improves balance and strength',
        primaryMuscles: [MuscleGroup.legs],
        secondaryMuscles: [MuscleGroup.glutes],
        difficulty: Difficulty.beginner,
        steps: [
          'Stand with feet together',
          'Step forward with one foot and lower your body until both knees form 90-degree angles',
          'Push through the front heel to return to starting position',
          'Alternate legs and repeat'
        ],
        tips: [
          'Keep your torso upright throughout the movement',
          'Make sure your front knee doesn\'t extend past your toes'
        ],
        recommendedReps: 10,
        recommendedSets: 3,
        caloriesBurned: 7,
      ),
      Exercise(
        name: 'Jumping Jacks',
        description: 'Full body cardio exercise that raises heart rate',
        primaryMuscles: [MuscleGroup.legs],
        secondaryMuscles: [MuscleGroup.shoulders],
        difficulty: Difficulty.beginner,
        steps: [
          'Stand with feet together and arms at sides',
          'Jump feet out to sides while raising arms overhead',
          'Jump back to starting position',
          'Repeat at a brisk pace'
        ],
        tips: [
          'Land softly by bending your knees',
          'Maintain a consistent pace'
        ],
        recommendedTime: 60,
        recommendedSets: 3,
        caloriesBurned: 10,
      ),

      // Abs exercises
      Exercise(
        name: 'Crunches',
        description: 'Basic abdominal exercise focused on the upper abs',
        primaryMuscles: [MuscleGroup.abs],
        difficulty: Difficulty.beginner,
        steps: [
          'Lie on your back with knees bent and feet flat on the floor',
          'Place hands behind or beside your head',
          'Lift your shoulders and upper back off the floor by contracting your abs',
          'Lower back down in a controlled manner',
          'Repeat for desired reps'
        ],
        tips: [
          'Focus on using your abs, not your neck or hip flexors',
          'Exhale as you crunch up, inhale as you lower down'
        ],
        recommendedReps: 20,
        recommendedSets: 3,
        caloriesBurned: 5,
      ),
      Exercise(
        name: 'Plank',
        description: 'Isometric core exercise that builds endurance and stability',
        primaryMuscles: [MuscleGroup.abs],
        secondaryMuscles: [MuscleGroup.shoulders, MuscleGroup.back],
        difficulty: Difficulty.beginner,
        steps: [
          'Start in a push-up position but with weight on forearms instead of hands',
          'Keep body in a straight line from head to heels',
          'Hold the position while engaging your core',
        ],
        tips: [
          'Don\'t let your hips sag or pike up',
          'Breathe normally throughout the hold',
          'Look slightly forward to maintain neutral neck alignment'
        ],
        recommendedTime: 30,
        recommendedSets: 3,
        caloriesBurned: 5,
      ),
      Exercise(
        name: 'Mountain Climbers',
        description: 'Dynamic core exercise that also provides cardio benefits',
        primaryMuscles: [MuscleGroup.abs],
        secondaryMuscles: [MuscleGroup.shoulders, MuscleGroup.legs],
        difficulty: Difficulty.intermediate,
        steps: [
          'Start in a push-up position with arms straight',
          'Alternate bringing knees toward chest in a running motion',
          'Keep core engaged throughout the movement',
          'Maintain a quick pace'
        ],
        tips: [
          'Keep your hips down and aligned with shoulders',
          'Focus on controlled yet rapid movement'
        ],
        recommendedTime: 30,
        recommendedSets: 3,
        caloriesBurned: 10,
      ),
      Exercise(
        name: 'Leg Raises',
        description: 'Effective exercise targeting the lower abs',
        primaryMuscles: [MuscleGroup.abs],
        difficulty: Difficulty.intermediate,
        steps: [
          'Lie on your back with legs straight and together',
          'Place hands by your sides or under lower back for support',
          'Keeping legs straight, lift them up until perpendicular to the floor',
          'Slowly lower back down without touching the floor',
          'Repeat for desired reps'
        ],
        tips: [
          'Keep lower back pressed into the floor throughout movement',
          'For easier version, bend knees slightly'
        ],
        recommendedReps: 15,
        recommendedSets: 3,
        caloriesBurned: 6,
      ),

      // Full body exercises
      Exercise(
        name: 'Burpees',
        description: 'High-intensity exercise that works the entire body',
        primaryMuscles: [MuscleGroup.fullBody],
        difficulty: Difficulty.advanced,
        steps: [
          'Start standing, then drop into a squat position and place hands on the ground',
          'Kick feet back into a plank position',
          'Perform a push-up (optional)',
          'Return feet to squat position',
          'Jump up explosively with arms overhead',
          'Repeat in a fluid motion'
        ],
        tips: [
          'Modify by stepping back instead of jumping if needed',
          'Focus on form rather than speed initially'
        ],
        recommendedReps: 10,
        recommendedSets: 3,
        caloriesBurned: 15,
      ),
      Exercise(
        name: 'Bear Crawl',
        description: 'Functional movement that builds strength and coordination',
        primaryMuscles: [MuscleGroup.fullBody],
        difficulty: Difficulty.intermediate,
        steps: [
          'Start on all fours with hands under shoulders and knees under hips',
          'Lift knees slightly off the ground',
          'Move forward by simultaneously moving right hand with left foot, then left hand with right foot',
          'Maintain a flat back and engaged core throughout'
        ],
        tips: [
          'Keep hips low and parallel to the ground',
          'Move contralaterally (opposite arm and leg)'
        ],
        recommendedTime: 30,
        recommendedSets: 3,
        caloriesBurned: 10,
      ),
      
      // Additional exercises to round out the collection
      Exercise(
        name: 'Wall Sit',
        description: 'Isometric exercise for building leg endurance',
        primaryMuscles: [MuscleGroup.legs],
        secondaryMuscles: [MuscleGroup.glutes],
        difficulty: Difficulty.beginner,
        steps: [
          'Stand with back against a wall',
          'Slide down until thighs are parallel to the ground',
          'Maintain a 90-degree angle at knees',
          'Hold the position for recommended time'
        ],
        tips: [
          'Keep weight in heels, not toes',
          'Breathe normally throughout the hold'
        ],
        recommendedTime: 45,
        recommendedSets: 3,
        caloriesBurned: 6,
      ),
      Exercise(
        name: 'High Knees',
        description: 'Cardio exercise that strengthens hip flexors and improves coordination',
        primaryMuscles: [MuscleGroup.legs],
        secondaryMuscles: [MuscleGroup.abs],
        difficulty: Difficulty.beginner,
        steps: [
          'Stand with feet hip-width apart',
          'Run in place, bringing knees up to hip level',
          'Pump arms in a running motion',
          'Maintain a quick pace'
        ],
        tips: [
          'Focus on height of knees rather than speed',
          'Land softly on the balls of your feet'
        ],
        recommendedTime: 30,
        recommendedSets: 3,
        caloriesBurned: 10,
      ),
      Exercise(
        name: 'Glute Bridges',
        description: 'Exercise targeting the glutes and hamstrings',
        primaryMuscles: [MuscleGroup.glutes],
        secondaryMuscles: [MuscleGroup.legs],
        difficulty: Difficulty.beginner,
        steps: [
          'Lie on your back with knees bent and feet flat on the floor',
          'Lift hips toward the ceiling by squeezing glutes',
          'Hold the contraction at the top for 1-2 seconds',
          'Lower back down and repeat'
        ],
        tips: [
          'Keep core engaged throughout the movement',
          'Ensure feet are hip-width apart for stability'
        ],
        recommendedReps: 15,
        recommendedSets: 3,
        caloriesBurned: 5,
      ),
    ];
  }
  
  // Pre-defined workouts based on different goals and fitness levels
  static List<Workout> getPredefinedWorkouts(List<Exercise> exercises) {
    return [
      // Beginner workouts
      Workout(
        name: 'Quick Morning Energizer',
        description: 'A short full-body workout to kickstart your day with energy',
        type: WorkoutType.fullBody,
        difficulty: Difficulty.beginner,
        exercises: [
          WorkoutExercise(
            exercise: exercises.firstWhere((e) => e.name == 'Jumping Jacks'),
            useTime: true,
            time: 60,
          ),
          WorkoutExercise(
            exercise: exercises.firstWhere((e) => e.name == 'Bodyweight Squats'),
            reps: 10,
          ),
          WorkoutExercise(
            exercise: exercises.firstWhere((e) => e.name == 'Push-ups'),
            reps: 5,
          ),
          WorkoutExercise(
            exercise: exercises.firstWhere((e) => e.name == 'Plank'),
            useTime: true,
            time: 20,
          ),
          WorkoutExercise(
            exercise: exercises.firstWhere((e) => e.name == 'High Knees'),
            useTime: true,
            time: 30,
          ),
        ],
        estimatedDuration: 15,
        estimatedCaloriesBurn: 100,
      ),
      
      // Intermediate workouts
      Workout(
        name: 'Core Crusher',
        description: 'Strengthen your core muscles with this focused abdominal workout',
        type: WorkoutType.core,
        difficulty: Difficulty.intermediate,
        exercises: [
          WorkoutExercise(
            exercise: exercises.firstWhere((e) => e.name == 'Plank'),
            useTime: true,
            time: 45,
            sets: 3,
          ),
          WorkoutExercise(
            exercise: exercises.firstWhere((e) => e.name == 'Crunches'),
            reps: 20,
            sets: 3,
          ),
          WorkoutExercise(
            exercise: exercises.firstWhere((e) => e.name == 'Leg Raises'),
            reps: 12,
            sets: 3,
          ),
          WorkoutExercise(
            exercise: exercises.firstWhere((e) => e.name == 'Mountain Climbers'),
            useTime: true,
            time: 30,
            sets: 3,
          ),
          WorkoutExercise(
            exercise: exercises.firstWhere((e) => e.name == 'Glute Bridges'),
            reps: 15,
            sets: 3,
          ),
        ],
        estimatedDuration: 25,
        estimatedCaloriesBurn: 150,
      ),
      
      // Advanced workouts
      Workout(
        name: 'HIIT Inferno',
        description: 'High-intensity interval training to maximize calorie burn',
        type: WorkoutType.hiit,
        difficulty: Difficulty.advanced,
        exercises: [
          WorkoutExercise(
            exercise: exercises.firstWhere((e) => e.name == 'Burpees'),
            reps: 10,
            sets: 4,
          ),
          WorkoutExercise(
            exercise: exercises.firstWhere((e) => e.name == 'Mountain Climbers'),
            useTime: true,
            time: 45,
            sets: 4,
          ),
          WorkoutExercise(
            exercise: exercises.firstWhere((e) => e.name == 'High Knees'),
            useTime: true,
            time: 45,
            sets: 4,
          ),
          WorkoutExercise(
            exercise: exercises.firstWhere((e) => e.name == 'Diamond Push-ups'),
            reps: 8,
            sets: 4,
          ),
          WorkoutExercise(
            exercise: exercises.firstWhere((e) => e.name == 'Bodyweight Squats'),
            reps: 20,
            sets: 4,
          ),
          WorkoutExercise(
            exercise: exercises.firstWhere((e) => e.name == 'Bear Crawl'),
            useTime: true,
            time: 30,
            sets: 4,
          ),
        ],
        estimatedDuration: 35,
        estimatedCaloriesBurn: 350,
        restBetweenExercises: 15, // Shorter rest for HIIT
      ),
      
      Workout(
        name: 'Upper Body Blast',
        description: 'Focus on building strength in chest, back, shoulders and arms',
        type: WorkoutType.upperBody,
        difficulty: Difficulty.intermediate,
        exercises: [
          WorkoutExercise(
            exercise: exercises.firstWhere((e) => e.name == 'Push-ups'),
            reps: 12,
            sets: 3,
          ),
          WorkoutExercise(
            exercise: exercises.firstWhere((e) => e.name == 'Superman Hold'),
            useTime: true,
            time: 30,
            sets: 3,
          ),
          WorkoutExercise(
            exercise: exercises.firstWhere((e) => e.name == 'Triceps Dips'),
            reps: 10,
            sets: 3,
          ),
          WorkoutExercise(
            exercise: exercises.firstWhere((e) => e.name == 'Pike Push-ups'),
            reps: 8,
            sets: 3,
          ),
          WorkoutExercise(
            exercise: exercises.firstWhere((e) => e.name == 'Chair Curls'),
            reps: 10,
            sets: 3,
          ),
        ],
        estimatedDuration: 30,
        estimatedCaloriesBurn: 200,
      ),
      
      Workout(
        name: 'Lower Body Sculptor',
        description: 'Target your legs and glutes with this effective routine',
        type: WorkoutType.lowerBody,
        difficulty: Difficulty.intermediate,
        exercises: [
          WorkoutExercise(
            exercise: exercises.firstWhere((e) => e.name == 'Bodyweight Squats'),
            reps: 20,
            sets: 4,
          ),
          WorkoutExercise(
            exercise: exercises.firstWhere((e) => e.name == 'Lunges'),
            reps: 12,
            sets: 3,
          ),
          WorkoutExercise(
            exercise: exercises.firstWhere((e) => e.name == 'Glute Bridges'),
            reps: 15,
            sets: 3,
          ),
          WorkoutExercise(
            exercise: exercises.firstWhere((e) => e.name == 'Wall Sit'),
            useTime: true,
            time: 45,
            sets: 3,
          ),
          WorkoutExercise(
            exercise: exercises.firstWhere((e) => e.name == 'High Knees'),
            useTime: true,
            time: 30,
            sets: 3,
          ),
        ],
        estimatedDuration: 30,
        estimatedCaloriesBurn: 220,
      ),
    ];
  }
  
  // Method to generate custom workout based on user profile and preferences
  static Workout generateCustomWorkout(UserProfile profile, List<Exercise> allExercises) {
    // Filter exercises for home workouts (no equipment)
    final availableExercises = allExercises.where((e) => !e.requiresEquipment).toList();
    
    // Determine appropriate difficulty based on user's fitness level
    Difficulty workoutDifficulty;
    switch (profile.fitnessLevel) {
      case FitnessLevel.beginner:
        workoutDifficulty = Difficulty.beginner;
        break;
      case FitnessLevel.intermediate:
        workoutDifficulty = Difficulty.intermediate;
        break;
      case FitnessLevel.advanced:
        workoutDifficulty = Difficulty.advanced;
        break;
    }
    
    // Determine workout type and target muscle groups based on user's goals
    WorkoutType workoutType;
    List<MuscleGroup> targetMuscles = [];
    
    switch (profile.primaryGoal) {
      case FitnessGoal.loseWeight:
        workoutType = WorkoutType.cardio;
        targetMuscles = [MuscleGroup.fullBody];
        break;
      case FitnessGoal.gainMuscle:
        workoutType = WorkoutType.fullBody;
        targetMuscles = [MuscleGroup.chest, MuscleGroup.back, MuscleGroup.legs];
        break;
      case FitnessGoal.improveEndurance:
        workoutType = WorkoutType.hiit;
        targetMuscles = [MuscleGroup.fullBody];
        break;
      case FitnessGoal.improveFlexibility:
        workoutType = WorkoutType.custom;
        targetMuscles = [MuscleGroup.legs, MuscleGroup.back];
        break;
      case FitnessGoal.stayHealthy:
        workoutType = WorkoutType.fullBody;
        targetMuscles = [MuscleGroup.fullBody];
        break;
    }
    
    // Filter exercises based on difficulty and target muscles
    List<Exercise> suitableExercises = availableExercises.where((e) {
      // Match difficulty
      if (e.difficulty.index > workoutDifficulty.index) return false;
      
      // Match target muscles 
      if (targetMuscles.contains(MuscleGroup.fullBody)) return true;
      
      // Check if the exercise targets any of our target muscles
      for (var muscle in e.primaryMuscles) {
        if (targetMuscles.contains(muscle)) return true;
      }
      return false;
    }).toList();
    
    // Ensure we have enough exercises
    if (suitableExercises.length < 4) {
      suitableExercises = availableExercises.where((e) =>
        e.difficulty.index <= workoutDifficulty.index
      ).toList();
    }
    
    // Shuffle to randomize the selection
    suitableExercises.shuffle();
    
    // Determine workout duration and number of exercises based on user preferences
    int targetDuration = profile.workoutDuration;
    int numberOfExercises = 5; // Default
    
    if (targetDuration <= 15) {
      numberOfExercises = 4;
    } else if (targetDuration >= 45) {
      numberOfExercises = 8;
    } else {
      numberOfExercises = 5 + ((targetDuration - 20) ~/ 10);
    }
    
    // Cap number of exercises to available exercises
    numberOfExercises = numberOfExercises.clamp(4, suitableExercises.length);
    
    // Select exercises for the workout
    final selectedExercises = suitableExercises.take(numberOfExercises).toList();
    
    // Create workout exercises with appropriate parameters
    List<WorkoutExercise> workoutExercises = [];
    
    for (var exercise in selectedExercises) {
      int sets;
      int reps;
      int time;
      bool useTime;
      
      switch (workoutDifficulty) {
        case Difficulty.beginner:
          sets = 2;
          reps = exercise.recommendedReps > 0 ? exercise.recommendedReps : 8;
          time = exercise.recommendedTime > 0 ? exercise.recommendedTime : 30;
          break;
        case Difficulty.intermediate:
          sets = 3;
          reps = exercise.recommendedReps > 0 ? exercise.recommendedReps : 12;
          time = exercise.recommendedTime > 0 ? exercise.recommendedTime : 40;
          break;
        case Difficulty.advanced:
          sets = 4;
          reps = exercise.recommendedReps > 0 ? (exercise.recommendedReps * 1.2).round() : 15;
          time = exercise.recommendedTime > 0 ? (exercise.recommendedTime * 1.3).round() : 50;
          break;
      }
      
      // Determine whether to use time or reps
      useTime = exercise.recommendedTime > 0;
      
      workoutExercises.add(WorkoutExercise(
        exercise: exercise,
        sets: sets,
        reps: reps,
        time: time,
        useTime: useTime,
        restBetweenSets: workoutType == WorkoutType.hiit ? 30 : 60,
      ));
    }
    
    // Calculate estimated calories
    int estimatedCalories = 0;
    for (var workoutExercise in workoutExercises) {
      if (workoutExercise.useTime) {
        estimatedCalories += (workoutExercise.exercise.caloriesBurned * 
          workoutExercise.time * workoutExercise.sets / 60).round();
      } else {
        // Estimate time as 2 seconds per rep
        double timeInMinutes = workoutExercise.reps * 2 * workoutExercise.sets / 60;
        estimatedCalories += (workoutExercise.exercise.caloriesBurned * timeInMinutes).round();
      }
    }
    
    // Create and return the custom workout
    return Workout(
      name: _generateWorkoutName(profile, workoutType),
      description: _generateWorkoutDescription(profile),
      type: workoutType,
      difficulty: workoutDifficulty,
      exercises: workoutExercises,
      estimatedDuration: targetDuration,
      estimatedCaloriesBurn: estimatedCalories,
      isCustom: true,
      restBetweenExercises: workoutType == WorkoutType.hiit ? 15 : 30,
    );
  }
  
  // Helper method to generate workout name
  static String _generateWorkoutName(UserProfile profile, WorkoutType type) {
    // Base names by workout type
    final baseNames = {
      WorkoutType.fullBody: ['Full Body', 'Total Body', 'Complete Body'],
      WorkoutType.upperBody: ['Upper Body', 'Arms & Chest', 'Upper Strength'],
      WorkoutType.lowerBody: ['Lower Body', 'Legs & Glutes', 'Lower Power'],
      WorkoutType.core: ['Core', 'Ab', 'Midsection'],
      WorkoutType.cardio: ['Cardio', 'Heart-Pumping', 'Calorie Burn'],
      WorkoutType.hiit: ['HIIT', 'Interval', 'Intensity'],
      WorkoutType.custom: ['Custom', 'Personalized', 'Tailored'],
    };
    
    // Modifiers based on fitness goal
    final goalModifiers = {
      FitnessGoal.loseWeight: ['Fat-Burning', 'Calorie Crusher', 'Slim Down'],
      FitnessGoal.gainMuscle: ['Muscle Builder', 'Strength', 'Power'],
      FitnessGoal.improveEndurance: ['Endurance', 'Stamina', 'Conditioning'],
      FitnessGoal.improveFlexibility: ['Flexibility', 'Mobility', 'Flow'],
      FitnessGoal.stayHealthy: ['Wellness', 'Health', 'Balance'],
    };
    
    // Suffixes
    final suffixes = ['Workout', 'Challenge', 'Routine', 'Circuit', 'Session'];
    
    // Generate random parts
    final baseName = baseNames[type]![DateTime.now().millisecond % baseNames[type]!.length];
    final modifier = goalModifiers[profile.primaryGoal]![DateTime.now().second % goalModifiers[profile.primaryGoal]!.length];
    final suffix = suffixes[DateTime.now().minute % suffixes.length];
    
    // Construct name
    return '$modifier $baseName $suffix';
  }
  
  // Helper method to generate workout description
  static String _generateWorkoutDescription(UserProfile profile) {
    final introductions = [
      'A custom workout designed just for you',
      'Personalized training to help you reach your goals',
      'Specially crafted exercises to match your fitness level',
      'A tailored workout routine based on your profile'
    ];
    
    final goalDescriptions = {
      FitnessGoal.loseWeight: 'focusing on calorie burning and fat loss',
      FitnessGoal.gainMuscle: 'targeting muscle growth and strength development',
      FitnessGoal.improveEndurance: 'building stamina and cardiovascular fitness',
      FitnessGoal.improveFlexibility: 'enhancing flexibility and range of motion',
      FitnessGoal.stayHealthy: 'maintaining overall fitness and wellness',
    };
    
    final levelDescriptions = {
      FitnessLevel.beginner: 'suitable for beginners',
      FitnessLevel.intermediate: 'designed for intermediate fitness levels',
      FitnessLevel.advanced: 'challenging enough for advanced fitness enthusiasts',
    };
    
    // Select random introduction
    final intro = introductions[DateTime.now().second % introductions.length];
    
    // Construct description
    return '$intro, ${goalDescriptions[profile.primaryGoal]} and ${levelDescriptions[profile.fitnessLevel]}.';
  }
}
