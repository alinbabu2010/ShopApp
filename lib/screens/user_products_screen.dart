import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/screens/edit_product_screen.dart';
import 'package:shop_app/widgets/app_drawer.dart';
import 'package:shop_app/widgets/user_product_item.dart';

import '../providers/products.dart';
import '../widgets/empty_msg.dart';

class UserProductsScreen extends StatefulWidget {
  static const routeName = "/user_product_screen";

  const UserProductsScreen({Key? key}) : super(key: key);

  @override
  State<UserProductsScreen> createState() => _UserProductsScreenState();
}

class _UserProductsScreenState extends State<UserProductsScreen> {
  late Future _productsFuture;
  var _isRefresh = false;

  Future<void> _obtainProductsFuture() async {
    await Provider.of<Products>(
      context,
      listen: false,
    ).fetchAndSetProducts().catchError((error) => Future.error(error));
  }

  @override
  void initState() {
    _productsFuture = _obtainProductsFuture();
    super.initState();
  }

  Future<void> _refreshProducts() async {
    final refreshFuture =
        _obtainProductsFuture().whenComplete(() => _isRefresh = false);
    _isRefresh = true;
    setState(() {
      _productsFuture = refreshFuture;
    });
  }

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.yourProducts),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(EditProductScreen.routeName);
            },
            icon: const Icon(Icons.add),
          )
        ],
      ),
      body: FutureBuilder(
          future: _productsFuture,
          builder: (_, dataSnapshot) {
            if (dataSnapshot.connectionState == ConnectionState.waiting &&
                !_isRefresh) {
              return const Center(child: CircularProgressIndicator());
            } else {
              return RefreshIndicator(
                onRefresh: _refreshProducts,
                child: dataSnapshot.hasError
                    ? EmptyMsgWidget(message: dataSnapshot.error.toString())
                    : Padding(
                        padding: const EdgeInsets.all(8),
                        child: ListView.builder(
                          itemBuilder: (_, index) {
                            var product = productsData.items[index];
                            return Column(
                              children: [
                                UserProductItem(product.id, product.title,
                                    product.imageUrl),
                                const Divider(color: Colors.black45),
                              ],
                            );
                          },
                          itemCount: productsData.items.length,
                        ),
                      ),
              );
            }
          }),
      drawer: const AppDrawer(),
    );
  }
}
