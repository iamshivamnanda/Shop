import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/screens/cartscreen.dart';
import 'package:shop/screens/useeproductsscreen.dart';
import '../screens/orderscreen.dart';
import '../providers/auth.dart';

class MyDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "App By Shivam Nanda",
            style: TextStyle(
                color: Theme.of(context).accentColor,
                // fontSize: 28,
                fontFamily: 'Anton'),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 15,
              ),
              ListTile(
                leading: Icon(
                  Icons.shop,
                  color: Theme.of(context).accentColor,
                ),
                title: Text('Shop'),
                onTap: () {
                  Navigator.of(context).pushNamed('/');
                },
              ),
              Divider(),
              ListTile(
                leading: Icon(
                  Icons.shopping_cart,
                  color: Theme.of(context).accentColor,
                ),
                title: Text('Cart'),
                onTap: () {
                  Navigator.of(context).pushNamed(CartScreen.routename);
                },
              ),
              Divider(),
              ListTile(
                leading: Icon(
                  Icons.payment,
                  color: Theme.of(context).accentColor,
                ),
                title: Text('Orders'),
                onTap: () {
                  Navigator.of(context).pushNamed(OrderScreen.routename);
                },
              ),
              Divider(),
              ListTile(
                leading: Icon(
                  Icons.edit,
                  color: Theme.of(context).accentColor,
                ),
                title: Text('Manage Products'),
                onTap: () {
                  Navigator.of(context)
                      .pushReplacementNamed(UserProductScreen.routename);
                },
              ),
              Divider(),
              ListTile(
                leading: Icon(
                  Icons.logout,
                  color: Theme.of(context).accentColor,
                ),
                title: Text('Log Out'),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pushReplacementNamed('/');
                  Provider.of<Auth>(context, listen: false).logout();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
