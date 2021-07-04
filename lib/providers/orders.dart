import 'package:flutter/material.dart';
import './cart.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class OrderItem {
  final String id;
  final List<CartItem> items;
  final double amount;
  final DateTime date;

  OrderItem({
    @required this.id,
    @required this.items,
    @required this.amount,
    @required this.date,
  });
}

class Orders with ChangeNotifier {
  List<OrderItem> _orderitems = [];

  List<OrderItem> get orderitems {
    return [..._orderitems];
  }

  final String token;
  final String userid;
  Orders(this.token, this._orderitems, this.userid);
  Future<void> fetechandsetorders() async {
    final url =
        'https://shop-fbad0-default-rtdb.firebaseio.com/orders/$userid.json?auth=$token';
    final response = await http.get(url);
    final extracteddata = json.decode(response.body) as Map<String, dynamic>;
    if (extracteddata == null) {
      return;
    }
    List<OrderItem> loadedorders = [];
    extracteddata.forEach((orderid, orderdata) {
      loadedorders.add(OrderItem(
          id: orderid,
          amount: orderdata['amount'],
          date: DateTime.parse(
            orderdata['date'],
          ),
          items: (orderdata['items'] as List<dynamic>)
              .map((e) => CartItem(
                  productId: e['id'],
                  title: e['title'],
                  price: e['price'],
                  quantity: e['quantity']))
              .toList()));
    });
    _orderitems = loadedorders.reversed.toList();
    notifyListeners();
    // print(extracteddata);
  }

  Future<void> addorder(
    List<CartItem> items,
    double amount,
  ) async {
    final url =
        'https://shop-fbad0-default-rtdb.firebaseio.com/orders/$userid.json?auth=$token';
    final datetime = DateTime.now();
    final response = await http.post(url,
        body: json.encode({
          'amount': amount,
          'date': datetime.toIso8601String(),
          'items': items
              .map((e) => {
                    'id': e.productId,
                    'title': e.title,
                    'price': e.price,
                    'quantity': e.quantity
                  })
              .toList()
        }));
    _orderitems.insert(
        0,
        OrderItem(
            id: json.decode(response.body)['name'],
            items: items,
            amount: amount,
            date: DateTime.now()));
    notifyListeners();
  }
}
