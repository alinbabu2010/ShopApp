import 'package:flutter/material.dart';

import '../utils/constants.dart' as constants;
import '../utils/dimens.dart' as dimens;
import 'auth_card.dart';

class AuthButton extends StatelessWidget {
  final bool isLoading;
  final AuthMode authMode;
  final VoidCallback onSubmit;

  const AuthButton({
    Key? key,
    required this.authMode,
    required this.onSubmit,
    required this.isLoading,
  }) : super(key: key);

  String get elevatedButtonText =>
      authMode == AuthMode.login ? constants.login : constants.signup;

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const CircularProgressIndicator()
        : ElevatedButton(
            onPressed: onSubmit,
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(
                Theme.of(context).primaryColor,
              ),
              foregroundColor: MaterialStateProperty.all(
                Theme.of(context).primaryTextTheme.labelLarge?.color,
              ),
              padding: MaterialStateProperty.all(
                dimens.authCardButtonPadding,
              ),
              shape: MaterialStateProperty.all(
                RoundedRectangleBorder(
                  borderRadius: dimens.authCardButtonBorderRadius,
                ),
              ),
            ),
            child: Text(elevatedButtonText),
          );
  }
}
