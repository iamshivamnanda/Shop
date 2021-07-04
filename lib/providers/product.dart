import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isfav;

  Product(
      {@required this.id,
      @required this.title,
      @required this.description,
      @required this.price,
      @required this.imageUrl,
      this.isfav = false});
  Future<void> togglefav(String token, String userid) async {
    final oldstatus = isfav;
    isfav = !isfav;
    notifyListeners();
    final url =
        'https://shop-fbad0-default-rtdb.firebaseio.com/userfavroutis/$userid/$id.json?auth=$token';
    try {
      final response = await http.put(url,
          body: json.encode(
            isfav,
          ));
      if (response.statusCode >= 400) {
        isfav = oldstatus;
        notifyListeners();
      }
    } catch (error) {
      isfav = oldstatus;
      notifyListeners();
    }
    // print(isfav);
  }
}
