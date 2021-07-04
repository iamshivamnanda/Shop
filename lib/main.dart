import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './providers/products.dart';
import './screens/product_overview_screen.dart';
import './screens/product_info_screen.dart';
import 'providers/cart.dart';
import './screens/cartscreen.dart';
import './providers/orders.dart';
import './screens/orderscreen.dart';
import './screens/useeproductsscreen.dart';
import './screens/editproductscreen.dart';
import './screens/auth_screen.dart';
import './providers/auth.dart';
import './screens/splash_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => Auth()),
          ChangeNotifierProxyProvider<Auth, Products>(
            update: (context, value, previous) => Products(value.token,
                previous == null ? [] : previous.item, value.userid),
          ),
          ChangeNotifierProvider(
            create: (context) => Cart(),
          ),
          ChangeNotifierProxyProvider<Auth, Orders>(
            update: (context, value, previous) => Orders(value.token,
                previous == null ? [] : previous.orderitems, value.userid),
          ),
        ],
        child: Consumer<Auth>(
          builder: (context, auth, child) => MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'MyShop',
            theme: ThemeData(
              primarySwatch: Colors.purple,
              accentColor: Colors.orange,
              fontFamily: 'Lato',
            ),
            home: auth.isauth
                ? ProductOverViewScreen()
                : FutureBuilder(
                    future: auth.autologin(),
                    builder: (context, snapshot) {
                      return (snapshot.connectionState ==
                              ConnectionState.waiting)
                          ? SplashScreen()
                          : AuthScreen();
                    }),
            routes: {
              ProductInfoScreen.routename: (ctx) => ProductInfoScreen(),
              CartScreen.routename: (ctx) => CartScreen(),
              OrderScreen.routename: (ctx) => OrderScreen(),
              UserProductScreen.routename: (ctx) => UserProductScreen(),
              EditProductScreen.routename: (ctx) => EditProductScreen(),
              AuthScreen.routeName: (ctx) => AuthScreen(),
            },
          ),
        ));
  }
}
