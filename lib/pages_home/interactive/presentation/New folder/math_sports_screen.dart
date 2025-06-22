import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../logic/interactive_view_model.dart';

class MathSportsScreen extends StatelessWidget {
  const MathSportsScreen({super.key});

  final Color lightBlue = const Color(0xFFD0E3F3);
  final Color lightPink = const Color(0xFFEECECE);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: Container(
                width: 50,
                height: 50,
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: IconButton(
                  icon: Icon(Icons.home, color: Colors.grey[700], size: 24),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  childAspectRatio: 0.8,
                  children: [
                    _buildGameCard(
                      context,
                      color: lightPink,
                      icon: Icons.confirmation_number,
                      title: 'الأعداد',
                      onGamePressed: () => Provider.of<InteractiveViewModel>(context, listen: false)
                          .navigateToGame(context, 'https://countinggame.netlify.app/'),
                    ),
                    _buildGameCard(
                      context,
                      color: lightBlue,
                      icon: Icons.remove_circle,
                      title: 'الطرح',
                      onVideoPressed: () => Provider.of<InteractiveViewModel>(context, listen: false)
                          .navigateToVideo(context, 'assets/videos/minus.mp4', 'فيديو الطرح'),
                      onGamePressed: () => Provider.of<InteractiveViewModel>(context, listen: false)
                          .navigateToGame(context, 'https://minusgame2.netlify.app/'),
                    ),
                    _buildGameCard(
                      context,
                      color: lightPink,
                      icon: Icons.add_circle,
                      title: 'الجمع',
                      onVideoPressed: () => Provider.of<InteractiveViewModel>(context, listen: false)
                          .navigateToVideo(context, 'assets/videos/plus.mp4', 'فيديو الجمع'),
                      onGamePressed: () => Provider.of<InteractiveViewModel>(context, listen: false)
                          .navigateToGame(context, 'https://plusgameu.netlify.app/'),
                    ),
                    _buildGameCard(
                      context,
                      color: lightBlue,
                      icon: Icons.calculate,
                      title: 'فيديو الأعداد',
                      onVideoPressed: () => Provider.of<InteractiveViewModel>(context, listen: false)
                          .navigateToVideo(context, 'assets/videos/number.mp4', 'فيديو الأعداد'),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              height: 100,
              width: double.infinity,
              margin: EdgeInsets.zero,
              padding: EdgeInsets.zero,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('images/1.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGameCard(
      BuildContext context, {
        required Color color,
        required IconData icon,
        required String title,
        VoidCallback? onVideoPressed,
        VoidCallback? onGamePressed,
      }) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 40, color: Colors.grey[700]),
          const SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey[800]),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          if (onVideoPressed != null)
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: onVideoPressed,
                icon: const Icon(Icons.play_arrow, size: 18),
                label: const Text('تشغيل الفيديو', style: TextStyle(fontSize: 12)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 10),
                ),
              ),
            ),
          if (onVideoPressed != null && onGamePressed != null) const SizedBox(height: 6),
          if (onGamePressed != null)
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: onGamePressed,
                icon: const Icon(Icons.videogame_asset, size: 18),
                label: const Text('ابدأ اللعبة', style: TextStyle(fontSize: 12)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 10),
                ),
              ),
            ),
        ],
      ),
    );
  }
}