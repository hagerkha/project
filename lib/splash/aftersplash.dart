import 'package:flutter/material.dart';

import '../service/presentaion/screen/login_screen.dart';
import 'onboarding_screen.dart';

class AfterSplashScreen extends StatelessWidget {
  const AfterSplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background Image
          Image.asset(
            'images/11.jpg',
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                color: Colors.grey[300],
                child: const Center(
                  child: Text(
                    'خطأ في تحميل الصورة',
                    style: TextStyle(fontSize: 20, color: Colors.red),
                  ),
                ),
              );
            },
          ),

          // Slightly right-shifted Image
          Align(
            alignment: const Alignment(0.4, 0.0), // من -1 إلى 1، 0.4 معناها محركه شويه يمين
            child: Image.asset(
              'images/12.jpg',
              width: MediaQuery.of(context).size.width * 0.8,
              height: MediaQuery.of(context).size.height * 0.3,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                return const Text(
                  'خطأ في تحميل الصورة المركزية',
                  style: TextStyle(fontSize: 16, color: Colors.red),
                );
              },
            ),
          ),

          // Buttons at t[he bottom
          Positioned(
            bottom: 40,
            left: 20,
            right: 20,
            child: Column(
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const OnboardingScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4682B4),
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 5,
                    textStyle: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'ArabicTransparent',
                    ),
                  ),
                  child: const Text('استكشاف التطبيق'),
                ),
                const SizedBox(height: 15),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const LoginScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: const Color(0xFF4682B4),
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                      side: const BorderSide(color: Color(0xFF4682B4), width: 2),
                    ),
                    elevation: 5,
                    textStyle: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'ArabicTransparent',
                    ),
                  ),
                  child: const Text('تسجيل الدخول'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
