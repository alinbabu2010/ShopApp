import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/orders.dart';
import 'package:shop_app/utils/constants.dart';
import 'package:shop_app/widgets/app_drawer.dart';
import 'package:shop_app/widgets/orders_item.dart';

class OrdersScreen extends StatelessWidget {
  static const routeName = "/orders_screen";

  const OrdersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final orderData = Provider.of<Orders>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text(yourOrders),
      ),
      body: ListView.builder(
        itemBuilder: (_, index) => OrdersItem(orderData.orders[index]),
        itemCount: orderData.orders.length,
      ),
      drawer: const AppDrawer(),
    );
  }
}
