
import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qbsdonation/models/dafq.dart';
import 'package:qbsdonation/utils/colors.dart';
import 'package:qbsdonation/utils/constants.dart';
import 'package:qbsdonation/utils/widgets.dart';

class CustomDialog extends StatelessWidget {
  final title;
  final detail;
  final image;
  Color color;
  CustomDialog({this.title, this.detail, this.image, required this.color});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: dialogContent(context),
    );
  }
  dialogContent(BuildContext context) {
    return Container(
        decoration: new BoxDecoration(
          color: Colors.white,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10.0,
              offset: const Offset(0.0, 10.0),
            ),
          ],
        ),
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisSize: MainAxisSize.min, // To make the card compact
          children: <Widget>[
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(padding: EdgeInsets.all(16), alignment: Alignment.centerRight, child: Icon(Icons.close, color: t1TextColorPrimary)),
            ),
            text(title, textColor: Colors.green, fontFamily: fontBold, fontSize: textSizeLarge),
            SizedBox(height: 24),
            Image.asset(
              image,
              color: color,
              width: 105,
              height: 105,
            ),
            SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16),
              child: text(detail, fontSize: textSizeMedium, maxLine: 2, isCentered: true),
            ),
            SizedBox(height: 30),
          ],
        ));
  }
}

class CustomDialog_II extends StatefulWidget{
  final user_profil profil;

  CustomDialog_II({required this.profil});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
   return CustomDialogState();
  }

}

class CustomDialogState extends State<CustomDialog_II>  {
  bool isMakePayment = false;
  TextEditingController amount= new TextEditingController();
  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: dialogContent(context),
    );
  }
  dialogContent(BuildContext context) {
    mission m = mission();
    var width = MediaQuery.of(context).size.width;
    return Container(
      decoration: new BoxDecoration(
        color: Colors.white,
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10.0,
            offset: const Offset(0.0, 10.0),
          ),
        ],
      ),
      width: MediaQuery.of(context).size.width,
      //height: MediaQuery.of(context).size.height * 0.8,
      padding: EdgeInsets.all(spacing_standard_new),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min, // To make the card compact
          children: <Widget>[
            Image.asset(
              'assets/images/icon.png',
              width: width * 0.25,
              height: width * 0.25,
              fit: BoxFit.fill,
            ),
            SizedBox(
              height: spacing_standard_new,
            ),
            text_normal('Silakan masukan nominal yang ingin anda simpan', textColor: t10_textColorSecondary, isLongText: true, isCentered: true),
            SizedBox(
              height: spacing_standard_new,
            ),
            TextFormField(
              controller: amount,
              cursorColor: t10_colorPrimary,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.fromLTRB(16, 8, 4, 8),
                hintText: 'Rp -.00',
                enabledBorder: UnderlineInputBorder(
                  borderSide: const BorderSide(color: t10_view_color, width: 0.0),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: const BorderSide(color: t10_view_color, width: 0.0),
                ),
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
              style: TextStyle(
                fontSize: textSizeMedium,
                color: t10_textColorPrimary,
              ),
            ),
            SizedBox(
              height: spacing_standard_new,
            ),
            AppButton(
              onPressed: () {
                  m.id = '12345678';
                  m.title = 'Debit';
                  if (amount.text==null){
                    Flushbar(
                      title: "Error",
                      message: "Masukan nominal",
                      duration: Duration(seconds: 2),
                    ).show(context);
                  }else{
                    // Will go to payment screen
                  }
                 ;
              },
              textContent: "Isi Dompet Anda",
            ),
            SizedBox(
              height: spacing_large,
            ),
          ],
        ),
      ),
    );
  }
}

class AppButton extends StatefulWidget {
  var textContent;
  VoidCallback onPressed;

  AppButton({@required this.textContent, required this.onPressed});

  @override
  State<StatefulWidget> createState() {
    return AppButtonState();
  }
}

class AppButtonState extends State<AppButton> {
  @override
  Widget build(BuildContext context) {
    return RaisedButton(
        onPressed: widget.onPressed,
        textColor: t10_white,
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(80.0)),
        padding: const EdgeInsets.all(0.0),
        child: Container(
          decoration: const BoxDecoration(
            // gradient: LinearGradient(colors: <Color>[t10_gradient1, t10_gradient2]),
            borderRadius: BorderRadius.all(Radius.circular(80.0)),
            color:  p_12,
          ),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
              child: Text(
                widget.textContent,
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ));
  }

  @override
  State<StatefulWidget>? createState() {
    // TODO: implement createState
    return null;
  }
}

