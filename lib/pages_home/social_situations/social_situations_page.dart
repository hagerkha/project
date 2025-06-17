import 'package:flutter/material.dart';

import '../daily_habit/habitcard.dart';
import '../daily_habit/videos.dart';
import 'feeling_pic.dart';

class SocialSituationsPage extends StatefulWidget {
  const SocialSituationsPage({super.key});

  @override
  State<SocialSituationsPage> createState() => _SocialSituationsPageState();
}

class _SocialSituationsPageState extends State<SocialSituationsPage> {
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
          'المواقف الاجتماعية',
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
                      // التعامل مع الآخرين
                      HabitCard(
                        icon: Icons.group,
                        title: 'التعامل مع الآخرين',
                        description: 'تعلم كيف تتعامل بأدب واحترام مع من حولك في مختلف المواقف الاجتماعية.',
                        color: const Color(0xFF0415A5),
                        onTap: () => _playAssetVideo(context, 'assets/videos/others.mp4', 'التعامل مع الآخرين'),
                      ),
                      const SizedBox(height: 15),
                      // المشاعر والتعابير
                      HabitCard(
                        icon: Icons.sentiment_satisfied,
                        title: 'المشاعر والتعابير',
                        description: 'تعرف على كيفية التعرف على مشاعرك والتعبير عنها بطريقة صحية.',
                        color: const Color(0xFF430202),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => FeelingsIntroScreen(
                                onContinue: () => _playAssetVideo(context, 'assets/videos/feeling.mp4', 'المشاعر والتعابير'),
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 15),
                      // مساعدة الآخرين
                      HabitCard(
                        icon: Icons.volunteer_activism,
                        title: 'مساعدة الآخرين',
                        description: 'تعلم أهمية التعاون ومساعدة الآخرين في حياتك اليومية.',
                        color: const Color(0xFF015985),
                        onTap: () => _playAssetVideo(context, 'assets/videos/helping.mp4', 'مساعدة الآخرين'),
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
