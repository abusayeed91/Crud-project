import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:product_app/models/product_model.dart';
import 'package:product_app/widgets/snack_bar_message.dart';

import '../utils/urls.dart';

class UpdateProductScreen extends StatefulWidget {
  const UpdateProductScreen({super.key, required this.product});

  final ProductModel product;

  @override
  State<UpdateProductScreen> createState() => _UpdateProductScreenState();
}

class _UpdateProductScreenState extends State<UpdateProductScreen> {
  bool _updateProductInProgress = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameTEController = TextEditingController();
  final TextEditingController _codeTEController = TextEditingController();
  final TextEditingController _priceTEController = TextEditingController();
  final TextEditingController _quantityTEController = TextEditingController();
  final TextEditingController _imageUrlTEController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nameTEController.text = widget.product.name;
    _codeTEController.text = widget.product.code.toString();
    _quantityTEController.text = widget.product.quantity.toString();
    _priceTEController.text = widget.product.unitPrice.toString();
    _imageUrlTEController.text = widget.product.image;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Update product')),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              spacing: 8,
              children: [
                TextFormField(
                  controller: _nameTEController,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    hintText: 'Product name',
                    labelText: 'Product name',
                  ),
                ),
                TextFormField(
                  controller: _codeTEController,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    hintText: 'Product code',
                    labelText: 'Product code',
                  ),
                ),
                TextFormField(
                  controller: _quantityTEController,
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    hintText: 'Quantity',
                    labelText: 'Quantity',
                  ),
                ),
                TextFormField(
                  controller: _priceTEController,
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: 'Unit price',
                    labelText: 'Unit price',
                  ),
                ),
                TextFormField(
                  controller: _imageUrlTEController,
                  decoration: InputDecoration(
                    hintText: 'Image Url',
                    labelText: 'Image Url',
                  ),
                  validator: (String? value) {
                    if (value?.trim().isEmpty ?? true) {
                      return 'Enter your value';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 8),
                Visibility(
                  visible: _updateProductInProgress == false,
                    replacement: Center(
                      child: CircularProgressIndicator(),
                    ),
                    child: FilledButton(
                        onPressed: _onTapUpdateProductButton,
                        child: Text('Update Product'),
                ),

                )],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _onTapUpdateProductButton() async {
    if (_formKey.currentState!.validate() == false) {
      return;
    }
    // TODO: CALL API TO UPDATE PRODUCT
    _updateProductInProgress = true;
    setState(() {});

    Uri uri = Uri.parse(Urls.updateProductsUrl(widget.product.id));
    // Prepare data
    int totalPrice = int.parse(_priceTEController.text) *
        int.parse(_quantityTEController.text);
    Map<String, dynamic> requestBody = {
      "ProductName": _nameTEController.text.trim(),
      "ProductCode": int.parse(_codeTEController.text.trim()),
      "Img": _imageUrlTEController.text.trim(),
      "Qty":  int.parse(_quantityTEController.text.trim()),
      "UnitPrice":  int.parse(_priceTEController.text.trim()),
      "TotalPrice": totalPrice
    };

    // Request with data
    Response response = await post(
      uri,
      headers: {
        'Content-Type': 'application/json'
      },
      body: jsonEncode(requestBody),
    );
    print(response.statusCode);
    print(response.body);

    if (response.statusCode == 200) {
      final decodedJson = jsonDecode(response.body);
      if (decodedJson['status'] == 'success') {
        _clearTextFields();
        showSnackBarMessage(context, 'Product update successfully');
      } else {
        String errorMessage = decodedJson['data'];
        showSnackBarMessage(context, errorMessage);
      }
    }
    _updateProductInProgress = false;
    setState(() {});

  }
  void _clearTextFields() {
    _nameTEController.clear();
    _codeTEController.clear();
    _priceTEController.clear();
    _quantityTEController.clear();
    _imageUrlTEController.clear();
  }

  @override
  void dispose() {
    _nameTEController.dispose();
    _priceTEController.dispose();
    _quantityTEController.dispose();
    _imageUrlTEController.dispose();
    _codeTEController.dispose();
    super.dispose();
  }
}