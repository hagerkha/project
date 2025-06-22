import 'package:flutter/material.dart';
import '../../data/model/habit_model.dart';
import '../../data/repository/habits_repository.dart';
import '../screens/video_player_screen.dart';
import '../widgets/onboarding_screens/food_intro_screen.dart';
import '../widgets/onboarding_screens/shoes_intro_screen.dart';
import '../widgets/onboarding_screens/teeth_intro_screen.dart';
import '../widgets/onboarding_screens/wash_hands_intro_screen.dart';

class HabitsViewModel with ChangeNotifier {
  final HabitsRepository _repository;
  List<HabitModel> _habits = [];
  bool _isLoading = false;

  HabitsViewModel(this._repository) {
    loadHabits();
  }

  List<HabitModel> get habits => _habits;
  bool get isLoading => _isLoading;

  Future<void> loadHabits() async {
    _isLoading = true;
    notifyListeners();
    _habits = _repository.getHabits();
    _isLoading = false;
    notifyListeners();
  }

  // دالة ترجع الـ Widget المناسب بدون تنفيذ التنقل
  Widget getOnboardingScreen(HabitModel habit) {
    switch (habit.id) {
      case 'food_etiquette':
        return FoodIntroScreen(onContinue: () => null); // التنقل هيتم في الـ UI
      case 'brushing_teeth':
        return BrushingTeethIntroScreen(onContinue: () => null);
      case 'wash_hands':
        return WashHandsIntroScreen(onContinue: () => null);
      case 'wearing_shoes':
        return ShoeIntroScreen(onContinue: () => null);
      default:
        return Container();
    }
  }

  // دالة للتنقل لشاشة الفيديو
  void navigateToVideo(BuildContext context, String videoPath, String videoTitle) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VideoPlayerScreen(videoPath: videoPath, videoTitle: videoTitle),
      ),
    );
  }
}