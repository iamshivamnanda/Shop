import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/products.dart';
import '../providers/cart.dart';
// import '../models/product.dart';

class ProductInfoScreen extends StatelessWidget {
  static const routename = '/product-info';
  @override
  Widget build(BuildContext context) {
    final productid = ModalRoute.of(context).settings.arguments as String;
    final productdata =
        Provider.of<Products>(context, listen: false).findbyid(productid);
    final cart = Provider.of<Cart>(context);

    // final product =

    return Scaffold(
      // appBar: AppBar(
      //   title: Text(productdata.title),
      // ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.shopping_cart),
        onPressed: () {
          cart.additem(productdata.id, productdata.title, productdata.price);
          ScaffoldMessenger.of(context).removeCurrentSnackBar();
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Added Item to Cart'),
            duration: Duration(seconds: 2),
            action: SnackBarAction(
              label: "UNDO",
              onPressed: () {
                cart.removesingleitem(productdata.id);
              },
            ),
          ));
        },
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
              expandedHeight: 300,
              pinned: true,
              title: Text(
                productdata.title.toUpperCase(),
                textAlign: TextAlign.center,
              ),
              flexibleSpace: FlexibleSpaceBar(
                  background: Hero(
                tag: productid,
                child: Image.network(
                  productdata.imageUrl,
                  fit: BoxFit.cover,
                ),
              ))),
          SliverList(
            delegate: SliverChildListDelegate([
              SizedBox(
                height: 15,
              ),
              Text(
                productdata.title.toUpperCase(),
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20, color: Colors.black54),
              ),
              SizedBox(
                height: 15,
              ),
              Text(
                'Price : \$${productdata.price}',
                style: TextStyle(fontSize: 30, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                '${productdata.description}',
                softWrap: true,
                style: TextStyle(
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 800,
              ),
            ]),
          ),
        ],
      ),
    );
  }
}
