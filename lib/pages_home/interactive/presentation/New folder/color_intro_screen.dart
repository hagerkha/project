import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../logic/interactive_view_model.dart';

class ColorIntroScreen extends StatefulWidget {
  const ColorIntroScreen({super.key});

  @override
  State<ColorIntroScreen> createState() => _ColorIntroScreenState();
}

class _ColorIntroScreenState extends State<ColorIntroScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<String> imagePaths = [
    'assets/videos/color/r.jpg', 'assets/videos/color/b.jpg', 'assets/videos/color/w.jpg',
    'assets/videos/color/y.jpg', 'assets/videos/color/br.jpg', 'assets/videos/color/bi.jpg',
    'assets/videos/color/g.jpg', 'assets/videos/color/bl.jpg',
  ];

  void _onPageChanged(int index) => setState(() => _currentPage = index);

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
              itemBuilder: (context, index) => Padding(
                padding: const EdgeInsets.all(16.0),
                child: Image.asset(imagePaths[index], fit: BoxFit.contain),
              ),
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
                onPressed: () {
                  if (_currentPage == imagePaths.length - 1) {
                    Provider.of<InteractiveViewModel>(context, listen: false)
                        .navigateToGame(context, 'https://colorgame22222.netlify.app/');
                  } else {
                    _pageController.nextPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  }
                },
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