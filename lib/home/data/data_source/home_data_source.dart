import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/course_model.dart';
import '../model/user_model.dart';

class HomeDataSource {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<CourseModel>> fetchCourses() async {
    // البيانات الحالية من home.dart كـ Default
    return [
      CourseModel(
        title: 'العادات اليومية',
        subtitle: 'تعلم العادات الصحية',
        routeName: '/dailyHabits',
        icon: Icons.schedule,
        imagePath: 'images/1.3.jpg',
      ),
      CourseModel(
        title: 'المواقف الاجتماعية',
        subtitle: 'تفاعل مع الآخرين',
        routeName: '/socialSituations',
        icon: Icons.people,
        imagePath: 'images/1.1 (1).jpg',
      ),
      CourseModel(
        title: 'التعليم التفاعلي',
        subtitle: 'دورة تعليمية تفاعلية',
        routeName: '/interactive',
        icon: Icons.school,
        imagePath: 'images/2.2.jpg',
      ),
    ];
  }

  Future<UserModel> fetchUserData() async {
    User? user = _auth.currentUser;
    if (user != null) {
      final prefs = await SharedPreferences.getInstance();
      final savedName = prefs.getString('user_name') ?? user.displayName ?? 'مستخدم';
      final savedPhotoUrl = prefs.getString('user_photo_url') ?? user.photoURL;
      return UserModel(name: savedName, photoUrl: savedPhotoUrl, email: user.email);
    }
    return UserModel(name: 'مستخدم', photoUrl: null, email: null);
  }
}