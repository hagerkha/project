import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class HelpGame extends StatefulWidget {
  const HelpGame({super.key});

  @override
  State<HelpGame> createState() => _HelpGameState();
}

class _HelpGameState extends State<HelpGame> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            print("Loading: $progress%");
          },
          onPageStarted: (String url) {
            print("Page started loading: $url");
          },
          onPageFinished: (String url) {
            print("Page finished loading: $url");
            _controller.runJavaScript(
              'document.body.style.zoom = 1.0; document.body.style.overflow = "hidden";',
            );
          },
          onWebResourceError: (WebResourceError error) {
            print("Error: ${error.description}");
          },
          onNavigationRequest: (NavigationRequest request) {
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse('https://clean22222.netlify.app/'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("لعبة مساعدة الآخرين"),
      ),
      body: SizedBox.expand(
        child: WebViewWidget(controller: _controller),
      ),
    );
  }
}
