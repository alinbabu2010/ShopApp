import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/data/models/http_exception.dart';

import '../providers/auth.dart';
import '../utils/constants.dart' as constants;
import '../utils/dimens.dart' as dimens;

enum AuthMode { signup, login }

class AuthCard extends StatefulWidget {
  const AuthCard({
    Key? key,
  }) : super(key: key);

  @override
  State<AuthCard> createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard>
    with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey();

  AuthMode _authMode = AuthMode.login;

  final Map<String, String> _authData = {
    constants.emailKey: '',
    constants.passwordKey: '',
  };

  var _isLoading = false;
  final _passwordController = TextEditingController();
  late AnimationController _controller;
  late Animation<Size> _heightAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _heightAnimation = Tween<Size>(
      begin: const Size(
        double.infinity,
        dimens.authCardLoginHeight,
      ),
      end: const Size(
        double.infinity,
        dimens.authCardSignupHeight,
      ),
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.linear,
      ),
    );
    _heightAnimation.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  void _setLoader(bool isLoading) {
    setState(() {
      _isLoading = isLoading;
    });
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(constants.errorOccurred),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(constants.ok),
          ),
        ],
      ),
    );
  }

  Future<void> _submit() async {
    if (_formKey.currentState?.validate() == false) {
      // Invalid!
      return;
    }
    _formKey.currentState?.save();
    final authProvider = Provider.of<Auth>(context, listen: false);
    _setLoader(true);
    try {
      if (_authMode == AuthMode.login) {
        await authProvider.signIn(
          _authData[constants.emailKey]!,
          _authData[constants.passwordKey]!,
        );
      } else {
        await authProvider.signup(
          _authData[constants.emailKey]!,
          _authData[constants.passwordKey]!,
        );
      }
    } on HttpException catch (error) {
      _showErrorDialog(error.toString());
    } catch (error) {
      _showErrorDialog(constants.authErrorMessage);
    }
    _setLoader(false);
  }

  void _switchAuthMode() {
    setState(() {
      if (_authMode == AuthMode.login) {
        _authMode = AuthMode.signup;
        _controller.forward();
      } else {
        _authMode = AuthMode.login;
        _controller.reverse();
      }
    });
  }

  double get authCardHeight => _heightAnimation.value.height;

  String get elevatedButtonText =>
      _authMode == AuthMode.login ? constants.login : constants.signup;

  String get buttonText =>
      _authMode == AuthMode.signup ? constants.login : constants.signup;

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: dimens.authCardBorderRadius,
      ),
      elevation: dimens.authCardElevation,
      child: Container(
        height: authCardHeight,
        constraints: BoxConstraints(minHeight: authCardHeight),
        width: deviceSize.width * 0.75,
        padding: dimens.authCardPadding,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                TextFormField(
                  decoration:
                      const InputDecoration(labelText: constants.labelEmail),
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    if (value?.isEmpty == true ||
                        value?.contains('@') == false) {
                      return constants.invalidEmail;
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _authData[constants.emailKey] = value!;
                  },
                ),
                TextFormField(
                  decoration:
                      const InputDecoration(labelText: constants.labelPassword),
                  obscureText: true,
                  textInputAction: _authMode == AuthMode.signup
                      ? TextInputAction.next
                      : TextInputAction.done,
                  controller: _passwordController,
                  validator: (value) {
                    if (value?.isEmpty == true ||
                        value?.length.compareTo(5).isNegative == true) {
                      return constants.shortPasswordError;
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _authData[constants.passwordKey] = value!;
                  },
                ),
                if (_authMode == AuthMode.signup)
                  TextFormField(
                    enabled: _authMode == AuthMode.signup,
                    decoration: const InputDecoration(
                      labelText: constants.labelConfirmPassword,
                    ),
                    obscureText: true,
                    textInputAction: TextInputAction.done,
                    validator: _authMode == AuthMode.signup
                        ? (value) {
                            if (value != _passwordController.text) {
                              return constants.passwordMatchError;
                            }
                            return null;
                          }
                        : null,
                  ),
                const SizedBox(
                  height: dimens.authCardSizedBoxHeight,
                ),
                if (_isLoading)
                  const CircularProgressIndicator()
                else
                  ElevatedButton(
                    onPressed: _submit,
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                        Theme.of(context).primaryColor,
                      ),
                      foregroundColor: MaterialStateProperty.all(
                        Theme.of(context).primaryTextTheme.button?.color,
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
                  ),
                TextButton(
                  onPressed: _switchAuthMode,
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
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
