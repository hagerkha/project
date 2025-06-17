import 'package:flutter/material.dart';
import 'games/color_game.dart'; // استيراد كلاس ColorGame

class OnBordaingColorIntroScreen extends StatefulWidget {
  final VoidCallback onContinue;

  const OnBordaingColorIntroScreen({Key? key, required this.onContinue}) : super(key: key);

  @override
  State<OnBordaingColorIntroScreen> createState() => _OnBordaingColorIntroScreenState();
}

class _OnBordaingColorIntroScreenState extends State<OnBordaingColorIntroScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<String> imagePaths = [
    'assets/videos/color/r.jpg',
    'assets/videos/color/b.jpg',
    'assets/videos/color/w.jpg',
    'assets/videos/color/y.jpg',
    'assets/videos/color/br.jpg',
    'assets/videos/color/bi.jpg',
    'assets/videos/color/g.jpg',
    'assets/videos/color/bl.jpg',
  ];

  void _onPageChanged(int index) {
    setState(() {
      _currentPage = index;
    });
  }

  void _handleNextButton() {
    if (_currentPage == imagePaths.length - 1) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const ColorGame()),
      );
    } else {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('الألوان'),
        backgroundColor: const Color(0xFFFF9F9F),
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: _onPageChanged,
              itemCount: imagePaths.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Image.asset(
                    imagePaths[index],
                    fit: BoxFit.contain,
                  ),
                );
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              imagePaths.length,
                  (index) => AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.symmetric(horizontal: 5),
                height: 10,
                width: _currentPage == index ? 25 : 10,
                decoration: BoxDecoration(
                  color: _currentPage == index ? const Color(0xFFFF9F9F) : Colors.grey[300],
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _handleNextButton,
                icon: const Icon(Icons.play_circle_fill),
                label: Text(_currentPage == imagePaths.length - 1 ? 'ابدأ اللعبة' : 'التالي'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF9F9F),
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
