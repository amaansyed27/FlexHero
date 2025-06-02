import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// ignore: unused_import
import '../models/user_profile.dart';
import '../providers/flex_hero_provider.dart';
import '../utils/app_utils.dart';
import '../widgets/common_widgets.dart';
import 'onboarding_screen.dart';

class ProfileScreen extends StatefulWidget {
  // ignore: use_super_parameters
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<FlexHeroProvider>(context);
    final userProfile = provider.userProfile;
    
    if (userProfile == null) {
      return const LoadingIndicator(message: 'Loading profile...');
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(
        title: 'Your Profile',
        showBackButton: false,
      ),
      body: ListView(
        children: [
          // Profile header
          Container(
            padding: const EdgeInsets.all(AppConstants.defaultPadding),
            color: AppColors.primary,
            child: Column(
              children: [
                // Profile avatar
                Container(
                  height: 100,
                  width: 100,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      userProfile.name.isNotEmpty ? userProfile.name[0].toUpperCase() : '?',
                      style: const TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  userProfile.name,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '${userProfile.age} years • ${userProfile.isMale ? 'Male' : 'Female'} • ${AppUtils.fitnessLevelToString(userProfile.fitnessLevel)}',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white.withOpacity(0.8),
                  ),
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  alignment: WrapAlignment.center,
                  children: [
                    _buildProfileBadge(
                      AppUtils.fitnessGoalToString(userProfile.primaryGoal),
                      AppColors.secondary,
                    ),
                    ...userProfile.secondaryGoals
                        .map((goal) => _buildProfileBadge(
                              AppUtils.fitnessGoalToString(goal),
                              Colors.white.withOpacity(0.3),
                            ))
                        .toList(),
                  ],
                ),
              ],
            ),
          ),

          // Stats section
          Padding(
            padding: const EdgeInsets.all(AppConstants.defaultPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SectionHeader(
                  title: 'Body Metrics',
                  subtitle: 'Your current measurements',
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    _buildStatCard('Height', '${userProfile.height.round()} cm'),
                    const SizedBox(width: 16),
                    _buildStatCard('Weight', '${userProfile.weight.toStringAsFixed(1)} kg'),
                    const SizedBox(width: 16),
                    _buildStatCard('BMI', userProfile.bmi.toStringAsFixed(1), 
                      subtitle: userProfile.bmiCategory),
                  ],
                ),
                const SizedBox(height: 24),

                // Workout stats
                const SectionHeader(
                  title: 'Workout Stats',
                  subtitle: 'Your fitness journey',
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    _buildStatCard('Completed', 
                      '${userProfile.completedWorkoutIds.length}',
                      subtitle: 'Workouts'),
                    const SizedBox(width: 16),
                    _buildStatCard('Weekly Goal', 
                      '${userProfile.weeklyWorkoutTarget}',
                      subtitle: 'Workouts'),
                    const SizedBox(width: 16),
                    _buildStatCard('Duration', 
                      '${userProfile.workoutDuration}',
                      subtitle: 'Minutes'),
                  ],
                ),
                const SizedBox(height: 24),

                // Edit profile
                CustomButton(
                  text: 'Edit Profile',
                  onPressed: () => _showEditProfile(context),
                  icon: Icons.edit,
                  isFullWidth: true,
                ),
                const SizedBox(height: 16),
                CustomButton(
                  text: 'Workout History',
                  onPressed: () => _showWorkoutHistory(context),
                  icon: Icons.history,
                  isOutlined: true,
                  isFullWidth: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileBadge(String text, Color bgColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, {String? subtitle}) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Column(
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textLight,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textDark,
              ),
            ),
            if (subtitle != null) ...[
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textLight,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _showEditProfile(BuildContext context) {
    // Navigate to edit profile screen (we can use a simplified version of the onboarding flow)
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const OnboardingScreen(isEditing: true),
      ),
    );
  }

  void _showWorkoutHistory(BuildContext context) async {
    final provider = Provider.of<FlexHeroProvider>(context, listen: false);
    final history = await provider.getWorkoutHistory();
    
    if (!context.mounted) return;
    
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
          return Column(
            children: [
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'Workout History',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textDark,
                  ),
                ),
              ),
              const Divider(),
              Expanded(
                child: history.isEmpty
                    ? const Center(
                        child: Text(
                          'No workout history found',
                          style: TextStyle(color: AppColors.textLight),
                        ),
                      )
                    : ListView.builder(
                        controller: scrollController,
                        itemCount: history.length,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        itemBuilder: (context, index) {
                          final item = history[index];
                          final date = DateTime.parse(item['date']);
                          
                          return Card(
                            margin: const EdgeInsets.only(bottom: 12),
                            child: ListTile(
                              title: Text(item['workoutName']),
                              subtitle: Text(
                                '${AppUtils.formatDuration(item['duration'])} • ${item['caloriesBurned']} kcal'
                              ),
                              trailing: Text(
                                '${date.day}/${date.month}/${date.year}',
                                style: const TextStyle(color: AppColors.textLight),
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}
