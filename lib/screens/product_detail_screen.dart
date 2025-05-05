import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/videojuego.dart';
import '../providers/cart_provider.dart';

class ProductDetailScreen extends StatelessWidget {
  final Videojuego producto;

  const ProductDetailScreen({super.key, required this.producto});

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(producto.nombre),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.network(
              producto.imagenUrl,
              width: double.infinity,
              height: 250,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => const SizedBox(
                height: 250,
                child: Center(child: Text('Imagen no disponible')),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(producto.nombre,
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text('Categoría: ${producto.categoria}'),
                  const SizedBox(height: 8),
                  Text('Estado: ${producto.estado}'),
                  const SizedBox(height: 8),
                  Text('Precio: \$${producto.precio}',
                      style: const TextStyle(fontSize: 20)),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.add_shopping_cart),
                    label: const Text('Agregar al carrito'),
                    onPressed: () {
                      cart.addToCart(producto);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('${producto.nombre} agregado al carrito')),
                      );
                    },
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
