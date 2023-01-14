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
