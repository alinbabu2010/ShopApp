import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/products.dart';
import 'package:shop_app/utils/dimens.dart';

import '../utils/typography.dart';

class ProductDetailScreen extends StatelessWidget {
  static const routeName = '/product_detail_screen';

  const ProductDetailScreen({Key? key}) : super(key: key);

  SizedBox buildSizedBox() => const SizedBox(
        height: productDetailsSpacingHeight,
      );

  @override
  Widget build(BuildContext context) {
    final id = ModalRoute.of(context)?.settings.arguments as String;
    final product = Provider.of<Products>(context, listen: false).findById(id);
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: productDetailsImageHeight,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(product.title),
              background: Hero(
                tag: product.id as Object,
                child: Image.network(
                  product.imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                buildSizedBox(),
                Text(
                  '\$${product.price}',
                  style: productDetailsPriceTextStyle,
                  textAlign: TextAlign.center,
                ),
                buildSizedBox(),
                Container(
                  padding: productDetailsContainerPadding,
                  width: double.infinity,
                  child: Text(
                    product.description,
                    textAlign: TextAlign.center,
                    softWrap: true,
                  ),
                ),
                const SizedBox(height: 750)
              ],
            ),
          )
        ],
      ),
    );
  }
}
