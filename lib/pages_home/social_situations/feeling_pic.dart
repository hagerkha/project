import 'package:flutter/material.dart';

class FeelingsIntroScreen extends StatefulWidget {
  final VoidCallback onContinue;

  const FeelingsIntroScreen({Key? key, required this.onContinue}) : super(key: key);

  @override
  State<FeelingsIntroScreen> createState() => _FeelingsIntroScreenState();
}

class _FeelingsIntroScreenState extends State<FeelingsIntroScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<String> imagePaths = [
    'assets/videos/fear.jpg',
    'assets/videos/shok.jpg',
    'assets/videos/happy.jpg',
    'assets/videos/bad.jpg',
    'assets/videos/sad.jpg',
  ];

  void _onPageChanged(int index) {
    setState(() {
      _currentPage = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('المشاعر والتعبيرات'),
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
                  color: _currentPage == index
                      ? const Color(0xFFFF9F9F)
                      : Colors.grey[300],
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
                    widget.onContinue();
                  } else {
                    _pageController.nextPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  }
                },
                icon: const Icon(Icons.play_circle_fill),
                label: Text(
                  _currentPage == imagePaths.length - 1
                      ? 'ابدأ الفيديو'
                      : 'التالي',
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF9F9F),
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
