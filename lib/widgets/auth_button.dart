import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../utils/dimens.dart' as dimens;
import 'auth_card.dart';

class AuthButton extends StatelessWidget {
  final bool isLoading;
  final AuthMode authMode;
  final VoidCallback onSubmit;

  const AuthButton({
    super.key,
    required this.authMode,
    required this.onSubmit,
    required this.isLoading,
  });

  String elevatedButtonText(BuildContext context) {
    final appLocalization = AppLocalizations.of(context)!;
    return authMode == AuthMode.login
        ? appLocalization.login
        : appLocalization.signup;
  }

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
            child: Text(elevatedButtonText(context)),
          );
  }
}
