import 'package:flutter/material.dart';

class CategoryIcons {
  static IconData getIconForCategory(String categoryId) {
    switch (categoryId.toLowerCase()) {
      case 'electronics':
        return Icons.devices;
      case 'fashion':
        return Icons.shopping_bag;
      case 'home':
        return Icons.home;
      case 'health':
        return Icons.spa;
      case 'sports':
        return Icons.sports_soccer;
      case 'cars':
        return Icons.directions_car;
      case 'toys':
        return Icons.toys;
      default:
        return Icons.category;
    }
  }

  static IconData getIconForSubcategory(String categoryId, String subcategory) {
    final subLower = subcategory.toLowerCase();

    switch (categoryId.toLowerCase()) {
      case 'electronics':
        if (subLower.contains('phone') || subLower.contains('móvil')) {
          return Icons.smartphone;
        }
        if (subLower.contains('computer') || subLower.contains('ordenador')) {
          return Icons.laptop_mac;
        }
        if (subLower.contains('tv') || subLower.contains('television')) {
          return Icons.tv;
        }
        if (subLower.contains('appliance') ||
            subLower.contains('electrodoméstico')) {
          return Icons.countertops;
        }
        if (subLower.contains('game') || subLower.contains('consola')) {
          return Icons.gamepad;
        }
        if (subLower.contains('camera') || subLower.contains('fotografía')) {
          return Icons.photo_camera;
        }
        if (subLower.contains('watch') || subLower.contains('wearable')) {
          return Icons.watch;
        }
        return Icons.devices_other;

      case 'fashion':
        if (subLower.contains('men') || subLower.contains('hombre')) {
          return Icons.person;
        }
        if (subLower.contains('women') || subLower.contains('mujer')) {
          return Icons.person_2;
        }
        if (subLower.contains('children') || subLower.contains('niño')) {
          return Icons.child_friendly;
        }
        if (subLower.contains('shoe') || subLower.contains('calzado')) {
          return Icons.hiking;
        }
        if (subLower.contains('bag') || subLower.contains('bolso')) {
          return Icons.work_outline;
        }
        if (subLower.contains('jewelry') || subLower.contains('joyería')) {
          return Icons.diamond;
        }
        if (subLower.contains('glass') || subLower.contains('gafas')) {
          return Icons.remove_red_eye;
        }
        return Icons.checkroom;

      case 'home':
        if (subLower.contains('furniture') || subLower.contains('mueble')) {
          return Icons.weekend;
        }
        if (subLower.contains('decoration') ||
            subLower.contains('decoración')) {
          return Icons.brush;
        }
        if (subLower.contains('light') || subLower.contains('iluminación')) {
          return Icons.lightbulb;
        }
        if (subLower.contains('bed') || subLower.contains('baño')) {
          return Icons.single_bed;
        }
        if (subLower.contains('kitchen') || subLower.contains('cocina')) {
          return Icons.restaurant_menu;
        }
        if (subLower.contains('storage') || subLower.contains('organización')) {
          return Icons.shelves;
        }
        if (subLower.contains('appliance') ||
            subLower.contains('electrodoméstico')) {
          return Icons.blender;
        }
        return Icons.chair;

      case 'health':
        if (subLower.contains('cosmetic') || subLower.contains('maquillaje')) {
          return Icons.face_retouching_natural;
        }
        if (subLower.contains('skin') || subLower.contains('piel')) {
          return Icons.face_3;
        }
        if (subLower.contains('hair') || subLower.contains('cabello')) {
          return Icons.content_cut;
        }
        if (subLower.contains('perfume') || subLower.contains('fragancia')) {
          return Icons.water_drop;
        }
        if (subLower.contains('nutrition') || subLower.contains('suplemento')) {
          return Icons.medication;
        }
        if (subLower.contains('equipment') || subLower.contains('equipo')) {
          return Icons.medical_services;
        }
        return Icons.healing;

      case 'sports':
        if (subLower.contains('gym') || subLower.contains('gimnasio')) {
          return Icons.fitness_center;
        }
        if (subLower.contains('bicycle') || subLower.contains('bicicleta')) {
          return Icons.pedal_bike;
        }
        if (subLower.contains('camp') || subLower.contains('senderismo')) {
          return Icons.terrain;
        }
        if (subLower.contains('water') || subLower.contains('acuático')) {
          return Icons.surfing;
        }
        if (subLower.contains('team') || subLower.contains('equipo')) {
          return Icons.sports_baseball;
        }
        if (subLower.contains('wear') || subLower.contains('ropa')) {
          return Icons.sports_handball;
        }
        return Icons.sports_basketball;

      case 'cars':
        if (subLower.contains('motorcycle') || subLower.contains('moto')) {
          return Icons.two_wheeler;
        }
        if (subLower.contains('tool') || subLower.contains('herramienta')) {
          return Icons.handyman;
        }
        if (subLower.contains('safety') || subLower.contains('seguridad')) {
          return Icons.health_and_safety;
        }
        if (subLower.contains('part') || subLower.contains('repuesto')) {
          return Icons.settings_suggest;
        }
        return Icons.car_repair;

      case 'toys':
        if (subLower.contains('board') || subLower.contains('mesa')) {
          return Icons.extension;
        }
        if (subLower.contains('figure') || subLower.contains('figura')) {
          return Icons.sports_martial_arts;
        }
        if (subLower.contains('education') || subLower.contains('educativo')) {
          return Icons.psychology;
        }
        if (subLower.contains('children') || subLower.contains('niño')) {
          return Icons.smart_toy;
        }
        return Icons.toys;

      default:
        return Icons.sell;
    }
  }
}
