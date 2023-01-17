import 'package:flutter/material.dart';

// ProductsOverviewScreen
const productOverviewGridPadding = EdgeInsets.all(10);
const productOverviewGridDelegate = SliverGridDelegateWithFixedCrossAxisCount(
  crossAxisCount: 2,
  childAspectRatio: 3 / 2,
  crossAxisSpacing: 10,
  mainAxisSpacing: 10,
);

// ProductItem Widget
var productItemClipRadius = BorderRadius.circular(10);
var productItemContainerRadius = BorderRadius.circular(10.5);

// Badge Widget
const badgeContainerPadding = EdgeInsets.all(2.0);
var badgeContainerBorderRadius = BorderRadius.circular(10.0);
const badgeContainerConstraints = BoxConstraints(minWidth: 16, minHeight: 16);

// Cart Screen
const cartScreenCardMargin = EdgeInsets.all(15);
const cartScreenCardPadding = EdgeInsets.all(8);
const cartScreenSpaceWidth = 10.0;
const cartScreenSpaceHeight = 10.0;

// CartItem Widget
const cartItemCardMargin = EdgeInsets.symmetric(horizontal: 15, vertical: 4);
const cartItemCardChildPadding = EdgeInsets.all(8);
const cartItemCircleTextPadding = EdgeInsets.all(4);
const cartItemDismissContainerPadding = EdgeInsets.only(right: 20);
const cartItemDismissIconSize = 40.0;

// ProductDetail Screen
const productDetailsImageHeight = 300.0;
const productDetailsSpacingHeight = 10.0;
const productDetailsContainerPadding = EdgeInsets.symmetric(horizontal: 10);

// OrdersItem Widget
const ordersItemCardMargin = EdgeInsets.all(10);
const ordersItemExpandedContainerPadding = EdgeInsets.symmetric(
  vertical: 2,
  horizontal: 15,
);

// UserProductItem Widget
const trailingSizedBoxWidth = 100.0;
