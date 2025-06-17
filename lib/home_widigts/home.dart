import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../chat/screens/home_screen.dart';
import '../pages_home/daily_habit/daily_habits_page.dart';
import '../pages_home/interactive/main interactive_page.dart';
import '../pages_home/social_situations/social_situations_page.dart';
import '../setting.dart';
import 'CourseCard.dart';
import 'CustomDrawer.dart';
import 'help.dart';

// Custom clipper for half-circle shape at the top
class HalfCircleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0);
    path.quadraticBezierTo(
      size.width / 2,
      -size.height / 2,
      0,
      0,
    );
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

// CourseCard with circular image and larger text
class CourseCard extends StatelessWidget {
  final String title;
  final Color color;
  final IconData icon;
  final String imagePath;
  final AnimationController animationController;
  final int delay;
  final VoidCallback onTap;

  const CourseCard({
    super.key,
    required this.title,
    required this.color,
    required this.icon,
    required this.imagePath,
    required this.animationController,
    this.delay = 0,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              // Circular image container
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: ClipOval(
                  child: Image.asset(
                    imagePath,
                    fit: BoxFit.cover,
                    width: 60,
                    height: 60,
                  ),
                ),
              ),
              const SizedBox(width: 20),
              // Text content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        color: color,
                        fontSize: 28, // Increased font size from 24 to 28
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              // Arrow icon
              Icon(
                Icons.arrow_forward_ios,
                color: color.withOpacity(0.5),
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> with TickerProviderStateMixin {
  String _userName = 'مستخدم';
  String? _userPhotoUrl;
  bool _isLoading = true;
  int _selectedIndex = 0;
  late AnimationController _animationController;
  late AnimationController _chatButtonController;
  late Animation<double> _chatPulseAnimation;

  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _filteredCourses = [];

  final List<Map<String, dynamic>> _courses = [
    {
      'title': 'العادات اليومية',
      'subtitle': 'تعلم العادات الصحية',
      'route': const DailyHabitsPage(),
      'icon': Icons.schedule,
      'imagePath': 'images/1.3.jpg',
    },
    {
      'title': 'المواقف الاجتماعية',
      'subtitle': 'تفاعل مع الآخرين',
      'route': const SocialSituationsPage(),
      'icon': Icons.people,
      'imagePath': 'images/1.1 (1).jpg',
    },
    {
      'title': 'التعليم التفاعلي',
      'subtitle': 'دورة تعليمية تفاعلية',
      'route': const MainInteractivePage(),
      'icon': Icons.school,
      'imagePath': 'images/2.2.jpg',
    },
  ];

  @override
  void initState() {
    super.initState();
    _getCurrentUser();
    _loadUserData();
    _filteredCourses = _courses;

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _chatButtonController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);

    _chatPulseAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _chatButtonController, curve: Curves.easeInOut),
    );

    _animationController.forward();

    _searchController.addListener(() {
      _performSearch(_searchController.text);
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _chatButtonController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _getCurrentUser() async {
    setState(() {
      _isLoading = true;
    });
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        setState(() {
          _userName = user.displayName ?? 'مستخدم';
          _userPhotoUrl = user.photoURL;
        });
      }
    } catch (e) {
      print('خطأ في جلب المستخدم: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _loadUserData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedName = prefs.getString('user_name');
      final savedPhotoUrl = prefs.getString('user_photo_url');

      if (savedName != null) {
        setState(() {
          _userName = savedName;
        });
      }

      if (savedPhotoUrl != null) {
        setState(() {
          _userPhotoUrl = savedPhotoUrl;
        });
      }
    } catch (e) {
      print('خطأ في تحميل بيانات المستخدم: $e');
    }
  }

  void _onNavBarTap(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const HelpPage()),
      );
    }
  }

  Widget _buildProfileImage() {
    ImageProvider imageProvider;

    if (_userPhotoUrl != null && _userPhotoUrl!.isNotEmpty) {
      if (_userPhotoUrl!.startsWith('http')) {
        imageProvider = NetworkImage(_userPhotoUrl!);
      } else if (_userPhotoUrl!.startsWith('assets/')) {
        imageProvider = AssetImage(_userPhotoUrl!);
      } else if (File(_userPhotoUrl!).existsSync()) {
        imageProvider = FileImage(File(_userPhotoUrl!));
      } else {
        imageProvider = const AssetImage('assets/images/default_profile.png');
      }
    } else {
      imageProvider = const AssetImage('assets/images/default_profile.png');
    }

    return CircleAvatar(
      radius: 25,
      backgroundColor: Colors.white,
      child: ClipOval(
        child: Image(
          image: imageProvider,
          fit: BoxFit.cover,
          width: 46,
          height: 46,
          errorBuilder: (context, error, stackTrace) {
            return const Icon(
              Icons.person,
              size: 25,
              color: Color(0xFFbbe7f4),
            );
          },
        ),
      ),
    );
  }

  void _performSearch(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredCourses = _courses;
      } else {
        _filteredCourses = _courses
            .where((course) =>
        course['title'].toString().toLowerCase().contains(query.toLowerCase()) ||
            course['subtitle'].toString().toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  Widget _buildHomeContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 110,
          width: double.infinity,
          color: const Color(0xFFE6E6FA),
          child: ClipPath(
            clipper: HalfCircleClipper(),
            child: Container(
              decoration: const BoxDecoration(
                color: Color(0xFFE6E6FA),
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 15, 20, 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildProfileImage(), // Profile image on the right
                    const SizedBox(width: 10), // Add spacing between image and text
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end, // Align text to the right
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 10), // Move text slightly to the right
                          child: Text(
                            'مرحبًا $_userName!',
                            style: const TextStyle(
                              color: Colors.black87,
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.right, // Ensure text alignment is right
                          ),
                        ),
                        const SizedBox(height: 4),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            child: ListView.builder(
              itemCount: _courses.length,
              itemBuilder: (context, index) {
                final course = _courses[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 15),
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height / 4, // Increased height to span more of the page
                    child: CourseCard(
                      title: course['title'],
                      color: const Color(0xFF1E88E5),
                      icon: course['icon'],
                      imagePath: course['imagePath'],
                      animationController: _animationController,
                      delay: index * 200,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => course['route'],
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSearchContent() {
    return Column(
      children: [
        Container(
          height: 140,
          width: double.infinity,
          decoration: const BoxDecoration(
            color: Color(0xFFE6E6FA),
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'البحث في الدورات',
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 15),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'ابحث عن الدورات...',
                      hintStyle: const TextStyle(fontSize: 16),
                      prefixIcon: const Icon(Icons.search, color: Colors.grey),
                      suffixIcon: _searchController.text.isNotEmpty
                          ? IconButton(
                        icon: const Icon(Icons.clear, color: Colors.grey),
                        onPressed: () {
                          _searchController.clear();
                          _performSearch('');
                        },
                      )
                          : null,
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                    ),
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: _filteredCourses.isEmpty
              ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.search_off,
                  size: 50,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 20),
                Text(
                  _searchController.text.isEmpty
                      ? 'ابدأ بالبحث للعثور على الدورات'
                      : 'لا توجد نتائج مطابقة',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          )
              : ListView.builder(
            padding: const EdgeInsets.all(15),
            itemCount: _filteredCourses.length,
            itemBuilder: (context, index) {
              final course = _filteredCourses[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 15),
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Row(
                      children: [
                        // Circular image for search results
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 5,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: ClipOval(
                            child: Image.asset(
                              course['imagePath'],
                              fit: BoxFit.cover,
                              width: 50,
                              height: 50,
                            ),
                          ),
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                course['title'],
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                course['subtitle'],
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Icon(Icons.arrow_forward_ios, color: Color(0xFFE6E6FA)),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      _buildHomeContent(),
      _buildSearchContent(),
      Container(),
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      drawer: CustomDrawer(
        userName: _userName,
        userPhotoUrl: _userPhotoUrl,
      ),
      body: _isLoading
          ? const Center(
        child: CircularProgressIndicator(color: Color(0xFFE6E6FA)),
      )
          : SafeArea(
        child: Stack(
          children: [
            pages[_selectedIndex],
            if (_selectedIndex == 0)
              Positioned(
                top: 40,
                left: 20,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Builder(
                    builder: (context) => IconButton(
                      icon: const Icon(Icons.menu, size: 26, color: Colors.white),
                      onPressed: () => Scaffold.of(context).openDrawer(),
                    ),
                  ),
                ),
              ),
            if (_selectedIndex == 0)
              Positioned(
                bottom: 100,
                right: 20,
                child: AnimatedBuilder(
                  animation: _chatButtonController,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _chatPulseAnimation.value,
                      child: FloatingActionButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const HomeScreen(),
                            ),
                          );
                        },
                        backgroundColor: Colors.white,
                        elevation: 0,
                        child: Container(
                          width: 50,
                          height: 50,
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage('images/ai.png'),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        height: 80,
        decoration: BoxDecoration(
          color: const Color(0xFFF0BBCD),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(25),
            topRight: Radius.circular(25),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildNavBarItem(
              icon: Icons.home,
              label: 'الرئيسية',
              index: 0,
            ),
            _buildNavBarItem(
              icon: Icons.search,
              label: 'البحث',
              index: 1,
            ),
            _buildNavBarItem(
              icon: Icons.help,
              label: 'المساعدة',
              index: 2,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavBarItem({
    required IconData icon,
    required String label,
    required int index,
  }) {
    bool isSelected = _selectedIndex == index;

    return GestureDetector(
      onTap: () => _onNavBarTap(index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: isSelected
            ? BoxDecoration(
          color: const Color(0xFFE6E6FA).withOpacity(0.15),
          borderRadius: BorderRadius.circular(25),
        )
            : null,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: isSelected
                  ? const BoxDecoration(
                color: Color(0xFFE6E6FA),
                borderRadius: BorderRadius.all(Radius.circular(15)),
              )
                  : null,
              child: Icon(
                icon,
                color: isSelected ? Colors.white : Colors.grey[600],
                size: 24,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? const Color(0xFFE6E6FA) : Colors.grey[700],
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}