import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:authenticationapp/chat/screens/home_screen.dart';
import '../../../pages_home/daily_habit/presentation/screens/daily_habits_screen.dart';
import '../../../pages_home/interactive/presentation/New folder/main_interactive_screen.dart';
import '../../../pages_home/social_situations/presentation/screens/social_situations_screen.dart';
import '../logic/home_view_model.dart';
import '../widgets/course_card.dart';
import '../widgets/custom_drawer.dart';
import '../widgets/navbar.dart';
import 'help_screen.dart';

class HalfCircleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0);
    path.quadraticBezierTo(size.width / 2, -size.height / 2, 0, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key}); // أضفت const لتحسين الأداء

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late AnimationController _chatButtonController;
  late Animation<double> _chatPulseAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    )..forward();

    _chatButtonController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);

    _chatPulseAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _chatButtonController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    _chatButtonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<HomeViewModel>(context, listen: false);

    return Scaffold(
      backgroundColor: Colors.white,
      drawer: CustomDrawer(userName: viewModel.user.name, userPhotoUrl: viewModel.user.photoUrl),
      body: Consumer<HomeViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.isLoading) {
            return const Center(child: CircularProgressIndicator(color: Color(0xFFE6E6FA)));
          }
          return Stack(
            children: [
              _buildHomeContent(viewModel),
              if (viewModel.searchQuery.isEmpty)
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
              if (viewModel.searchQuery.isEmpty)
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
                              MaterialPageRoute(builder: (context) => const HomeScreen()), // عدّلت اسم الكلاس
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
          );
        },
      ),
      bottomNavigationBar: Navbar(
        selectedIndex: viewModel.searchQuery.isEmpty ? 0 : 1,
        onItemTapped: (index) {
          if (index == 2) {
            Navigator.push(context, MaterialPageRoute(builder: (context) =>  HelpScreen()));
          }
        },
      ),
    );
  }

  Widget _buildHomeContent(HomeViewModel viewModel) {
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
              decoration: const BoxDecoration(color: Color(0xFFE6E6FA)),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 15, 20, 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildProfileImage(viewModel.user),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: Text(
                            'مرحبًا ${viewModel.user.name}!',
                            style: const TextStyle(
                              color: Colors.black87,
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.right,
                          ),
                        ),
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
            child: viewModel.searchQuery.isNotEmpty
                ? _buildSearchContent(viewModel)
                : ListView.builder(
              itemCount: viewModel.courses.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 15),
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height / 4,
                    child: CourseCard(
                      title: viewModel.courses[index].title,
                      color: const Color(0xFF1E88E5),
                      icon: viewModel.courses[index].icon,
                      imagePath: viewModel.courses[index].imagePath,
                      animationController: _animationController,
                      delay: index * 200,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              switch (viewModel.courses[index].routeName) {
                                case '/dailyHabits':
                                  return const DailyHabitsScreen();
                                case '/socialSituations':
                                  return const SocialSituationsScreen();
                                case '/interactive':
                                  return const MainInteractiveScreen();
                                default:
                                  return Container();
                              }
                            },
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

  Widget _buildSearchContent(HomeViewModel viewModel) {
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
                    onChanged: (value) => viewModel.searchQuery = value,
                    decoration: InputDecoration(
                      hintText: 'ابحث عن الدورات...',
                      hintStyle: const TextStyle(fontSize: 16),
                      prefixIcon: const Icon(Icons.search, color: Colors.grey),
                      suffixIcon: viewModel.searchQuery.isNotEmpty
                          ? IconButton(
                        icon: const Icon(Icons.clear, color: Colors.grey),
                        onPressed: () => viewModel.searchQuery = '',
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
          child: viewModel.filteredCourses.isEmpty
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
                  viewModel.searchQuery.isEmpty
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
            itemCount: viewModel.filteredCourses.length,
            itemBuilder: (context, index) {
              final course = viewModel.filteredCourses[index];
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
                              course.imagePath,
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
                                course.title,
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                course.subtitle,
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

  Widget _buildProfileImage(user) {
    ImageProvider imageProvider;
    if (user.photoUrl != null && user.photoUrl!.isNotEmpty) {
      if (user.photoUrl!.startsWith('http')) {
        imageProvider = NetworkImage(user.photoUrl!);
      } else {
        imageProvider = AssetImage(user.photoUrl!);
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
}