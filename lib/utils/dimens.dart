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