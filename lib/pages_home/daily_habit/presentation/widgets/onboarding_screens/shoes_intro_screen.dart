import 'package:flutter/material.dart';

class ShoeIntroScreen extends StatefulWidget {
  final VoidCallback onContinue;

  const ShoeIntroScreen({Key? key, required this.onContinue}) : super(key: key);

  @override
  State<ShoeIntroScreen> createState() => _ShoeIntroScreenState();
}

class _ShoeIntroScreenState extends State<ShoeIntroScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<String> imagePaths = [
    'assets/videos/shose/1.jpg', 'assets/videos/shose/2.jpg', 'assets/videos/shose/3.jpg',
    'assets/videos/shose/4.jpg', 'assets/videos/shose/5.jpg',
  ];

  void _onPageChanged(int index) => setState(() => _currentPage = index);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('لبس الحذاء'), backgroundColor: const Color(0xFFd39593)),
      body: Column(
        children: [
          const SizedBox(height: 20),
          Expanded(child: PageView.builder(
            controller: _pageController,
            onPageChanged: _onPageChanged,
            itemCount: imagePaths.length,
            itemBuilder: (context, index) => Padding(
              padding: const EdgeInsets.all(16.0),
              child: Image.asset(imagePaths[index], fit: BoxFit.contain),
            ),
          )),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: List.generate(imagePaths.length, (index) => AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            margin: const EdgeInsets.symmetric(horizontal: 5),
            height: 10,
            width: _currentPage == index ? 25 : 10,
            decoration: BoxDecoration(
              color: _currentPage == index ? const Color(0xFFd39593) : Colors.grey[300],
              borderRadius: BorderRadius.circular(5),
            ),
          ))),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  if (_currentPage == imagePaths.length - 1) widget.onContinue();
                  else _pageController.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
                },
                icon: const Icon(Icons.play_circle_fill),
                label: Text(_currentPage == imagePaths.length - 1 ? 'ابدأ الفيديو' : 'التالي'),
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