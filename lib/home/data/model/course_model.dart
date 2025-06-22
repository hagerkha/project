import 'package:flutter/cupertino.dart';

class CourseModel {
  final String title;
  final String subtitle;
  final String routeName;
  final IconData icon;
  final String imagePath;

  CourseModel({
    required this.title,
    required this.subtitle,
    required this.routeName,
    required this.icon,
    required this.imagePath,
  });
}