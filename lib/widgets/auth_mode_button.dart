import 'package:flutter/material.dart';
import 'package:shop_app/widgets/auth_card.dart';

import '../utils/constants.dart' as constants;
import '../utils/dimens.dart' as dimens;

class AuthModeButton extends StatelessWidget {
  final AuthMode authMode;
  final VoidCallback onClick;

  const AuthModeButton({
    Key? key,
    required this.authMode,
    required this.onClick,
  }) : super(key: key);

  String get buttonText =>
      authMode == AuthMode.signup ? constants.login : constants.signup;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onClick,
      style: ButtonStyle(
        padding: MaterialStateProperty.all(
          dimens.authCardTextButtonPadding,
        ),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        foregroundColor: MaterialStateProperty.all(
          Theme.of(context).primaryColor,
        ),
      ),
      child: Text('$buttonText ${constants.instead}'),
    );
  }
}
