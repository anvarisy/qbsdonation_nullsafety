

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void goreplace(BuildContext context, Widget screen){
  Navigator.of(context).pushReplacement(MaterialPageRoute(
      builder: (context) => screen));
}

void gopush(BuildContext context, Widget screen){
  Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => screen));
}

String money(String nominal){
  String val = "0";
  if(nominal==null){
    val = "0";
  }else{
    val = nominal;
  }
  var a = NumberFormat.currency(locale: "in_ID",symbol: "Rp");
  return a.format(val);
}