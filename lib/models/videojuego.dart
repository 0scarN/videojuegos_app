class Videojuego {
  int id;
  String nombre;
  String categoria;
  int precio;
  String imagenUrl;
  String estado;
  int stock;

  Videojuego({
    required this.id,
    required this.nombre,
    required this.categoria,
    required this.precio,
    required this.imagenUrl,
    required this.estado,
    required this.stock,
  });

  factory Videojuego.fromJson(Map<String, dynamic> json) => Videojuego(
        id: json['id'],
        nombre: json['nombre'],
        categoria: json['categoria'],
        precio: json['precio'],
        imagenUrl: json['imagenUrl'],
        estado: json['estado'],
        stock: json['stock'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'nombre': nombre,
        'categoria': categoria,
        'precio': precio,
        'imagenUrl': imagenUrl,
        'estado': estado,
        'stock': stock,
      };
}
