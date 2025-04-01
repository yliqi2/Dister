class HighlightOptions {
  static const Map<String, Map<String, String>> options = {
    "free_shipping": {"en": "Free Shipping", "es": "Envío Gratis"},
    "free": {"en": "Free", "es": "Gratis"},
    "limited_time": {
      "en": "Limited Time Offer",
      "es": "Oferta por Tiempo Limitado"
    },
    "best_seller": {"en": "Best Seller", "es": "Más Vendido"},
    "special_discount": {"en": "Special Discount", "es": "Descuento Especial"},
    "flash_sale": {"en": "Flash Sale", "es": "Venta Flash"},
    "exclusive_deal": {"en": "Exclusive Deal", "es": "Oferta Exclusiva"},
    "new_arrival": {"en": "New Arrival", "es": "Recién Llegado"},
    "limited_stock": {"en": "Limited Stock", "es": "Stock Limitado"}
  };

  static List<String> getLocalizedOptions(String locale) {
    final String lang = locale.split('_')[0];
    return options.values
        .map((option) => option[lang] ?? option["en"]!)
        .toList();
  }
}
