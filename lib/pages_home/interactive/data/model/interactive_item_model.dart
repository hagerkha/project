import 'package:flutter/material.dart';

class InteractiveItemModel {
  final String id;
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final String? videoPath;
  final String? gameUrl;
  final String? contentRoute;
  final String? onboardingRoute;

  InteractiveItemModel({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    this.videoPath,
    this.gameUrl,
    this.contentRoute,
    this.onboardingRoute,
  });

  static List<InteractiveItemModel> getInteractiveItems() {
    return [
      InteractiveItemModel(
        id: 'arabic',
        title: 'قسم حروف اللغة العربية',
        description: 'تعلم اللغة العربية بطريقة تفاعلية.',
        icon: Icons.language,
        color: const Color(0xFF030B4E),
        videoPath: 'assets/videos/arabic.mp4',
        gameUrl: 'https://arabicgme.netlify.app/',
        contentRoute: '/arabic_content',
      ),
      InteractiveItemModel(
        id: 'english',
        title: 'قسم الحروف الإنجليزية',
        description: 'تعلم الحروف الإنجليزية بطريقة تفاعلية.',
        icon: Icons.eco,
        color: const Color(0xFFE91E63),
        videoPath: 'assets/videos/english.mp4',
        gameUrl: 'https://englishlettergame333.netlify.app/',
        contentRoute: '/english_content',
      ),
      InteractiveItemModel(
        id: 'colors',
        title: 'قسم الألوان',
        description: 'تعلم الألوان من خلال صور تمهيدية تفاعلية ولعبة ممتعة.',
        icon: Icons.color_lens,
        color: const Color(0xFF2196F3),
        videoPath: 'assets/videos/color.mp4',
        gameUrl: 'https://colorgame22222.netlify.app/',
        onboardingRoute: '/color_intro',
      ),
      InteractiveItemModel(
        id: 'environment',
        title: 'الحفاظ على البيئة',
        description: 'تعلم كيف نحافظ على بيئتنا.',
        icon: Icons.eco,
        color: const Color(0xFF4CAF50),
        videoPath: 'assets/videos/environ.mp4',
      ),
      InteractiveItemModel(
        id: 'animals',
        title: 'الحيوانات',
        description: 'تعرف على الحيوانات بطريقة ممتعة وتفاعلية.',
        icon: Icons.pets,
        color: const Color(0xFFF44336),
        videoPath: 'assets/videos/animal.mp4',
        gameUrl: 'https://animalgame22222.netlify.app/',
      ),
      InteractiveItemModel(
        id: 'cleaning',
        title: 'مساعدة على النظافة',
        description: 'تعلم الأطفال كيفية الحفاظ على النظافة ومساعدة الآخرين.',
        icon: Icons.cleaning_services,
        color: const Color(0xFFFF9800),
        videoPath: 'assets/videos/help.mp4',
        gameUrl: 'https://clean22222.netlify.app/',
      ),
      InteractiveItemModel(
        id: 'math',
        title: 'الحساب',
        description: 'تعلم من خلال التمارين التفاعلية والأنشطة الرياضية.',
        icon: Icons.sports,
        color: const Color(0xFF673AB7),
        contentRoute: '/math_sports',
      ),
    ];
  }
}