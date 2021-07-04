import 'package:flutter/material.dart';
import '../providers/orders.dart';
import 'package:provider/provider.dart';
import '../widgets/OrderItem_widget.dart' as ordw;

class OrderScreen extends StatelessWidget {
  static const routename = '/order-screen';

  @override
  Widget build(BuildContext context) {
    // final orderdata = Provider.of<Orders>(context);
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Your Orders",
            textAlign: TextAlign.center,
          ),
        ),
        body: FutureBuilder(
          future:
              Provider.of<Orders>(context, listen: false).fetechandsetorders(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else {
              if (snapshot.error != null) {
                return Center(
                  child: Text('An Error Occured'),
                );
              } else {
                return Padding(
                    padding: EdgeInsets.all(8),
                    child: Consumer<Orders>(
                      builder: (context, orderdata, child) => ListView.builder(
                        itemCount: orderdata.orderitems.length,
                        itemBuilder: (context, index) =>
                            ordw.OrderItem(orderdata.orderitems[index]),
                      ),
                    ));
              }
            }
          },
        ));
  }
}
