import 'package:flutter/material.dart';
import '../models/user_profile.dart';
import '../models/workout.dart';
import '../services/workout_service.dart';

class FlexHeroProvider with ChangeNotifier {
  final WorkoutService _workoutService = WorkoutService();
  UserProfile? _userProfile;
  List<Workout>? _customWorkouts;
  List<Workout> _predefinedWorkouts = [];
  Workout? _currentWorkout;
  bool _isLoading = false;
  
  // Expose workout service for direct access
  WorkoutService get workoutService => _workoutService;
    FlexHeroProvider() {
    initializeData();
  }
  
  // Getters
  UserProfile? get userProfile => _userProfile;
  List<Workout> get customWorkouts => _customWorkouts ?? [];
  List<Workout> get predefinedWorkouts => _predefinedWorkouts;
  Workout? get currentWorkout => _currentWorkout;
  bool get isLoading => _isLoading;
  bool get isUserProfileSet => _userProfile != null;
    // Initialize data from local storage
  Future<void> initializeData() async {
    _setLoading(true);
    
    try {
      // Load user profile
      _userProfile = await _workoutService.getUserProfile();
      
      // Load workouts
      _predefinedWorkouts = _workoutService.predefinedWorkouts;
      _customWorkouts = await _workoutService.getCustomWorkouts();
    } catch (e) {
      print('Error initializing data: $e');
    } finally {
      _setLoading(false);
    }
  }
  
  // Create or update user profile
  Future<void> updateUserProfile(UserProfile profile) async {
    _setLoading(true);
    
    try {
      await _workoutService.saveUserProfile(profile);
      _userProfile = profile;
      notifyListeners();
    } catch (e) {
      print('Error updating user profile: $e');
    } finally {
      _setLoading(false);
    }
  }
  
  // Generate a workout for the user
  Future<Workout?> generateWorkoutForUser() async {
    if (_userProfile == null) return null;
    
    _setLoading(true);
    
    try {
      final workout = _workoutService.generateWorkoutForUser(_userProfile!);
      _currentWorkout = workout;
      return workout;
    } catch (e) {
      print('Error generating workout: $e');
      return null;
    } finally {
      _setLoading(false);
    }
  }
  
  // Save workout to history
  Future<void> completeWorkout(String workoutId, DateTime completedDate, int duration, int caloriesBurned) async {
    _setLoading(true);
    
    try {
      await _workoutService.saveWorkoutToHistory(
        workoutId, 
        completedDate, 
        duration, 
        caloriesBurned
      );
      _userProfile = await _workoutService.getUserProfile();
      notifyListeners();
    } catch (e) {
      print('Error saving workout to history: $e');
    } finally {
      _setLoading(false);
    }
  }
  
  // Save a custom workout
  Future<void> saveCustomWorkout(Workout workout) async {
    _setLoading(true);
    
    try {
      await _workoutService.saveCustomWorkout(workout);
      _customWorkouts = await _workoutService.getCustomWorkouts();
      notifyListeners();
    } catch (e) {
      print('Error saving custom workout: $e');
    } finally {
      _setLoading(false);
    }
  }
  
  // Set current workout
  void setCurrentWorkout(Workout workout) {
    _currentWorkout = workout;
    notifyListeners();
  }
  
  // Get workout by ID
  Future<Workout?> getWorkoutById(String id) async {
    return await _workoutService.getWorkoutById(id);
  }
  
  // Get workout history
  Future<List<Map<String, dynamic>>> getWorkoutHistory() async {
    return await _workoutService.getWorkoutHistory();
  }
  
  // Helper to set loading state
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }
}
