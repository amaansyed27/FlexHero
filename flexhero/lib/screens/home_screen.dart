import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/exercise.dart';
import '../models/workout.dart';
import '../models/workout_filter.dart';
import '../providers/flex_hero_provider.dart';
import '../utils/app_utils.dart';
import '../utils/animation_helper.dart';
import '../widgets/common_widgets.dart';
import '../widgets/workout_widgets.dart';
import 'workout_detail_screen.dart';
import 'exercise_library_screen.dart';
import 'profile_screen.dart';
import 'tutorial_screen.dart';
import 'workout_builder_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  final List<Widget> _screens = [
    const DashboardPage(),
    const WorkoutsPage(),
    const ExerciseLibraryScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: AnimationHelper.fadeIn(
        duration: const Duration(milliseconds: 200),
        child: _screens[_selectedIndex],
      ),
      floatingActionButton: AnimationHelper.scale(
        child: FloatingActionButton(
          onPressed: _showHelp,
          backgroundColor: AppColors.primary,
          child: const Icon(
            Icons.help_outline,
            color: Colors.white,
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textLight,
        showUnselectedLabels: true,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.fitness_center),
            label: 'Workouts',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.accessibility_new),
            label: 'Exercises',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
  
  void _showHelp() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const TutorialScreen(showInitialOverlay: false)),
    );
  }
}

class DashboardPage extends StatelessWidget {
  // ignore: use_super_parameters
  const DashboardPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<FlexHeroProvider>(context);
    final userProfile = provider.userProfile;

    if (userProfile == null) {
      return const LoadingIndicator(message: 'Loading dashboard...');
    }

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        children: [
          // User greeting
          Row(
            children: [
              Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                  // ignore: deprecated_member_use
                  color: AppColors.primary.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    userProfile.name.isNotEmpty
                        ? userProfile.name[0].toUpperCase()
                        : '?',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Hi, ${userProfile.name}',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textDark,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Let\'s get moving today!',
                      style: TextStyle(
                        fontSize: 16,
                        color: AppColors.textLight,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Quick stats
          Row(
            children: [
              _buildStatCard(
                Icons.local_fire_department,
                userProfile.completedWorkoutIds.length.toString(),
                'Workouts',
                AppColors.primary,
              ),
              const SizedBox(width: 16),
              _buildStatCard(
                Icons.trending_up,
                AppUtils.fitnessLevelToString(userProfile.fitnessLevel),
                'Level',
                AppColors.secondary,
              ),
              const SizedBox(width: 16),
              _buildStatCard(
                Icons.calendar_today,
                userProfile.weeklyWorkoutTarget.toString(),
                'Weekly Goal',
                AppColors.accent,
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Suggested workout
          const SectionHeader(
            title: 'Suggested Workout',
            subtitle: 'Personalized just for you',
          ),
          const SizedBox(height: 8),
          _buildSuggestedWorkout(context),
          const SizedBox(height: 32),

          // Browse by categories
          const SectionHeader(
            title: 'Browse Workouts',
            subtitle: 'Find the perfect workout for you',
          ),
          const SizedBox(height: 16),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: WorkoutType.values.map((type) {
                return Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: GestureDetector(
                    onTap: () {
                      // Navigate to workouts tab with filter
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => FilteredWorkoutsPage(
                            workoutType: type,
                          ),
                        ),
                      );
                    },
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            // ignore: deprecated_member_use
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            AppUtils.getWorkoutTypeIcon(type),
                            size: 32,
                            color: AppColors.primary,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            AppUtils.workoutTypeToString(type),
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: AppColors.textDark,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),

          const SizedBox(height: 32),
          // Target muscle groups
          const SectionHeader(
            title: 'Target Muscle Groups',
            subtitle: 'Focus on specific areas',
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: MuscleGroup.values.map((muscle) {
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => FilteredExercisesPage(
                        muscleGroup: muscle,
                      ),
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: AppColors.lightGrey,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        AppUtils.getMuscleGroupIcon(muscle),
                        size: 18,
                        color: AppColors.textLight,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        AppUtils.muscleGroupToString(muscle),
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppColors.textDark,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    IconData icon,
    String value,
    String label,
    Color color,
  ) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              // ignore: deprecated_member_use
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 28,
              color: color,
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textLight,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSuggestedWorkout(BuildContext context) {
    return Consumer<FlexHeroProvider>(
      builder: (context, provider, _) {
        if (provider.isLoading) {
          return const LoadingIndicator(message: 'Generating workout...');
        }

        final userProfile = provider.userProfile;
        if (userProfile == null) {
          return const SizedBox();
        }

        return FutureBuilder(
          future: provider.currentWorkout != null
              ? Future.value(provider.currentWorkout)
              : provider.generateWorkoutForUser(),
          builder: (context, AsyncSnapshot<Workout?> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const LoadingIndicator(message: 'Generating workout...');
            }

            if (snapshot.hasError || !snapshot.hasData || snapshot.data == null) {
              return CustomCard(
                // ignore: deprecated_member_use
                backgroundColor: AppColors.lightGrey.withOpacity(0.3),
                child: Column(
                  children: [
                    const Text(
                      'Failed to generate workout',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textDark,
                      ),
                    ),
                    const SizedBox(height: 16),
                    CustomButton(
                      text: 'Try Again',
                      onPressed: () {
                        provider.generateWorkoutForUser();
                      },
                      icon: Icons.refresh,
                    ),
                  ],
                ),
              );
            }

            final workout = snapshot.data!;
            return WorkoutCard(
              workout: workout,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => WorkoutDetailScreen(workout: workout),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}

class WorkoutsPage extends StatelessWidget {
  const WorkoutsPage({super.key});
  
  void _navigateToWorkoutBuilder(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const WorkoutBuilderScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<FlexHeroProvider>(context);
    final predefinedWorkouts = provider.predefinedWorkouts;
    final customWorkouts = provider.customWorkouts;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(
        title: 'Workouts',
        showBackButton: false,
      ),
      floatingActionButton: AnimationHelper.scale(
        child: FloatingActionButton(
          onPressed: () => _navigateToWorkoutBuilder(context),
          backgroundColor: AppColors.primary,
          child: const Icon(Icons.add),
        ),
      ),
      body: provider.isLoading
          ? const LoadingIndicator(message: 'Loading workouts...')
          : ListView(
              padding: const EdgeInsets.all(AppConstants.defaultPadding),
              children: [                // Create custom workout card
                AnimationHelper.fadeIn(
                  child: Card(
                    color: AppColors.primary.withOpacity(0.15),
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: InkWell(
                      onTap: () => _navigateToWorkoutBuilder(context),
                      borderRadius: BorderRadius.circular(12),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            Container(
                              width: 60,
                              height: 60,
                              decoration: const BoxDecoration(
                                color: AppColors.primary,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.fitness_center,
                                color: Colors.white,
                                size: 30,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Create Custom Workout',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.textDark,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Design a workout tailored to your specific goals',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: AppColors.textLight,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Icon(
                              Icons.arrow_forward_ios,
                              color: AppColors.primary,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                
                // Custom workouts section
                if (customWorkouts.isNotEmpty) ...[
                  const SectionHeader(
                    title: 'My Custom Workouts',
                    subtitle: 'Workouts you\'ve created or saved',
                  ),
                  const SizedBox(height: 16),
                  AnimationHelper.slideIn(
                    direction: SlideDirection.fromRight,
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: customWorkouts.length,
                      itemBuilder: (context, index) {
                        final workout = customWorkouts[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: WorkoutCard(
                            workout: workout,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      WorkoutDetailScreen(workout: workout),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 24),
                ],

                // Filter chips for workout types
                const Text(
                  'Filter by Difficulty',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 8),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: Difficulty.values.map((difficulty) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: FilterChip(
                          label: Text(AppUtils.difficultyToString(difficulty)),
                          selected: false,
                          onSelected: (selected) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => FilteredWorkoutsPage(
                                  difficulty: difficulty,
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 16),

                const Text(
                  'Filter by Type',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 8),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: WorkoutType.values.map((type) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: FilterChip(
                          label: Text(AppUtils.workoutTypeToString(type)),
                          selected: false,
                          onSelected: (selected) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => FilteredWorkoutsPage(
                                  workoutType: type,
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 24),

                // Predefined workouts
                const SectionHeader(
                  title: 'Predefined Workouts',
                  subtitle: 'Ready to go workouts for you',
                ),
                const SizedBox(height: 16),
                if (predefinedWorkouts.isEmpty)
                  const EmptyStateWidget(
                    message: 'No predefined workouts available.',
                    icon: Icons.fitness_center,
                  )
                else
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: predefinedWorkouts.length,
                    itemBuilder: (context, index) {
                      final workout = predefinedWorkouts[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: WorkoutCard(
                          workout: workout,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    WorkoutDetailScreen(workout: workout),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                const SizedBox(height: 24),

                // Generate custom workout button
                CustomCard(
                  // ignore: deprecated_member_use
                  backgroundColor: AppColors.primary.withOpacity(0.05),
                  child: Column(
                    children: [
                      const Text(
                        'Need a custom workout?',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textDark,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Generate a workout based on your profile and preferences.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.textLight,
                        ),
                      ),
                      const SizedBox(height: 16),
                      CustomButton(
                        text: 'Generate Workout',
                        onPressed: () async {
                          final workout = await provider.generateWorkoutForUser();
                          if (workout != null && context.mounted) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    WorkoutDetailScreen(workout: workout),
                              ),
                            );
                          }
                        },
                        icon: Icons.fitness_center,
                        isLoading: provider.isLoading,
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}

class FilteredWorkoutsPage extends StatelessWidget {
  final WorkoutType? workoutType;
  final Difficulty? difficulty;

  // ignore: use_super_parameters
  const FilteredWorkoutsPage({
    Key? key,
    this.workoutType,
    this.difficulty,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<FlexHeroProvider>(context);
    final allWorkouts = [...provider.predefinedWorkouts, ...provider.customWorkouts];
    
    // Apply filters
    final filteredWorkouts = allWorkouts.where((workout) {
      if (workoutType != null && workout.type != workoutType) {
        return false;
      }
      if (difficulty != null && workout.difficulty != difficulty) {
        return false;
      }
      return true;
    }).toList();

    String title = 'Workouts';
    if (workoutType != null) {
      title = '${AppUtils.workoutTypeToString(workoutType!)} Workouts';
    } else if (difficulty != null) {
      title = '${AppUtils.difficultyToString(difficulty!)} Workouts';
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(title: title),
      body: provider.isLoading
          ? const LoadingIndicator(message: 'Loading workouts...')
          : filteredWorkouts.isEmpty
              ? EmptyStateWidget(
                  message: 'No ${title.toLowerCase()} found.',
                  icon: Icons.fitness_center,
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(AppConstants.defaultPadding),
                  itemCount: filteredWorkouts.length,
                  itemBuilder: (context, index) {
                    final workout = filteredWorkouts[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: WorkoutCard(
                        workout: workout,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  WorkoutDetailScreen(workout: workout),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
    );
  }
}

class FilteredExercisesPage extends StatelessWidget {
  final MuscleGroup muscleGroup;

  const FilteredExercisesPage({
    super.key,
    required this.muscleGroup,
  });

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<FlexHeroProvider>(context);
    final allExercises = provider.workoutService.allExercises;
    
    // Apply filter
    final filteredExercises = allExercises.where((exercise) {
      return exercise.primaryMuscles.contains(muscleGroup) || 
              exercise.secondaryMuscles.contains(muscleGroup);
    }).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(
        title: '${AppUtils.muscleGroupToString(muscleGroup)} Exercises',
      ),
      body: filteredExercises.isEmpty
          ? EmptyStateWidget(
              message: 'No ${AppUtils.muscleGroupToString(muscleGroup).toLowerCase()} exercises found.',
              icon: Icons.fitness_center,
            )
          : ListView.builder(
              padding: const EdgeInsets.all(AppConstants.defaultPadding),
              itemCount: filteredExercises.length,
              itemBuilder: (context, index) {
                final exercise = filteredExercises[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: ExerciseCard(
                    exercise: exercise,
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.white,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(20),
                          ),
                        ),
                        builder: (_) => DraggableScrollableSheet(
                          initialChildSize: 0.7,
                          maxChildSize: 0.9,
                          minChildSize: 0.5,
                          expand: false,
                          builder: (_, scrollController) {
                            return SingleChildScrollView(
                              controller: scrollController,
                              padding: const EdgeInsets.all(20),
                              child: ExerciseDetailView(exercise: exercise),
                            );
                          },
                        ),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}
