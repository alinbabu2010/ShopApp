import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/orders.dart';
import 'package:shop_app/utils/constants.dart';
import 'package:shop_app/widgets/app_drawer.dart';
import 'package:shop_app/widgets/orders_item.dart';

class OrdersScreen extends StatefulWidget {
  static const routeName = "/orders_screen";

  const OrdersScreen({Key? key}) : super(key: key);

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  late Orders orderData;
  var _isInit = true;
  var _isLoading = true;

  void _setLoader(bool isLoading) {
    setState(() {
      _isLoading = isLoading;
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      _setLoader(true);
      orderData = Provider.of<Orders>(context);
      orderData.fetchOrders().then((_) => _setLoader(false));
      _isInit = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(yourOrders),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: () => orderData.fetchOrders(),
              child: orderData.orders.isEmpty
                  ? SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height * 0.8,
                        child: const Center(
                          child: Text("No orders to show."),
                        ),
                      ),
                    )
                  : ListView.builder(
                      itemBuilder: (_, index) =>
                          OrdersItem(orderData.orders[index]),
                      itemCount: orderData.orders.length,
                    ),
            ),
      drawer: const AppDrawer(),
    );
  }
}
