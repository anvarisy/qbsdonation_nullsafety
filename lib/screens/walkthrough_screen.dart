

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qbsdonation/components/walkthrough.dart';
import 'package:qbsdonation/helpers/methods.dart';
import 'package:qbsdonation/helpers/widgets.dart';
import 'package:qbsdonation/models/colors.dart';
import 'package:qbsdonation/models/font_sizes.dart';
import 'package:qbsdonation/screens/register_screen.dart';

class walkthrough_screen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _walkthrough_screen();
  }

}

class _walkthrough_screen extends State<walkthrough_screen> {
  final PageController controller = new PageController();
  var currentPage = 0;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    var height = MediaQuery.of(context).size.height;
    return Scaffold(body: BuildWalk(context));
  }

  void _onPageChanged(int page) {
    setState(() {
      currentPage = page;
    });
  }

  Widget BuildWalk(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('Walk').orderBy('position').snapshots(),
      builder: (context, snapshot) {
        return !snapshot.hasData
            ? Text('-')
            : _Walk(context, snapshot.data!.docs);
      },
    );
  }

  Widget _Walk(BuildContext context, List<DocumentSnapshot> snapshot) {
    var height = MediaQuery.of(context).size.height;
    var content = <Widget>[];
    for (DocumentSnapshot element in snapshot) {
      walkthrough_widget widget = walkthrough_widget();
      widget.title = '${element['title']}';
      widget.subTitle = '${element['detail']}';
      widget.image = '${element['image']}';
      content.add(widget);
    }
    return Container(
      decoration: backgroundDecor(),
      child:  Column(
        children: <Widget>[
          Expanded(
            child: PageView(
              children: content,
              controller: controller,
              onPageChanged: _onPageChanged,
            ),
          ),
          Column(
            children: <Widget>[
              Padding(padding: EdgeInsets.fromLTRB(0, 0, 0, 20),
                child: content.length > 0 ? DotsIndicator(
               dotsCount: content.length,
               position: currentPage.toDouble(),
               decorator: DotsDecorator(
                   color: p_12.withOpacity(0.15),
                   activeColor: p_12,
                   activeSize: Size.square(spacing_middle),
                   spacing: EdgeInsets.all(3)),
             ) : Container(),),
              SizedBox(
                  width: double.infinity,
                  child: Padding(padding: EdgeInsets.fromLTRB(spacing_large, 0, spacing_large, 0),
                    child: MaterialButton(
                      padding: EdgeInsets.only(
                        top: 16, bottom: 16),
                        child: text(
                        currentPage == (content.length - 1)
                            ? "Get Started"
                            : "Continue",
                        textColor: Colors.white,
                        fontFamily: fontMedium),
                        shape: RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(spacing_standard)),
                        color: p_12,
                        onPressed: () => {
                      if (currentPage == (content.length - 1)){
                          gopush(context, register_screen())}
                      else{
                           setState(() {
                           currentPage++;
                           controller.animateToPage(currentPage,
                            duration: Duration(milliseconds: 500),
                            curve: Curves.ease);})}
                    },
                  ),),
                ),
              Padding(padding: EdgeInsets.all(spacing_standard_new),
                  child: InkWell(
                    onTap: ()=>{
                    gopush(context, register_screen())
                    },
                    child: text(currentPage != (content.length-1) ? "Skip Now" : "",
                        fontSize: textSizeMedium),
                ),),
            ],
          )
        ],
      ),
    );
  }
}