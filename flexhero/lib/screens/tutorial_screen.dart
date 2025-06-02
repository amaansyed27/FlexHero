import 'package:flutter/material.dart';
import '../utils/app_utils.dart';
import '../utils/animation_helper.dart';
import '../widgets/common_widgets.dart';

class TutorialScreen extends StatefulWidget {
  final bool showInitialOverlay;
  
  const TutorialScreen({
    Key? key,
    this.showInitialOverlay = true,
  }) : super(key: key);

  @override
  State<TutorialScreen> createState() => _TutorialScreenState();
}

class _TutorialScreenState extends State<TutorialScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  
  final List<TutorialStep> _tutorialSteps = [
    TutorialStep(
      title: 'Welcome to FlexHero',
      description: 'Your personal workout companion to help you achieve your fitness goals without equipment.',
      imagePath: 'assets/images/tutorial/welcome.png',
      iconData: Icons.fitness_center,
    ),
    TutorialStep(
      title: 'Customized Workouts',
      description: 'Get personalized home workouts based on your fitness level, goals, and available time.',
      imagePath: 'assets/images/tutorial/customize.png',
      iconData: Icons.auto_awesome,
    ),
    TutorialStep(
      title: 'Track Your Progress',
      description: 'Monitor your workout history, body metrics, and achievements over time.',
      imagePath: 'assets/images/tutorial/track.png',
      iconData: Icons.insert_chart,
    ),
    TutorialStep(
      title: 'Exercise Library',
      description: 'Browse through a comprehensive collection of bodyweight exercises with detailed instructions.',
      imagePath: 'assets/images/tutorial/library.png',
      iconData: Icons.menu_book,
    ),
    TutorialStep(
      title: "Let's Get Started!",
      description: 'Complete your profile and start your fitness journey today!',
      imagePath: 'assets/images/tutorial/start.png',
      iconData: Icons.play_circle_fill,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Skip button
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextButton(
                  onPressed: _onFinish,
                  child: const Text(
                    'Skip',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            
            // Page content
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _tutorialSteps.length,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemBuilder: (context, index) {
                  final step = _tutorialSteps[index];
                  return _buildTutorialPage(step);
                },
              ),
            ),
            
            // Page indicator
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  _tutorialSteps.length,
                  (index) => _buildPageIndicator(index),
                ),
              ),
            ),
            
            // Navigation buttons
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
              child: SizedBox(
                width: double.infinity,
                child: CustomButton(
                  text: _currentPage == _tutorialSteps.length - 1 
                      ? 'Get Started' : 'Next',
                  onPressed: () {
                    if (_currentPage < _tutorialSteps.length - 1) {
                      _pageController.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    } else {
                      _onFinish();
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildTutorialPage(TutorialStep step) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimationHelper.scale(
            child: Container(              width: 150,
              height: 150,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(
                step.iconData,
                size: 80,
                color: AppColors.primary,
              ),
            ),
          ),
          const SizedBox(height: 40),
          AnimationHelper.fadeIn(
            child: Text(
              step.title,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: AppColors.textDark,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 16),
          AnimationHelper.slideIn(
            direction: SlideDirection.fromBottom,
            distance: 50,
            child: Text(
              step.description,
              style: TextStyle(
                fontSize: 16,
                color: AppColors.textLight,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildPageIndicator(int index) {
    final isActive = index == _currentPage;
    
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: 5),
      height: 8,
      width: isActive ? 24 : 8,      decoration: BoxDecoration(
        color: isActive ? AppColors.primary : AppColors.lightGrey,
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }
  
  void _onFinish() {
    Navigator.of(context).pop();
  }
}

class TutorialStep {
  final String title;
  final String description;
  final String? imagePath;
  final IconData iconData;
  
  TutorialStep({
    required this.title,
    required this.description,
    this.imagePath,
    required this.iconData,
  });
}

class TutorialOverlay {
  static void show(BuildContext context) {
    Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        pageBuilder: (context, _, __) => const _TutorialFeatureOverlay(),
        transitionDuration: const Duration(milliseconds: 300),
        transitionsBuilder: (context, animation, _, child) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
      ),
    );
  }
}

class _TutorialFeatureOverlay extends StatefulWidget {
  const _TutorialFeatureOverlay();

  @override
  State<_TutorialFeatureOverlay> createState() => _TutorialFeatureOverlayState();
}

class _TutorialFeatureOverlayState extends State<_TutorialFeatureOverlay> {
  int _currentStep = 0;
  
  final List<FeatureStep> _features = [
    FeatureStep(
      title: 'Dashboard',
      description: 'View your workout stats, upcoming sessions, and quick access to recommended workouts.',
      targetAlignment: Alignment.topCenter,
      offsetY: 100,
    ),
    FeatureStep(
      title: 'Workout Library',
      description: 'Browse through predefined workouts or create your own custom routines.',
      targetAlignment: Alignment.center,
      offsetY: 0,
    ),
    FeatureStep(
      title: 'Exercise Library',
      description: 'Explore all available exercises with detailed instructions and animations.',
      targetAlignment: Alignment.bottomCenter,
      offsetY: -100,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final feature = _features[_currentStep];
    
    return Material(
      color: Colors.black.withOpacity(0.7),
      child: InkWell(
        onTap: _nextStep,
        child: Stack(
          children: [
            Positioned.fill(
              child: Center(
                child: AnimationHelper.fadeIn(
                  child: _buildFeatureHighlight(feature),
                ),
              ),
            ),
            Positioned(
              bottom: 48,
              left: 0,
              right: 0,
              child: Center(
                child: ElevatedButton(
                  onPressed: _nextStep,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: Text(
                    _currentStep < _features.length - 1
                        ? 'Next Tip'
                        : 'Got It',
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildFeatureHighlight(FeatureStep feature) {
    return Align(
      alignment: feature.targetAlignment,
      child: Transform.translate(
        offset: Offset(0, feature.offsetY ?? 0),
        child: Container(
          width: 300,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 10,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                feature.title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                feature.description,
                style: TextStyle(
                  fontSize: 16,
                  color: AppColors.textLight,
                  height: 1.4,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                '${_currentStep + 1}/${_features.length}',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.textLight.withOpacity(0.7),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  void _nextStep() {
    if (_currentStep < _features.length - 1) {
      setState(() {
        _currentStep++;
      });
    } else {
      Navigator.of(context).pop();
    }
  }
}

class FeatureStep {
  final String title;
  final String description;
  final Alignment targetAlignment;
  final double? offsetY;
  
  FeatureStep({
    required this.title,
    required this.description,
    required this.targetAlignment,
    this.offsetY,
  });
}
