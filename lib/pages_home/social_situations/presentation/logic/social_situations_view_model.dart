import 'package:flutter/material.dart';
import '../../../daily_habit/presentation/screens/video_player_screen.dart';
import '../../data/model/social_situation_model.dart';
import '../../data/repository/social_situations_repository.dart';
import '../screens/feelings_intro_screen.dart';

class SocialSituationsViewModel with ChangeNotifier {
  final SocialSituationsRepository _repository;
  List<SocialSituationModel> _situations = [];
  bool _isLoading = false;

  SocialSituationsViewModel(this._repository) {
    loadSituations();
  }

  List<SocialSituationModel> get situations => _situations;
  bool get isLoading => _isLoading;

  Future<void> loadSituations() async {
    _isLoading = true;
    notifyListeners();
    _situations = _repository.getSocialSituations();
    _isLoading = false;
    notifyListeners();
  }

  void navigateToVideo(BuildContext context, String videoPath, String videoTitle) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VideoPlayerScreen(videoPath: videoPath, videoTitle: videoTitle),
      ),
    );
  }

  void navigateToOnboarding(BuildContext context, String onboardingRoute) {
    Navigator.pushNamed(context, onboardingRoute);
  }
}