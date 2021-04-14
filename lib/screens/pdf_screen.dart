

import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

class pdf_screen extends StatefulWidget{
  String path;

  pdf_screen({required this.path});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
  return _pdf_Screen();
  }

}

class _pdf_Screen extends State<pdf_screen>{

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
      body:
      const PDF().cachedFromUrl(
        widget.path,
        placeholder: (double progress) => Center(child: Text('$progress %')),
        errorWidget: (dynamic error) => Center(child: Text(error.toString())),
      ),
    );
  }

}