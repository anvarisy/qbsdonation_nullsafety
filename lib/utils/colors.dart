

import 'dart:ui';

import 'package:flutter/material.dart';

const black = Color(0xFF000000);
const dominan = Color(0xFF4c54a3);
const p_1 = Color(0xFF15b494);
const p_2 = Color(0xFF4b52a3);
const p_3 = Color(0xFFcec7a8);
const p_4 = Color(0xFF8a94c5);
const p_5 = Color(0xFF452d8c);
const p_6 = Color(0xFF3d95a8);
const p_7 = Color(0xFF98a9d4);
const p_8 = Color(0xFFa1c2d4);
const p_9 = Color(0xFF9e842c);
const p_10 = Color(0xFF347ca4);
const p_11 = Color(0xff7ac3ff);
const p_12 = Color(0xffff6e26);
const p_13 = Color(0xff5491f2);

const t12_primary_color = Color(0xFF3d87ff);
const t12_success = Color(0xFF36d592);
const t12_error = Color(0xFFF32323);
const t12_text_color_primary = Color(0xFF1e253a);
const t12_text_secondary = Color(0xFF838591);
const t12_edittext_background = Color(0xFFfafafa);
const t12_cat1 = Color(0xFF366cfd);
const t12_cat2 = Color(0xFFff7d34);
const t12_cat3 = Color(0xFF35c88e);
const t12_cat4 = Color(0xFFf32323);
const t12_colors = [t12_cat1, t12_cat2, t12_cat3, t12_cat4];
const t12_gradient_colors = [[Color(0xFF7deaa7),Color(0xff57ca8f), Color(0xff189f6b)], [Color(0xFF79caff),Color(0xff5b9afb), Color(0xff3155cf)], [Color(0xFFFeaa7b),Color(0xfffb965e), Color(0xfff5762f)]];

const t1TextColorPrimary = Color(0xFF212121);
const t2_colorPrimary = Color(0xFF5959fc);
const t2_colorPrimaryDark = Color(0xFF7900F5);
const t2_colorPrimaryLight = Color(0xFFF2ECFD);
const t2_colorAccent = Color(0xFF7e05fa);
const t2_textColorPrimary = Color(0xFF212121);
const t2_textColorSecondary = Color(0xFF747474);
const t2_app_background = Color(0xFFf8f8f8);
const t2_view_color = Color(0xFFDADADA);
const t2_white = Color(0xFFFFFFFF);
const t2_icon_color = Color(0xFF747474);
const t2_blue = Color(0xFF1C38D3);
const t2_orange = Color(0xFFFF5722);
const t2_background_bottom_navigation = Color(0xFFE9E7FE);
const t2_background_selected = Color(0xFFF3EDFE);
const t2_green = Color(0xFF5CD551);
const t2_red = Color(0xFFFD4D4B);
const t2_card_background = Color(0xFFFaFaFa);
const t2_bg_bottom_sheet = Color(0xFFE8E6FD);
const t2_instagram_pink = Color(0xFFCC2F97);
const t2_linkedin_pink = Color(0xFF0c78b6);
var t2lightStatusBar = materialColor(0xFFEAEAF9);
var t2White = materialColor(0xFFFFFFFF);
var t2TextColorPrimary = materialColor(0xFF212121);
const shadow_color = Color(0xFFECECEC);

Map<int, Color> color = {
  50: Color.fromRGBO(136, 14, 79, .1),
  100: Color.fromRGBO(136, 14, 79, .2),
  200: Color.fromRGBO(136, 14, 79, .3),
  300: Color.fromRGBO(136, 14, 79, .4),
  400: Color.fromRGBO(136, 14, 79, .5),
  500: Color.fromRGBO(136, 14, 79, .6),
  600: Color.fromRGBO(136, 14, 79, .7),
  700: Color.fromRGBO(136, 14, 79, .8),
  800: Color.fromRGBO(136, 14, 79, .9),
  900: Color.fromRGBO(136, 14, 79, 1),
};

MaterialColor materialColor(colorHax) {
  return MaterialColor(colorHax, color);
}

MaterialColor colorCustom = MaterialColor(0xFF5959fc, color);


const t4_colorPrimary = Color(0xFF4600D9);
const t4_colorPrimaryDark = Color(0xFF4600D9);
const t4_colorAccent = Color(0xFF4600D9);

const t4_textColorPrimary = Color(0xFF333333);
const t4_textColorSecondary = Color(0xFF9D9D9D);

const t4_app_background = Color(0xFFf8f8f8);
const t4_view_color = Color(0xFFDADADA);

const t4_white = Color(0xFFffffff);
const t4_black = Color(0xFF000000);

const t4_icon_color = Color(0xFF747474);
const t4_form_background = Color(0xFFF6F7F9);
const t4_form_facebook = Color(0xFF2F3181);
const t4_form_google = Color(0xFFF13B19);
const t4_green = Color(0xFF0DAF14);
const t4_light = Color(0xFF23DFD5);
const t4_walk = Color(0xFFEDE5FC);

const t4_cat1 = Color(0xFFFF727B);
const t4_cat2 = Color(0xFF439AF8);
const t4_cat3 = Color(0xFF72D4A1);
const t4_cat4 = Color(0xFFFFC358);
const t4_cat5 = Color(0xFFA89DF6);
const t4_shadow_color = Color(0x95E9EBF0);


const t10_colorPrimary = Color(0xFF554BDF);
const t10_colorPrimaryDark = Color(0xFF554BDF);
const t10_colorAccent = Color(0xFF554BDF);
const t10_colorPrimary_light = Color(0xFF3E3A5BFB);
const t10_textColorPrimary = Color(0xFF130925);
const t10_textColorSecondary = Color(0xFF888888);
const t10_textColorSecondary_blue = Color(0xFF86859B);
const t10_textColorThird = Color(0xFFBABFB6);
const t10_textColorGrey = Color(0xFFB4BBC2);
const t10_white = Color(0xFFFFFFFF);

const t10_layout_background_white = Color(0xFFF6F7FA);
const t10_view_color = Color(0xFFB4BBC2);
const t10_blue_color = Color(0xFF3A5BFB);
const t10_gradient1 = Color(0xFF3a5af9);
const t10_app_background = Color(0xFFf8f8f8);
const t10_gradient2 = Color(0xFF7449fa);

const t10_ShadowColor = Color(0x95E9EBF0);


const t5ColorPrimary = Color(0xFF5104D7);
const t5ColorPrimaryDark = Color(0xFF325BF0);
const t5ColorAccent = Color(0xFFD81B60);
const t5TextColorPrimary = Color(0xFF130925);
const t5TextColorSecondary = Color(0xFF888888);
const t5TextColorThird = Color(0xFFBABFB6);
const t5TextColorGrey = Color(0xFFB4BBC2);
const t5White = Color(0xFFFFFFFF);
const t5LayoutBackgroundWhite = Color(0xFFF6F7FA);
const t5ViewColor = Color(0xFFB4BBC2);
const t5SkyBlue = Color(0xFF1fc9cd);
const t5DarkNavy = Color(0xFF130925);
const t5Cat1 = Color(0xFF45c7db);
const t5Cat2 = Color(0xFF510AD7);
const t5Cat3 = Color(0xFFe43649);
const t5Cat4 = Color(0xFFf4b428);
const t5Cat5 = Color(0xFF22ce9a);
const t5Cat6 = Color(0xFF203afb);
const t5ShadowColor = Color(0x95E9EBF0);
const t5DarkRed = Color(0xFFF06263);
const t5ColorPrimaryLight = Color(0x505104D7);


const t11_PrimaryColor = Color(0xFF020e66);
const t11_GradientColor1 = Color(0xFFF2F5F9);
const t11_GradientColor2 = Color(0xFFB4C5D1);

const t11_BackgroundColor = Color(0xFF4c61fc);
const t11_WhiteColor = Color(0xFFffffff);
const t11_blackColor = Color(0xFF000000);
const t11_greyColor = Color(0xFF808080);
const t11_1 = Color(0xFF020e66);

const t7colorPrimary = Color(0xFF2F95A1);

const t7colorPrimaryDark = Color(0xFF2F95A1);
const t7colorAccent = Color(0xFF2F95A1);

const t7textColorPrimary = Color(0xFF333333);
const t7textColorSecondary = Color(0xFF9D9D9D);

const t7app_background = Color(0xFFf8f8f8);
const t7view_color = Color(0xFFDADADA);

const t7white = Color(0xFFffffff);
const t7black = Color(0xFF000000);

const t7icon_color = Color(0xFF747474);
const t7form_facebook = Color(0xFF2F3181);
const t7form_google = Color(0xFFF13B19);
const t7light_blue = Color(0xFFD6DBF0);
const t7ShadowColor = Color(0x95E9EBF0);

const T7Hotel = Color(0xFFF0F5F7);
const T7Flight = Color(0xFFFFF4F4);
const T7Food = Color(0xFFFFF6F1);
const T7Event = Color(0xFFF3F1FA);
const t7_fb_blue = Color(0xFF3B5998);
const t7_black_trans = Color(0xFF56303030);