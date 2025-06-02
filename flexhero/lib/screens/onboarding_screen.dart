import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/user_profile.dart';
import '../providers/flex_hero_provider.dart';
import '../utils/app_utils.dart';
import '../widgets/common_widgets.dart';
import 'home_screen.dart';

class OnboardingScreen extends StatefulWidget {
  final bool isEditing;
  
  const OnboardingScreen({
    Key? key, 
    this.isEditing = false,
  }) : super(key: key);

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  
  int _currentPage = 0;
  bool _isLoading = false;
  
  // User data
  String _name = '';
  int _age = 30;
  double _weight = 70.0;
  double _height = 170.0;
  bool _isMale = true;
  FitnessLevel _fitnessLevel = FitnessLevel.beginner;
  FitnessGoal _primaryGoal = FitnessGoal.stayHealthy;
  List<FitnessGoal> _secondaryGoals = [];
  int _weeklyWorkoutTarget = 3;
  int _workoutDuration = 30;
  
  @override
  void initState() {
    super.initState();
    _loadUserData();
  }
  
  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
  
  Future<void> _loadUserData() async {
    if (!widget.isEditing) return;
    
    setState(() {
      _isLoading = true;
    });
    
    try {
      final provider = Provider.of<FlexHeroProvider>(context, listen: false);
      final userProfile = provider.userProfile;
      
      if (userProfile != null) {
        setState(() {
          _name = userProfile.name;
          _age = userProfile.age;
          _weight = userProfile.weight;
          _height = userProfile.height;
          _isMale = userProfile.isMale;
          _fitnessLevel = userProfile.fitnessLevel;
          _primaryGoal = userProfile.primaryGoal;
          _secondaryGoals = List.from(userProfile.secondaryGoals);
          _weeklyWorkoutTarget = userProfile.weeklyWorkoutTarget;
          _workoutDuration = userProfile.workoutDuration;
        });
      }
    } catch (e) {
      print('Error loading user data: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
    void _nextPage() {
    if (_currentPage == 0 && (_name.isEmpty || _name.length < 2)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid name')),
      );
      return;
    }
    
    if (_currentPage < 4) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _saveProfile();
    }
  }
  
  void _previousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }
  
  Future<void> _saveProfile() async {
    final userProfile = UserProfile(
      name: _name,
      age: _age,
      weight: _weight,
      height: _height,
      isMale: _isMale,
      fitnessLevel: _fitnessLevel,
      primaryGoal: _primaryGoal,
      secondaryGoals: _secondaryGoals,
      weeklyWorkoutTarget: _weeklyWorkoutTarget,
      workoutDuration: _workoutDuration,
    );
    
    final provider = Provider.of<FlexHeroProvider>(context, listen: false);
    await provider.updateUserProfile(userProfile);
    
    if (mounted) {      if (widget.isEditing) {
        Navigator.pop(context);
      } else {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const HomeScreen()),
        );
      }
    }
  }
  
  void _toggleSecondaryGoal(FitnessGoal goal) {
    setState(() {
      if (_secondaryGoals.contains(goal)) {
        _secondaryGoals.remove(goal);
      } else {
        // Don't add primary goal as secondary
        if (goal != _primaryGoal) {
          _secondaryGoals.add(goal);
        }
      }
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: _currentPage > 0 || widget.isEditing
          ? IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: _currentPage > 0 ? _previousPage : () => Navigator.pop(context),
              color: AppColors.primary,
            )
          : null,
        title: Text(
          widget.isEditing ? 'Edit Profile' : 'Profile Setup',
          style: const TextStyle(
            color: AppColors.textDark,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Form(
        key: _formKey,
        child: PageView(
          controller: _pageController,
          physics: const NeverScrollableScrollPhysics(),
          onPageChanged: (page) {
            setState(() {
              _currentPage = page;
            });
          },
          children: [
            _buildNamePage(),
            _buildBodyInfoPage(),
            _buildFitnessLevelPage(),
            _buildFitnessGoalsPage(),
            _buildWorkoutPreferencesPage(),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomBar(),
    );
  }
  
  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 5,
            spreadRadius: 1,
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,          children: [
            Row(
              children: [
                ...List.generate(5, (index) {
                  return Expanded(
                    child: Container(
                      height: 4,
                      margin: const EdgeInsets.symmetric(horizontal: 2),
                      decoration: BoxDecoration(
                        color: index <= _currentPage
                            ? AppColors.primary
                            : AppColors.lightGrey,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  );
                }),
              ],
            ),
            const SizedBox(height: 16),
            CustomButton(
              text: _currentPage == 4 ? (widget.isEditing ? 'Save' : 'Finish') : 'Next',
              onPressed: _nextPage,
              icon: _currentPage == 4 ? Icons.check : Icons.arrow_forward,
              isFullWidth: true,
              isLoading: _isLoading,
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildNamePage() {
    return Padding(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Welcome to FlexHero!',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Let\'s get to know you better to create your personalized workout plan.',
            style: TextStyle(
              fontSize: 16,
              color: AppColors.textLight,
            ),
          ),
          const SizedBox(height: 32),
          const Text(
            'What should we call you?',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 16),
          CustomTextField(
            hintText: 'Enter your name',
            prefixIcon: Icons.person,
            onChanged: (value) {
              setState(() {
                _name = value;
              });
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your name';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }
  
  Widget _buildBodyInfoPage() {
    return Padding(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Body Information',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'This helps us tailor workouts to your specific needs.',
            style: TextStyle(
              fontSize: 16,
              color: AppColors.textLight,
            ),
          ),
          const SizedBox(height: 32),
          
          // Gender selection
          const Text(
            'Gender',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _isMale = true;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: _isMale ? AppColors.primary.withOpacity(0.1) : Colors.white,
                      borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
                      border: Border.all(
                        color: _isMale ? AppColors.primary : AppColors.lightGrey,
                      ),
                    ),
                    child: Column(
                      children: [
                        Icon(
                          Icons.male,
                          size: 40,
                          color: _isMale ? AppColors.primary : AppColors.textLight,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Male',
                          style: TextStyle(
                            color: _isMale ? AppColors.primary : AppColors.textLight,
                            fontWeight: _isMale ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _isMale = false;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: !_isMale ? AppColors.primary.withOpacity(0.1) : Colors.white,
                      borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
                      border: Border.all(
                        color: !_isMale ? AppColors.primary : AppColors.lightGrey,
                      ),
                    ),
                    child: Column(
                      children: [
                        Icon(
                          Icons.female,
                          size: 40,
                          color: !_isMale ? AppColors.primary : AppColors.textLight,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Female',
                          style: TextStyle(
                            color: !_isMale ? AppColors.primary : AppColors.textLight,
                            fontWeight: !_isMale ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 24),
          
          // Age
          Row(
            children: [
              const Text(
                'Age',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                ),
              ),
              const SizedBox(width: 16),
              Text(
                '$_age years',
                style: const TextStyle(
                  fontSize: 16,
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Slider(
            value: _age.toDouble(),
            min: 15,
            max: 80,
            divisions: 65,
            activeColor: AppColors.primary,
            inactiveColor: AppColors.lightGrey,
            label: _age.toString(),
            onChanged: (value) {
              setState(() {
                _age = value.round();
              });
            },
          ),
          
          const SizedBox(height: 16),
          
          // Weight
          Row(
            children: [
              const Text(
                'Weight',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                ),
              ),
              const SizedBox(width: 16),
              Text(
                '${_weight.toStringAsFixed(1)} kg',
                style: const TextStyle(
                  fontSize: 16,
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Slider(
            value: _weight,
            min: 40,
            max: 150,
            divisions: 220,
            activeColor: AppColors.primary,
            inactiveColor: AppColors.lightGrey,
            label: _weight.toStringAsFixed(1),
            onChanged: (value) {
              setState(() {
                _weight = double.parse(value.toStringAsFixed(1));
              });
            },
          ),
          
          const SizedBox(height: 16),
          
          // Height
          Row(
            children: [
              const Text(
                'Height',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                ),
              ),
              const SizedBox(width: 16),
              Text(
                '${_height.toStringAsFixed(0)} cm',
                style: const TextStyle(
                  fontSize: 16,
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Slider(
            value: _height,
            min: 140,
            max: 220,
            divisions: 80,
            activeColor: AppColors.primary,
            inactiveColor: AppColors.lightGrey,
            label: _height.toStringAsFixed(0),
            onChanged: (value) {
              setState(() {
                _height = value.roundToDouble();
              });
            },
          ),
        ],
      ),
    );
  }
  
  Widget _buildFitnessLevelPage() {
    return Padding(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Your Fitness Level',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'This helps us determine the intensity of your workouts.',
            style: TextStyle(
              fontSize: 16,
              color: AppColors.textLight,
            ),
          ),
          const SizedBox(height: 32),
          
          _buildFitnessLevelOption(
            FitnessLevel.beginner,
            'Beginner',
            'New to fitness or returning after a long break',
            Icons.star_outline,
          ),
          
          const SizedBox(height: 16),
          
          _buildFitnessLevelOption(
            FitnessLevel.intermediate,
            'Intermediate',
            'Worked out consistently for a few months',
            Icons.star_half,
          ),
          
          const SizedBox(height: 16),
          
          _buildFitnessLevelOption(
            FitnessLevel.advanced,
            'Advanced',
            'Exercise regularly with high intensity',
            Icons.star,
          ),
        ],
      ),
    );
  }
  
  Widget _buildFitnessLevelOption(
    FitnessLevel level,
    String title,
    String description,
    IconData icon,
  ) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _fitnessLevel = level;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color:
              _fitnessLevel == level ? AppColors.primary.withOpacity(0.1) : Colors.white,
          borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
          border: Border.all(
            color: _fitnessLevel == level ? AppColors.primary : AppColors.lightGrey,
          ),
        ),
        child: Row(
          children: [
            Container(
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                color: _fitnessLevel == level
                    ? AppColors.primary
                    : AppColors.lightGrey,
                borderRadius: BorderRadius.circular(25),
              ),
              child: Icon(
                icon,
                color:
                    _fitnessLevel == level ? Colors.white : AppColors.textLight,
                size: 30,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: _fitnessLevel == level
                          ? AppColors.primary
                          : AppColors.textDark,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 14,
                      color: _fitnessLevel == level
                          ? AppColors.primary
                          : AppColors.textLight,
                    ),
                  ),
                ],
              ),
            ),
            Radio<FitnessLevel>(
              value: level,
              groupValue: _fitnessLevel,
              activeColor: AppColors.primary,
              onChanged: (value) {
                setState(() {
                  _fitnessLevel = value!;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildFitnessGoalsPage() {
    return Padding(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Your Fitness Goals',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Select your primary goal and any secondary goals you may have.',
            style: TextStyle(
              fontSize: 16,
              color: AppColors.textLight,
            ),
          ),
          const SizedBox(height: 24),
          
          const Text(
            'Primary Goal',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 16),
          
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: FitnessGoal.values.map((goal) {
              return ChoiceChip(
                label: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: Text(
                    AppUtils.fitnessGoalToString(goal),
                    style: TextStyle(
                      color: _primaryGoal == goal ? Colors.white : AppColors.textDark,
                    ),
                  ),
                ),
                selected: _primaryGoal == goal,
                selectedColor: AppColors.primary,
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: BorderSide(
                    color: _primaryGoal == goal ? AppColors.primary : AppColors.lightGrey,
                  ),
                ),
                onSelected: (selected) {
                  if (selected) {
                    setState(() {
                      _primaryGoal = goal;
                      // Remove from secondary goals if it was there
                      _secondaryGoals.remove(goal);
                    });
                  }
                },
              );
            }).toList(),
          ),
          
          const SizedBox(height: 24),
          
          const Text(
            'Secondary Goals (Optional)',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 16),
          
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: FitnessGoal.values
                .where((goal) => goal != _primaryGoal)
                .map((goal) {
              return ChoiceChip(
                label: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: Text(
                    AppUtils.fitnessGoalToString(goal),
                    style: TextStyle(
                      color: _secondaryGoals.contains(goal) ? Colors.white : AppColors.textDark,
                    ),
                  ),
                ),
                selected: _secondaryGoals.contains(goal),
                selectedColor: AppColors.secondary,
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: BorderSide(
                    color: _secondaryGoals.contains(goal) ? AppColors.secondary : AppColors.lightGrey,
                  ),
                ),
                onSelected: (selected) {
                  _toggleSecondaryGoal(goal);
                },
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
  
  Widget _buildWorkoutPreferencesPage() {
    return Padding(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Workout Preferences',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Let us know how often and how long you want to work out.',
            style: TextStyle(
              fontSize: 16,
              color: AppColors.textLight,
            ),
          ),
          const SizedBox(height: 32),
          
          // Weekly workout target
          const Text(
            'How many workouts per week?',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 16),
          
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(7, (index) {
              final days = index + 1;
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _weeklyWorkoutTarget = days;
                  });
                },
                child: Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    color: _weeklyWorkoutTarget == days
                        ? AppColors.primary
                        : Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: _weeklyWorkoutTarget == days
                          ? AppColors.primary
                          : AppColors.lightGrey,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      days.toString(),
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: _weeklyWorkoutTarget == days
                            ? Colors.white
                            : AppColors.textDark,
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
          
          const SizedBox(height: 32),
          
          // Workout duration
          const Text(
            'Preferred workout duration',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'How long do you want your workouts to be?',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textLight,
            ),
          ),
          const SizedBox(height: 16),
          
          Row(
            children: [
              const Text(
                'Duration:',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                ),
              ),
              const SizedBox(width: 16),
              Text(
                '$_workoutDuration minutes',
                style: const TextStyle(
                  fontSize: 16,
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Slider(
            value: _workoutDuration.toDouble(),
            min: 10,
            max: 60,
            divisions: 10,
            activeColor: AppColors.primary,
            inactiveColor: AppColors.lightGrey,
            label: '$_workoutDuration minutes',
            onChanged: (value) {
              setState(() {
                _workoutDuration = value.round();
              });
            },
          ),
          
          const SizedBox(height: 24),
          
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
              border: Border.all(
                color: AppColors.primary.withOpacity(0.3),
              ),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.info_outline,
                  color: AppColors.primary,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Almost Done!',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'We\'ll create a personalized workout plan for you based on your preferences. You can always adjust these settings later.',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.primary.withOpacity(0.8),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
