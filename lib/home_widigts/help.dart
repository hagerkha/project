import 'package:flutter/material.dart';

import 'home.dart';

class HelpPage extends StatelessWidget {
  const HelpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const MainPage()),
            );
          },
        ),
        title: const Text(
          'المساعدة',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.home, color: Colors.black),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const MainPage()),
              );
            },
          ),
        ],
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
                      const SizedBox(height: 20),
                      // تعليمات استخدام الألعاب
                      const HelpCard(
                        icon: Icons.games,
                        title: 'تعليمات استخدام الألعاب',
                        description: '1. افتح اللعبة واضغط على الشكل المطلوب.\n'
                            '2. في لعبة المحافظة ع البيئة اسحب الشكل إلى المكان الصحيح.\n'
                            '3. في اللعبة الإنجليزية إذا ضغطت على مكان خارج الإطار، سيعتبر ذلك خطأ.\n'
                            '4. في لعبة الحروف العربية تم وضع ثلاث محاولات للطالب للإجابة.',
                        color: Color(0xFF030B4E), // Navy Blue
                      ),
                      const SizedBox(height: 15),
                      // كيفية بدء التعلم
                      const HelpCard(
                        icon: Icons.play_circle_outline,
                        title: 'كيفية بدء التعلم',
                        description: 'اضغط على أي مادة تعليمية لبدء التعلم. ابدأ بالمستوى الأول واتقدم تدريجيًا.',
                        color: Color(0xFFC31010), // Vivid Red
                      ),
                      const SizedBox(height: 15),
                      // تحديث الملف الشخصي
                      const HelpCard(
                        icon: Icons.account_circle,
                        title: 'تحديث الملف الشخصي',
                        description: 'اضغط على صورتك الشخصية أو زر الإعدادات لتحديث اسمك وصورتك.',
                        color: Color(0xFF010668), // Deep Blue
                      ),
                      const SizedBox(height: 15),
                      // المساعد الصوتي
                      const HelpCard(
                        icon: Icons.chat,
                        title: 'المساعد الصوتي',
                        description: 'استخدم زر الدردشة للحصول على مساعدة فورية ونصائح تعليمية.',
                        color: Color(0xFF712200), // Deep Brown
                      ),
                      const SizedBox(height: 15),
                      // التنقل في التطبيق
                      const HelpCard(
                        icon: Icons.navigation,
                        title: 'التنقل في التطبيق',
                        description: 'استخدم الأزرار السفلية للتنقل بين أقسام التطبيق المختلفة.',
                        color: Color(0xFFE91E63), // Vivid Pink (extended palette)
                      ),
                      const SizedBox(height: 15),
                      // تتبع التقدم
                      const HelpCard(
                        icon: Icons.star,
                        title: 'تتبع التقدم',
                        description: 'راقب تقدمك في كل مادة من خلال النجوم والمستويات المكملة.',
                        color: Color(0xFF2196F3), // Bright Blue (extended palette)
                      ),
                      const SizedBox(height: 30),
                      // Contact Section
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: const Color(0xFF030B4E).withOpacity(0.1), // Matching navy blue
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(
                            color: const Color(0xFF030B4E).withOpacity(0.3),
                          ),
                        ),
                        child: const Column(
                          children: [
                            Icon(
                              Icons.support_agent,
                              size: 50,
                              color: Color(0xFF030B4E), // Matching navy blue
                            ),
                            SizedBox(height: 10),
                            Text(
                              'هل تحتاج مساعدة إضافية؟',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF030B4E), // Navy blue
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              'فريق الدعم متاح لمساعدتك في أي وقت',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                          ],
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

// HelpCard Widget
class HelpCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final Color color;

  const HelpCard({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: color.withOpacity(0.3),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: color,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    color: color,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: color.withOpacity(0.8),
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}