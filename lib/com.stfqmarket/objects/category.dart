
import 'package:cloud_firestore/cloud_firestore.dart';

class Category {
  final String id, name;
  final String? image;

  Category(this.id, this.name, {this.image});

  static List<Category> toList(List<QueryDocumentSnapshot> items) {
    return items.map<Category>((e) => Category(e.id, e.data()['category_name'],
        image: e.data()['category_image'])).toList();
  }
}