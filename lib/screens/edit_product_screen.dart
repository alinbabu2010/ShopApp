import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/models/product.dart';

import '../providers/products.dart';
import '../utils/constants.dart' as constants;
import '../utils/dimens.dart' as dimens;
import '../utils/form_validator.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = '/edit_product_screen';

  const EditProductScreen({Key? key}) : super(key: key);

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
        await displayErrorDialog();
      }).then((_) => _setLoader(false));
    } else {
      _productsData
          .updateProduct(_editedProduct.id, _editedProduct)
          .then((_) => _setLoader(false));
    }
  }

  Future<void> displayErrorDialog() async {
    return await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text(constants.errorOccurred),
        content: const Text(constants.somethingWrong),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text(constants.ok),
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
    return Scaffold(
      appBar: AppBar(
        title: const Text(constants.editProduct),
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
                            const InputDecoration(labelText: constants.title),
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
                              const InputDecoration(labelText: constants.price),
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
                        decoration: const InputDecoration(
                            labelText: constants.description),
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
                                ? const Text(constants.enterImageUrl)
                                : FittedBox(
                                    child: Image.network(
                                      _imageUrlController.text,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                          ),
                          Expanded(
                            child: TextFormField(
                              decoration: const InputDecoration(
                                  labelText: constants.imageUrl),
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
