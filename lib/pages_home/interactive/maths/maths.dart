import 'package:flutter/material.dart';
import 'package:authenticationapp/pages_home/interactive/games/plusgame.dart';
import 'package:authenticationapp/pages_home/interactive/games/minusgame.dart';
import 'package:authenticationapp/pages_home/daily_habit/videos.dart';
import 'package:authenticationapp/pages_home/interactive/contact_game/contact_num_game.dart';

class GridSportsPage extends StatelessWidget {
  const GridSportsPage({Key? key}) : super(key: key);

  final Color lightBlue = const Color(0xFFD0E3F3);
  final Color lightPink = const Color(0xFFEECECE);

  void _playAssetVideo(BuildContext context, String assetPath, String videoTitle) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VideoPlayerScreen(
          videoPath: assetPath,
          videoTitle: videoTitle,
        ),
      ),
    );
  }

  void _openPlusGame(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const PlusGamePage()),
    );
  }

  void _openMinusGame(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const MinecraftPage()),
    );
  }

  void _openCountingGame(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ContactNumPage()),
    );
  }

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
                  icon: Icon(
                    Icons.home,
                    color: Colors.grey[700],
                    size: 24,
                  ),
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
                    // الأعداد
                    _buildGameCard(
                      context,
                      color: lightPink,
                      icon: Icons.confirmation_number,
                      title: 'الأعداد',
                      onVideoPressed: null,
                      onGamePressed: () => _openCountingGame(context),
                    ),

                    // الطرح
                    _buildGameCard(
                      context,
                      color: lightBlue,
                      icon: Icons.remove_circle,
                      title: 'الطرح',
                      onVideoPressed: () => _playAssetVideo(context, 'assets/videos/minus.mp4', 'فيديو الطرح'),
                      onGamePressed: () => _openMinusGame(context),
                    ),

                    // الجمع
                    _buildGameCard(
                      context,
                      color: lightPink,
                      icon: Icons.add_circle,
                      title: 'الجمع',
                      onVideoPressed: () => _playAssetVideo(context, 'assets/videos/plus.mp4', 'فيديو الجمع'),
                      onGamePressed: () => _openPlusGame(context),
                    ),

                    // فيديو الأعداد
                    _buildGameCard(
                      context,
                      color: lightBlue,
                      icon: Icons.calculate,
                      title: 'فيديو الأعداد',
                      onVideoPressed: () => _playAssetVideo(context, 'assets/videos/number.mp4', 'فيديو الأعداد'),
                      onGamePressed: null,
                    ),
                  ],
                ),
              ),
            ),
            // الصورة السفلية
            Container(
              height: 100, // تقدرِ تكبّري أو تصغّري الرقم ده
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
