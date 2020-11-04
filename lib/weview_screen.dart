import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:async';

class ShopCreditWebView extends StatefulWidget {
  ShopCreditWebView(this.url);
  String url;
  @override
  _WebViewClassState createState() => _WebViewClassState(url);
}

class _WebViewClassState extends State<ShopCreditWebView> {
  _WebViewClassState(this.url);
  String url;
  Completer<WebViewController> _controller = Completer<WebViewController>();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.black,
        title:  Text(
          'ShoutOut',
          style: TextStyle(color: Colors.white,fontSize: 28),
        ),
      ),
      body: WebView(
        initialUrl: url,
        onWebViewCreated: (WebViewController webViewController) {
          _controller.complete(webViewController);
        },
      ),
    );
  }
}
