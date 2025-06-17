import 'dart:async';
import 'dart:math' show pi, sin;
import 'package:authenticationapp/signup.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'forgot_password.dart';
import 'home_widigts/home.dart' hide Home;

class LogIn extends StatefulWidget {
  const LogIn({super.key});

  @override
  State<LogIn> createState() => _LogInState();
}

class _LogInState extends State<LogIn> with SingleTickerProviderStateMixin {
  String email = "", password = "";
  bool _isPasswordVisible = false;
  bool _isAnimationRunning = false;
  bool _isLoading = false; // Added to track login progress

  late AnimationController _animationController;
  late Animation<double> _glowAnimation;
  late Animation<Color?> _gradientAnimation;

  double _cloud1Position = 0;
  double _cloud2Position = 0;
  double _cloudWaveOffset = 0;

  TextEditingController mailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  late FocusNode _emailFocusNode;
  late FocusNode _passwordFocusNode;

  @override
  void initState() {
    super.initState();

    _emailFocusNode = FocusNode();
    _passwordFocusNode = FocusNode();
    _emailFocusNode.addListener(_handleFocusChange);
    _passwordFocusNode.addListener(_handleFocusChange);

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    );

    _glowAnimation = Tween<double>(begin: 0.3, end: 0.6).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    _gradientAnimation = ColorTween(
      begin: const Color(0xFFB0C4DE),
      end: const Color(0xFFADD8E6),
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
  }

  void _handleFocusChange() {
    if (_emailFocusNode.hasFocus || _passwordFocusNode.hasFocus) {
      _isAnimationRunning = false;
      _animationController.stop();
    }
    setState(() {});
  }

  void _toggleAnimation() {
    setState(() {
      if (_isAnimationRunning) {
        _animationController.stop();
        _isAnimationRunning = false;
      } else {
        _animationController.repeat(reverse: true);
        _isAnimationRunning = true;
        _startCloudAnimation();
      }
    });
  }

  void _startCloudAnimation() {
    Timer.periodic(const Duration(milliseconds: 100), (timer) {
      if (mounted && _isAnimationRunning && !_emailFocusNode.hasFocus && !_passwordFocusNode.hasFocus) {
        setState(() {
          _cloud1Position += 0.2;
          _cloud2Position -= 0.15;
          _cloudWaveOffset += 0.02;

          if (_cloud1Position > MediaQuery.of(context).size.width) {
            _cloud1Position = -40;
          }
          if (_cloud2Position < -40) {
            _cloud2Position = MediaQuery.of(context).size.width;
          }
        });
      } else {
        timer.cancel();
      }
    });
  }

  Future<void> userLogin() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true; // Show loading indicator
        email = mailController.text.trim();
        password = passwordController.text;
      });

      try {
        await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: email, password: password)
            .timeout(const Duration(seconds: 10), onTimeout: () {
          throw FirebaseAuthException(
            code: 'timeout',
            message: 'الرجاء التحقق من الإنترنت والمحاولة مجددًا.',
          );
        });

        if (!mounted) return; // Ensure widget is still mounted

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MainPage()), // Changed to Home
        );
      } catch (e) {
        if (!mounted) return; // Ensure widget is still mounted

        String message;
        if (e is FirebaseAuthException) {
          switch (e.code) {
            case 'user-not-found':
              message = "لا يوجد حساب بهذا البريد الإلكتروني";
              break;
            case 'wrong-password':
              message = "كلمة المرور غير صحيحة";
              break;
            case 'invalid-email':
              message = "البريد الإلكتروني غير صحيح";
              break;
            case 'timeout':
              message = "تأكد من الإنترنت وحاول مجددًا";
              break;
            default:
              message = "حدث خطأ: ${e.message ?? 'غير معروف'}";
          }
        } else {
          message = "حدث خطأ غير متوقع: $e";
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
            duration: const Duration(seconds: 4),
          ),
        );
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false; // Hide loading indicator
          });
        }
      }
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    _emailFocusNode.removeListener(_handleFocusChange);
    _passwordFocusNode.removeListener(_handleFocusChange);
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
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
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 20),
                          child: const Text(
                            'مرحبًا! سجّل الدخول الآن',
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
                              controller: mailController,
                              focusNode: _emailFocusNode,
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
                              controller: passwordController,
                              focusNode: _passwordFocusNode,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'أدخل كلمة المرور';
                                }
                                return null;
                              },
                              obscureText: !_isPasswordVisible,
                              textAlign: TextAlign.right,
                              style: const TextStyle(
                                fontSize: 28,
                                fontFamily: 'ArabicTransparent',
                              ),
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "كلمة المرور",
                                hintStyle: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 24,
                                  fontFamily: 'ArabicTransparent',
                                ),
                                prefixIcon: const Icon(
                                  Icons.lock,
                                  size: 40,
                                  color: Colors.blue,
                                ),
                                suffixIcon: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      _isPasswordVisible = !_isPasswordVisible;
                                    });
                                  },
                                  icon: Icon(
                                    _isPasswordVisible
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                    color: Colors.grey,
                                    size: 30,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 30),
                          GestureDetector(
                            onTap: _isLoading ? null : userLogin, // Disable button while loading
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.8,
                              padding: const EdgeInsets.symmetric(
                                  vertical: 15, horizontal: 20),
                              decoration: BoxDecoration(
                                color: _isLoading
                                    ? const Color(0xFF4682B4).withOpacity(0.5)
                                    : const Color(0xFF4682B4),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Semantics(
                                label: "زر تسجيل الدخول",
                                child: Center(
                                  child: _isLoading
                                      ? const CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  )
                                      : const Text(
                                    "تسجيل الدخول",
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
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                PageRouteBuilder(
                                  pageBuilder:
                                      (context, animation, secondaryAnimation) =>
                                  const ForgotPassword(),
                                  transitionsBuilder:
                                      (context, animation, secondaryAnimation, child) {
                                    return FadeTransition(
                                      opacity: animation,
                                      child: child,
                                    );
                                  },
                                  transitionDuration: const Duration(milliseconds: 500),
                                ),
                              );
                            },
                            child: const Text(
                              "نسيت كلمة المرور؟",
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 24,
                                fontFamily: 'ArabicTransparent',
                              ),
                            ),
                          ),
                          const Spacer(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                "ليس لديك حساب؟",
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
                                    PageRouteBuilder(
                                      pageBuilder:
                                          (context, animation, secondaryAnimation) =>
                                      const SignUp(),
                                      transitionsBuilder:
                                          (context, animation, secondaryAnimation, child) {
                                        return SlideTransition(
                                          position: Tween<Offset>(
                                            begin: const Offset(1, 0),
                                            end: Offset.zero,
                                          ).animate(animation),
                                          child: child,
                                        );
                                      },
                                      transitionDuration: const Duration(milliseconds: 500),
                                    ),
                                  );
                                },
                                child: const Text(
                                  "سجّل الآن",
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
        ],
      ),
    );
  }
}