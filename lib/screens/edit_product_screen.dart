import 'package:flutter/material.dart';
import 'package:shop_app/providers/product.dart';

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

  var _editedProduct = Product(
    id: DateTime.now().toString(),
    title: '',
    description: '',
    price: 0.0,
    imageUrl: '',
  );

  @override
  void initState() {
    super.initState();
    _imageUrlFocusNode.addListener(_updateImageUrl);
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

  void _saveForm() {
    var isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) {
      return;
    }
    _formKey.currentState?.save();
  }

  void createProduct({
    String? title,
    String? description,
    double? price,
    String? imageUrl,
  }) {
    _editedProduct = Product(
      id: DateTime.now().toString(),
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
      body: Padding(
        padding: dimens.editProductsPadding,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  decoration: const InputDecoration(labelText: constants.title),
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (_) => _priceFocusNode.requestFocus(),
                  onSaved: (value) => createProduct(title: value),
                  validator: (value) => FormValidator.checkTitle(value),
                ),
                TextFormField(
                    decoration:
                        const InputDecoration(labelText: constants.price),
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.number,
                    focusNode: _priceFocusNode,
                    onFieldSubmitted: (_) =>
                        _descriptionFocusNode.requestFocus(),
                    onSaved: (value) =>
                        createProduct(price: double.tryParse(value!)),
                    validator: (value) => FormValidator.checkPrice(value)),
                TextFormField(
                  decoration:
                      const InputDecoration(labelText: constants.description),
                  maxLines: 3,
                  keyboardType: TextInputType.multiline,
                  focusNode: _descriptionFocusNode,
                  onSaved: (value) => createProduct(description: value),
                  validator: (value) => FormValidator.checkDescription(value),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      width: dimens.editProductsRowContainerWidth,
                      height: dimens.editProductsRowContainerHeight,
                      margin: dimens.editProductsRowContainerMargin,
                      decoration: BoxDecoration(
                          border: Border.all(width: 1, color: Colors.grey)),
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
                        onSaved: (value) => createProduct(imageUrl: value),
                        validator: (value) => FormValidator.checkUrl(value),
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
