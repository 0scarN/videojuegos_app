import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/videojuego_service.dart';
import '../widgets/product_card.dart';
import '../providers/cart_provider.dart';
import '../models/videojuego.dart';
import 'product_detail_screen.dart'; // Asegúrate de tener esta pantalla creada

class ListVideojuegosScreen extends StatefulWidget {
  const ListVideojuegosScreen({super.key});

  @override
  State<ListVideojuegosScreen> createState() => _ListVideojuegosScreenState();
}

class _ListVideojuegosScreenState extends State<ListVideojuegosScreen> {
  String _filtro = '';
  String _categoriaSeleccionada = '';

  @override
  Widget build(BuildContext context) {
    final videojuegoService = Provider.of<VideojuegoService>(context);

    if (videojuegoService.isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    // Filtrar videojuegos por nombre y categoría
    final List<Videojuego> videojuegosFiltrados = videojuegoService.videojuegos.where((vj) {
      final coincideFiltro = vj.nombre.toLowerCase().contains(_filtro.toLowerCase());
      final coincideCategoria = _categoriaSeleccionada.isEmpty || vj.categoria == _categoriaSeleccionada;
      return coincideFiltro && coincideCategoria;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Catálogo de Videojuegos'),
        actions: [
          Consumer<CartProvider>(
            builder: (_, cart, __) => Stack(
              alignment: Alignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.shopping_cart),
                  onPressed: () {
                    Navigator.pushNamed(context, 'cart');
                  },
                ),
                if (cart.totalItems > 0)
                  Positioned(
                    right: 8,
                    top: 8,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 16,
                        minHeight: 16,
                      ),
                      child: Text(
                        '${cart.totalItems}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Campo de búsqueda
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Buscar videojuegos...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (valor) {
                setState(() {
                  _filtro = valor;
                });
              },
            ),
          ),

          // Filtro por categoría
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: DropdownButton<String>(
              isExpanded: true,
              hint: const Text('Filtrar por categoría'),
              value: _categoriaSeleccionada.isEmpty ? null : _categoriaSeleccionada,
              items: ['Acción', 'Aventura', 'Deportes', 'Estrategia', 'Puzzle']
                  .map((cat) => DropdownMenuItem(
                        value: cat,
                        child: Text(cat),
                      ))
                  .toList(),
              onChanged: (valor) {
                setState(() {
                  _categoriaSeleccionada = valor ?? '';
                });
              },
            ),
          ),

          // Lista filtrada
          Expanded(
            child: videojuegosFiltrados.isEmpty
                ? const Center(child: Text("No se encontraron videojuegos."))
                : ListView.builder(
                    itemCount: videojuegosFiltrados.length,
                    itemBuilder: (context, index) {
                      final juego = videojuegosFiltrados[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ProductDetailScreen(producto: juego),
                            ),
                          );
                        },
                        child: ProductCard(
                          product: juego,
                          trailing: IconButton(
                            icon: const Icon(Icons.shopping_cart),
                            onPressed: () {
                              Provider.of<CartProvider>(context, listen: false).addToCart(juego);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('${juego.nombre} agregado al carrito')),
                              );
                            },
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
