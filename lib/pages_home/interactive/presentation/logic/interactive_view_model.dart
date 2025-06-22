import 'package:flutter/material.dart';
import '../../../daily_habit/presentation/screens/video_player_screen.dart';
import '../../data/model/interactive_item_model.dart';
import '../../data/repository/interactive_repository.dart';
import '../New folder/arabic_game.dart';


class InteractiveViewModel with ChangeNotifier {
  final InteractiveRepository _repository;
  List<InteractiveItemModel> _items = [];
  bool _isLoading = false;

  InteractiveViewModel(this._repository) {
    loadItems();
  }

  List<InteractiveItemModel> get items => _items;
  bool get isLoading => _isLoading;

  Future<void> loadItems() async {
    _isLoading = true;
    notifyListeners();
    _items = _repository.getInteractiveItems();
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

  void navigateToGame(BuildContext context, String gameUrl) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => _getGameScreen(gameUrl),
      ),
    );
  }

  void navigateToContent(BuildContext context, String contentRoute) {
    Navigator.pushNamed(context, contentRoute);
  }

  void navigateToOnboarding(BuildContext context, String onboardingRoute) {
    Navigator.pushNamed(context, onboardingRoute);
  }

  Widget _getGameScreen(String gameUrl) {
    switch (gameUrl) {
      case 'https://arabicgme.netlify.app/':
        return const ArabicGameScreen();
      case 'https://englishlettergame333.netlify.app/':
        return const ArabicGameScreen();
      case 'https://colorgame22222.netlify.app/':
        return const ArabicGameScreen();
      case 'https://animalgame22222.netlify.app/':
        return const ArabicGameScreen();
      case 'https://clean22222.netlify.app/':
        return const ArabicGameScreen();
      default:
        return Container();
    }
  }
}