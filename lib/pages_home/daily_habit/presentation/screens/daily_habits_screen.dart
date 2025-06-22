import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../logic/habits_view_model.dart';
import '../widgets/habit_card.dart';
import '../widgets/onboarding_screens/food_intro_screen.dart';
import '../widgets/onboarding_screens/shoes_intro_screen.dart';
import '../widgets/onboarding_screens/teeth_intro_screen.dart';
import '../widgets/onboarding_screens/wash_hands_intro_screen.dart';

class DailyHabitsScreen extends StatefulWidget {
  const DailyHabitsScreen({super.key});

  @override
  State<DailyHabitsScreen> createState() => _DailyHabitsScreenState();
}

class _DailyHabitsScreenState extends State<DailyHabitsScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer<HabitsViewModel>(
      builder: (context, viewModel, child) => Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.pop(context),
          ),
          title: const Text(
            'العادات اليومية',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
        ),
        body: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('images/33.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SafeArea(
              child: Align(
                alignment: Alignment.center,
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.6,
                  margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: viewModel.isLoading
                          ? [const Center(child: CircularProgressIndicator())]
                          : viewModel.habits.map((habit) {
                        return HabitCard(
                          icon: habit.icon,
                          title: habit.title,
                          description: habit.description,
                          color: habit.color,
                          onTap: () {
                            final screen = viewModel.getOnboardingScreen(habit);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => screen,
                              ),
                            ).then((_) {
                              // استخدام navigateToVideo من الـ ViewModel
                              if (screen is FoodIntroScreen ||
                                  screen is BrushingTeethIntroScreen ||
                                  screen is WashHandsIntroScreen ||
                                  screen is ShoeIntroScreen) {
                                viewModel.navigateToVideo(context, habit.videoPath, habit.title);
                              }
                            });
                          },
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}