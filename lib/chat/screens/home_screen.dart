import 'package:authenticationapp/chat/screens/profile_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../providers/chat_provider.dart';
import 'chat_history_screen.dart';
import 'chat_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // list of screens
  final List<Widget> _screens = [
    const ChatHistoryScreen(),
    const ChatScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Consumer<ChatProvider>(
      builder: (context, chatProvider, child) {
        return Scaffold(
          body: PageView(
            controller: chatProvider.pageController,
            children: _screens,
            onPageChanged: (index) {
              chatProvider.setCurrentIndex(newIndex: index);
            },
          ),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: chatProvider.currentIndex,
            elevation: 0,
            selectedItemColor: Theme.of(context).colorScheme.primary,
            onTap: (index) {
              chatProvider.setCurrentIndex(newIndex: index);
              chatProvider.pageController.jumpToPage(index);
            },
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.history),
                // icon: Icon(CupertinoIcons.timelapse),
                label: 'تاريخ الشات',
              ),
              BottomNavigationBarItem(
                icon: Icon(CupertinoIcons.chat_bubble),
                label: 'الشات',
              ),
              BottomNavigationBarItem(
                icon: Icon(CupertinoIcons.person),
                label: 'بروفيل',
              ),
            ],
          ),
        );
      },
    );
  }
}
