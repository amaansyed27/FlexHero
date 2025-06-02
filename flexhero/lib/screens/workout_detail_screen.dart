import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/workout.dart';
import '../providers/flex_hero_provider.dart';
import '../utils/app_utils.dart';
import '../widgets/common_widgets.dart';
import '../widgets/workout_widgets.dart';

class WorkoutDetailScreen extends StatelessWidget {
  final Workout workout;

  const WorkoutDetailScreen({
    Key? key,
    required this.workout,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(
        title: 'Workout Details',
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Workout header
            Text(
              workout.name,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              workout.description,
              style: const TextStyle(
                fontSize: 16,
                color: AppColors.textLight,
              ),
            ),
            const SizedBox(height: 16),

            // Workout stats
            Row(
              children: [
                _buildStatBadge(
                  Icons.timer,
                  '${workout.estimatedDuration} min',
                ),
                const SizedBox(width: 16),
                _buildStatBadge(
                  Icons.fitness_center,
                  '${workout.exercises.length} exercises',
                ),
                const SizedBox(width: 16),
                DifficultyBadge(difficulty: workout.difficulty),
              ],
            ),
            const SizedBox(height: 24),

            // Exercise list
            const Text(
              'Exercises',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(height: 16),
            ...workout.exercises.asMap().entries.map(
                  (entry) => Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: WorkoutExerciseItem(
                      workoutExercise: entry.value,
                      index: entry.key,
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
                                child: ExerciseDetailView(
                                  exercise: entry.value.exercise,
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ),
            const SizedBox(height: 24),

            // Target muscles
            if (workout.targetMuscleGroups.isNotEmpty) ...[
              const Text(
                'Target Muscle Groups',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: workout.targetMuscleGroups
                    .map((m) => MuscleGroupChip(muscleGroup: m))
                    .toList(),
              ),
              const SizedBox(height: 24),
            ],

            // Start workout button
            CustomButton(
              text: 'Start Workout',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => WorkoutSessionScreen(workout: workout),
                  ),
                );
              },
              isFullWidth: true,
              icon: Icons.play_arrow,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatBadge(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.lightGrey),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: 16,
            color: AppColors.textLight,
          ),
          const SizedBox(width: 4),
          Text(
            text,
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.textDark,
            ),
          ),
        ],
      ),
    );
  }
}

class WorkoutSessionScreen extends StatefulWidget {
  final Workout workout;

  const WorkoutSessionScreen({
    Key? key,
    required this.workout,
  }) : super(key: key);

  @override
  State<WorkoutSessionScreen> createState() => _WorkoutSessionScreenState();
}

class _WorkoutSessionScreenState extends State<WorkoutSessionScreen> {
  int _currentExerciseIndex = 0;
  int _currentSet = 1;
  bool _isResting = false;
  bool _isCompleted = false;
  bool _isPaused = false;
  
  int _timerSeconds = 0;
  Timer? _timer;
  Timer? _exerciseTimer;
  int _sessionDuration = 0;
  int _estimatedCaloriesBurned = 0;
  
  @override
  void initState() {
    super.initState();
    _startWorkoutTimer();
    _initializeExerciseTimer();
  }
  
  @override
  void dispose() {
    _timer?.cancel();
    _exerciseTimer?.cancel();
    super.dispose();
  }
  
  void _startWorkoutTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!_isPaused) {
        setState(() {
          _sessionDuration++;
          
          // Calculate estimated calories burned every minute
          if (_sessionDuration % 60 == 0) {
            final caloriesPerMinute = _getCurrentExercise().exercise.caloriesBurned;
            _estimatedCaloriesBurned += caloriesPerMinute;
          }
        });
      }
    });
  }
  
  void _initializeExerciseTimer() {
    final exercise = _getCurrentExerciseItem();
    
    if (exercise.useTime) {
      setState(() {
        _timerSeconds = exercise.time;
      });
      
      _startExerciseTimer();
    } else {
      setState(() {
        _timerSeconds = 0;
      });
    }
  }
  
  void _startExerciseTimer() {
    _exerciseTimer?.cancel();
    
    _exerciseTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!_isPaused) {
        setState(() {
          if (_timerSeconds > 0) {
            _timerSeconds--;
          } else {
            _completeCurrentSetOrRest();
          }
        });
      }
    });
  }
  
  void _togglePause() {
    setState(() {
      _isPaused = !_isPaused;
    });
  }
  
  WorkoutExercise _getCurrentExercise() {
    return widget.workout.exercises[_currentExerciseIndex];
  }
  
  WorkoutExercise _getCurrentExerciseItem() {
    return widget.workout.exercises[_currentExerciseIndex];
  }
  
  void _completeCurrentSetOrRest() {
    _exerciseTimer?.cancel();
    final exerciseItem = _getCurrentExerciseItem();
    
    if (_isResting) {
      // Rest completed, move to next set or exercise
      setState(() {
        _isResting = false;
        
        if (_currentSet < exerciseItem.sets) {
          // More sets to go
          _currentSet++;
        } else {
          // All sets completed, move to next exercise
          _moveToNextExercise();
        }
      });
      
      // Initialize timer for next exercise or set
      if (!_isCompleted) {
        _initializeExerciseTimer();
      }
    } else {
      // Exercise set completed, start rest timer if there are more sets
      if (_currentSet < exerciseItem.sets) {
        setState(() {
          _isResting = true;
          _timerSeconds = exerciseItem.restBetweenSets;
        });
        _startExerciseTimer();
      } else {
        // Check if there are more exercises
        if (_currentExerciseIndex < widget.workout.exercises.length - 1) {
          setState(() {
            _isResting = true;
            _timerSeconds = widget.workout.restBetweenExercises;
          });
          _startExerciseTimer();
        } else {
          _completeWorkout();
        }
      }
    }
  }
  
  void _moveToNextExercise() {
    if (_currentExerciseIndex < widget.workout.exercises.length - 1) {
      setState(() {
        _currentExerciseIndex++;
        _currentSet = 1;
      });
    } else {
      _completeWorkout();
    }
  }
  
  void _completeWorkout() {
    _timer?.cancel();
    _exerciseTimer?.cancel();
    
    setState(() {
      _isCompleted = true;
    });
    
    // Save workout stats
    final provider = Provider.of<FlexHeroProvider>(context, listen: false);
    provider.completeWorkout(
      widget.workout.id,
      DateTime.now(),
      _sessionDuration,
      _estimatedCaloriesBurned,
    );
  }
  
  @override
  Widget build(BuildContext context) {
    if (_isCompleted) {
      return _buildCompletionScreen();
    }
    
    final currentExercise = _getCurrentExercise();
    final isTimeBased = currentExercise.useTime;
    
    return WillPopScope(
      onWillPop: () async {
        final shouldPop = await showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text('Quit Workout?'),
            content: const Text('Are you sure you want to quit this workout?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('No'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(true),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                ),
                child: const Text('Yes'),
              ),
            ],
          ),
        );
        
        return shouldPop ?? false;
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text(
            widget.workout.name,
            style: const TextStyle(
              color: AppColors.textDark,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            TextButton.icon(
              onPressed: _togglePause,
              icon: Icon(_isPaused ? Icons.play_arrow : Icons.pause),
              label: Text(_isPaused ? 'Resume' : 'Pause'),
              style: TextButton.styleFrom(
                foregroundColor: AppColors.primary,
              ),
            ),
          ],
        ),
        body: Column(
          children: [
            // Progress bar
            LinearProgressIndicator(
              value: (_currentExerciseIndex * currentExercise.sets + (_currentSet - 1)) /
                  (widget.workout.exercises.length * currentExercise.sets),
              backgroundColor: AppColors.lightGrey,
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
              minHeight: 6,
            ),
            
            // Main content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(AppConstants.defaultPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Exercise info
                    Text(
                      _isResting ? 'Rest' : currentExercise.exercise.name,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: _isResting ? AppColors.secondary : AppColors.textDark,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _isResting
                          ? 'Next: Set ${_currentSet} of ${currentExercise.sets}'
                          : 'Set $_currentSet of ${currentExercise.sets}',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: _isResting ? AppColors.secondary : AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 40),
                    
                    // Exercise image or icon
                    Container(
                      height: 200,
                      width: 200,
                      decoration: BoxDecoration(
                        color: _isResting
                            ? AppColors.secondary.withOpacity(0.1)
                            : AppColors.primary.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: _isResting
                            ? const Icon(
                                Icons.hourglass_bottom,
                                size: 80,
                                color: AppColors.secondary,
                              )
                            : Icon(
                                AppUtils.getMuscleGroupIcon(
                                  currentExercise.exercise.primaryMuscles.first,
                                ),
                                size: 80,
                                color: AppColors.primary,
                              ),
                      ),
                    ),
                    const SizedBox(height: 40),
                    
                    // Timer or rep count
                    if (isTimeBased || _isResting)
                      Column(
                        children: [
                          Text(
                            AppUtils.formatSeconds(_timerSeconds),
                            style: TextStyle(
                              fontSize: 60,
                              fontWeight: FontWeight.bold,
                              color: _isResting ? AppColors.secondary : AppColors.textDark,
                            ),
                          ),
                          Text(
                            _isResting ? 'Rest Time Remaining' : 'Time Remaining',
                            style: const TextStyle(
                              fontSize: 16,
                              color: AppColors.textLight,
                            ),
                          ),
                        ],
                      )
                    else
                      Column(
                        children: [
                          Text(
                            '${currentExercise.reps}',
                            style: const TextStyle(
                              fontSize: 60,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textDark,
                            ),
                          ),
                          const Text(
                            'Reps to Complete',
                            style: TextStyle(
                              fontSize: 16,
                              color: AppColors.textLight,
                            ),
                          ),
                        ],
                      ),
                    
                    const SizedBox(height: 24),
                    
                    // Workout stats
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildStatItem(
                          Icons.timer,
                          'Duration',
                          AppUtils.formatSeconds(_sessionDuration),
                        ),
                        const SizedBox(width: 40),
                        _buildStatItem(
                          Icons.local_fire_department,
                          'Calories',
                          '$_estimatedCaloriesBurned',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            
            // Bottom controls
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(AppConstants.defaultPadding),
                child: Row(
                  children: [
                    Expanded(                      child: CustomButton(
                        text: 'Previous',
                        onPressed: _currentExerciseIndex > 0 && !_isResting
                            ? () {
                                _exerciseTimer?.cancel();
                                setState(() {
                                  _currentExerciseIndex--;
                                  _currentSet = 1;
                                  _isResting = false;
                                });
                                _initializeExerciseTimer();
                              }
                            : () {},
                        backgroundColor: Colors.grey[300],
                        textColor: AppColors.textDark,
                        isOutlined: true,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: CustomButton(
                        text: _isResting
                            ? 'Skip Rest'
                            : isTimeBased
                                ? 'Skip Timer'
                                : 'Complete',
                        onPressed: () {
                          _completeCurrentSetOrRest();
                        },
                        backgroundColor: _isResting
                            ? AppColors.secondary
                            : AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildStatItem(IconData icon, String label, String value) {
    return Column(
      children: [
        Icon(
          icon,
          color: AppColors.textLight,
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.textDark,
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
    );
  }
  
  Widget _buildCompletionScreen() {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.defaultPadding),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.check_circle,
                size: 100,
                color: AppColors.success,
              ),
              const SizedBox(height: 24),
              const Text(
                'Workout Complete!',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Congratulations on completing ${widget.workout.name}',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  color: AppColors.textLight,
                ),
              ),
              const SizedBox(height: 40),
              
              // Stats
              CustomCard(
                child: Column(
                  children: [
                    _buildCompletionStat('Total Time', AppUtils.formatDuration(_sessionDuration)),
                    const Divider(),
                    _buildCompletionStat('Calories Burned', '$_estimatedCaloriesBurned kcal'),
                    const Divider(),
                    _buildCompletionStat(
                      'Exercises Completed', 
                      '${widget.workout.exercises.length}'
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              
              CustomButton(
                text: 'Finish',
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                isFullWidth: true,
                backgroundColor: AppColors.success,
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildCompletionStat(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              color: AppColors.textLight,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.textDark,
            ),
          ),
        ],
      ),
    );
  }
}
