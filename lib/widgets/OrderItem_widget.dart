import 'package:flutter/material.dart';
import '../providers/orders.dart' as ord;
import 'package:intl/intl.dart';
import 'dart:math';

class OrderItem extends StatefulWidget {
  final ord.OrderItem orderItem;
  OrderItem(this.orderItem);

  @override
  _OrderItemState createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  bool _expanded = false;
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      height: _expanded
          ? min(widget.orderItem.items.length * 20.0 + 150, 250)
          : 102,
      child: Card(
        margin: EdgeInsets.all(15),
        child: Column(
          children: [
            ListTile(
              title: Text('Total Amount \$${widget.orderItem.amount}'),
              subtitle: Text(
                  DateFormat('dd MM yyyy hh:mm').format(widget.orderItem.date)),
              trailing: IconButton(
                icon: Icon(Icons.expand_more),
                onPressed: () {
                  setState(() {
                    _expanded = !_expanded;
                  });
                },
              ),
            ),
            AnimatedContainer(
              duration: Duration(milliseconds: 300),
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
              height: _expanded
                  ? min(widget.orderItem.items.length * 20.0 + 20, 180)
                  : 0,
              child: ListView.builder(
                itemCount: widget.orderItem.items.length,
                itemBuilder: (context, index) => Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.orderItem.items[index].title,
                    ),
                    Text(
                        '${widget.orderItem.items[index].quantity}x  \$${widget.orderItem.items[index].price}')
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
