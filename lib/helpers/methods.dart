

import 'package:flutter/material.dart';

void goreplace(BuildContext context, Widget screen){
  Navigator.of(context).pushReplacement(MaterialPageRoute(
      builder: (context) => screen));
}

void gopush(BuildContext context, Widget screen){
  Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => screen));
}