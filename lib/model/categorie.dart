class ProductCategory {
  final String name;
  final List<String> subcategories;

  ProductCategory({required this.name, required this.subcategories});
}

class ProductCategories {
  static final List<ProductCategory> _categories = [
    ProductCategory(name: "Electronics and Technology", subcategories: [
      "Mobile phones and accessories",
      "Computers and laptops",
      "Televisions and entertainment",
      "Home appliances",
      "Game consoles and video games",
      "Cameras and photography",
      "Smartwatches and wearables",
    ]),
    ProductCategory(name: "Fashion and Accessories", subcategories: [
      "Men's clothing",
      "Women's clothing",
      "Children's clothing",
      "Shoes and footwear",
      "Bags and backpacks",
      "Jewelry and watches",
      "Sunglasses and accessories",
    ]),
    ProductCategory(name: "Home and Furniture", subcategories: [
      "Furniture",
      "Decoration",
      "Lighting",
      "Bed, bath, and textiles",
      "Kitchen and dining",
      "Organization and storage",
      "Small appliances",
    ]),
    ProductCategory(name: "Health and Beauty", subcategories: [
      "Cosmetics and makeup",
      "Skin care",
      "Hair care",
      "Perfumes and fragrances",
      "Nutrition and supplements",
      "Personal care equipment",
    ]),
    ProductCategory(name: "Sports and Outdoors", subcategories: [
      "Sportswear and footwear",
      "Gym equipment",
      "Bicycles and accessories",
      "Camping and hiking",
      "Water sports",
      "Team sports",
    ]),
    ProductCategory(name: "Cars and Motorcycles", subcategories: [
      "Car accessories",
      "Motorcycle accessories",
      "Spare parts and tools",
      "Vehicle safety",
    ]),
    ProductCategory(name: "Toys and Games", subcategories: [
      "Toys for children",
      "Board games",
      "Collectible figures",
      "Educational toys",
    ]),
    ProductCategory(name: "Food and Beverages", subcategories: [
      "Gourmet products",
      "Alcoholic beverages",
      "Organic products",
      "Snacks and sweets",
    ]),
    ProductCategory(name: "Books, Music, and Entertainment", subcategories: [
      "Books and magazines",
      "Movies and series",
      "Musical instruments",
    ]),
  ];

  static List<ProductCategory> getCategories() => _categories;

  static ProductCategory getCategoryByName(String name) {
    return _categories.firstWhere(
      (category) => category.name == name,
      orElse: () => _categories.first,
    );
  }
}
