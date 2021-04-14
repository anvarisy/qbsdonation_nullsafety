import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pinch_zoom/pinch_zoom.dart';

// ignore: camel_case_types, must_be_immutable
class image_viewer_ii extends StatefulWidget{
  // ignore: non_constant_identifier_names
  int current_index;
  // ignore: non_constant_identifier_names
  int max_images;
  List<dynamic> images;

  // ignore: non_constant_identifier_names
  image_viewer_ii({required this.current_index, required this.max_images, required this.images});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _image_viewer_ii();
  }

}

// ignore: camel_case_types
class _image_viewer_ii extends State<image_viewer_ii>{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    final PageController controller = PageController(initialPage: widget.current_index);
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        )),
      body: SafeArea(
        child:PageView(
          scrollDirection: Axis.horizontal,
          controller: controller,
            children:imgs()
          )
        ),
    );
  }
List<Widget> imgs(){
    List<Widget> a = [];
    for(String i in List<String>.from(widget.images)){
      a.add(
          InteractiveViewer(
              panEnabled: false, // Set it to false
              boundaryMargin: EdgeInsets.all(100),
              minScale: 1,
              maxScale: 2,
            child:PinchZoom(
              image: CachedNetworkImage(
                imageUrl: i,
                placeholder: (context, url) =>Center(
                  child: Container(
                    width: 20.0,
                    height: 20.0,
                    child: CircularProgressIndicator(),
                  ),
                ),
                errorWidget: (context, url, error) => Icon(Icons.error),
                fit: BoxFit.contain,
              ),
              zoomedBackgroundColor: Colors.black.withOpacity(0.5),
              // resetDuration: const Duration(milliseconds: 100),
              maxScale: 2.5,
              onZoomStart: (){print('Start zooming');},
              onZoomEnd: (){print('Stop zooming');},
            ),/*CachedNetworkImage(
              imageUrl: i,
              placeholder: (context, url) =>Center(
                child: Container(
                  width: 20.0,
                  height: 20.0,
                  child: CircularProgressIndicator(),
                ),
              ),
              errorWidget: (context, url, error) => Icon(Icons.error),
              fit: BoxFit.contain,
            ),*/
          )

      );
    }
    return a;
}
}