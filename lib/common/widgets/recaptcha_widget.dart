import 'dart:async';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class RecaptchaWidget extends StatefulWidget {
  final String siteKey;
  final Function(String) onVerified;

  const RecaptchaWidget({
    Key? key,
    required this.siteKey,
    required this.onVerified,
  }) : super(key: key);

  @override
  _RecaptchaWidgetState createState() => _RecaptchaWidgetState();
}

class _RecaptchaWidgetState extends State<RecaptchaWidget> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..addJavaScriptChannel(
        'Captcha',
        onMessageReceived: (JavaScriptMessage message) {
          widget.onVerified(message.message);
        },
      )
      ..loadHtmlString(_html);
  }

  String get _html => '''
    <!DOCTYPE html>
    <html>
    <head>
      <meta name="viewport" content="width=device-width, initial-scale=1">
      <script src="https://www.google.com/recaptcha/api.js" async defer></script>
    </head>
    <body>
      <div id="recaptcha" class="g-recaptcha"
        data-sitekey="${widget.siteKey}"
        data-callback="onVerify"
        data-size="normal">
      </div>
      <script>
        function onVerify(token) {
          if (token) {
            Captcha.postMessage(token);
          }
        }
      </script>
    </body>
    </html>
  ''';

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: WebViewWidget(controller: _controller),
    );
  }
}