# Screen Documentation

This document provides a detailed overview of all the screens in the FlexHero application.

## Screen Flow

The application follows this general screen flow:

```
SplashScreen -> OnboardingScreen (if first time) -> HomeScreen
                                                  └── Dashboard
                                                  └── WorkoutsPage
                                                  └── ExerciseLibraryScreen
                                                  └── ProfileScreen
```

## Screens

### 1. SplashScreen

**Purpose**: Display the app logo and loading animation while initializing data

**Components**:
- App logo and title
- Loading indicator
- Animated background

**Implementation**:
```dart
class SplashScreen extends StatefulWidget {
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}
```

**Interactions**:
- Automatically navigates to OnboardingScreen or HomeScreen after initialization
- Checks if user profile exists to determine navigation

**Screenshot**:
![SplashScreen](https://via.placeholder.com/300x600?text=SplashScreen)

### 2. OnboardingScreen

**Purpose**: Collect user information and preferences to create a personalized profile

**Components**:
- Multi-page form with PageView
- Progress indicator
- Input fields for user data
- Custom selection UI for fitness levels and goals

**Implementation**:
```dart
class OnboardingScreen extends StatefulWidget {
  final bool isEditing;
  
  const OnboardingScreen({
    Key? key, 
    this.isEditing = false,
  }) : super(key: key);
}
```

**Pages**:
1. **Name Page**: Collects user name
2. **Body Info Page**: Collects gender, age, height, weight
3. **Fitness Level Page**: Determines user's current fitness level
4. **Fitness Goals Page**: Sets primary and secondary fitness goals
5. **Workout Preferences Page**: Sets weekly targets and duration preferences

**Interactions**:
- Next/Previous navigation between pages
- Input validation
- Profile creation on completion
- Special handling for editing mode

**Screenshot**:
![OnboardingScreen](https://via.placeholder.com/300x600?text=OnboardingScreen)

### 3. HomeScreen

**Purpose**: Main container screen with bottom navigation

**Components**:
- Bottom navigation bar with 4 tabs
- Container for sub-screens

**Implementation**:
```dart
class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}
```

**Tabs**:
1. Dashboard
2. Workouts
3. Exercises
4. Profile

**Interactions**:
- Tab switching
- Maintaining tab state

**Screenshot**:
![HomeScreen](https://via.placeholder.com/300x600?text=HomeScreen)

### 4. DashboardPage

**Purpose**: Show user overview and suggested workout

**Components**:
- User greeting and profile summary
- Quick stats (completed workouts, fitness level, weekly goal)
- Suggested workout card
- Categories for browsing workouts
- Target muscle groups selection

**Implementation**:
```dart
class DashboardPage extends StatelessWidget {
  const DashboardPage({Key? key}) : super(key: key);
}
```

**Interactions**:
- Navigate to workout details
- Browse categories
- Select muscle groups
- Generate custom workout

**Screenshot**:
![DashboardPage](https://via.placeholder.com/300x600?text=DashboardPage)

### 5. WorkoutsPage

**Purpose**: Browse and filter all available workouts

**Components**:
- Filter options for difficulty and workout type
- List of predefined workouts
- List of custom workouts
- Generate workout button

**Implementation**:
```dart
class WorkoutsPage extends StatelessWidget {
  const WorkoutsPage({Key? key}) : super(key: key);
}
```

**Interactions**:
- Filter workouts
- Navigate to workout details
- Generate custom workout

**Screenshot**:
![WorkoutsPage](https://via.placeholder.com/300x600?text=WorkoutsPage)

### 6. ExerciseLibraryScreen

**Purpose**: Browse and search all available exercises

**Components**:
- Search bar
- Filter dropdowns for muscle group and difficulty
- List of exercises with details
- Empty state for no results

**Implementation**:
```dart
class ExerciseLibraryScreen extends StatefulWidget {
  @override
  State<ExerciseLibraryScreen> createState() => _ExerciseLibraryScreenState();
}
```

**Interactions**:
- Search exercises
- Filter by muscle group and difficulty
- View exercise details

**Screenshot**:
![ExerciseLibraryScreen](https://via.placeholder.com/300x600?text=ExerciseLibraryScreen)

### 7. ProfileScreen

**Purpose**: Display and edit user information and stats

**Components**:
- Profile header with user info
- Body metrics section
- Workout stats
- Edit profile button
- Workout history button

**Implementation**:
```dart
class ProfileScreen extends StatefulWidget {
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}
```

**Interactions**:
- Edit profile (navigates to OnboardingScreen in edit mode)
- View workout history
- See body metrics and stats

**Screenshot**:
![ProfileScreen](https://via.placeholder.com/300x600?text=ProfileScreen)

### 8. WorkoutDetailScreen

**Purpose**: Show details of a specific workout and allow starting it

**Components**:
- Workout header with name, description
- Workout stats (duration, exercises, difficulty)
- List of exercises in the workout
- Target muscle groups
- Start workout button

**Implementation**:
```dart
class WorkoutDetailScreen extends StatelessWidget {
  final Workout workout;
  
  const WorkoutDetailScreen({
    Key? key,
    required this.workout,
  }) : super(key: key);
}
```

**Interactions**:
- View exercise details
- Start workout
- See workout information

**Screenshot**:
![WorkoutDetailScreen](https://via.placeholder.com/300x600?text=WorkoutDetailScreen)

### 9. WorkoutSessionScreen

**Purpose**: Guide user through workout execution

**Components**:
- Progress indicator
- Current exercise display
- Timer or rep counter
- Next/Previous controls
- Pause/Resume controls
- Completion screen

**Implementation**:
```dart
class WorkoutSessionScreen extends StatefulWidget {
  final Workout workout;
  
  const WorkoutSessionScreen({
    Key? key,
    required this.workout,
  }) : super(key: key);
}
```

**States**:
1. **Exercise**: Showing current exercise with timer/reps
2. **Rest**: Rest period between exercises
3. **Completed**: Workout summary and stats

**Interactions**:
- Timer management
- Exercise navigation
- Pause/Resume workout
- Complete workout

**Screenshot**:
![WorkoutSessionScreen](https://via.placeholder.com/300x600?text=WorkoutSessionScreen)

### 10. FilteredWorkoutsPage & FilteredExercisesPage

**Purpose**: Display filtered workouts or exercises

**Components**:
- List of filtered items
- Filter indicator in header
- Empty state for no results

**Implementation**:
```dart
class FilteredWorkoutsPage extends StatelessWidget {
  final WorkoutType? workoutType;
  final Difficulty? difficulty;
  
  const FilteredWorkoutsPage({
    Key? key,
    this.workoutType,
    this.difficulty,
  }) : super(key: key);
}

class FilteredExercisesPage extends StatelessWidget {
  final MuscleGroup muscleGroup;
  
  const FilteredExercisesPage({
    Key? key,
    required this.muscleGroup,
  }) : super(key: key);
}
```

**Interactions**:
- View details of items
- Apply additional filters

**Screenshot**:
![FilteredPages](https://via.placeholder.com/300x600?text=FilteredPages)

### 11. WorkoutBuilderScreen

**Purpose**: Create customized workouts based on user-defined criteria

**Components**:
- Duration selector (10-60 minutes)
- Difficulty selector (Beginner, Intermediate, Advanced)
- Target muscle groups selector
- Workout goal selector (health maintenance, weight loss, endurance)
- Advanced options for equipment-free workouts, balanced muscle targeting, intensity level

**Implementation**:
```dart
class WorkoutBuilderScreen extends StatefulWidget {
  final WorkoutFilter? initialFilter;
  
  const WorkoutBuilderScreen({
    Key? key,
    this.initialFilter,
  }) : super(key: key);

  @override
  State<WorkoutBuilderScreen> createState() => _WorkoutBuilderScreenState();
}
```

**Interactions**:
- Select filter options
- Generate workout based on filters
- Preview workout with exercise list
- See estimated duration and calories burned
- Start the workout immediately
- Edit the workout parameters to generate a new one

The generated workouts are automatically saved to the user's custom workouts collection.

**Screenshot**:
![WorkoutBuilderScreen](https://via.placeholder.com/300x600?text=WorkoutBuilderScreen)

## Modal Sheets

### 1. Exercise Detail View

**Purpose**: Show detailed information about an exercise

**Components**:
- Exercise name and description
- Muscle groups targeted
- Difficulty indicator
- Step-by-step instructions
- Tips for proper form

**Implementation**:
```dart
class ExerciseDetailView extends StatelessWidget {
  final Exercise exercise;
  
  const ExerciseDetailView({
    Key? key,
    required this.exercise,
  }) : super(key: key);
}
```

**Interactions**:
- Scroll through details

### 2. Workout History View

**Purpose**: Display list of completed workouts

**Components**:
- List of workout history items
- Date, duration, and calories for each workout

**Implementation**: Shows as a modal bottom sheet from the ProfileScreen

**Interactions**:
- Scroll through history

## Common Interaction Patterns

1. **Navigation**: Standard push/pop navigation with MaterialPageRoute
2. **Lists**: ListView.builder for efficient list rendering
3. **Detail Views**: Modal bottom sheets for showing details
4. **Forms**: Custom form components with validation
5. **Loading States**: LoadingIndicator widget for async operations
6. **Empty States**: EmptyStateWidget for no data scenarios

This document provides a comprehensive overview of the screen structure in the FlexHero application.

## Animation Enhancements

The app uses custom animations to create a more engaging user experience:

- Fade-in animations for page transitions
- Slide-in animations for list items
- Scale animations for interactive elements
- Staggered animations for multiple items appearing in sequence

The `AnimationHelper` class provides reusable animation components:

```dart
class AnimationHelper {
  static Widget fadeIn({
    required Widget child,
    Duration duration = const Duration(milliseconds: 300),
    Curve curve = Curves.easeIn,
    bool animate = true,
  }) {
    // Implementation...
  }
  
  static Widget slideIn({
    required Widget child,
    SlideDirection direction = SlideDirection.fromBottom,
    // More parameters...
  }) {
    // Implementation...
  }
  
  // More animation methods...
}
```

## Help & Tutorial Screens

The app includes tutorial screens to help users navigate and understand the application:

1. `TutorialScreen`: A multi-page onboarding tutorial that introduces users to the main features
2. `TutorialOverlay`: Contextual help overlays that highlight specific features in the app
