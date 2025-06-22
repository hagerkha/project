import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ArabicGameScreen extends StatefulWidget {
  const ArabicGameScreen({super.key});

  @override
  State<ArabicGameScreen> createState() => _ArabicGameScreenState();
}

class _ArabicGameScreenState extends State<ArabicGameScreen> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) => debugPrint("Loading: $progress%"),
          onPageStarted: (String url) => debugPrint("Page started loading: $url"),
          onPageFinished: (String url) {
            debugPrint("Page finished loading: $url");
            _controller.runJavaScript(
              'document.body.style.zoom = 1.0; document.body.style.overflow = "hidden";',
            );
          },
          onWebResourceError: (WebResourceError error) => debugPrint("Error: ${error.description}"),
          onNavigationRequest: (NavigationRequest request) => NavigationDecision.navigate,
        ),
      )
      ..loadRequest(Uri.parse('https://arabicgme.netlify.app/'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(child: WebViewWidget(controller: _controller)),
            const SizedBox(height: 10),
            Container(
              height: 60,
              width: double.infinity,
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
}