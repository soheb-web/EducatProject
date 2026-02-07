import 'dart:async';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewPage extends StatefulWidget {
  final String url;

  const WebViewPage({super.key, required this.url});

  @override
  State<WebViewPage> createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  late final WebViewController _controller;
  bool isLoading = true;
  bool hasError = false;
  String? errorMsg;

  Timer? _timer;

  @override
  void initState() {
    super.initState();

    _timer = Timer(const Duration(seconds: 8), () {
      if (mounted && isLoading) {
        setState(() {
          isLoading = false;
          hasError = true;
          errorMsg = "Bahut time lag raha hai... check your internet?";
        });
      }
    });

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (url) {
            if (mounted) {
              setState(() {
                isLoading = true;
                hasError = false;
              });
            }
          },
          onPageFinished: (url) {
            if (mounted) {
              setState(() => isLoading = false);
            }
          },
          onWebResourceError: (WebResourceError error) {
            if (mounted) {
              setState(() {
                isLoading = false;
                hasError = true;
                errorMsg = error.description.isNotEmpty
                    ? error.description
                    : "Page load nahi ho paya (code: ${error.errorCode})";
              });
            }
          },
          // Optional: agar sirf main frame ka error dikhana hai to
          // onHttpError: (HttpResponseError error) { ... }
        ),
      )
      ..loadRequest(Uri.parse(widget.url));   // ← yahan widget.url use kar rahe hain
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          "Website",
          style: TextStyle(color: Color(0xFF1B1B1B)),
        ),
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1B1B1B)),
        ),
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),

          if (isLoading)
            const Center(child: CircularProgressIndicator()),

          if (hasError)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [

                    const SizedBox(height: 8),
                    Text(
                      errorMsg ?? "Internet check karein ya URL sahi daalein",
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          hasError = false;
                          isLoading = true;
                        });
                        _controller.reload();
                      },
                      child: const Text("ReTry"),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}