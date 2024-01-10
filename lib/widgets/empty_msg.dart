import 'package:flutter/cupertino.dart';

import '../utils/typography.dart';

class EmptyMsgWidget extends StatelessWidget {
  final String message;

  const EmptyMsgWidget({
    super.key,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: SizedBox(
        height: mediaQuery.size.height * 0.88,
        child: Center(
          child: Text(
            message,
            style: emptyMsgTextStyle,
          ),
        ),
      ),
    );
  }
}
