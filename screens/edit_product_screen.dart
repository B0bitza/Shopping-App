// ignore_for_file: deprecated_member_use

import 'package:app4/providers/product.dart';
import 'package:app4/providers/products.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = '/edit-product';
  const EditProductScreen({Key? key}) : super(key: key);

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _imageUrlController = TextEditingController();
  final _form = GlobalKey<FormState>();
  var _editedProduct =
      Product(id: '', title: '', description: '', price: 0, imageUrl: '');
  var _isLoading = false;
  void _updateImageUrl() {
    if ((!_imageUrlController.text.contains('http') ||
            !_imageUrlController.text.contains('https')) &&
        (!_imageUrlController.text.endsWith('.png') ||
            !_imageUrlController.text.endsWith('.jpg')) &&
        _imageUrlController.text.isNotEmpty) {
      return;
    } else {
      setState(() {});
    }
  }

  void _saveForm() {
    var isValid = _form.currentState?.validate() as bool;
    if (isValid) {
      _form.currentState?.save();
      setState(() {
        _isLoading = true;
      });
      if (_editedProduct.id != '') {
        Provider.of<Products>(context, listen: false)
            .updateProduct(_editedProduct.id, _editedProduct);
        setState(() {
          _isLoading = false;
        });
        Navigator.of(context).pop(context);
      } else {
        Provider.of<Products>(context, listen: false)
            .addProduct(_editedProduct)
            .catchError((error) {
          print('se executa');
          showDialog(
              context: context,
              builder: (ctx) {
                _isLoading = true;
                return AlertDialog(
                  title: const Text('An error occurred'),
                  content: const Text('SomeThing went Wrong'),
                  actions: <Widget>[
                    FlatButton(
                      onPressed: () {
                        setState(() {
                          _isLoading = false;
                        });
                        Navigator.of(context).pop(context);
                      },
                      child: Text('Close'),
                    )
                  ],
                );
              });
        }).then((_) {
          setState(() {
            _isLoading = false;
          });
          Navigator.of(context).pop();
        });
      }
    } else {
      return;
    }
  }

  var _initValues = {
    'title': '',
    'description': '',
    'price': '',
    'imageUrl': 'something',
  };
  var _isInit = true;
  @override
  void didChangeDependencies() {
    //if (_isInit) {
    final productId = ModalRoute.of(context)?.settings.arguments;
    if (productId != null) {
      _editedProduct = Provider.of<Products>(
        context,
        listen: false,
      ).findById(productId.toString());
      _initValues = {
        'title': _editedProduct.title,
        'description': _editedProduct.description,
        'price': _editedProduct.price.toString(),
      };
      _imageUrlController.text = _editedProduct.imageUrl;
    }
    super.didChangeDependencies();
  }

  @override
  Dispose() {
    _imageUrlController.removeListener(_updateImageUrl);
    _imageUrlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Product'),
        actions: [
          IconButton(
            onPressed: () => _saveForm(),
            icon: Icon(Icons.save),
          )
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _form,
                child: ListView(children: [
                  TextFormField(
                    initialValue: _initValues['title'],
                    decoration: const InputDecoration(labelText: 'Title'),
                    textInputAction: TextInputAction.next,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please provide a value.';
                      } else {
                        return null;
                      }
                    },
                    onSaved: (value) => _editedProduct = Product(
                        id: _editedProduct.id,
                        isFavorite: _editedProduct.isFavorite,
                        title: value.toString(),
                        description: _editedProduct.description,
                        price: _editedProduct.price,
                        imageUrl: _editedProduct.imageUrl),
                  ),
                  TextFormField(
                    initialValue: _initValues['price'],
                    decoration: const InputDecoration(labelText: 'Price'),
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please provide a price.';
                      } else {
                        if (double.tryParse(value) == null) {
                          return 'Please provide a valid number.';
                        }
                      }
                      if (double.parse(value) <= 0) {
                        return 'Please provide a number greater than 0.';
                      } else {
                        return null;
                      }
                    },
                    onSaved: (value) => _editedProduct = Product(
                        id: _editedProduct.id,
                        isFavorite: _editedProduct.isFavorite,
                        title: _editedProduct.title,
                        description: _editedProduct.description,
                        price: double.parse(value.toString()),
                        imageUrl: _editedProduct.imageUrl),
                  ),
                  TextFormField(
                    initialValue: _initValues['description'],
                    maxLines: 3,
                    keyboardType: TextInputType.multiline,
                    decoration: const InputDecoration(labelText: 'Description'),
                    textInputAction: TextInputAction.next,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please provide a description.';
                      }
                      if (value.length <= 10) {
                        return 'Please provide a longer description';
                      } else {
                        return null;
                      }
                    },
                    onSaved: (value) {
                      _editedProduct = Product(
                          isFavorite: _editedProduct.isFavorite,
                          id: _editedProduct.id,
                          title: _editedProduct.title,
                          description: value.toString(),
                          price: _editedProduct.price,
                          imageUrl: _editedProduct.imageUrl);
                    },
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        width: 100,
                        height: 100,
                        margin: const EdgeInsets.only(
                          top: 8,
                          right: 10,
                        ),
                        decoration: BoxDecoration(
                            border: Border.all(width: 1, color: Colors.grey)),
                        child: _imageUrlController.text.isEmpty
                            ? const Center(child: Text('Enter Url'))
                            : Image.network(
                                _imageUrlController.text,
                                fit: BoxFit.cover,
                              ),
                      ),
                      Expanded(
                        child: TextFormField(
                            keyboardType: TextInputType.url,
                            decoration:
                                const InputDecoration(labelText: 'Image Url'),
                            textInputAction: TextInputAction.done,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please provide a link.';
                              } else {
                                return null;
                              }
                            },
                            controller: _imageUrlController,
                            onSaved: (value) => _editedProduct = Product(
                                id: _editedProduct.id,
                                isFavorite: _editedProduct.isFavorite,
                                title: _editedProduct.title,
                                description: _editedProduct.description,
                                price: _editedProduct.price,
                                imageUrl: value.toString()),
                            onFieldSubmitted: (_) {
                              _saveForm();
                              _updateImageUrl();
                            }),
                      ),
                    ],
                  ),
                ]),
              ),
            ),
    );
  }
}
