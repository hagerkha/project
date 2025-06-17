import 'package:authenticationapp/splash/aftersplash.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:device_preview/device_preview.dart';
import 'package:provider/provider.dart';

import 'chat/providers/chat_provider.dart';
import 'chat/providers/settings_provider.dart';
import 'chat/screens/home_screen.dart';
import 'forgot_password.dart';
import 'home_widigts/home.dart';
import 'login.dart';
import 'signup.dart';
import 'splash/onboarding_screen.dart';
import 'splash/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // تهيئة Firebase
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: "AIzaSyB9-iJ9MJ2FZR9Sq1Zi_bXoIloVtOPPJhc",
      authDomain: "kidsapp-d0a0d.firebaseapp.com",
      projectId: "kidsapp-d0a0d",
      storageBucket: "kidsapp-d0a0d.appspot.com",
      messagingSenderId: "574200276810",
      appId: "1:574200276810:web:9b9f35df8ef74d7b3503b3",
      measurementId: "G-2NM9LX7XHL",
    ),
  );

  // تهيئة Hive للدردشة
  await ChatProvider.initHive();

  runApp(
    DevicePreview(
      enabled: !kReleaseMode,
      builder: (context) => const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ChatProvider()),
        ChangeNotifierProvider(create: (_) => SettingsProvider()),
      ],
      child: Builder(
        builder: (context) {
          final isDarkMode = context.watch<SettingsProvider>().isDarkMode;

          return MaterialApp(
            title: 'تطبيق الأطفال',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              brightness: Brightness.light,
              primarySwatch: Colors.blue,
              fontFamily: 'ArabicTransparent',
            ),
            darkTheme: ThemeData(
              brightness: Brightness.dark,
              fontFamily: 'ArabicTransparent',
            ),
            themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
            useInheritedMediaQuery: true,
            locale: DevicePreview.locale(context),
            builder: DevicePreview.appBuilder,
            initialRoute: '/splash',
            routes: {
              '/splash': (context) => const SplashScreen(),
              '/AfterSplashScreen': (context) => const AfterSplashScreen(),
              '/onboarding': (context) => const OnboardingScreen(),
              '/': (context) => const MainPage(),
              '/login': (context) => const LogIn(),
              '/signup': (context) => const SignUp(),
              '/forgot-password': (context) => const ForgotPassword(),
              '/chat': (context) => const HomeScreen(), // صفحة الشات
            },
          );
        },
      ),
    );
  }
}
