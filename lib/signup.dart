import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'home_widigts/home.dart';
import 'login.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> with TickerProviderStateMixin {
  String email = "", password = "", name = "";
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController mailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  // Animation variables
  late AnimationController _animationController;
  late Animation<Color?> _gradientAnimation;
  late Animation<double> _glowAnimation;
  double _cloud1Position = 50.0;
  double _cloud2Position = 50.0;
  double _cloudWaveOffset = 0.0;
  bool _isAnimationRunning = false; // تعطيل الرسوم المتحركة افتراضيًا

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4), // إبطاء الرسوم المتحركة
    );

    _gradientAnimation = ColorTween(
      begin: const Color(0xFFB0C4DE), // لون أزرق فاتح مريح
      end: const Color(0xFFADD8E6),
    ).animate(_animationController);

    _glowAnimation = Tween<double>(begin: 0.3, end: 0.6).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _animationController.addListener(() {
      if (_isAnimationRunning) {
        setState(() {
          _cloudWaveOffset += 0.02; // إبطاء حركة السحب
        });
      }
    });
  }

  void _toggleAnimation() {
    setState(() {
      _isAnimationRunning = !_isAnimationRunning;
      if (_isAnimationRunning) {
        _animationController.repeat(reverse: true);
      } else {
        _animationController.stop();
      }
    });
  }

  Future<void> registration() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
        email = mailController.text;
        name = nameController.text;
        password = passwordController.text;
      });

      try {
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: password)
            .timeout(const Duration(seconds: 10), onTimeout: () {
          throw FirebaseAuthException(
            code: 'timeout',
            message: 'الرجاء التحقق من الإنترنت والمحاولة مجددًا.',
          );
        });
        await userCredential.user!.updateDisplayName(name);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "تم التسجيل بنجاح!",
              style: const TextStyle(
                fontSize: 24.0,
                fontFamily: 'ArabicTransparent',
              ),
            ),
          ),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MainPage()),
        );
      } on FirebaseAuthException catch (e) {
        String message;
        switch (e.code) {
          case 'weak-password':
            message = "كلمة المرور ضعيفة جدًا";
            break;
          case 'email-already-in-use':
            message = "هذا الحساب موجود بالفعل";
            break;
          case 'invalid-email':
            message = "البريد الإلكتروني غير صحيح";
            break;
          case 'timeout':
            message = "تأكد من الإنترنت وحاول مجددًا";
            break;
          default:
            message = "حدث خطأ: ${e.message}";
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.orangeAccent,
            content: Text(
              message,
              style: const TextStyle(
                fontSize: 24.0,
                fontFamily: 'ArabicTransparent',
              ),
            ),
          ),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    nameController.dispose();
    mailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: MediaQuery.of(context).size.height * 0.3,
            child: AnimatedBuilder(
              animation: _gradientAnimation,
              builder: (context, child) {
                return Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        _isAnimationRunning
                            ? _gradientAnimation.value!
                            : const Color(0xFFB0C4DE),
                        _isAnimationRunning
                            ? _gradientAnimation.value!.withOpacity(0.7)
                            : const Color(0xFFB0C4DE).withOpacity(0.7),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                );
              },
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                Expanded(
                  flex: 2,
                  child: Stack(
                    children: [
                      Positioned(
                        top: 60,
                        left: _cloud1Position,
                        child: Transform.translate(
                          offset: Offset(
                              0, _isAnimationRunning ? 5 * sin(_cloudWaveOffset) : 0),
                          child: Image.asset(
                            'images/cloud.png',
                            width: 40,
                            height: 25,
                            color: Colors.white.withOpacity(0.7),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 90,
                        right: _cloud2Position,
                        child: Transform.translate(
                          offset: Offset(
                              0, _isAnimationRunning ? 5 * sin(_cloudWaveOffset + pi) : 0),
                          child: Image.asset(
                            'images/cloud.png',
                            width: 40,
                            height: 25,
                            color: Colors.white.withOpacity(0.7),
                          ),
                        ),
                      ),
                      Center(
                        child: RepaintBoundary(
                          child: AnimatedBuilder(
                            animation: _glowAnimation,
                            builder: (context, child) {
                              return Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  boxShadow: _isAnimationRunning
                                      ? [
                                    BoxShadow(
                                      color: Colors.white
                                          .withOpacity(0.2 * _glowAnimation.value),
                                      blurRadius: 15 * _glowAnimation.value,
                                      spreadRadius: 3 * _glowAnimation.value,
                                    ),
                                  ]
                                      : [],
                                ),
                                child: Image.asset(
                                  'images/7.png',
                                  height: 100,
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 20),
                          child: const Text(
                            'مرحبًا! سجّل الآن',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'ArabicTransparent',
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 10,
                        left: 10,
                        child: IconButton(
                          onPressed: _toggleAnimation,
                          icon: Icon(
                            _isAnimationRunning ? Icons.pause : Icons.play_arrow,
                            color: Colors.white,
                            size: 24,
                          ),
                          tooltip: _isAnimationRunning ? 'إيقاف الحركة' : 'تشغيل الحركة',
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 5,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 8, horizontal: 20),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF0F8FF),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: TextFormField(
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'أدخل اسمك';
                                }
                                return null;
                              },
                              controller: nameController,
                              textAlign: TextAlign.right,
                              style: const TextStyle(
                                fontSize: 28,
                                fontFamily: 'ArabicTransparent',
                              ),
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: "اسمك",
                                hintStyle: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 24,
                                  fontFamily: 'ArabicTransparent',
                                ),
                                prefixIcon: Icon(
                                  Icons.person,
                                  size: 40,
                                  color: Colors.blue,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 8, horizontal: 20),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF0F8FF),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: TextFormField(
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'أدخل بريدك الإلكتروني';
                                }
                                if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                                    .hasMatch(value)) {
                                  return 'البريد الإلكتروني غير صحيح';
                                }
                                return null;
                              },
                              controller: mailController,
                              textAlign: TextAlign.right,
                              style: const TextStyle(
                                fontSize: 28,
                                fontFamily: 'ArabicTransparent',
                              ),
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: "بريدك الإلكتروني",
                                hintStyle: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 24,
                                  fontFamily: 'ArabicTransparent',
                                ),
                                prefixIcon: Icon(
                                  Icons.email,
                                  size: 40,
                                  color: Colors.blue,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 8, horizontal: 20),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF0F8FF),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: TextFormField(
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'أدخل كلمة المرور';
                                }
                                if (value.length < 6) {
                                  return 'كلمة المرور يجب أن تكون 6 أحرف أو أكثر';
                                }
                                return null;
                              },
                              controller: passwordController,
                              textAlign: TextAlign.right,
                              style: const TextStyle(
                                fontSize: 28,
                                fontFamily: 'ArabicTransparent',
                              ),
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: "كلمة المرور",
                                hintStyle: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 24,
                                  fontFamily: 'ArabicTransparent',
                                ),
                                prefixIcon: Icon(
                                  Icons.lock,
                                  size: 40,
                                  color: Colors.blue,
                                ),
                              ),
                              obscureText: true,
                            ),
                          ),
                          const SizedBox(height: 30),
                          GestureDetector(
                            onTap: registration,
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.8,
                              padding: const EdgeInsets.symmetric(
                                  vertical: 15, horizontal: 20),
                              decoration: BoxDecoration(
                                color: const Color(0xFF4682B4),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Semantics(
                                label: "زر التسجيل",
                                child: const Center(
                                  child: Text(
                                    "سجّل الآن",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 28,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'ArabicTransparent',
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                "هل لديك حساب؟",
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 24,
                                  fontFamily: 'ArabicTransparent',
                                ),
                              ),
                              const SizedBox(width: 5),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => const LogIn()),
                                  );
                                },
                                child: const Text(
                                  "تسجيل الدخول",
                                  style: TextStyle(
                                    color: Color(0xFF4682B4),
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'ArabicTransparent',
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (_isLoading)
            const Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }
}