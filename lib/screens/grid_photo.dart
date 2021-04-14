import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:qbsdonation/screens/image_viewer_ii.dart';
import 'package:qbsdonation/utils/constants.dart';

class grid_photo extends StatefulWidget {
  final dynamic images;
  final int? max;
  final from;

  grid_photo({this.images, this.max, this.from});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return grid();
  }
}

class grid extends State<grid_photo> {
  @override
  void initState() {}

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    // print(widget.images);
    return GridView.builder(
      scrollDirection: Axis.vertical,
      itemCount: widget.max,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return InkWell(
          onTap: () {
/*            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => GalleryPhotoViewWrapper(
                      initialIndex: index,
                      galleryItems: widget.images,
                      maxImage:
                         widget.max,
                    ))
            )*/
           /* ImageViewer.showImageSlider(images: List<String>.from(widget.images),
            startingPosition: index)*/
            Navigator.of(context).push(MaterialPageRoute(builder: (context) =>
               image_viewer_ii(current_index:index, max_images:widget.max ?? 0, images:widget.images)
           ));
          },
          child: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(spacing_middle)),
            child:  CachedNetworkImage(
              placeholder: (context, url) =>Center(
                child: Container(
                  width: 20.0,
                  height: 20.0,
                  child: CircularProgressIndicator(),
                ),
              ),
              errorWidget: (context, url, error) => Icon(Icons.error),
              imageUrl:widget.images[index],
              fit: BoxFit.cover,
            ),
          ),
        );
      },
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
    );
  }
/* List<col_profil> getProfile() {
    List<col_profil> list = List<col_profil>();
    list.add(col_profil('assets/images/sample/a.jpg'));
    list.add(col_profil('assets/images/sample/b.jpg'));
    list.add(col_profil('assets/images/sample/c.jpg'));
    list.add(col_profil('assets/images/sample/d.jpg'));
    list.add(col_profil('assets/images/sample/e.jpg'));
    return list;
  }*/
}
