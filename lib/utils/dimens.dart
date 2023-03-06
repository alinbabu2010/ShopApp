import 'package:flutter/material.dart';

// ProductsOverviewScreen
const productOverviewGridPadding = EdgeInsets.all(10);
const productOverviewGridDelegate = SliverGridDelegateWithFixedCrossAxisCount(
  crossAxisCount: 2,
  childAspectRatio: 3 / 2,
  crossAxisSpacing: 10,
  mainAxisSpacing: 10,
);
const badgeTopMargin = EdgeInsets.only(top: 4.0);

// ProductItem Widget
var productItemClipRadius = BorderRadius.circular(10);
var productItemContainerRadius = BorderRadius.circular(10.5);

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

// EditProductsScreen
const editProductsPadding = EdgeInsets.all(16.0);
const editProductsRowContainerMargin = EdgeInsets.only(top: 8, right: 10);
const editProductsRowContainerWidth = 100.0;
const editProductsRowContainerHeight = 100.0;

// Auth Screen
const authFlexContainerMargin = EdgeInsets.only(bottom: 20.0);
const authFlexContainerPadding = EdgeInsets.symmetric(
  vertical: 8.0,
  horizontal: 74.0,
);
var authFlexContainerBorderRadius = BorderRadius.circular(20);
const authFlexContainerBlurRadius = 8.0;

// AuthCard Widget
var authCardBorderRadius = BorderRadius.circular(10.0);
const authCardElevation = 8.0;
const authCardSignupHeight = 340.0;
const authCardLoginHeight = 300.0;
const authCardPadding = EdgeInsets.all(16.0);
const authCardSizedBoxHeight = 20.0;
const authCardButtonPadding = EdgeInsets.symmetric(
  horizontal: 30.0,
  vertical: 8.0,
);
var authCardButtonBorderRadius = BorderRadius.circular(30);
const authCardTextButtonPadding = EdgeInsets.symmetric(
  horizontal: 30.0,
  vertical: 4,
);
