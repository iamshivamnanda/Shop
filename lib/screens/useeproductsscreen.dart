import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/screens/editproductscreen.dart';
import '../providers/products.dart';
import '../widgets/Drawer.dart';
import '../widgets/Productmanager.dart';

class UserProductScreen extends StatelessWidget {
  static const routename = '/user-products';
  Future<void> _refreshproducts(BuildContext context) async {
    await Provider.of<Products>(context, listen: false).fetechandsetdata(true);
  }

  @override
  Widget build(BuildContext context) {
    // final productdata = Provider.of<Products>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Your Products'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(EditProductScreen.routename);
            },
          )
        ],
      ),
      drawer: MyDrawer(),
      body: FutureBuilder(
          future: _refreshproducts(context),
          builder: (context, snapshot) {
            return (snapshot.connectionState == ConnectionState.waiting)
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : RefreshIndicator(
                    onRefresh: () => _refreshproducts(context),
                    child: Consumer<Products>(
                      builder: (ctx, productdata, _) => ListView.builder(
                        itemCount: productdata.item.length,
                        itemBuilder: (context, index) => ProductManger(
                            productdata.item[index].id,
                            productdata.item[index].title,
                            productdata.item[index].imageUrl),
                      ),
                    ),
                  );
          }),
    );
  }
}
