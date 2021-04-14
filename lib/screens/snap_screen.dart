
import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

class snap_screen extends StatefulWidget{
  String snap_url;

  snap_screen({required this.snap_url});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
   return _snap_screen();
  }
}

class _snap_screen extends State<snap_screen>{
  Completer<WebViewController> _controller = Completer<WebViewController>();
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),

        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.fromLTRB(0,8,0,0),
        child: WebView(
          initialUrl: widget.snap_url,
          javascriptMode: JavascriptMode.unrestricted,
          onWebViewCreated: (WebViewController webViewController) {
            _controller.complete(webViewController);
          },
          javascriptChannels: <JavascriptChannel>{
            // _toasterJavascriptChannel(context),
          },
          navigationDelegate: (NavigationRequest request) {
            /*if(request.url.contains("gojek:")) {
              launch(request.url);
              return NavigationDecision.prevent;
            }else if(request.url.contains("dafq:")){
              launch(request.url);
              return NavigationDecision.prevent;
            }*/
            return NavigationDecision.navigate;
          },
          onPageStarted: (String url) async{
            if (url.startsWith('gojek://gopay/merchanttransfer')) {
              bool isAble = await canLaunch(url);
              if (isAble) {
                await launch(url);
                Navigator.pop(context, true);
              } else {
                throw 'Could not launch $url';
              }
            }
          },
          onPageFinished: (String url) {
            print('Page finished loading: $url');
          },
          gestureNavigationEnabled: true,
        ),
      ),
    );
  }
  
}