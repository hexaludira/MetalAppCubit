import 'package:flutter/material.dart';
//import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
//import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class WebView extends StatefulWidget {
  @override
  _WebViewState createState() => _WebViewState();
}

class _WebViewState extends State<WebView> {
  @override
  Widget build(BuildContext context) {
    return WebviewScaffold(
      //url: "http://10.10.41.246/adidas",
      url: "http://10.0.2.2/adidas_new",
      withJavascript: true,
      appBar: AppBar(
        title: const Text('Metal Monitoring System'),
        leading: IconButton(icon: Icon(Icons.arrow_back), onPressed: (){
          //Navigator.popAndPushNamed(context, '/');
          Navigator.pop(context);
        }), 
      ),
    );
    // return Scaffold(
    //     appBar: AppBar(
    //       title: const Text('Metal Monitoring System'),
    //     ),
    //     body: 
          
    //     // Container(
    //     //   child: InAppWebView(
    //     //     initialUrlRequest:
    //     //         URLRequest(url: Uri.parse("http://10.10.10.98/adidas")),
    //     //   ),
          
    //     // )
    // );
  }
}
