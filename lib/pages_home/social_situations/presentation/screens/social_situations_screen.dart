import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../logic/social_situations_view_model.dart';
import '../widgets/social_situation_card.dart';

class SocialSituationsScreen extends StatefulWidget {
  const SocialSituationsScreen({super.key});

  @override
  State<SocialSituationsScreen> createState() => _SocialSituationsScreenState();
}

class _SocialSituationsScreenState extends State<SocialSituationsScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer<SocialSituationsViewModel>(
      builder: (context, viewModel, child) => Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.pop(context),
          ),
          title: const Text(
            'المواقف الاجتماعية',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
        ),
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
                  height: MediaQuery.of(context).size.height * 0.6,
                  margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: viewModel.isLoading
                          ? [const Center(child: CircularProgressIndicator())]
                          : viewModel.situations.map((situation) {
                        return Column(
                          children: [
                            SocialSituationCard(
                              icon: situation.icon,
                              title: situation.title,
                              description: situation.description,
                              color: situation.color,
                              onTap: () {
                                if (situation.onboardingRoute != null) {
                                  viewModel.navigateToOnboarding(context, situation.onboardingRoute!);
                                } else {
                                  viewModel.navigateToVideo(context, situation.videoPath!, situation.title);
                                }
                              },
                            ),
                            const SizedBox(height: 15),
                          ],
                        );
                      }).toList(),
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