import 'package:flutter/material.dart';
import '../models/videojuego.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class VideojuegoService extends ChangeNotifier {
  List<Videojuego> videojuegos = [];
  bool isLoading = true;

  VideojuegoService() {
    loadVideojuegos();
  }
  Future<void> loadVideojuegos() async {
    isLoading = true;
    notifyListeners();

    final snapshot =
        await FirebaseFirestore.instance.collection('videojuego').get();

    for (var doc in snapshot.docs) {
      print('Documento: ${doc.data()}');
    }

    videojuegos = snapshot.docs
        .map((doc) => Videojuego.fromJson(doc.data()))
        .toList();

    print('Videojuegos cargados: ${videojuegos.length}');

    isLoading = false;
    notifyListeners();
  }
}
