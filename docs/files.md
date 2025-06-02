# Files Documentation

This document provides a comprehensive overview of all files in the FlexHero project, explaining their purpose and relationships.

## Project Structure

The FlexHero project follows a standard Flutter application structure with a custom organization for clarity:

```
flexhero/
├── lib/                           # Main source code
│   ├── main.dart                  # Application entry point
│   ├── models/                    # Data models
│   ├── providers/                 # State management
│   ├── screens/                   # UI screens
│   ├── services/                  # Business logic
│   ├── utils/                     # Utilities
│   └── widgets/                   # Reusable UI components
├── test/                          # Test files
├── android/                       # Android-specific files
├── ios/                           # iOS-specific files
├── web/                           # Web-specific files
├── linux/                         # Linux-specific files
├── macos/                         # macOS-specific files
├── windows/                       # Windows-specific files
└── pubspec.yaml                   # Flutter dependencies
```

## Core Files

### Main Entry Point

#### `lib/main.dart`

The entry point of the application that initializes the app and sets up the theme and provider.

```dart
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => FlexHeroProvider()),
      ],
      child: MaterialApp(
        title: 'FlexHero',
        // Theme setup and home screen
      ),
    );
  }
}
```

### Models

#### `lib/models/exercise.dart`

Defines the `Exercise` class and related enums (`MuscleGroup`, `Difficulty`).

- `Exercise`: Represents a workout exercise with properties for muscle targets, difficulty, instructions, etc.
- `MuscleGroup`: Enum for different muscle groups (chest, back, legs, etc.)
- `Difficulty`: Enum for exercise difficulty levels (beginner, intermediate, advanced)

#### `lib/models/workout.dart`

Defines the `Workout` class and related enums.

- `Workout`: Represents a complete workout with exercises, duration, difficulty, etc.
- `WorkoutExercise`: Represents an exercise within a workout (with sets, reps, etc.)
- `WorkoutType`: Enum for different workout types (fullBody, upperBody, etc.)

#### `lib/models/user_profile.dart`

Defines the `UserProfile` class and related enums.

- `UserProfile`: Stores user information, preferences, and history
- `FitnessLevel`: Enum for user fitness levels
- `FitnessGoal`: Enum for fitness goals (loseWeight, gainMuscle, etc.)

### Providers

#### `lib/providers/flex_hero_provider.dart`

Implements the state management using Provider pattern.

- `FlexHeroProvider`: Main state manager that connects UI with services
  - Handles user profile management
  - Workout generation and access
  - Loading states
  - Custom workout creation
  - History tracking

### Services

#### `lib/services/exercise_database.dart`

Contains the exercise database and workout generation logic.

- `ExerciseDatabase`: Static class providing:
  - Comprehensive list of home exercises
  - Predefined workout templates
  - Custom workout generation algorithm
  - Exercise filtering and selection logic

#### `lib/services/workout_service.dart`

Handles workout-related operations and storage.

- `WorkoutService`: Service class for:
  - User profile persistence
  - Workout history management
  - Custom workout saving/loading
  - Exercise and workout data access

### Screens

#### `lib/screens/splash_screen.dart`

Initial screen shown while the app loads.

- Displays app logo and loading animation
- Checks for user profile existence
- Navigates to appropriate screen

#### `lib/screens/onboarding_screen.dart`

Multi-step form for creating or editing user profile.

- Collects user information through multiple pages
- Handles validation and profile creation/editing
- Uses PageView for step navigation

#### `lib/screens/home_screen.dart`

Main container screen with bottom navigation.

- Hosts four main tabs (Dashboard, Workouts, Exercises, Profile)
- Manages bottom navigation
- Contains implementation of DashboardPage and WorkoutsPage

#### `lib/screens/exercise_library_screen.dart`

Browse and search all exercises.

- Search and filter functionality
- Exercise listing
- Exercise detail view

#### `lib/screens/profile_screen.dart`

View and edit user profile information.

- Displays user stats and metrics
- Shows workout history
- Provides edit profile option
- Shows body metrics visualization

#### `lib/screens/workout_detail_screen.dart`

Shows workout details and execution screen.

- Workout information display
- Exercise listing for the workout
- Workout execution with timer/counter
- Completion tracking

### Utils

#### `lib/utils/app_utils.dart`

Contains app-wide utilities, constants, and helper functions.

- `AppColors`: Color palette for the app
- `AppConstants`: Common constants (padding, border radius, etc.)
- `AppUtils`: Helper methods for formatting, conversions, and utility functions

#### `lib/utils/navigation_service.dart`

Provides navigation utilities and standardized navigation patterns.

- Navigation helper methods
- Dialog display utilities
- Exercise detail navigation

### Widgets

#### `lib/widgets/common_widgets.dart`

Reusable UI components used throughout the app.

- `CustomAppBar`: Standardized app bar
- `CustomButton`: Button with various styles
- `CustomCard`: Card container with consistent styling
- `CustomTextField`: Text input with standardized styling
- `LoadingIndicator`: Loading animation with message
- `MuscleGroupChip`: Tag for displaying muscle groups
- `WorkoutTypeChip`: Tag for workout types
- `DifficultyBadge`: Visual indicator of difficulty level
- `SectionHeader`: Section title with optional subtitle
- `EmptyStateWidget`: Display for empty lists or screens

#### `lib/widgets/workout_widgets.dart`

Specialized widgets for workout-related UI.

- `WorkoutCard`: Displays workout summary in a card
- `ExerciseCard`: Displays exercise summary in a card
- `WorkoutExerciseItem`: List item for workout exercises
- `ExerciseDetailView`: Detailed view of an exercise

## Configuration Files

### `pubspec.yaml`

Defines project dependencies and assets.

```yaml
dependencies:
  flutter:
    sdk: flutter
  provider: ^6.1.5
  shared_preferences: ^2.2.0
  uuid: ^4.0.0
  path_provider: ^2.1.0
  flutter_svg: ^2.0.5
  http: ^1.1.0
```

### `analysis_options.yaml`

Configures the Dart analyzer with linting rules.

## Platform-specific Folders

- `android/`: Android platform code and configuration
- `ios/`: iOS platform code and configuration
- `web/`: Web platform files
- `linux/`, `macos/`, `windows/`: Desktop platform files

## Test Files

### `test/widget_test.dart`

Contains widget tests for the app.

## Directory Relationships

The files in FlexHero are interconnected following these patterns:

1. **Screens** use:
   - Providers for state access
   - Widgets for UI components
   - Utils for helper functions

2. **Providers** use:
   - Services for business logic
   - Models for data structures

3. **Services** use:
   - Models for data structures
   - Other services for specialized functionality

4. **Widgets** use:
   - Models for displaying data
   - Utils for formatting and constants

This organized structure ensures good separation of concerns and makes the codebase maintainable and extensible.
