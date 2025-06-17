import 'package:flutter/material.dart';
import 'package:authenticationapp/pages_home/daily_habit/videos.dart';
import 'habitcard.dart';
import 'on_bording/food_onbirdaing.dart';
import 'on_bording/onbordaing_teeth.dart';
import 'on_bording/onbording_shos.dart';
import 'on_bording/onbording_wash.dart';

class DailyHabitsPage extends StatefulWidget {
  const DailyHabitsPage({super.key});

  @override
  State<DailyHabitsPage> createState() => _DailyHabitsPageState();
}

class _DailyHabitsPageState extends State<DailyHabitsPage> {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                height: MediaQuery.of(context).size.height * 0.6,
                margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // آداب الطعام
                      HabitCard(
                        icon: Icons.restaurant_menu,
                        title: 'آداب الطعام',
                        description: 'تعلم السلوكيات الصحيحة لتناول الطعام بأدب واحترام في جميع الأوقات.',
                        color: const Color(0xFF030B4E),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => FoodIntroScreen(
                                onContinue: () => _playAssetVideo(
                                  context,
                                  'assets/videos/food_etiquette.mp4',
                                  'آداب الطعام',
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 15),
                      // غسل الأسنان
                      HabitCard(
                        icon: Icons.brush,
                        title: 'غسل الأسنان',
                        description: 'حافظ على ابتسامة صحية ونظيفة بتعلم الطريقة الصحيحة لغسل أسنانك.',
                        color: const Color(0xFFC31010),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BrushingTeethIntroScreen(
                                onContinue: () => _playAssetVideo(
                                  context,
                                  'assets/videos/brushing_teeth.mp4',
                                  'غسل الأسنان',
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 15),
                      // غسل اليدين
                      HabitCard(
                        icon: Icons.wash,
                        title: 'غسل اليدين',
                        description: 'تجنب الجراثيم وحافظ على نظافتك الشخصية بمعرفة أهمية غسل اليدين بالطريقة الصحيحة.',
                        color: const Color(0xFF010668),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => WashHandsIntroScreen(
                                onContinue: () => _playAssetVideo(
                                  context,
                                  'assets/videos/washing_hands.mp4',
                                  'غسل اليدين',
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 15),
                      // لبس الحذاء
                      HabitCard(
                        icon: Icons.directions_walk,
                        title: 'لبس الحذاء',
                        description: 'استكشف كيفية ارتداء حذائك بشكل صحيح ومريح لرحلاتك اليومية.',
                        color: const Color(0xFF712200),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ShoeIntroScreen(
                                onContinue: () => _playAssetVideo(
                                  context,
                                  'assets/videos/wearing_shoes.mp4',
                                  'لبس الحذاء',
                                ),
                              ),
                            ),
                          );
                        },
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
