import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/orders.dart';
import 'package:shop_app/widgets/app_drawer.dart';
import 'package:shop_app/widgets/orders_item.dart';

import '../widgets/empty_msg.dart';

class OrdersScreen extends StatefulWidget {
  static const routeName = "/orders_screen";

  const OrdersScreen({Key? key}) : super(key: key);

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  late Future _ordersFuture;

  var _isRefresh = false;

  Future<void> _getFutureOrders() => Provider.of<Orders>(
        context,
        listen: false,
      ).fetchOrders().catchError((error) => Future.error(error));

  Future<void> _refreshOrders() async {
    final refreshFuture =
        _getFutureOrders().whenComplete(() => _isRefresh = false);
    _isRefresh = true;
    setState(() {
      _ordersFuture = refreshFuture;
    });
  }

  @override
  void initState() {
    super.initState();
    _ordersFuture = _getFutureOrders();
  }

  @override
  Widget build(BuildContext context) {
    final appLocalization = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(appLocalization.yourOrders),
      ),
      body: FutureBuilder(
          future: _ordersFuture,
          builder: (context, dataSnapShot) {
            if (dataSnapShot.connectionState == ConnectionState.waiting &&
                !_isRefresh) {
              return const Center(child: CircularProgressIndicator());
            } else {
              if (dataSnapShot.hasError) {
                return EmptyMsgWidget(message: dataSnapShot.error.toString());
              } else {
                return Consumer<Orders>(
                  builder: (context, orderData, child) => RefreshIndicator(
                    onRefresh: _refreshOrders,
                    child: orderData.orders.isEmpty
                        ? EmptyMsgWidget(message: appLocalization.emptyOrders)
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
