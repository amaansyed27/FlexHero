import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/exercise.dart';
import '../models/user_profile.dart';
import '../models/workout.dart';
import '../models/workout_filter.dart';
import '../providers/flex_hero_provider.dart';
import '../utils/app_utils.dart';
import '../utils/animation_helper.dart';
import '../widgets/common_widgets.dart';
import 'workout_detail_screen.dart';

class WorkoutBuilderScreen extends StatefulWidget {
  final WorkoutFilter? initialFilter;
  
  const WorkoutBuilderScreen({
    Key? key,
    this.initialFilter,
  }) : super(key: key);

  @override
  State<WorkoutBuilderScreen> createState() => _WorkoutBuilderScreenState();
}

class _WorkoutBuilderScreenState extends State<WorkoutBuilderScreen> {
  late WorkoutFilter _filter;
  bool _isLoading = false;
  Workout? _generatedWorkout;
  
  // Muscle group selection
  final List<MuscleGroup> _selectedMuscleGroups = [];
  
  // UI control
  final _formKey = GlobalKey<FormState>();
  
  @override
  void initState() {
    super.initState();
    
    // Initialize filter from provided initial filter or create a default one
    _filter = widget.initialFilter ?? 
        WorkoutFilter(
          durationMinutes: 30,
          difficulty: Difficulty.intermediate,
          bodyweightOnly: true,
          balancedWorkout: true,
        );
        
    // Initialize selected muscle groups
    _selectedMuscleGroups.addAll(_filter.targetMuscleGroups);
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(
        title: 'Create Custom Workout',
        showBackButton: true,
      ),
      body: _generatedWorkout != null
          ? _buildWorkoutPreview()
          : _buildFilterForm(),
      floatingActionButton: _generatedWorkout == null
          ? FloatingActionButton(
              onPressed: _generateWorkout,
              backgroundColor: AppColors.primary,
              child: const Icon(Icons.fitness_center),
            )
          : FloatingActionButton(
              onPressed: _resetBuilder,
              backgroundColor: AppColors.secondary,
              child: const Icon(Icons.refresh),
            ),
    );
  }
  
  Widget _buildFilterForm() {
    return Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        children: AnimationHelper.createStaggeredList(
          context: context,
          items: [
            _buildDurationSection(),
            _buildDifficultySection(),
            _buildMuscleGroupsSection(),
            _buildGoalSection(),
            _buildAdvancedOptionsSection(),
          ],
          itemBuilder: (context, widget, index, animation) {
            return AnimationHelper.slideIn(
              child: widget,
              direction: SlideDirection.fromBottom,
            );
          },
        ),
      ),
    );
  }
  
  Widget _buildDurationSection() {
    return Card(
      color: AppColors.cardBackground,
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Workout Duration',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Icon(Icons.timer, color: AppColors.primary),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    '${_filter.durationMinutes} minutes',
                    style: const TextStyle(
                      fontSize: 16,
                      color: AppColors.textDark,
                    ),
                  ),
                ),
              ],
            ),
            Slider(
              value: _filter.durationMinutes?.toDouble() ?? 30,
              min: 10,
              max: 60,
              divisions: 10,              label: '${_filter.durationMinutes} min',
              activeColor: AppColors.primary,
              inactiveColor: AppColors.lightGrey,
              onChanged: (value) {
                setState(() {
                  _filter = _filter.copyWith(durationMinutes: value.round());
                });
              },
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildDifficultySection() {
    return Card(
      color: AppColors.cardBackground,
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Difficulty Level',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildDifficultyButton(Difficulty.beginner, 'Beginner'),
                _buildDifficultyButton(Difficulty.intermediate, 'Intermediate'),
                _buildDifficultyButton(Difficulty.advanced, 'Advanced'),
              ],
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildDifficultyButton(Difficulty difficulty, String label) {
    final isSelected = _filter.difficulty == difficulty;
    
    return GestureDetector(
      onTap: () {
        setState(() {
          _filter = _filter.copyWith(difficulty: difficulty);
        });
      },
      child: Column(
        children: [
          Container(              width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isSelected ? AppColors.primary : AppColors.primary.withOpacity(0.15),
              border: isSelected
                  ? Border.all(color: AppColors.primary, width: 3)
                  : null,
            ),
            child: Icon(
              difficulty == Difficulty.beginner
                  ? Icons.sentiment_satisfied_alt
                  : difficulty == Difficulty.intermediate
                      ? Icons.sentiment_neutral
                      : Icons.sentiment_very_dissatisfied,
              size: 40,
              color: isSelected ? Colors.white : AppColors.primary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              color: isSelected ? AppColors.primary : AppColors.textLight,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildMuscleGroupsSection() {
    return Card(
      color: AppColors.cardBackground,
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Target Muscle Groups',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Select muscle groups to target in this workout',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textLight,
              ),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _buildMuscleGroupChip(MuscleGroup.chest, 'Chest'),
                _buildMuscleGroupChip(MuscleGroup.back, 'Back'),
                _buildMuscleGroupChip(MuscleGroup.legs, 'Legs'),
                _buildMuscleGroupChip(MuscleGroup.shoulders, 'Shoulders'),
                _buildMuscleGroupChip(MuscleGroup.biceps, 'Biceps'),
                _buildMuscleGroupChip(MuscleGroup.triceps, 'Triceps'),
                _buildMuscleGroupChip(MuscleGroup.abs, 'Abs'),
                _buildMuscleGroupChip(MuscleGroup.fullBody, 'Full Body'),
              ],
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildMuscleGroupChip(MuscleGroup muscleGroup, String label) {
    final isSelected = _selectedMuscleGroups.contains(muscleGroup);
    
    return FilterChip(
      selected: isSelected,
      label: Text(label),
      backgroundColor: AppColors.cardBackground,
      checkmarkColor: Colors.white,
      selectedColor: AppColors.primary,
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : AppColors.textDark,
      ),
      onSelected: (selected) {
        setState(() {
          if (selected) {
            _selectedMuscleGroups.add(muscleGroup);
          } else {
            _selectedMuscleGroups.remove(muscleGroup);
          }
          
          _filter = _filter.copyWith(
            targetMuscleGroups: List.from(_selectedMuscleGroups),
          );
        });
      },
    );
  }
  
  Widget _buildGoalSection() {
    final fitnessGoals = [
      FitnessGoal.stayHealthy,
      FitnessGoal.loseWeight,
      FitnessGoal.improveEndurance,
    ];
    
    return Card(
      color: AppColors.cardBackground,
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Workout Goal',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(height: 16),
            ...fitnessGoals.map((goal) => RadioListTile<FitnessGoal>(
              title: Text(AppUtils.fitnessGoalToString(goal)),
              value: goal,
              groupValue: _filter.primaryGoal,
              activeColor: AppColors.primary,
              onChanged: (value) {
                setState(() {
                  _filter = _filter.copyWith(primaryGoal: value);
                });
              },
            )),
          ],
        ),
      ),
    );
  }
  
  Widget _buildAdvancedOptionsSection() {
    return Card(
      color: AppColors.cardBackground,
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Advanced Options',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(height: 16),
            CheckboxListTile(
              title: const Text('Equipment-free workout'),
              value: _filter.bodyweightOnly,
              activeColor: AppColors.primary,
              onChanged: (value) {
                setState(() {
                  _filter = _filter.copyWith(bodyweightOnly: value ?? true);
                });
              },
            ),
            const Divider(),
            CheckboxListTile(
              title: const Text('Balance exercises across muscle groups'),
              value: _filter.balancedWorkout,
              activeColor: AppColors.primary,
              onChanged: (value) {
                setState(() {
                  _filter = _filter.copyWith(balancedWorkout: value ?? true);
                });
              },
            ),
            if (_filter.intensityLevel != null) ...[
              const Divider(),
              ListTile(
                title: const Text('Intensity Level'),
                subtitle: Slider(
                  value: _filter.intensityLevel?.toDouble() ?? 5,
                  min: 1,
                  max: 10,
                  divisions: 9,                  label: '${_filter.intensityLevel}',
                  activeColor: AppColors.primary,
                  inactiveColor: AppColors.lightGrey,
                  onChanged: (value) {
                    setState(() {
                      _filter = _filter.copyWith(
                          intensityLevel: value.round());
                    });
                  },
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
  
  Widget _buildWorkoutPreview() {
    if (_generatedWorkout == null) {
      return const LoadingIndicator(message: 'Generating workout...');
    }
    
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppConstants.defaultPadding),
            child: Column(
              children: [
                AnimationHelper.fadeIn(
                  child: Card(
                    color: AppColors.cardBackground,
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Text(
                            _generatedWorkout!.name,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textDark,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _generatedWorkout!.description,
                            style: TextStyle(
                              fontSize: 14,
                              color: AppColors.textLight,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              _buildWorkoutInfoBadge(
                                icon: Icons.timer,
                                label: '${_generatedWorkout!.estimatedDuration} min',
                              ),
                              _buildWorkoutInfoBadge(
                                icon: Icons.local_fire_department,
                                label: '${_generatedWorkout!.estimatedCaloriesBurn} cal',
                              ),
                              _buildWorkoutInfoBadge(
                                icon: Icons.fitness_center,
                                label: '${_generatedWorkout!.exercises.length} ex',
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                AnimationHelper.slideIn(
                  direction: SlideDirection.fromBottom,
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _generatedWorkout!.exercises.length,
                    itemBuilder: (context, index) {
                      final exercise = _generatedWorkout!.exercises[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 8),
                        color: AppColors.cardBackground,
                        child: ListTile(                          leading: CircleAvatar(
                            backgroundColor: AppColors.primary.withOpacity(0.15),
                            child: Text(
                              (index + 1).toString(),
                              style: const TextStyle(
                                color: AppColors.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          title: Text(exercise.exercise.name),
                          subtitle: Text(
                            exercise.useTime
                                ? '${exercise.sets} sets × ${exercise.time}s'
                                : '${exercise.sets} sets × ${exercise.reps} reps',
                          ),
                          trailing: const Icon(Icons.keyboard_arrow_right),
                          onTap: () {
                            // Show exercise details
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.cardBackground,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 4,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: Row(
            children: [
              Expanded(                child: CustomButton(
                  text: 'Edit',
                  onPressed: _resetBuilder,
                  backgroundColor: AppColors.cardBackground,
                  textColor: AppColors.primary,
                  isOutlined: true,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: CustomButton(
                  text: 'Start Workout',
                  onPressed: () {                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => WorkoutDetailScreen(
                          workout: _generatedWorkout!,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
  
  Widget _buildWorkoutInfoBadge({required IconData icon, required String label}) {
    return Column(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(            shape: BoxShape.circle,
            color: AppColors.primary.withOpacity(0.15),
          ),
          child: Icon(icon, color: AppColors.primary),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
  
  Future<void> _generateWorkout() async {
    if (_isLoading) return;
    
    setState(() {
      _isLoading = true;
    });
    
    try {
      final provider = Provider.of<FlexHeroProvider>(context, listen: false);
      
      // Generate workout using our filter
      final workout = provider.workoutService.generateWorkoutWithFilter(_filter);
      
      // Save this workout to custom workouts
      await provider.workoutService.saveCustomWorkout(workout);
      
      setState(() {
        _generatedWorkout = workout;
        _isLoading = false;
      });
    } catch (e) {
      print('Error generating workout: $e');
      setState(() {
        _isLoading = false;
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to generate workout. Please try again.'),
        ),
      );
    }
  }
  
  void _resetBuilder() {
    setState(() {
      _generatedWorkout = null;
    });
  }
}
