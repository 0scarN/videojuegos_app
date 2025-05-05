import 'package:flutter/material.dart';
import '../models/videojuego.dart';

class CartProvider extends ChangeNotifier {
  final List<Videojuego> _items = [];

  List<Videojuego> get items => [..._items];

  void addToCart(Videojuego product) {
    _items.add(product);
    notifyListeners();
  }

  void removeFromCart(Videojuego product) {
    _items.remove(product);
    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }

  int get totalItems => _items.length;

  int get totalPrice =>
      _items.fold(0, (sum, item) => sum + item.precio);
}
