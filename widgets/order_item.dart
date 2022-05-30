import 'package:flutter/material.dart';
import '../providers/orders.dart' as ord;
import 'package:intl/intl.dart';
import 'dart:math';

class OrderItem extends StatefulWidget {
  final ord.OrderItem order;

  OrderItem(this.order);

  @override
  State<OrderItem> createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  var _expanded = false;
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(10),
      child: Column(children: [
        ListTile(
          title: Text('\$${widget.order.amount.roundToDouble()}'),
          subtitle: Text(
            DateFormat('dd MM yyyy hh:mm').format(widget.order.dateTime),
          ),
          trailing: IconButton(
            icon: Icon(_expanded ? Icons.expand_less : Icons.expand_more),
            onPressed: () {
              setState(() {
                _expanded = !_expanded;
              });
            },
          ),
        ),
        if (_expanded)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
            height: min(widget.order.products.length * 20.0 + 10.0, 100.0),
            child: ListView(
              children: widget.order.products
                  .map(
                    (product) => Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(product.title),
                        Text('${product.quantity}x${product.price}\$')
                      ],
                    ),
                  )
                  .toList(),
            ),
          )
      ]),
    );
  }
}
