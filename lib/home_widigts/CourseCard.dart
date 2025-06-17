import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
class CourseCard extends StatelessWidget {
  final String title;
  final Color color;
  final IconData icon;
  final String? imagePath;
  final AnimationController animationController;
  final int delay;
  final VoidCallback onTap;

  const CourseCard({
    Key? key,
    required this.title,
    required this.color,
    required this.icon,
    this.imagePath,
    required this.animationController,
    this.delay = 0,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: animationController,
        curve: Interval(
          delay / 1000,
          (delay + 600) / 1000,
          curve: Curves.easeInOut,
        ),
      ),
    );

    final slideAnimation = Tween<Offset>(
      begin: const Offset(0, 20),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: animationController,
        curve: Interval(
          delay / 1000,
          (delay + 600) / 1000,
          curve: Curves.easeOutCubic,
        ),
      ),
    );

    return GestureDetector(
      onTap: onTap,
      child: AnimatedBuilder(
        animation: animationController,
        builder: (context, child) {
          return Opacity(
            opacity: fadeAnimation.value,
            child: Transform.translate(
              offset: slideAnimation.value,
              child: Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                    color: color.withOpacity(0.3),
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 5,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    // صورة أو أيقونة داخل دائرة
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                        border: Border.all(
                          color: color.withOpacity(0.4),
                          width: 2,
                        ),
                      ),
                      child: imagePath != null
                          ? ClipOval(
                        child: Image.asset(
                          imagePath!,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Icon(
                              icon,
                              color: color,
                              size: 28,
                            );
                          },
                        ),
                      )
                          : Icon(
                        icon,
                        color: color,
                        size: 28,
                      ),
                    ),

                    SizedBox(width: 15),

                    // العنوان
                    Expanded(
                      child: Text(
                        title,
                        style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.w500,
                          color: color,
                        ),
                        textAlign: TextAlign.right,
                      ),
                    ),

                    SizedBox(width: 10),

                    // سهم
                    Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.pink[300],
                      size: 18,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
