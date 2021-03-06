


import 'dart:async';
import 'dart:typed_data';

import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'dart:io';



class carousel {
    var title;
    var subtitle;
    var link;
    var image;
}

class company_{
    var detail;
    dynamic photos;
    dynamic missions;
    var visi;
}

class user_profil{
    var uid;
    var name;
    var email;
    var mobile;
}

class mission {
    var id;
    var title;
    var detail;
    var image;
    var target;
    dynamic photos;
    dynamic collected;
    var start;
    var end;
    var report;
}

class articles{
    var title;
    var detail;
    var image;
    var date;

}

class donation{
    var title;
    var date;
    var amount;
    var image;
}

class ticket{
   Color? color;
   var amount;
   var icon;
   double? value;

}

class stfq_video{
    String? link;
    bool? status;
}

class m_stfq_video{
    String? video_link;
    String? image_link;
}

class user_auth{
    var email;
    var uid;
    var status;
}

/*
class ThumbnailRequest {
    final String? video;
    final String? thumbnailPath;
    final ImageFormat? imageFormat;
    final int? maxHeight;
    final int? maxWidth;
    final int? timeMs;
    final int? quality;

    const ThumbnailRequest(
        { this.video,
            this.thumbnailPath,
            this.imageFormat,
            this.maxHeight,
            this.maxWidth,
            this.timeMs,
            this.quality});
}
*/

class ThumbnailResult {
    final Image? image;
    final int? dataSize;
    final int? height;
    final int? width;
    const ThumbnailResult({this.image, this.dataSize, this.height, this.width});
}

/*
Future<ThumbnailResult> genThumbnail(ThumbnailRequest r) async {
    //WidgetsFlutterBinding.ensureInitialized();
    Uint8List bytes;
    final Completer<ThumbnailResult> completer = Completer();
    if (r.thumbnailPath != null) {
        final thumbnailPath = await VideoThumbnail.thumbnailFile(
            video: r.video!,
            thumbnailPath: r.thumbnailPath!,
            imageFormat: r.imageFormat!,
            maxHeight: r.maxHeight!,
            maxWidth: r.maxWidth!,
            timeMs: r.timeMs!,
            quality: r.quality!);
        print('----------------------------------------');
        print("thumbnail file is located: $thumbnailPath");

        final file = File(thumbnailPath!);
        bytes = file.readAsBytesSync();
    } else {
        print('+++++++++++++++++++++++++++++++++++++++++++');
        bytes = (await VideoThumbnail.thumbnailData(
            video: r.video!,
            imageFormat: r.imageFormat!,
            maxHeight: r.maxHeight!,
            maxWidth: r.maxWidth!,
            timeMs: r.timeMs!,
            quality: r.quality!))!;
    }

    int _imageDataSize = bytes.length;
    print("image size: $_imageDataSize");

    final _image = Image.memory(bytes);
    _image.image
        .resolve(ImageConfiguration())
        .addListener(ImageStreamListener((ImageInfo info, bool _) {
        completer.complete(ThumbnailResult(
            image: _image,
            dataSize: _imageDataSize,
            height: info.image.height,
            width: info.image.width,
        ));
    }));
    return completer.future;
}
*/

class col_profil{
    var image;

    col_profil(this.image);

}

class channel{
    var id;
    var icon;
    var title;
    int? code;
}

class money {
    static String toCurrency(String value) {
        return toCurrencyString(
            value,
            mantissaLength: 2,
            thousandSeparator: ThousandSeparator.Period,
            shorteningPolicy: ShorteningPolicy.NoShortening,
            leadingSymbol: 'IDR',
            trailingSymbol: '',
            useSymbolPadding: false,
     );
    }
}

class CreditCardModel {

    CreditCardModel(this.cardNumber, this.expiryDate, this.cardHolderName, this.cvvCode, this.isCvvFocused);

    String cardNumber = '';
    String expiryDate = '';
    String cardHolderName = '';
    String cvvCode = '';
    bool isCvvFocused = false;
}
