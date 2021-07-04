import 'package:flutter/material.dart';
import 'package:shop/screens/cartscreen.dart';
// import '../models/product.dart';
import '../widgets/productitem.dart';
import '../widgets/Drawer.dart';
import 'package:provider/provider.dart';
import '../providers/products.dart';
import '../widgets/badge.dart';
import '../providers/cart.dart';

enum FilterOption { Favorite, All }

class ProductOverViewScreen extends StatefulWidget {
  @override
  _ProductOverViewScreenState createState() => _ProductOverViewScreenState();
}

class _ProductOverViewScreenState extends State<ProductOverViewScreen> {
  var _showfav = false;
  var _initstate = true;
  var _loading = false;
  @override
  void didChangeDependencies() {
    if (_initstate) {
      setState(() {
        _loading = true;
      });
      Provider.of<Products>(context, listen: false)
          .fetechandsetdata(false)
          .then((value) {
        setState(() {
          _loading = false;
        });
      });
    }
    _initstate = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MyDrawer(),
      appBar: AppBar(
        title: Text('MY SHOP'),
        actions: [
          PopupMenuButton(
            itemBuilder: (context) => [
              PopupMenuItem(
                child: Text('Only Favorites'),
                value: FilterOption.Favorite,
              ),
              PopupMenuItem(
                child: Text('Show All'),
                value: FilterOption.All,
              )
            ],
            icon: Icon(Icons.more_vert),
            onSelected: (FilterOption value) {
              if (value == FilterOption.Favorite) {
                setState(() {
                  _showfav = true;
                });
              } else {
                setState(() {
                  _showfav = false;
                });
              }
            },
          ),
          Consumer<Cart>(
            builder: (context, value, child) =>
                Badge(child: child, value: value.itemcount.toString()),
            child: IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: () {
                Navigator.of(context).pushNamed(CartScreen.routename);
              },
            ),
          )
        ],
      ),
      body: _loading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ProductsGrid(_showfav),
    );
  }
}

class ProductsGrid extends StatelessWidget {
  final bool fav;
  ProductsGrid(this.fav);
  @override
  Widget build(BuildContext context) {
    final productdata = Provider.of<Products>(context);
    final products = fav ? productdata.favitems : productdata.item;
    return GridView.builder(
      padding: EdgeInsets.all(10.0),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 3 / 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10),
      itemBuilder: (context, index) => ChangeNotifierProvider.value(
        value: products[index],
        child: ProductItem(),
      ),
      itemCount: products.length,
    );
  }
}
