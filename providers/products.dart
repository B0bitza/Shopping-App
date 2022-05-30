import 'product.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Products with ChangeNotifier {
  // ignore: prefer_final_fields
  List<Product> _items = [];

  List<Product> get item {
    return [..._items];
  }

  List<Product> get favorite {
    return _items.where((prodcut) => prodcut.isFavorite).toList();
  }

  Product findById(String id) {
    return _items.firstWhere((product) => product.id == id);
  }

  void deleteProduct(String id) {
    _items.removeWhere((product) => product.id == id);
    notifyListeners();
  }

  Future<void> fetchAndSetProducts() async {
    const url =
        'https://flutter-project-50fc2-default-rtdb.firebaseio.com/products.json';
    try {
      final response = await http.get(Uri.parse(url));
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      final List<Product> loadedProducts = [];
      extractedData.forEach((productId, productData) {
        loadedProducts.add(
          Product(
            id: productId,
            title: productData['title'],
            price: productData['price'],
            description: productData['description'],
            isFavorite: productData['isFavorite'],
            imageUrl: productData['imageUrl'],
          ),
        );
        _items = loadedProducts;
      });
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> addProduct(Product product) {
    const url =
        'https://flutter-project-50fc2-default-rtdb.firebaseio.com/products.json';
    return http
        .post(Uri.parse(url),
            body: json.encode({
              'title': product.title,
              'description': product.description,
              'imageUrl': product.imageUrl,
              'isFavorite': product.isFavorite,
              'price': product.price,
            }))
        .then((response) {
      final newProduct = Product(
          title: product.title,
          description: product.description,
          price: product.price,
          imageUrl: product.imageUrl,
          id: json.decode(response.body)['name']);
      _items.add(newProduct);
      notifyListeners();
    }).catchError((error) {
      throw error;
    });
  }

  Future<void> updateProduct(String id, Product newProduct) async {
    final produsIndex = _items.indexWhere((product) => product.id == id);
    if (produsIndex >= 0) {
      var url =
          'https://flutter-project-50fc2-default-rtdb.firebaseio.com/products/$id.json';
      http.patch(Uri.parse(url),
          body: json.encode({
            'title': newProduct.title,
            'price': newProduct.price,
            'description': newProduct.description,
            'imageUrl': newProduct.imageUrl,
          }));
      _items[produsIndex] = newProduct;
      notifyListeners();
    }
  }
}
