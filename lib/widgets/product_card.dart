import 'package:flutter/material.dart';
import '../models/videojuego.dart';

class ProductCard extends StatelessWidget {
  final Videojuego product;
  final Widget? trailing;

  const ProductCard({super.key, required this.product, this.trailing});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        margin: const EdgeInsets.only(top: 30, bottom: 50),
        width: double.infinity,
        height: 400,
        decoration: _cardDecorations(),
        child: Stack(
          alignment: Alignment.bottomLeft,
          children: [
            _BackgroundImage(url: product.imagenUrl),
            _ProductDetails(product: product),
            Positioned(
              top: 0,
              right: 0,
              child: _PriceTag(product: product),
            ),
            if (product.estado != 'disponible')
              Positioned(
                top: 0,
                left: 0,
                child: _StateTag(estado: product.estado),
              ),
            if (trailing != null)
              Positioned(bottom: 10, right: 10, child: trailing!),
          ],
        ),
      ),
    );
  }

  BoxDecoration _cardDecorations() => BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: const [
          BoxShadow(color: Colors.black, offset: Offset(0, 5), blurRadius: 10),
        ],
      );
}

class _BackgroundImage extends StatelessWidget {
  final String url;

  const _BackgroundImage({required this.url});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(25),
      child: Image.network(
        url,
        height: 400,
        width: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => const Center(
          child: Text('Imagen no disponible'),
        ),
      ),
    );
  }
}

class _PriceTag extends StatelessWidget {
  final Videojuego product;

  const _PriceTag({required this.product});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 70,
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        color: Colors.orange,
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(25), bottomLeft: Radius.circular(25)),
      ),
      child: Text('\$${product.precio}',
          style: const TextStyle(color: Colors.white, fontSize: 18)),
    );
  }
}

class _ProductDetails extends StatelessWidget {
  final Videojuego product;

  const _ProductDetails({required this.product});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: const BoxDecoration(
        color: Colors.orange,
        borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(25), topRight: Radius.circular(25)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(product.nombre,
              style: const TextStyle(
                  fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
              maxLines: 1,
              overflow: TextOverflow.ellipsis),
          Text(product.categoria,
              style: const TextStyle(fontSize: 15, color: Colors.white)),
        ],
      ),
    );
  }
}

class _StateTag extends StatelessWidget {
  final String estado;

  const _StateTag({required this.estado});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 70,
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25), bottomRight: Radius.circular(25)),
      ),
      child: Text(estado,
          style: const TextStyle(fontSize: 18, color: Colors.white)),
    );
  }
}
