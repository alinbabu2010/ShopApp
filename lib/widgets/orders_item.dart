import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shop_app/data/models/order_item.dart';
import 'package:shop_app/utils/dimens.dart';
import 'package:shop_app/utils/typography.dart';

class OrdersItem extends StatefulWidget {
  final OrderItem order;

  const OrdersItem(this.order, {Key? key}) : super(key: key);

  @override
  State<OrdersItem> createState() => _OrdersItemState();
}

class _OrdersItemState extends State<OrdersItem> {
  var _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: ordersItemCardMargin,
      child: Column(
        children: [
          ListTile(
            title: Text('\$${widget.order.amount.toStringAsFixed(2)}'),
            subtitle: Text(
              DateFormat.yMMMd().add_jm().format(widget.order.dateTime),
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
              padding: ordersItemExpandedContainerPadding,
              height: min(((widget.order.products.length * 20) + 20), 180),
              child: ListView(
                children: widget.order.products
                    .map((product) => Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              product.title,
                              style: orderItemExpandedTitleStyle,
                            ),
                            Text(
                              '${product.quantity} x \$${product.price}',
                              style: orderItemExpandedPriceStyle,
                            )
                          ],
                        ))
                    .toList(),
              ),
            )
        ],
      ),
    );
  }
}
