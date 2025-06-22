import 'package:flutter/material.dart';

class SocialSituationModel {
  final String id;
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final String? videoPath;
  final String? onboardingRoute;

  SocialSituationModel({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    this.videoPath,
    this.onboardingRoute,
  });

  static List<SocialSituationModel> getSocialSituations() {
    return [
      SocialSituationModel(
        id: 'dealing_with_others',
        title: 'التعامل مع الآخرين',
        description: 'تعلم كيف تتعامل بأدب واحترام مع من حولك في مختلف المواقف الاجتماعية.',
        icon: Icons.group,
        color: const Color(0xFF0415A5),
        videoPath: 'assets/videos/others.mp4',
      ),
      SocialSituationModel(
        id: 'feelings_expressions',
        title: 'المشاعر والتعابير',
        description: 'تعرف على كيفية التعرف على مشاعرك والتعبير عنها بطريقة صحية.',
        icon: Icons.sentiment_satisfied,
        color: const Color(0xFF430202),
        videoPath: 'assets/videos/feeling.mp4',
        onboardingRoute: '/feelings_intro',
      ),
      SocialSituationModel(
        id: 'helping_others',
        title: 'مساعدة الآخرين',
        description: 'تعلم أهمية التعاون ومساعدة الآخرين في حياتك اليومية.',
        icon: Icons.volunteer_activism,
        color: const Color(0xFF015985),
        videoPath: 'assets/videos/helping.mp4',
      ),
    ];
  }
}