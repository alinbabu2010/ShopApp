import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/orders.dart';
import 'package:shop_app/utils/constants.dart' as constants;
import 'package:shop_app/widgets/app_drawer.dart';
import 'package:shop_app/widgets/orders_item.dart';

import '../widgets/empty_msg.dart';

class OrdersScreen extends StatelessWidget {
  static const routeName = "/orders_screen";

  const OrdersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(constants.yourOrders),
      ),
      body: FutureBuilder(
          future: Provider.of<Orders>(context, listen: false).fetchOrders(),
          builder: (context, dataSnapShot) {
            if (dataSnapShot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else {
              if (dataSnapShot.hasError) {
                return EmptyMsgWidget(message: dataSnapShot.error.toString());
              } else {
                return Consumer<Orders>(
                  builder: (context, orderData, child) => RefreshIndicator(
                    onRefresh: () => orderData.fetchOrders(),
                    child: orderData.orders.isEmpty
                        ? const EmptyMsgWidget(message: constants.emptyOrders)
                        : ListView.builder(
                            itemBuilder: (_, index) =>
                                OrdersItem(orderData.orders[index]),
                            itemCount: orderData.orders.length,
                          ),
                  ),
                );
              }
            }
          }),
      drawer: const AppDrawer(),
    );
  }
}