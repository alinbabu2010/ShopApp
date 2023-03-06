import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shop_app/widgets/auth_card.dart';

import '../utils/dimens.dart' as dimens;

class AuthModeButton extends StatelessWidget {
  final AuthMode authMode;
  final VoidCallback onClick;

  const AuthModeButton({
    Key? key,
    required this.authMode,
    required this.onClick,
  }) : super(key: key);

  String buttonText(BuildContext context) {
    final appLocalization = AppLocalizations.of(context)!;
    return authMode == AuthMode.signup
        ? appLocalization.login
        : appLocalization.signup;
  }

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
      child: Text(
          '${buttonText(context)} ${AppLocalizations.of(context)!.instead}'),
    );
  }
}
