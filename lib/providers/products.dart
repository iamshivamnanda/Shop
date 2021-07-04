import 'package:flutter/material.dart';
import 'product.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/http_exception.dart';

class Products with ChangeNotifier {
  List<Product> _items = [
    // Product(
    //   id: 'p1',
    //   title: 'Red Shirt',
    //   description: 'A red shirt - it is pretty red!',
    //   price: 29.99,
    //   imageUrl:
    //       'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    // ),
    // Product(
    //   id: 'p2',
    //   title: 'Trousers',
    //   description: 'A nice pair of trousers.',
    //   price: 59.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    // ),
    // Product(
    //   id: 'p3',
    //   title: 'Yellow Scarf',
    //   description: 'Warm and cozy - exactly what you need for the winter.',
    //   price: 19.99,
    //   imageUrl:
    //       'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    // ),
    // Product(
    //   id: 'p4',
    //   title: 'A Pan',
    //   description: 'Prepare any meal you want.',
    //   price: 49.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    // ),
  ];
  final String token;
  final String userid;
  Products(this.token, this._items, this.userid);
  List<Product> get item {
    return [..._items];
  }

  Future<void> additem(Product recivedproduct) async {
    final url =
        'https://shop-fbad0-default-rtdb.firebaseio.com/products.json?auth=$token';
    try {
      final response = await http.post(url,
          body: json.encode({
            'title': recivedproduct.title,
            'price': recivedproduct.price,
            'description': recivedproduct.description,
            'imageurl': recivedproduct.imageUrl,
            'isfav': recivedproduct.isfav,
            'createrid': userid
          }));
      final newproduct = Product(
          title: recivedproduct.title,
          price: recivedproduct.price,
          description: recivedproduct.description,
          imageUrl: recivedproduct.imageUrl,
          id: json.decode(response.body)['name']);
      _items.add(newproduct);
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Product findbyid(String id) {
    return _items.firstWhere((element) => element.id == id);
  }

  List<Product> get favitems {
    return _items.where((element) => element.isfav).toList();
  }

  Future<void> updateproduct(String productid, Product newproduct) async {
    final prodindex = _items.indexWhere((element) => element.id == productid);

    if (prodindex >= 0) {
      final url =
          'https://shop-fbad0-default-rtdb.firebaseio.com/products/$productid.json?auth=$token';
      try {
        await http.patch(url,
            body: json.encode({
              'title': newproduct.title,
              'price': newproduct.price,
              'description': newproduct.description,
              'imageurl': newproduct.imageUrl,
            }));

        _items[prodindex] = newproduct;
        notifyListeners();
      } catch (error) {
        throw error;
      }
    } else {
      print('inavlid');
    }
  }

  Future<void> delproduct(String productid) async {
    final productindex =
        _items.indexWhere((element) => element.id == productid);
    var existingproduct = _items[productindex];
    _items.removeAt(productindex);
    notifyListeners();

    final url =
        'https://shop-fbad0-default-rtdb.firebaseio.com/products/$productid.json?auth=$token';
    final response = await http.delete(url);

    if (response.statusCode >= 400) {
      _items.insert(productindex, existingproduct);
      notifyListeners();
      throw HttpException('Could Not Delete Error');
    }
    existingproduct = null;
  }

  Future<void> fetechandsetdata(bool filterByUser) async {
    final filterString =
        filterByUser ? 'orderBy="createrid"&equalTo="$userid"' : '';
    var url =
        'https://shop-fbad0-default-rtdb.firebaseio.com/products.json?auth=$token&$filterString';
    try {
      final response = await http.get(url);
      final responsedata = json.decode(response.body) as Map<String, dynamic>;
      if (responsedata == null) {
        return;
      }
      final userurl =
          'https://shop-fbad0-default-rtdb.firebaseio.com/userfavroutis/$userid.json?auth=$token';
      final userresponse = await http.get(userurl);
      final favoriteData = json.decode(userresponse.body);
      List<Product> loadedproduct = [];
      responsedata.forEach((prodid, proddata) {
        loadedproduct.add(Product(
          id: prodid,
          title: proddata['title'],
          price: double.parse(proddata['price'].toString()),
          description: proddata['description'],
          imageUrl: proddata['imageurl'],
          isfav: favoriteData == null ? false : favoriteData[prodid] ?? false,
          // isfav: (userresponsedata == null) ? false : userresponsedata[prodid],
        ));
      });
      _items = loadedproduct;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }
}
