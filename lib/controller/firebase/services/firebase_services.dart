import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dister/model/categorie.dart'; // Se importa la clase Category.
import 'package:dister/model/listing.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:dister/model/user.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:intl/intl.dart'; // Importa el paquete intl para manejar fechas.

class FirebaseServices {
  final FirebaseFirestore _fs = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Obtener el UID del usuario actual
  String getCurrentUser() {
    User? user = _auth.currentUser;
    return user?.uid ?? 'error';
  }

  // Obtener las credenciales del usuario por su UID
  Future<Users?> getCredentialsUser(String uid) async {
    DocumentSnapshot dn = await _fs.collection('users').doc(uid).get();

    if (dn.exists) {
      return Users.fromMap(dn.data() as Map<String, dynamic>);
    }
    return null;
  }

  // Función para convertir el texto de fecha en DateTime
  DateTime? convertStringToDateTime(String dateStr,
      {String format = "yyyy-mm-dd"}) {
    try {
      final DateFormat formatter =
          DateFormat(format); // Define el formato de fecha
      return formatter.parse(dateStr); // Convierte el texto a DateTime
    } catch (e) {
      print("Error parsing date: $e");
      return null; // Si hay error en la conversión, retorna null
    }
  }

  // Subir un nuevo Listing a Firestore
  Future<bool> uploadListing({
    required String title,
    required String desc,
    required String expiresAtStr, // Recibimos la fecha como un String
    required String link,
    required double originalPrice,
    required double discountPrice,
    required String storeName,
    required String userId,
    required String categories,
    required String subcategories,
    required List<String> highlights,
    required List<XFile?> selectedImages, // Cambiado a List<XFile?>
  }) async {
    try {
      // Convertir el texto de la fecha a DateTime
      DateTime? expiresAt = convertStringToDateTime(expiresAtStr);

      // Si la fecha no se pudo convertir, podemos retornar un error
      if (expiresAt == null) {
        return false;
      }

      // Crear el objeto Listing
      Listing listing = Listing(
        title: title,
        desc: desc,
        publishedAt: DateTime.now(),
        expiresAt: expiresAt,
        link: link,
        originalPrice: originalPrice,
        discountPrice: discountPrice,
        storeName: storeName,
        categories: categories,
        subcategories: subcategories,
        likes: 0,
        images: [], // Inicialmente vacío
        highlights: highlights.isNotEmpty ? highlights : [],
        owner: userId,
      );

      // Subir las imágenes a Firebase Storage
      List<String> imageUrls = [];
      if (selectedImages.isNotEmpty) {
        imageUrls = await uploadImages(selectedImages);
        listing.images = imageUrls;
      }

      // Guardar el Listing en Firestore
      await _fs.collection('listings').add(listing.toMap());

      return true; // Retornamos true si todo fue exitoso
    } catch (e) {
      print('Error uploading listing: $e');
      return false; // Retornamos false si ocurrió un error
    }
  }

  // Subir imágenes a Firebase Storage y obtener las URLs
  Future<List<String>> uploadImages(List<XFile?> images) async {
    List<String> imageUrls = [];
    try {
      for (var image in images) {
        if (image != null) {
          // Comprobar si la imagen no es null
          String fileName = image.name;
          firebase_storage.Reference ref = firebase_storage
              .FirebaseStorage.instance
              .ref()
              .child('listings/images/$fileName');
          firebase_storage.UploadTask uploadTask =
              ref.putFile(File(image.path));

          // Esperar a que se complete la carga
          await uploadTask.whenComplete(() async {
            // Obtener la URL de la imagen cargada
            String imageUrl = await ref.getDownloadURL();
            imageUrls.add(imageUrl);
          });
        }
      }
    } catch (e) {
      print("Error uploading images: $e");
    }
    return imageUrls;
  }

  Future<void> incrementUserListings(String userId) async {
    final userDoc = FirebaseFirestore.instance.collection('users').doc(userId);
    await userDoc.update({
      'listings': FieldValue.increment(1),
    });
  }
}
