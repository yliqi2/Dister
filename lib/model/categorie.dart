class ProductCategory {
  final String name;
  final List<String> subcategories;

  ProductCategory({required this.name, required this.subcategories});
}

class ProductCategories {
  static final List<ProductCategory> _categories = [
    ProductCategory(name: "Electrónica y Tecnología", subcategories: [
      "Teléfonos móviles y accesorios",
      "Computadoras y laptops",
      "Televisores y entretenimiento",
      "Electrodomésticos",
      "Videoconsolas y videojuegos",
      "Cámaras y fotografía",
      "Smartwatches y wearables",
    ]),
    ProductCategory(name: "Moda y Accesorios", subcategories: [
      "Ropa de hombre",
      "Ropa de mujer",
      "Ropa infantil",
      "Zapatos y calzado",
      "Bolsos y mochilas",
      "Joyería y relojes",
      "Gafas de sol y accesorios",
    ]),
    ProductCategory(name: "Hogar y Muebles", subcategories: [
      "Muebles",
      "Decoración",
      "Iluminación",
      "Cama, baño y textiles",
      "Cocina y comedor",
      "Organización y almacenamiento",
      "Electrodomésticos pequeños",
    ]),
    ProductCategory(name: "Salud y Belleza", subcategories: [
      "Cosméticos y maquillaje",
      "Cuidado de la piel",
      "Cuidado del cabello",
      "Perfumes y fragancias",
      "Nutrición y suplementos",
      "Equipos de cuidado personal",
    ]),
    ProductCategory(name: "Deportes y Aire Libre", subcategories: [
      "Ropa y calzado deportivo",
      "Equipamiento de gimnasio",
      "Bicicletas y accesorios",
      "Camping y senderismo",
      "Deportes acuáticos",
      "Deportes de equipo",
    ]),
    ProductCategory(name: "Automóviles y Motocicletas", subcategories: [
      "Accesorios para coches",
      "Accesorios para motos",
      "Repuestos y herramientas",
      "Seguridad vehicular",
    ]),
    ProductCategory(name: "Juguetes y Juegos", subcategories: [
      "Juguetes para niños",
      "Juegos de mesa",
      "Figuras de colección",
      "Juguetes educativos",
    ]),
    ProductCategory(name: "Alimentos y Bebidas", subcategories: [
      "Productos gourmet",
      "Bebidas alcohólicas",
      "Productos orgánicos",
      "Snacks y dulces",
    ]),
    ProductCategory(name: "Libros, Música y Entretenimiento", subcategories: [
      "Libros y revistas",
      "Películas y series",
      "Instrumentos musicales",
    ]),
  ];

  static List<ProductCategory> getCategories() => _categories;

  // Método para obtener una categoría por nombre, con una opción por defecto si no se encuentra.
  static ProductCategory getCategoryByName(String name) {
    return _categories.firstWhere(
      (category) => category.name == name,
      orElse: () => _categories
          .first, // Devuelve la primera categoría si no encuentra coincidencias
    );
  }
}
