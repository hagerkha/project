import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../daily_habit/habitcard.dart';
import '../daily_habit/videos.dart';
import 'contact_game/contact_arabic.dart';
import 'contact_game/english_contact.dart';
import 'games/arabic_game.dart';
import 'games/color_game.dart';
import 'games/englishgame.dart';
import 'maths/maths.dart';
import 'on_bordaing_color.dart';
import 'games/help_game.dart';

class MainInteractivePage extends StatefulWidget {
  const MainInteractivePage({super.key});

  @override
  State<MainInteractivePage> createState() => _MainInteractivePageState();
}

class _MainInteractivePageState extends State<MainInteractivePage> {
  void _playAssetVideo(BuildContext context, String assetPath, String videoTitle) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VideoPlayerScreen(
          videoPath: assetPath,
          videoTitle: videoTitle,
        ),
      ),
    );
  }

  void _openAnimalGame() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const EnglishGameWebPage()),
    );
  }

  void _openSportsPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const GridSportsPage()),
    );
  }

  void _openHelpGame() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const HelpGame()),
    );
  }

  void _openArabicContent() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ContactArabicPage()),
    );
  }

  void _openArabicGame() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ArabicGamePage()),
    );
  }

  void _openEnglishContent() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ContactEnglishPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Background image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('images/33.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Scrollable content
          SafeArea(
            child: Align(
              alignment: Alignment.center,
              child: Container(
                height: MediaQuery.of(context).size.height * 0.75, // Increased height for larger scrollable area
                margin: const EdgeInsets.symmetric(horizontal: 26, vertical: 20),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 20),
                      const Text(
                        'التعليم التفاعلي',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                        ),
                      ),
                      const SizedBox(height: 20),
                      // اللغة العربية
                      HabitCard(
                        icon: Icons.language,
                        title: 'قسم حروف اللغه العربية',
                        description: 'تعلم اللغة العربية بطريقة تفاعلية.',
                        color: const Color(0xFF030B4E),
                        onTap: () {},
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          children: [
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  _playAssetVideo(context, 'assets/videos/arabic.mp4', 'اللغة العربية');
                                },
                                icon: const Icon(Icons.play_arrow),
                                label: const Text('تشغيل الفيديو'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  foregroundColor: Colors.black,
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: _openArabicGame,
                                icon: const Icon(Icons.videogame_asset),
                                label: const Text('لعبة اللغة العربية'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  foregroundColor: Colors.black,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        child: ElevatedButton.icon(
                          onPressed: _openArabicContent,
                          icon: const Icon(Icons.book),
                          label: const Text('محتوى اللغة العربية'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.black,
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                      // اللغة الإنجليزية
                      HabitCard(
                        icon: Icons.eco,
                        title: 'قسم الحروف الإنجليزية',
                        description: 'تعلم الحروف الإنجليزية بطريقة تفاعلية.',
                        color: const Color(0xFFE91E63),
                        onTap: () {},
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          children: [
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  _playAssetVideo(context, 'assets/videos/english.mp4', 'اللغة الإنجليزية');
                                },
                                icon: const Icon(Icons.play_arrow),
                                label: const Text('تشغيل الفيديو'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  foregroundColor: Colors.black,
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: _openAnimalGame,
                                icon: const Icon(Icons.videogame_asset),
                                label: const Text('لعبة للغة الإنجليزية'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  foregroundColor: Colors.black,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        child: ElevatedButton.icon(
                          onPressed: _openEnglishContent,
                          icon: const Icon(Icons.book),
                          label: const Text('محتوى للغة الإنجليزية'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.black,
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                      // الألوان
                      HabitCard(
                        icon: Icons.color_lens,
                        title: 'قسم الألوان',
                        description: 'تعلم الألوان من خلال صور تمهيدية تفاعلية ولعبة ممتعة.',
                        color: const Color(0xFF2196F3),
                        onTap: () {},
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          children: [
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  _playAssetVideo(context, 'assets/videos/color.mp4', 'الألوان');
                                },
                                icon: const Icon(Icons.play_arrow),
                                label: const Text('تشغيل الفيديو'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  foregroundColor: Colors.black,
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => OnBordaingColorIntroScreen(
                                        onContinue: () {
                                          Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(builder: (context) => const ColorGame()),
                                          );
                                        },
                                      ),
                                    ),
                                  );
                                },
                                icon: const Icon(Icons.videogame_asset),
                                label: const Text('لعبة الألوان'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  foregroundColor: Colors.black,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 15),
                      // الحفاظ على البيئة
                      HabitCard(
                        icon: Icons.eco,
                        title: 'الحفاظ على البيئة',
                        description: 'تعلم كيف نحافظ على بيئتنا.',
                        color: const Color(0xFF4CAF50),
                        onTap: () {},
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        child: ElevatedButton.icon(
                          onPressed: () {
                            _playAssetVideo(context, 'assets/videos/environ.mp4', 'الحفاظ على البيئة');
                          },
                          icon: const Icon(Icons.play_arrow),
                          label: const Text('تشغيل الفيديو'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.black,
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                      // الحيوانات
                      HabitCard(
                        icon: Icons.pets,
                        title: 'الحيوانات',
                        description: 'تعرف على الحيوانات بطريقة ممتعة وتفاعلية.',
                        color: const Color(0xFFF44336),
                        onTap: () {},
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          children: [
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  _playAssetVideo(context, 'assets/videos/animal.mp4', 'فيديو الحيوانات');
                                },
                                icon: const Icon(Icons.play_arrow),
                                label: const Text('تشغيل الفيديو'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  foregroundColor: Colors.black,
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: _openAnimalGame,
                                icon: const Icon(Icons.videogame_asset),
                                label: const Text('لعبة الحيوانات'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  foregroundColor: Colors.black,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 15),
                      // النظافة
                      HabitCard(
                        icon: Icons.cleaning_services,
                        title: 'مساعدة على النظافة',
                        description: 'تعلم الأطفال كيفية الحفاظ على النظافة ومساعدة الآخرين.',
                        color: const Color(0xFFFF9800),
                        onTap: () {},
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          children: [
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  _playAssetVideo(context, 'assets/videos/help.mp4', 'مساعدة الآخرين');
                                },
                                icon: const Icon(Icons.play_arrow),
                                label: const Text('تشغيل الفيديو'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  foregroundColor: Colors.black,
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: _openHelpGame,
                                icon: const Icon(Icons.videogame_asset),
                                label: const Text('لعبة مساعدة الآخرين'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  foregroundColor: Colors.black,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 15),
                      // الحساب
                      HabitCard(
                        icon: Icons.sports,
                        title: 'الحساب',
                        description: 'تعلم من خلال التمارين التفاعلية والأنشطة الرياضية.',
                        color: const Color(0xFF673AB7),
                        onTap: () {},
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        child: ElevatedButton(
                          onPressed: _openSportsPage,
                          child: const Text('الانتقال إلى قسم الرياضة'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.black,
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                    ],
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