# Flutter Application Architecture

This document explains the architecture and data flow of the FlexHero application.

## Architecture Overview

FlexHero follows a modified Provider pattern architecture with clear separation of concerns:

![Architecture Diagram](https://via.placeholder.com/800x400?text=FlexHero+Architecture+Diagram)

The app is structured into the following main components:

1. **UI Layer (Screens & Widgets)**
2. **State Management (Providers)**
3. **Business Logic (Services)**
4. **Data Layer (Models)**

## Data Flow

The data flow in FlexHero follows this pattern:

1. User interactions in the UI trigger actions in the Provider
2. The Provider delegates business logic to Services
3. Services perform operations and return data
4. The Provider updates its state
5. UI automatically rebuilds with the new data

## Key Components

### Models

Models represent the core data structures used throughout the application:

- **Exercise**: Defines workout exercises with properties for muscle groups, difficulty, instructions
- **UserProfile**: Stores user data including fitness level, goals, body metrics
- **Workout**: Represents a complete workout with multiple exercises

```dart
// Example of UserProfile Model
class UserProfile {
  final String id;
  final String name;
  final int age;
  final double weight;
  final double height;
  final bool isMale;
  final FitnessLevel fitnessLevel;
  final FitnessGoal primaryGoal;
  final List<FitnessGoal> secondaryGoals;
  final List<String> completedWorkoutIds;
  // ...
}
```

### Providers

The app uses Provider for state management:

- **FlexHeroProvider**: Central state manager that coordinates between UI and Services

```dart
class FlexHeroProvider with ChangeNotifier {
  // Dependencies
  final WorkoutService _workoutService = WorkoutService();
  
  // State variables
  UserProfile? _userProfile;
  List<Workout>? _customWorkouts;
  List<Workout> _predefinedWorkouts = [];
  Workout? _currentWorkout;
  bool _isLoading = false;

  // Methods to update state and notify listeners
  Future<void> updateUserProfile(UserProfile profile) async {
    // Implementation
    notifyListeners();
  }
  
  Future<Workout?> generateWorkoutForUser() async {
    // Generate workout based on user profile
    notifyListeners();
  }
}
```

### Services

Services handle business logic and data operations:

- **WorkoutService**: Manages workout generation, user profiles, and history
- **ExerciseDatabase**: Provides the exercise database and workout generation logic

```dart
class WorkoutService {
  // Constants
  static const String _userProfileKey = 'user_profile';
  
  // Data
  late List<Exercise> _exercises;
  late List<Workout> _predefinedWorkouts;
  
  // Methods
  Future<void> saveUserProfile(UserProfile profile) async {
    // Save profile to local storage
  }
  
  Future<UserProfile?> getUserProfile() async {
    // Load profile from local storage
  }
  
  Workout generateWorkoutForUser(UserProfile profile) {
    // Delegate to ExerciseDatabase
    return ExerciseDatabase.generateCustomWorkout(profile, _exercises);
  }
}
```

### UI Components

UI is divided into screens and reusable widgets:

- **Screens**: Full pages like HomeScreen, WorkoutDetailScreen
- **Widgets**: Reusable components like WorkoutCard, ExerciseCard

## State Management

The app uses Provider pattern for state management:

1. The `FlexHeroProvider` class extends `ChangeNotifier`
2. UI components access the provider using `Provider.of<FlexHeroProvider>(context)`
3. When state changes, the provider calls `notifyListeners()` to rebuild the UI

## Data Persistence

Data is persisted locally using `SharedPreferences`:

- User profile
- Workout history
- Custom workouts

```dart
// Example of data persistence
Future<void> saveUserProfile(UserProfile profile) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString(_userProfileKey, jsonEncode(profile.toJson()));
}

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
```

## Navigation

The app uses Flutter's standard navigation system with `Navigator` for moving between screens:

```dart
// Example of navigation
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => WorkoutDetailScreen(workout: workout),
  ),
);
```

For complex navigation scenarios, the app uses a `NavigationService`:

```dart
NavigationService.navigateToExerciseDetail(context, exerciseId);
```

## Dependency Flow

The dependency flow in the app follows this pattern:

1. **Screens** depend on **Providers** and **Widgets**
2. **Providers** depend on **Services**
3. **Services** depend on **Models**
4. **Widgets** depend on **Models**

This ensures a clean separation of concerns and makes the code more maintainable.

## Error Handling

The app implements error handling at various levels:

- **UI Level**: Display friendly error messages to users
- **Provider Level**: Catch and log errors, update state accordingly
- **Service Level**: Handle and propagate errors with proper context

## Theming and Styling

The app uses a consistent design system defined in `app_utils.dart`:

```dart
class AppColors {
  static const primary = Color(0xFF4A90E2);
  static const secondary = Color(0xFF58C0EB);
  static const accent = Color(0xFFFF7D54);
  // ...
}

class AppConstants {
  static const double defaultPadding = 16.0;
  static const double defaultBorderRadius = 12.0;
  // ...
}
```

## Application Lifecycle

The application lifecycle follows this pattern:

1. **Initialization**: Load dependencies and user data in `FlexHeroProvider`
2. **Splash Screen**: Display while data is loading
3. **Onboarding or Home**: Navigate to onboarding if no user profile, otherwise home
4. **Normal Usage**: User interacts with the app, state is updated and persisted
5. **Background/Foreground**: App state is preserved when app goes to background

## Performance Considerations

The app implements several performance optimizations:

- Lazy loading of data
- Efficient widget rebuilding with Provider
- Caching of workout data
- Optimized list rendering with ListView.builder

This architecture ensures that FlexHero is maintainable, scalable, and performs well even as features are added.
