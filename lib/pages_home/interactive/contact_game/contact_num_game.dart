import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ContactNumPage extends StatefulWidget {
  const ContactNumPage({super.key});

  @override
  State<ContactNumPage> createState() => _ContactNumPageState();
}

class _ContactNumPageState extends State<ContactNumPage> {
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
            debugPrint("Loading: $progress%");
          },
          onPageStarted: (String url) {
            debugPrint("Page started loading: $url");
          },
          onPageFinished: (String url) {
            debugPrint("Page finished loading: $url");
            _controller.runJavaScript(
              'document.body.style.zoom = 1.0; document.body.style.overflow = "hidden";',
            );
          },
          onWebResourceError: (WebResourceError error) {
            debugPrint("Error: ${error.description}");
          },
          onNavigationRequest: (NavigationRequest request) {
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(
        Uri.parse('https://contactnum.netlify.app/'),
      );
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: WebViewWidgetWrapper(),
      ),
    );
  }
}

class WebViewWidgetWrapper extends StatelessWidget {
  const WebViewWidgetWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.findAncestorStateOfType<_ContactNumPageState>();
    return state == null
        ? Center(child: CircularProgressIndicator())
        : WebViewWidget(controller: state._controller);
  }
}
