// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a es locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes
// ignore_for_file:unnecessary_string_interpolations, unnecessary_string_escapes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'es';

  static String m0(name) => "Chat con ${name}";

  static String m1(error) => "Error durante el cierre de sesión: ${error}";

  static String m2(error) => "Error: ${error}";

  static String m3(message) => "Error inesperado: ${message}";

  static String m4(error) => "Error al subir la imagen: ${error}";

  static String m5(date) => "• Expira el ${date}";

  static String m6(count) => "• ${count} Me gusta";

  static String m7(count) => "${count} Me gusta";

  static String m8(percent) => "${percent}% descuento";

  static String m9(time) => "• Publicado hace ${time}";

  static String m10(rating) => "• Valoración: ${rating} ⭐";

  static String m11(name) => "• ${name}";

  static String m12(time) => "hace ${time}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
    "AlreadyAccount": MessageLookupByLibrary.simpleMessage(
      "¿Ya tienes una cuenta? ",
    ),
    "allCategoriesFilter": MessageLookupByLibrary.simpleMessage(
      "Todas las categorías",
    ),
    "allSubcategoriesFilter": MessageLookupByLibrary.simpleMessage(
      "Todas las subcategorías",
    ),
    "cannotFollowAgain": MessageLookupByLibrary.simpleMessage(
      "No puedes volver a seguir a este usuario.",
    ),
    "cannotOpenLink": MessageLookupByLibrary.simpleMessage(
      "No se pudo abrir el enlace",
    ),
    "categories": MessageLookupByLibrary.simpleMessage("Categorias"),
    "categorydropdown": MessageLookupByLibrary.simpleMessage(
      "Selecciona una categoría",
    ),
    "categoryerror": MessageLookupByLibrary.simpleMessage(
      "Por favor selecciona una categoría",
    ),
    "categorylabel": MessageLookupByLibrary.simpleMessage("Categoría"),
    "chatWith": m0,
    "confirmPassword": MessageLookupByLibrary.simpleMessage(
      "Confirma tu contraseña",
    ),
    "containsSpace": MessageLookupByLibrary.simpleMessage(
      "El usuario no puede contener espacios",
    ),
    "continuebtn": MessageLookupByLibrary.simpleMessage("Continuar"),
    "continues": MessageLookupByLibrary.simpleMessage("Comenzar"),
    "datehelptext": MessageLookupByLibrary.simpleMessage(
      "Este campo es opcional",
    ),
    "datehintText": MessageLookupByLibrary.simpleMessage(
      "Selecciona una fecha",
    ),
    "datelabel": MessageLookupByLibrary.simpleMessage("La oferta expira el..."),
    "descriptionerror": MessageLookupByLibrary.simpleMessage(
      "Por favor introduce una descripción",
    ),
    "descriptionerror2": MessageLookupByLibrary.simpleMessage(
      "La descripción no puede tener menos de 10 caracteres",
    ),
    "descriptionerror3": MessageLookupByLibrary.simpleMessage(
      "La descripción no puede tener más de 200 caracteres",
    ),
    "descriptionhint": MessageLookupByLibrary.simpleMessage(
      "Introduce una descripción para el producto",
    ),
    "descriptionlabel": MessageLookupByLibrary.simpleMessage("Descripción"),
    "editProfile": MessageLookupByLibrary.simpleMessage("Editar perfil"),
    "emailInUse": MessageLookupByLibrary.simpleMessage(
      "El correo electrónico ya está en uso",
    ),
    "emptyConfirmPassword": MessageLookupByLibrary.simpleMessage(
      "Por favor confirma tu contraseña",
    ),
    "emptyEmail": MessageLookupByLibrary.simpleMessage("Introduce tu correo"),
    "emptyPassword": MessageLookupByLibrary.simpleMessage(
      "Introduce tu contraseña",
    ),
    "emptyUsername": MessageLookupByLibrary.simpleMessage(
      "Introduce tu usuario",
    ),
    "errorCredential": MessageLookupByLibrary.simpleMessage(
      "Datos incorrectos",
    ),
    "errorDuringLogout": m1,
    "errorGeneric": m2,
    "errorLoadingListings": MessageLookupByLibrary.simpleMessage(
      "Error al cargar los anuncios. Inténtalo de nuevo.",
    ),
    "errorNetwork": MessageLookupByLibrary.simpleMessage("Problema de red"),
    "errorUnknow": m3,
    "errorUploadingImage": m4,
    "errorhighlight": MessageLookupByLibrary.simpleMessage(
      "Por favor selecciona al menos un destacado.",
    ),
    "errorimage": MessageLookupByLibrary.simpleMessage(
      "Por favor sube al menos una imagen.",
    ),
    "erroruploading": MessageLookupByLibrary.simpleMessage(
      "Error al subir el anuncio, por favor inténtalo de nuevo.",
    ),
    "exampleUrl": MessageLookupByLibrary.simpleMessage(
      "www.dister.com/ejemplo",
    ),
    "expiresOn": m5,
    "finalpriceerror": MessageLookupByLibrary.simpleMessage(
      "Por favor introduce un precio válido",
    ),
    "finalpriceerror2": MessageLookupByLibrary.simpleMessage(
      "El precio final debe ser menor que el precio original",
    ),
    "finalpricelabel": MessageLookupByLibrary.simpleMessage("Precio final"),
    "firstpage": MessageLookupByLibrary.simpleMessage(
      "Comparte una oferta\ncon millones de usuarios",
    ),
    "firstpagesubtitle": MessageLookupByLibrary.simpleMessage(
      "¡Alcanza a millones de personas y haz que su oferta destaque!",
    ),
    "follow": MessageLookupByLibrary.simpleMessage("Seguir"),
    "followers": MessageLookupByLibrary.simpleMessage("Seguidores"),
    "following": MessageLookupByLibrary.simpleMessage("Siguiendo"),
    "forgotPassword": MessageLookupByLibrary.simpleMessage(
      "¿Has olvidado la contraseña? ",
    ),
    "formError": MessageLookupByLibrary.simpleMessage("Arregla el formulario"),
    "goForDiscount": MessageLookupByLibrary.simpleMessage("Obtener descuento"),
    "goback": MessageLookupByLibrary.simpleMessage("Volver al inicio"),
    "hintConfirmPass": MessageLookupByLibrary.simpleMessage(
      "Confirma tu contraseña",
    ),
    "hintEmail": MessageLookupByLibrary.simpleMessage("Introduce tu email"),
    "hintPass": MessageLookupByLibrary.simpleMessage("Introduce tu contraseña"),
    "hintUser": MessageLookupByLibrary.simpleMessage("Introduce tu usuario"),
    "infoTerms": MessageLookupByLibrary.simpleMessage(
      "Al registrarte, aceptas nuestros ",
    ),
    "invalidEmail": MessageLookupByLibrary.simpleMessage(
      "Por favor ingrese una dirección válida",
    ),
    "joinUs": MessageLookupByLibrary.simpleMessage("Unete"),
    "lenghtPassword": MessageLookupByLibrary.simpleMessage(
      "La contraseña debe tener al menos 8 caracteres",
    ),
    "likesCount": m6,
    "likesText": m7,
    "link": MessageLookupByLibrary.simpleMessage("Enlace"),
    "linkempty": MessageLookupByLibrary.simpleMessage(
      "Por favor introduce un enlace",
    ),
    "linkerror": MessageLookupByLibrary.simpleMessage(
      "Por favor introduce un enlace válido",
    ),
    "linkhelptext": MessageLookupByLibrary.simpleMessage(
      "Pega el enlace donde otros usuarios puedan encontrar la oferta",
    ),
    "listings": MessageLookupByLibrary.simpleMessage("Anuncios"),
    "loading": MessageLookupByLibrary.simpleMessage("Cargando..."),
    "login": MessageLookupByLibrary.simpleMessage("Inicia sesión"),
    "loginSubtitle": MessageLookupByLibrary.simpleMessage(
      "Ingresa tus datos para empezar a ahorrar y\ncomprar de manera más inteligente.",
    ),
    "loginTitle": MessageLookupByLibrary.simpleMessage(
      "Bienvenido de nuevo,\nAccede a tus ofertas.",
    ),
    "loginbtn": MessageLookupByLibrary.simpleMessage("Login"),
    "longUsername": MessageLookupByLibrary.simpleMessage(
      "El usuario no debe tener más de 15 caracteres",
    ),
    "messages": MessageLookupByLibrary.simpleMessage("Mensajes"),
    "noAccount": MessageLookupByLibrary.simpleMessage("¿No tienes cuenta? "),
    "noDescription": MessageLookupByLibrary.simpleMessage(
      "No se ha añadido ninguna descripción.",
    ),
    "noListingsAvailable": MessageLookupByLibrary.simpleMessage(
      "No hay anuncios disponibles.",
    ),
    "noMessages": MessageLookupByLibrary.simpleMessage("No hay mensajes aún."),
    "noUserData": MessageLookupByLibrary.simpleMessage(
      "No hay datos de usuario disponibles",
    ),
    "notValidDomainEmail": MessageLookupByLibrary.simpleMessage(
      "Tiene que terminar @gmail.com",
    ),
    "originalMessage": MessageLookupByLibrary.simpleMessage("Mensaje original"),
    "originalprice": MessageLookupByLibrary.simpleMessage("Precio original"),
    "originalpriceerror": MessageLookupByLibrary.simpleMessage(
      "Por favor introduce un precio válido",
    ),
    "password": MessageLookupByLibrary.simpleMessage("Contraseña"),
    "percentOff": m8,
    "postedTimeAgo": m9,
    "privacy": MessageLookupByLibrary.simpleMessage("Política de privacidad"),
    "productDetails": MessageLookupByLibrary.simpleMessage(
      "Detalles del producto",
    ),
    "profileUpdated": MessageLookupByLibrary.simpleMessage(
      "Foto de perfil actualizada correctamente.",
    ),
    "publish": MessageLookupByLibrary.simpleMessage("Publicar"),
    "publishing": MessageLookupByLibrary.simpleMessage("Publicando..."),
    "ratingWithStars": m10,
    "readLess": MessageLookupByLibrary.simpleMessage(" Leer menos"),
    "readMore": MessageLookupByLibrary.simpleMessage(" Leer más"),
    "registerbtn": MessageLookupByLibrary.simpleMessage("Registrate"),
    "resetPassword": MessageLookupByLibrary.simpleMessage(
      "Restablecer contraseña",
    ),
    "searchHint": MessageLookupByLibrary.simpleMessage("Buscar \"ropa\""),
    "searchHint2": MessageLookupByLibrary.simpleMessage(
      "Buscar \"tecnología\"",
    ),
    "searchHint3": MessageLookupByLibrary.simpleMessage("Buscar \"muebles\""),
    "secondpagesubtitle": MessageLookupByLibrary.simpleMessage(
      "Debes subir al menos una imagen para continuar.",
    ),
    "secondpagetitle": MessageLookupByLibrary.simpleMessage(
      "Añade imágenes para la oferta",
    ),
    "segurityConfirmPassword": MessageLookupByLibrary.simpleMessage(
      "Las contraseñas no coinciden",
    ),
    "segurityPassword": MessageLookupByLibrary.simpleMessage(
      "La contraseña debe tener al menos un numero",
    ),
    "selectCategoryFilter": MessageLookupByLibrary.simpleMessage(
      "Selecciona una categoría",
    ),
    "selectSubcategoryFilter": MessageLookupByLibrary.simpleMessage(
      "Selecciona una subcategoría",
    ),
    "selecthighlights": MessageLookupByLibrary.simpleMessage(
      "Selecciona los destacados para la oferta",
    ),
    "sendMessage": MessageLookupByLibrary.simpleMessage("Enviar mensaje"),
    "shoppingDetails": MessageLookupByLibrary.simpleMessage(
      "Detalles de compra",
    ),
    "shortUsername": MessageLookupByLibrary.simpleMessage(
      "El usuario debe tener más de 5 caracteres",
    ),
    "signSubtitle": MessageLookupByLibrary.simpleMessage(
      "Empecemos y crea tu cuenta.",
    ),
    "signTitle": MessageLookupByLibrary.simpleMessage(
      "Regístrate para desbloquear ofertas!",
    ),
    "storePrefix": m11,
    "subcategorydropdown": MessageLookupByLibrary.simpleMessage(
      "Selecciona una subcategoría",
    ),
    "subcategoryerror": MessageLookupByLibrary.simpleMessage(
      "Por favor selecciona una subcategoría",
    ),
    "subcategorylabel": MessageLookupByLibrary.simpleMessage("Subcategoría"),
    "subtitle_onboarding": MessageLookupByLibrary.simpleMessage(
      "Descubre tesoros y grandes ofertas.\n¡Conéctate hoy!",
    ),
    "subtitle_onboarding2": MessageLookupByLibrary.simpleMessage(
      "¡Compara precios y encuentra las mejores ofertas con un solo toque!",
    ),
    "subtitle_onboarding3": MessageLookupByLibrary.simpleMessage(
      "Tu próxima gran oferta está\na solo una notificación de distancia.",
    ),
    "subtitlehigh": MessageLookupByLibrary.simpleMessage(
      "Elige los destacados que apliquen a tu oferta.",
    ),
    "terms": MessageLookupByLibrary.simpleMessage("Terminos"),
    "tiendaerror": MessageLookupByLibrary.simpleMessage(
      "Por favor introduce el nombre de la tienda",
    ),
    "tiendahint": MessageLookupByLibrary.simpleMessage(
      "Ej: Zalando, Amazon...",
    ),
    "tiendalabel": MessageLookupByLibrary.simpleMessage("Nombre de la tienda"),
    "timeAgo": m12,
    "timeDay": MessageLookupByLibrary.simpleMessage("d"),
    "timeHour": MessageLookupByLibrary.simpleMessage("h"),
    "timeMinute": MessageLookupByLibrary.simpleMessage("min."),
    "title_onboarding": MessageLookupByLibrary.simpleMessage(
      "Encuentra lo que\nnecesitas y más",
    ),
    "title_onboarding2": MessageLookupByLibrary.simpleMessage(
      "Obtén más,\nGasta menos",
    ),
    "title_onboarding3": MessageLookupByLibrary.simpleMessage(
      "Nunca te lo pierdas",
    ),
    "titleerror": MessageLookupByLibrary.simpleMessage(
      "Por favor introduce un título",
    ),
    "titleerror2": MessageLookupByLibrary.simpleMessage(
      "El título no puede tener menos de 3 caracteres",
    ),
    "titlehint": MessageLookupByLibrary.simpleMessage("Nombre del producto"),
    "titlelabel": MessageLookupByLibrary.simpleMessage("Título"),
    "today": MessageLookupByLibrary.simpleMessage("Hoy"),
    "translate": MessageLookupByLibrary.simpleMessage("Traducir"),
    "translatedMessage": MessageLookupByLibrary.simpleMessage(
      "Mensaje traducido",
    ),
    "translating": MessageLookupByLibrary.simpleMessage("Traduciendo..."),
    "typeMessage": MessageLookupByLibrary.simpleMessage(
      "Escribe un mensaje...",
    ),
    "unfollow": MessageLookupByLibrary.simpleMessage("Dejar de seguir"),
    "upload": MessageLookupByLibrary.simpleMessage("Subir"),
    "userLabel": MessageLookupByLibrary.simpleMessage("Usuario"),
    "userNotFound": MessageLookupByLibrary.simpleMessage(
      "Usuario no encontrado",
    ),
    "usernameInUse": MessageLookupByLibrary.simpleMessage(
      "El usuario ya esta en uso",
    ),
    "yesterday": MessageLookupByLibrary.simpleMessage("Ayer"),
  };
}
