class ProductCategory {
  final String id;
  final Map<String, String> names;
  final List<Map<String, String>> subcategories;

  ProductCategory({
    required this.id,
    required this.names,
    required this.subcategories,
  });

  String getName(String locale) {
    final String lang = locale.split('_')[0];
    return names[lang] ?? names["en"] ?? "";
  }

  List<String> getSubcategories(String locale) {
    final String lang = locale.split('_')[0];
    return subcategories
        .map((subcat) => subcat[lang] ?? subcat["en"] ?? "")
        .toList();
  }
}

class ProductCategories {
  static final List<ProductCategory> _categories = [
    ProductCategory(
      id: "electronics",
      names: {
        "en": "Electronics and Technology",
        "es": "Electrónica y Tecnología",
      },
      subcategories: [
        {
          "en": "Mobile phones and accessories",
          "es": "Teléfonos móviles y accesorios",
        },
        {
          "en": "Computers and laptops",
          "es": "Ordenadores y portátiles",
        },
        {
          "en": "Televisions and entertainment",
          "es": "Televisores y entretenimiento",
        },
        {
          "en": "Home appliances",
          "es": "Electrodomésticos",
        },
        {
          "en": "Game consoles and video games",
          "es": "Consolas y videojuegos",
        },
        {
          "en": "Cameras and photography",
          "es": "Cámaras y fotografía",
        },
        {
          "en": "Smartwatches and wearables",
          "es": "Smartwatches y wearables",
        },
      ],
    ),
    ProductCategory(
      id: "fashion",
      names: {
        "en": "Fashion and Accessories",
        "es": "Moda y Accesorios",
      },
      subcategories: [
        {
          "en": "Men's clothing",
          "es": "Ropa para hombre",
        },
        {
          "en": "Women's clothing",
          "es": "Ropa para mujer",
        },
        {
          "en": "Children's clothing",
          "es": "Ropa para niños",
        },
        {
          "en": "Shoes and footwear",
          "es": "Zapatos y calzado",
        },
        {
          "en": "Bags and backpacks",
          "es": "Bolsos y mochilas",
        },
        {
          "en": "Jewelry and watches",
          "es": "Joyería y relojes",
        },
        {
          "en": "Sunglasses and accessories",
          "es": "Gafas de sol y accesorios",
        },
      ],
    ),
    ProductCategory(
      id: "home",
      names: {
        "en": "Home and Furniture",
        "es": "Hogar y Muebles",
      },
      subcategories: [
        {
          "en": "Furniture",
          "es": "Muebles",
        },
        {
          "en": "Decoration",
          "es": "Decoración",
        },
        {
          "en": "Lighting",
          "es": "Iluminación",
        },
        {
          "en": "Bed, bath, and textiles",
          "es": "Cama, baño y textiles",
        },
        {
          "en": "Kitchen and dining",
          "es": "Cocina y comedor",
        },
        {
          "en": "Organization and storage",
          "es": "Organización y almacenamiento",
        },
        {
          "en": "Small appliances",
          "es": "Pequeños electrodomésticos",
        },
      ],
    ),
    ProductCategory(
      id: "health",
      names: {
        "en": "Health and Beauty",
        "es": "Salud y Belleza",
      },
      subcategories: [
        {
          "en": "Cosmetics and makeup",
          "es": "Cosméticos y maquillaje",
        },
        {
          "en": "Skin care",
          "es": "Cuidado de la piel",
        },
        {
          "en": "Hair care",
          "es": "Cuidado del cabello",
        },
        {
          "en": "Perfumes and fragrances",
          "es": "Perfumes y fragancias",
        },
        {
          "en": "Nutrition and supplements",
          "es": "Nutrición y suplementos",
        },
        {
          "en": "Personal care equipment",
          "es": "Equipos de cuidado personal",
        },
      ],
    ),
    ProductCategory(
      id: "sports",
      names: {
        "en": "Sports and Outdoors",
        "es": "Deportes y Aire Libre",
      },
      subcategories: [
        {
          "en": "Sportswear and footwear",
          "es": "Ropa y calzado deportivo",
        },
        {
          "en": "Gym equipment",
          "es": "Equipamiento de gimnasio",
        },
        {
          "en": "Bicycles and accessories",
          "es": "Bicicletas y accesorios",
        },
        {
          "en": "Camping and hiking",
          "es": "Camping y senderismo",
        },
        {
          "en": "Water sports",
          "es": "Deportes acuáticos",
        },
        {
          "en": "Team sports",
          "es": "Deportes de equipo",
        },
      ],
    ),
    ProductCategory(
      id: "cars",
      names: {
        "en": "Cars and Motorcycles",
        "es": "Coches y Motocicletas",
      },
      subcategories: [
        {
          "en": "Car accessories",
          "es": "Accesorios para coches",
        },
        {
          "en": "Motorcycle accessories",
          "es": "Accesorios para motocicletas",
        },
        {
          "en": "Spare parts and tools",
          "es": "Repuestos y herramientas",
        },
        {
          "en": "Vehicle safety",
          "es": "Seguridad vehicular",
        },
      ],
    ),
    ProductCategory(
      id: "toys",
      names: {
        "en": "Toys and Games",
        "es": "Juguetes y Juegos",
      },
      subcategories: [
        {
          "en": "Toys for children",
          "es": "Juguetes para niños",
        },
        {
          "en": "Board games",
          "es": "Juegos de mesa",
        },
        {
          "en": "Collectible figures",
          "es": "Figuras coleccionables",
        },
        {
          "en": "Educational toys",
          "es": "Juguetes educativos",
        },
      ],
    ),
    ProductCategory(
      id: "food",
      names: {
        "en": "Food and Beverages",
        "es": "Alimentos y Bebidas",
      },
      subcategories: [
        {
          "en": "Gourmet products",
          "es": "Productos gourmet",
        },
        {
          "en": "Alcoholic beverages",
          "es": "Bebidas alcohólicas",
        },
        {
          "en": "Organic products",
          "es": "Productos orgánicos",
        },
        {
          "en": "Snacks and sweets",
          "es": "Snacks y dulces",
        },
      ],
    ),
    ProductCategory(
      id: "books",
      names: {
        "en": "Books, Music, and Entertainment",
        "es": "Libros, Música y Entretenimiento",
      },
      subcategories: [
        {
          "en": "Books and magazines",
          "es": "Libros y revistas",
        },
        {
          "en": "Movies and series",
          "es": "Películas y series",
        },
        {
          "en": "Musical instruments",
          "es": "Instrumentos musicales",
        },
      ],
    ),
  ];

  static List<ProductCategory> getCategories() => _categories;

  static ProductCategory getCategoryById(String id) {
    return _categories.firstWhere(
      (category) => category.id == id,
      orElse: () => _categories.first,
    );
  }

  static List<String> getCategoryNames(String locale) {
    return _categories.map((cat) => cat.getName(locale)).toList();
  }

  static List<String> getSubcategoriesByName(
      String categoryName, String locale) {
    final category = _categories.firstWhere(
      (cat) => cat.getName(locale) == categoryName,
      orElse: () => _categories.first,
    );
    return category.getSubcategories(locale);
  }
}
