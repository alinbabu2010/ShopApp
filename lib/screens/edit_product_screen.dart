import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../data/models/product.dart';
import '../providers/products.dart';
import '../utils/dimens.dart' as dimens;
import '../utils/form_validator.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = '/edit_product_screen';

  const EditProductScreen({super.key});

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _imageUrlFocusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();

  late Products _productsData;

  var _editedProduct = Product(
    id: null,
    title: '',
    description: '',
    price: 0.0,
    imageUrl: '',
  );

  var _isInit = true;
  var _isLoading = false;

  @override
  void initState() {
    super.initState();
    _imageUrlFocusNode.addListener(_updateImageUrl);
    _productsData = Provider.of<Products>(context, listen: false);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      final productId = ModalRoute.of(context)?.settings.arguments as String?;
      if (productId != null) {
        _editedProduct = _productsData.findById(productId);
        _imageUrlController.text = _editedProduct.imageUrl;
      }
    }
    _isInit = false;
  }

  void _updateImageUrl() {
    if (!_imageUrlFocusNode.hasFocus) {
      var isValid = FormValidator.checkUrl(
        _imageUrlController.text,
        checkEmpty: false,
      );
      if (isValid != null) {
        return;
      }
      setState(() {});
    }
  }

  void _setLoader(bool isLoading) {
    setState(() {
      _isLoading = isLoading;
    });
    if (!isLoading) {
      Navigator.of(context).pop();
    }
  }

  void _saveForm() {
    var isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) {
      return;
    }
    _formKey.currentState?.save();
    _setLoader(true);
    if (_editedProduct.id == null) {
      _productsData.addProduct(_editedProduct).catchError((error) async {
        await displayErrorDialog(error.toString());
      }).then((_) => _setLoader(false));
    } else {
      _productsData
          .updateProduct(_editedProduct.id, _editedProduct)
          .then((_) => _setLoader(false));
    }
  }

  Future<void> displayErrorDialog(String message) async {
    final appLocalization = AppLocalizations.of(context)!;
    return await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(appLocalization.errorOccurred),
        content: Text(kDebugMode ? message : appLocalization.somethingWrong),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(appLocalization.ok),
          )
        ],
      ),
    );
  }

  void createProduct({
    String? title,
    String? description,
    double? price,
    String? imageUrl,
  }) {
    _editedProduct = Product(
      id: _editedProduct.id,
      title: title ?? _editedProduct.title,
      description: description ?? _editedProduct.description,
      price: price ?? _editedProduct.price,
      imageUrl: imageUrl ?? _editedProduct.imageUrl,
    );
  }

  @override
  void dispose() {
    super.dispose();
    _imageUrlFocusNode.removeListener(_updateImageUrl);
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlController.dispose();
    _imageUrlFocusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appLocalization = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(appLocalization.editProduct),
        actions: [
          IconButton(
            onPressed: _saveForm,
            icon: const Icon(Icons.save),
          )
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
        padding: dimens.editProductsPadding,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  initialValue: _editedProduct.title,
                        decoration:
                            InputDecoration(labelText: appLocalization.title),
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_) => _priceFocusNode.requestFocus(),
                        onSaved: (value) => createProduct(title: value),
                        validator: (value) => FormValidator.checkTitle(value),
                      ),
                TextFormField(
                    initialValue: _editedProduct.price > 0
                              ? _editedProduct.price.toString()
                              : "",
                          decoration:
                              InputDecoration(labelText: appLocalization.price),
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.number,
                          focusNode: _priceFocusNode,
                          onFieldSubmitted: (_) =>
                              _descriptionFocusNode.requestFocus(),
                          onSaved: (value) =>
                              createProduct(price: double.tryParse(value!)),
                          validator: (value) =>
                              FormValidator.checkPrice(value)),
                TextFormField(
                  initialValue: _editedProduct.description,
                        decoration: InputDecoration(
                            labelText: appLocalization.description),
                        maxLines: 3,
                        keyboardType: TextInputType.multiline,
                        focusNode: _descriptionFocusNode,
                        onSaved: (value) => createProduct(description: value),
                        validator: (value) =>
                            FormValidator.checkDescription(value),
                      ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      width: dimens.editProductsRowContainerWidth,
                      height: dimens.editProductsRowContainerHeight,
                      margin: dimens.editProductsRowContainerMargin,
                      decoration: BoxDecoration(
                          border:
                          Border.all(width: 1, color: Colors.grey)),
                      child: _imageUrlController.text.isEmpty
                                ? Text(appLocalization.enterImageUrl)
                                : FittedBox(
                                    child: Image.network(
                                      _imageUrlController.text,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                    ),
                    Expanded(
                      child: TextFormField(
                              decoration: InputDecoration(
                                  labelText: appLocalization.imageUrl),
                              keyboardType: TextInputType.url,
                              textInputAction: TextInputAction.done,
                              controller: _imageUrlController,
                              focusNode: _imageUrlFocusNode,
                              onFieldSubmitted: (_) => _saveForm,
                              onSaved: (value) =>
                                  createProduct(imageUrl: value),
                              validator: (value) =>
                                  FormValidator.checkUrl(value),
                            ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
