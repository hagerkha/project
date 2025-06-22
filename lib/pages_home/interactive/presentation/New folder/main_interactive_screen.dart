import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../widgets/interactive_card.dart';
import '../logic/interactive_view_model.dart';

class MainInteractiveScreen extends StatefulWidget {
  const MainInteractiveScreen({super.key});

  @override
  State<MainInteractiveScreen> createState() => _MainInteractiveScreenState();
}

class _MainInteractiveScreenState extends State<MainInteractiveScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer<InteractiveViewModel>(
      builder: (context, viewModel, child) => Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('images/33.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SafeArea(
              child: Align(
                alignment: Alignment.center,
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.75,
                  margin: const EdgeInsets.symmetric(horizontal: 26, vertical: 20),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 20),
                        const Text(
                          'التعليم التفاعلي',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                          ),
                        ),
                        const SizedBox(height: 20),
                        ...viewModel.isLoading
                            ? [const Center(child: CircularProgressIndicator())]
                            : viewModel.items.map((item) {
                          return Column(
                            children: [
                              InteractiveCard(
                                icon: item.icon,
                                title: item.title,
                                description: item.description,
                                color: item.color,
                                onTap: () {},
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16),
                                child: Row(
                                  children: [
                                    if (item.videoPath != null)
                                      Expanded(
                                        child: ElevatedButton.icon(
                                          onPressed: () => viewModel.navigateToVideo(
                                              context, item.videoPath!, item.title),
                                          icon: const Icon(Icons.play_arrow),
                                          label: const Text('تشغيل الفيديو'),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.white,
                                            foregroundColor: Colors.black,
                                          ),
                                        ),
                                      ),
                                    if (item.videoPath != null && item.gameUrl != null)
                                      const SizedBox(width: 10),
                                    if (item.gameUrl != null)
                                      Expanded(
                                        child: ElevatedButton.icon(
                                          onPressed: () => item.onboardingRoute != null
                                              ? viewModel.navigateToOnboarding(context, item.onboardingRoute!)
                                              : viewModel.navigateToGame(context, item.gameUrl!),
                                          icon: const Icon(Icons.videogame_asset),
                                          label: const Text('ابدأ اللعبة'),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.white,
                                            foregroundColor: Colors.black,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                              if (item.contentRoute != null)
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                  child: ElevatedButton.icon(
                                    onPressed: () => viewModel.navigateToContent(context, item.contentRoute!),
                                    icon: const Icon(Icons.book),
                                    label: Text('محتوى ${item.title}'),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.white,
                                      foregroundColor: Colors.black,
                                    ),
                                  ),
                                ),
                              const SizedBox(height: 15),
                            ],
                          );
                        }).toList(),
                        const SizedBox(height: 30),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}