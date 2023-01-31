import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/data/models/http_exception.dart';
import 'package:shop_app/utils/form_validator.dart';
import 'package:shop_app/widgets/auth_button.dart';
import 'package:shop_app/widgets/auth_mode_button.dart';

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
  late Animation<Offset> _slideAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -1.5),
      end: const Offset(0, 0),
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.linear,
      ),
    );
    _opacityAnimation = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    ));
    //_heightAnimation.addListener(() => setState(() {}));
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

  double get authCardHeight => _authMode == AuthMode.signup
      ? dimens.authCardSignupHeight
      : dimens.authCardLoginHeight;

  TextInputAction get _passwordTextInputAction => _authMode == AuthMode.signup
      ? TextInputAction.next
      : TextInputAction.done;

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Card(
      shape: RoundedRectangleBorder(borderRadius: dimens.authCardBorderRadius),
      elevation: dimens.authCardElevation,
      child: AnimatedContainer(
        width: deviceSize.width * 0.75,
        padding: dimens.authCardPadding,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeIn,
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
                  validator: FormValidator.checkValidEmail,
                  onSaved: (value) {
                    _authData[constants.emailKey] = value!;
                  },
                ),
                TextFormField(
                  decoration:
                      const InputDecoration(labelText: constants.labelPassword),
                  obscureText: true,
                  textInputAction: _passwordTextInputAction,
                  controller: _passwordController,
                  validator: FormValidator.checkValidPassword,
                  onSaved: (value) {
                    _authData[constants.passwordKey] = value!;
                  },
                ),
                AnimatedSize(
                  duration: const Duration(milliseconds: 300),
                  child: SizedBox(
                    height: _authMode == AuthMode.signup ? null : 0,
                    child: FadeTransition(
                      opacity: _opacityAnimation,
                      child: SlideTransition(
                        position: _slideAnimation,
                        child: TextFormField(
                          enabled: _authMode == AuthMode.signup,
                          decoration: const InputDecoration(
                              labelText: constants.labelConfirmPassword),
                          obscureText: true,
                          textInputAction: TextInputAction.done,
                          validator: _authMode == AuthMode.signup
                              ? (value) => FormValidator.checkPasswordMatch(
                                  value, _passwordController.text)
                              : null,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: dimens.authCardSizedBoxHeight),
                AuthButton(
                  authMode: _authMode,
                  onSubmit: _submit,
                  isLoading: _isLoading,
                ),
                AuthModeButton(
                  authMode: _authMode,
                  onClick: _switchAuthMode,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
