import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/exercise.dart';
import '../providers/flex_hero_provider.dart';
import '../utils/app_utils.dart';
import '../widgets/common_widgets.dart';
import '../widgets/workout_widgets.dart';

class ExerciseLibraryScreen extends StatefulWidget {
  const ExerciseLibraryScreen({Key? key}) : super(key: key);

  @override
  State<ExerciseLibraryScreen> createState() => _ExerciseLibraryScreenState();
}

class _ExerciseLibraryScreenState extends State<ExerciseLibraryScreen> {
  String _searchQuery = '';
  MuscleGroup? _selectedMuscleGroup;
  Difficulty? _selectedDifficulty;
  
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<FlexHeroProvider>(context);
    final allExercises = provider.workoutService.allExercises;
    
    // Filter exercises based on search query, muscle group, and difficulty
    final filteredExercises = allExercises.where((exercise) {
      // Filter by search query
      final matchesSearch = _searchQuery.isEmpty || 
          exercise.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          exercise.description.toLowerCase().contains(_searchQuery.toLowerCase());
      
      // Filter by muscle group
      final matchesMuscleGroup = _selectedMuscleGroup == null || 
          exercise.primaryMuscles.contains(_selectedMuscleGroup) ||
          exercise.secondaryMuscles.contains(_selectedMuscleGroup);
      
      // Filter by difficulty
      final matchesDifficulty = _selectedDifficulty == null || 
          exercise.difficulty == _selectedDifficulty;
      
      return matchesSearch && matchesMuscleGroup && matchesDifficulty;
    }).toList();
    
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(
        title: 'Exercise Library',
        showBackButton: false,
      ),
      body: Column(
        children: [
          // Search and filter section
          Container(
            padding: const EdgeInsets.all(AppConstants.defaultPadding),
            color: AppColors.cardBackground,
            child: Column(
              children: [
                // Search bar
                CustomTextField(
                  hintText: 'Search exercises...',
                  prefixIcon: Icons.search,
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                    });
                  },
                ),
                const SizedBox(height: 16),
                
                Row(
                  children: [
                    Expanded(
                      child: _buildFilterDropdown<MuscleGroup>(
                        value: _selectedMuscleGroup,
                        items: MuscleGroup.values,
                        hint: 'Muscle Group',
                        onChanged: (value) {
                          setState(() {
                            _selectedMuscleGroup = value;
                          });
                        },
                        itemToString: (item) => AppUtils.muscleGroupToString(item),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildFilterDropdown<Difficulty>(
                        value: _selectedDifficulty,
                        items: Difficulty.values,
                        hint: 'Difficulty',
                        onChanged: (value) {
                          setState(() {
                            _selectedDifficulty = value;
                          });
                        },
                        itemToString: (item) => AppUtils.difficultyToString(item),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          // Exercise list
          Expanded(
            child: provider.isLoading
                ? const LoadingIndicator(message: 'Loading exercises...')
                : filteredExercises.isEmpty
                    ? const EmptyStateWidget(
                        message: 'No exercises found.\nTry adjusting your filters.',
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
                                _showExerciseDetails(context, exercise);
                              },
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterDropdown<T>({
    required T? value,
    required List<T> items,
    required String hint,
    required void Function(T?) onChanged,
    required String Function(T) itemToString,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppConstants.smallBorderRadius),
        border: Border.all(color: AppColors.lightGrey),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          value: value,
          hint: Text(hint),
          isExpanded: true,
          icon: const Icon(Icons.arrow_drop_down),
          items: [
            DropdownMenuItem<T>(
              value: null,
              child: Text('All $hint'),
            ),
            ...items.map((item) => DropdownMenuItem<T>(
                  value: item,
                  child: Text(itemToString(item)),
                )).toList(),
          ],
          onChanged: onChanged,
        ),
      ),
    );
  }

  void _showExerciseDetails(BuildContext context, Exercise exercise) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
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
  }
}
