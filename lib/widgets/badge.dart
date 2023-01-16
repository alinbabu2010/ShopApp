import 'package:flutter/material.dart';
import 'package:shop_app/utils/typography.dart';

import '../utils/dimens.dart';

class Badge extends StatelessWidget {
  final Widget child;
  final String value;
  final Color? color;

  const Badge({
    required this.child,
    required this.value,
    this.color,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        child,
        Positioned(
          right: 8,
          top: 8,
          child: Container(
            padding: badgeContainerPadding,
            decoration: BoxDecoration(
              borderRadius: badgeContainerBorderRadius,
              color: color ?? Theme.of(context).colorScheme.secondary,
            ),
            constraints: badgeContainerConstraints,
            child: Text(
              value,
              textAlign: TextAlign.center,
              style: badgeContainerTextStyle,
            ),
          ),
        )
      ],
    );
  }
}
