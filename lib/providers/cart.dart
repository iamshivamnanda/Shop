import 'package:flutter/foundation.dart';

class CartItem {
  final String productId;
  final String title;
  final double price;
  final int quantity;

  CartItem(
      {@required this.productId,
      @required this.title,
      @required this.price,
      @required this.quantity});
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    return {..._items};
  }

  int get itemcount {
    return _items.length;
  }

  double get totalamout {
    double total = 0.0;
    _items.forEach((key, value) {
      total += value.price * value.quantity;
    });
    return total;
  }

  void additem(String productId, String title, double price) {
    if (_items.containsKey(productId)) {
      //change the qunatity
      _items.update(
          productId,
          (value) => CartItem(
              productId: value.productId,
              title: value.title,
              price: value.price,
              quantity: value.quantity + 1));
    } else {
      _items.putIfAbsent(
          productId,
          () => CartItem(
              productId: DateTime.now().toString(),
              title: title,
              price: price,
              quantity: 1));
    }
    notifyListeners();
  }

  void deleteitem(String productid) {
    _items.remove(productid);
    notifyListeners();
  }

  void clearitems() {
    _items = {};
    notifyListeners();
  }

  void removesingleitem(String productid) {
    if (!_items.containsKey(productid)) {
      return;
    }
    if (_items[productid].quantity > 1) {
      _items.update(
          productid,
          (value) => CartItem(
              productId: value.productId,
              title: value.title,
              price: value.price,
              quantity: value.quantity - 1));
    } else {
      _items.remove(productid);
    }
    notifyListeners();
  }
}
