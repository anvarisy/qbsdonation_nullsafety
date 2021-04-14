import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:qbsdonation/models/colors.dart';
import 'package:qbsdonation/models/font_sizes.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

BoxDecoration backgroundDecor() => BoxDecoration(
  color: Colors.lightBlue[50],
  /*gradient: LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomLeft,
    colors: [
      //p_11.withOpacity(0.87),
      //t11_GradientColor1.withOpacity(0.4),
      Colors.blue.shade300,
      Colors.white,
    ],
  ),*/
);

BoxDecoration boxDecoration({double radius = 2, Color color = Colors.transparent, Color bgColor = Colors.white, var showShadow = false}) {
  return BoxDecoration(
      color: bgColor,
      //gradient: LinearGradient(colors: [bgColor, whiteColor]),
      boxShadow: showShadow ? [BoxShadow(color: Colors.grey.withOpacity(0.2), blurRadius: 10, spreadRadius: 2)] : [BoxShadow(color: Colors.transparent)],
      border: Border.all(color: color),
      borderRadius: BorderRadius.all(Radius.circular(radius)));
}

Widget themeLogo(){
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[
      Image(image: AssetImage('assets/images/icon.png'),width: 45,height: 45,),
      Padding(padding: EdgeInsets.fromLTRB(spacing_standard_new, 0, 0, 0),
        child: text("DAFQ APP",fontSize: textSizeLarge,fontFamily: fontBold,textColor: t12_text_color_primary),)

    ],
  );
}

Widget text(var text,
    {var fontSize = textSizeLargeMedium, textColor = t12_text_secondary, var fontFamily = fontRegular, var isCentered = false, var maxLine = 1, var latterSpacing = 0.1, overflow: Overflow}) {
  return Text(text,
      textAlign: isCentered ? TextAlign.center : TextAlign.start,
      maxLines: maxLine, overflow: TextOverflow.ellipsis,
      style: TextStyle(fontWeight: FontWeight.bold, fontSize: fontSize, color: textColor, height: 1.5, letterSpacing: latterSpacing));
}

Widget formField( BuildContext context, String hint,
    {isEnabled = true,
      isDummy = false,
      isReadOnly = false,
      controller,
      maxLength,
      isPasswordVisible = false,
      isPassword = false,
      keyboardType = TextInputType.text,
      required FormFieldValidator<String> validator,
      onSaved,
      textInputAction = TextInputAction.next,
      required FocusNode focusNode,
      required FocusNode nextFocus,
      required IconData suffixIcon,
      required IconData prefixIcon,
      maxLine = 1,
      suffixIconSelector}) {
  return TextFormField(
    controller: controller,
    readOnly: isReadOnly,
    maxLength: maxLength,
    obscureText: isPassword?isPasswordVisible:false,
    cursorColor: t12_primary_color,
    maxLines: maxLine,
    keyboardType: keyboardType,
    validator: validator,
    onSaved: onSaved,
    textInputAction: textInputAction,
    focusNode: focusNode,
    onFieldSubmitted: (arg) {
      if (nextFocus != null) {
        FocusScope.of(context).requestFocus(nextFocus);
      }
    },
    decoration: InputDecoration(
      focusedBorder: UnderlineInputBorder(
          borderRadius: BorderRadius.circular(spacing_standard),
          borderSide: BorderSide(color: Colors.transparent)

      ),
      enabledBorder: UnderlineInputBorder(
          borderRadius: BorderRadius.circular(spacing_standard),
          borderSide: BorderSide(color: Colors.transparent)

      ),
      filled: true,
      fillColor: t12_edittext_background,
      hintText:hint,
      hintStyle: TextStyle(
          fontSize: textSizeMedium, color: t12_text_secondary),
      prefixIcon:Icon(
        prefixIcon,
        color: t12_text_secondary,
        size: 20,
      ) ,
      suffixIcon: isPassword
          ? GestureDetector(
            onTap: suffixIconSelector,
              child: new Icon(
              suffixIcon,
              color: t12_text_secondary,
              size: 20,
        ),
      )
          : Icon(
        suffixIcon,
        color: t12_text_secondary,
        size: 20,
      ),
    ),
    style: TextStyle(
        fontSize: textSizeNormal,
        color: isDummy
            ? Colors.transparent
            : t12_text_color_primary,
        fontFamily: fontRegular),
  );
}

InputDecoration textDecoration({required String hint,  required IconData prefixIcon, required bool isPassword}){
  return InputDecoration(
    focusedBorder: UnderlineInputBorder(
        borderRadius: BorderRadius.circular(spacing_standard),
        borderSide: BorderSide(color: Colors.transparent)

    ),
    enabledBorder: UnderlineInputBorder(
        borderRadius: BorderRadius.circular(spacing_standard),
        borderSide: BorderSide(color: Colors.transparent)

    ),
    filled: true,
    fillColor: t12_edittext_background,
    hintText:hint,
    hintStyle: TextStyle(
        fontSize: textSizeMedium, color: t12_text_secondary),
    prefixIcon:Icon(
      prefixIcon,
      color: t12_text_secondary,
      size: 20,
    ) ,
  );
}

InputDecoration passDecoration({required String hint,  required IconData prefixIcon, required bool isPassword, suffixIconSelector,required IconData suffixIcon}){
  return InputDecoration(
    focusedBorder: UnderlineInputBorder(
        borderRadius: BorderRadius.circular(spacing_standard),
        borderSide: BorderSide(color: Colors.transparent)

    ),
    enabledBorder: UnderlineInputBorder(
        borderRadius: BorderRadius.circular(spacing_standard),
        borderSide: BorderSide(color: Colors.transparent)

    ),
    filled: true,
    fillColor: t12_edittext_background,
    hintText:hint,
    hintStyle: TextStyle(
        fontSize: textSizeMedium, color: t12_text_secondary),
    prefixIcon:Icon(
      prefixIcon,
      color: t12_text_secondary,
      size: 20,
    ) ,
    suffixIcon: isPassword
        ? GestureDetector(
          onTap: suffixIconSelector,
          child: new Icon(
        suffixIcon,
        color: t12_text_secondary,
        size: 20,
      ),
    )
        : Icon(
      suffixIcon,
      color: t12_text_secondary,
      size: 20,
    ),
  );
}


TextStyle textStyle(){
  return TextStyle(
      fontSize: textSizeNormal,
      color: false
          ? Colors.transparent
          : t12_text_color_primary,
      fontFamily: fontRegular);
}



class CustomAnimation extends EasyLoadingAnimation {
  CustomAnimation();

  @override
  Widget buildWidget(
      Widget child,
      AnimationController controller,
      AlignmentGeometry alignment,
      ) {
    return Opacity(
      opacity: controller.value,
      child: RotationTransition(
        turns: controller,
        child: child,
      ),
    );
  }
}