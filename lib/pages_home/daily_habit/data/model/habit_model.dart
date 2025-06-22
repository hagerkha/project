import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HabitModel {
  final String id;
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final String videoPath;
  final String onboardingImages;

  HabitModel({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.videoPath,
    required this.onboardingImages,
  });

  static List<HabitModel> getHabits() {
    return [
      HabitModel(
        id: 'food_etiquette',
        title: 'آداب الطعام',
        description: 'تعلم السلوكيات الصحيحة لتناول الطعام بأدب واحترام في جميع الأوقات.',
        icon: Icons.restaurant_menu,
        color: const Color(0xFF030B4E),
        videoPath: 'assets/videos/food_etiquette.mp4',
        onboardingImages: 'assets/videos/food/',
      ),
      HabitModel(
        id: 'brushing_teeth',
        title: 'غسل الأسنان',
        description: 'حافظ على ابتسامة صحية ونظيفة بتعلم الطريقة الصحيحة لغسل أسنانك.',
        icon: Icons.brush,
        color: const Color(0xFFC31010),
        videoPath: 'assets/videos/brushing_teeth.mp4',
        onboardingImages: 'assets/videos/',
      ),
      HabitModel(
        id: 'wash_hands',
        title: 'غسل اليدين',
        description: 'تجنب الجراثيم وحافظ على نظافتك الشخصية بمعرفة أهمية غسل اليدين بالطريقة الصحيحة.',
        icon: Icons.wash,
        color: const Color(0xFF010668),
        videoPath: 'assets/videos/washing_hands.mp4',
        onboardingImages: 'assets/videos/wash_hands/',
      ),
      HabitModel(
        id: 'wearing_shoes',
        title: 'لبس الحذاء',
        description: 'استكشف كيفية ارتداء حذائك بشكل صحيح ومريح لرحلاتك اليومية.',
        icon: Icons.directions_walk,
        color: const Color(0xFF712200),
        videoPath: 'assets/videos/wearing_shoes.mp4',
        onboardingImages: 'assets/videos/shose/',
      ),
    ];
  }
}