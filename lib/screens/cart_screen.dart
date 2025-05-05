import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../providers/cart_provider.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tu carrito'),
      ),
      body: cart.items.isEmpty
          ? const Center(child: Text('Tu carrito está vacío 😢'))
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: cart.items.length,
                    itemBuilder: (context, index) {
                      final item = cart.items[index];
                      return ListTile(
                        leading: Image.network(item.imagenUrl, width: 50),
                        title: Text(item.nombre),
                        subtitle: Text('\$${item.precio}'),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            cart.removeFromCart(item);
                          },
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Total:',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold)),
                          Text('\$${cart.totalPrice}',
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold)),
                        ],
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton.icon(
                        icon: const Icon(Icons.payment),
                        label: const Text('Comprar'),
                        onPressed: () async {
                          final firestore = FirebaseFirestore.instance;
                          List<String> sinStock = [];

                          for (var item in cart.items) {
                            final doc = await firestore
                                .collection('videojuego')
                                .doc(item.id.toString())
                                .get();

                            final data = doc.data();

                            if (data == null || data['stock'] == null) continue;

                            final stockActual = data['stock'];

                            if (stockActual >= 1) {
                              // Restar stock
                              await firestore
                                  .collection('videojuego')
                                  .doc(item.id.toString())
                                  .update({
                                'stock': stockActual - 1,
                              });
                            } else {
                              // Sin stock
                              sinStock.add(item.nombre);
                            }
                          }

                          // Quitar del carrito los que no tienen stock
                          cart.items
                              .where((item) => sinStock.contains(item.nombre))
                              .toList()
                              .forEach(cart.removeFromCart);

                          if (sinStock.isNotEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                    'Sin stock: ${sinStock.join(', ')}'),
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content:
                                      Text('Compra realizada con éxito 🎉')),
                            );
                            cart.clearCart();
                            Navigator.pop(context);
                          }
                        },
                      )
                    ],
                  ),
                )
              ],
            ),
    );
  }
}
