
import 'package:qbsdonation/com.stfqmarket/objects/cart.dart';
import 'package:qbsdonation/com.stfqmarket/objects/category.dart';
import 'package:qbsdonation/com.stfqmarket/objects/product.dart';
import 'package:qbsdonation/com.stfqmarket/objects/tenant.dart';

class TempData {
  static List<Category>? MarketCategories; //TODO: reset to null on refresh
  static List<Product>? MarketProducts; //TODO: reset to null on refresh

  static void clear() {
    MarketCategories = null;
    MarketProducts = null;
  }
}