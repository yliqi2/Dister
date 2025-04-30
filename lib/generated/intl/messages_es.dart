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

  static String m1(error) => "Error: ${error}";

  static String m2(error) => "Error al eliminar la cuenta: ${error}";

  static String m3(error) => "Error durante el cierre de sesión: ${error}";

  static String m4(error) => "Error: ${error}";

  static String m5(message) => "Error inesperado: ${message}";

  static String m6(error) => "Error al subir la imagen: ${error}";

  static String m7(date) => "• Expira el ${date}";

  static String m8(message, date) => "${message}\n${date}";

  static String m9(count) => "• ${count} Favoritos";

  static String m10(count) => "${count} Favoritos";

  static String m11(percent) => "${percent}% descuento";

  static String m12(time) => "• Publicado hace ${time}";

  static String m13(date) => "Publicado el: ${date}";

  static String m14(rating) => "• Valoración: ${rating} ⭐";

  static String m15(name) => "• ${name}";

  static String m16(time) => "hace ${time}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "AlreadyAccount": MessageLookupByLibrary.simpleMessage(
          "¿Ya tienes una cuenta? ",
        ),
        "addComment":
            MessageLookupByLibrary.simpleMessage("Añadir un comentario"),
        "allCategoriesFilter": MessageLookupByLibrary.simpleMessage(
          "Todas las categorías",
        ),
        "allSubcategoriesFilter": MessageLookupByLibrary.simpleMessage(
          "Todas las subcategorías",
        ),
        "cancel": MessageLookupByLibrary.simpleMessage("Cancelar"),
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
        "changeLanguage":
            MessageLookupByLibrary.simpleMessage("Cambiar idioma"),
        "chatWith": m0,
        "commentAdded": MessageLookupByLibrary.simpleMessage(
          "Comentario añadido correctamente",
        ),
        "commentDeleted": MessageLookupByLibrary.simpleMessage(
          "Comentario eliminado correctamente",
        ),
        "comments": MessageLookupByLibrary.simpleMessage("Comentarios"),
        "confirm": MessageLookupByLibrary.simpleMessage("Confirmar"),
        "confirmDeleteAccount": MessageLookupByLibrary.simpleMessage(
          "¿Estás seguro de que deseas eliminar tu cuenta? Esta acción no se puede deshacer.",
        ),
        "confirmPassword": MessageLookupByLibrary.simpleMessage(
          "Confirma tu contraseña",
        ),
        "containsSpace": MessageLookupByLibrary.simpleMessage(
          "El usuario no puede contener espacios",
        ),
        "continuebtn": MessageLookupByLibrary.simpleMessage("Continuar"),
        "continues": MessageLookupByLibrary.simpleMessage("Comenzar"),
        "darkTheme": MessageLookupByLibrary.simpleMessage("Oscuro"),
        "darkThemeOption": MessageLookupByLibrary.simpleMessage("Tema oscuro"),
        "datehelptext": MessageLookupByLibrary.simpleMessage(
          "Este campo es opcional",
        ),
        "datehintText": MessageLookupByLibrary.simpleMessage(
          "Selecciona una fecha",
        ),
        "datelabel":
            MessageLookupByLibrary.simpleMessage("La oferta expira el..."),
        "delete": MessageLookupByLibrary.simpleMessage("Eliminar"),
        "deleteAccount": MessageLookupByLibrary.simpleMessage("Borrar cuenta"),
        "deleteCommentConfirmation": MessageLookupByLibrary.simpleMessage(
          "¿Eliminar comentario?",
        ),
        "deleteCommentWarning": MessageLookupByLibrary.simpleMessage(
          "¿Estás seguro de que quieres eliminar este comentario?",
        ),
        "deleteConfirmation": MessageLookupByLibrary.simpleMessage(
          "Confirmar eliminación",
        ),
        "deleteListingWarning": MessageLookupByLibrary.simpleMessage(
          "¿Estás seguro de que quieres eliminar este anuncio? Esta acción no se puede deshacer.",
        ),
        "description": MessageLookupByLibrary.simpleMessage("Descripción"),
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
        "emptyEmail":
            MessageLookupByLibrary.simpleMessage("Introduce tu correo"),
        "emptyPassword": MessageLookupByLibrary.simpleMessage(
          "Introduce tu contraseña",
        ),
        "emptyUsername": MessageLookupByLibrary.simpleMessage(
          "Introduce tu usuario",
        ),
        "enterComment": MessageLookupByLibrary.simpleMessage(
          "Escribe tu comentario aquí...",
        ),
        "error": m1,
        "errorCredential": MessageLookupByLibrary.simpleMessage(
          "Datos incorrectos",
        ),
        "errorDeletingAccount": m2,
        "errorDuringLogout": m3,
        "errorGeneric": m4,
        "errorLoadingListings": MessageLookupByLibrary.simpleMessage(
          "Error al cargar los anuncios. Inténtalo de nuevo.",
        ),
        "errorLoadingMessage": MessageLookupByLibrary.simpleMessage(
          "Error al cargar el mensaje.",
        ),
        "errorNetwork": MessageLookupByLibrary.simpleMessage("Problema de red"),
        "errorUnknow": m5,
        "errorUploadingImage": m6,
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
        "expiresOn": m7,
        "favorites": MessageLookupByLibrary.simpleMessage("Favoritos"),
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
        "formError":
            MessageLookupByLibrary.simpleMessage("Arregla el formulario"),
        "goForDiscount":
            MessageLookupByLibrary.simpleMessage("Obtener descuento"),
        "goback": MessageLookupByLibrary.simpleMessage("Volver al inicio"),
        "hintConfirmPass": MessageLookupByLibrary.simpleMessage(
          "Confirma tu contraseña",
        ),
        "hintEmail": MessageLookupByLibrary.simpleMessage("Introduce tu email"),
        "hintPass":
            MessageLookupByLibrary.simpleMessage("Introduce tu contraseña"),
        "hintUser":
            MessageLookupByLibrary.simpleMessage("Introduce tu usuario"),
        "home": MessageLookupByLibrary.simpleMessage("Inicio"),
        "incompleteUserData": MessageLookupByLibrary.simpleMessage(
          "Los datos del usuario están incompletos.",
        ),
        "infoTerms": MessageLookupByLibrary.simpleMessage(
          "Al registrarte, aceptas nuestros ",
        ),
        "invalidEmail": MessageLookupByLibrary.simpleMessage(
          "Por favor ingrese una dirección válida",
        ),
        "joinUs": MessageLookupByLibrary.simpleMessage("Unete"),
        "justNow": MessageLookupByLibrary.simpleMessage("Ahora mismo"),
        "languageEnglish": MessageLookupByLibrary.simpleMessage("Inglés"),
        "languageOptions": MessageLookupByLibrary.simpleMessage(
          "Opciones de idioma",
        ),
        "languageSpanish": MessageLookupByLibrary.simpleMessage("Español"),
        "lastMessage": m8,
        "lenghtPassword": MessageLookupByLibrary.simpleMessage(
          "La contraseña debe tener al menos 8 caracteres",
        ),
        "lightTheme": MessageLookupByLibrary.simpleMessage("Claro"),
        "lightThemeOption": MessageLookupByLibrary.simpleMessage("Tema claro"),
        "likesCount": m9,
        "likesText": m10,
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
        "listingDeleted": MessageLookupByLibrary.simpleMessage(
          "Anuncio eliminado correctamente",
        ),
        "listings": MessageLookupByLibrary.simpleMessage("Anuncios"),
        "loading": MessageLookupByLibrary.simpleMessage("Cargando..."),
        "loadingChats": MessageLookupByLibrary.simpleMessage("Cargando..."),
        "login": MessageLookupByLibrary.simpleMessage("Inicia sesión"),
        "loginSubtitle": MessageLookupByLibrary.simpleMessage(
          "Ingresa tus datos para empezar a ahorrar y\ncomprar de manera más inteligente.",
        ),
        "loginTitle": MessageLookupByLibrary.simpleMessage(
          "Bienvenido de nuevo,\nAccede a tus ofertas.",
        ),
        "loginbtn": MessageLookupByLibrary.simpleMessage("Login"),
        "logout": MessageLookupByLibrary.simpleMessage("Cerrar sesión"),
        "longUsername": MessageLookupByLibrary.simpleMessage(
          "El usuario no debe tener más de 15 caracteres",
        ),
        "messages": MessageLookupByLibrary.simpleMessage("Mensajes"),
        "newPost": MessageLookupByLibrary.simpleMessage("Nueva publicación"),
        "noAccount":
            MessageLookupByLibrary.simpleMessage("¿No tienes cuenta? "),
        "noComments": MessageLookupByLibrary.simpleMessage(
          "Aún no hay comentarios. ¡Sé el primero en comentar!",
        ),
        "noDescription": MessageLookupByLibrary.simpleMessage(
          "No se ha añadido ninguna descripción.",
        ),
        "noFavoritesYet": MessageLookupByLibrary.simpleMessage(
          "No tienes favoritos aún.",
        ),
        "noFollowingUsersFound": MessageLookupByLibrary.simpleMessage(
          "No sigues a ningún usuario.",
        ),
        "noListingsAvailable": MessageLookupByLibrary.simpleMessage(
          "No hay anuncios disponibles.",
        ),
        "noListingsToShow": MessageLookupByLibrary.simpleMessage(
          "No hay anuncios para mostrar",
        ),
        "noMessages":
            MessageLookupByLibrary.simpleMessage("No hay mensajes aún."),
        "noUserData": MessageLookupByLibrary.simpleMessage(
          "No hay datos de usuario disponibles",
        ),
        "notValidDomainEmail": MessageLookupByLibrary.simpleMessage(
          "Tiene que terminar @gmail.com",
        ),
        "onlinePosts": MessageLookupByLibrary.simpleMessage(
          "Publicaciones en línea",
        ),
        "originalMessage":
            MessageLookupByLibrary.simpleMessage("Mensaje original"),
        "originalprice":
            MessageLookupByLibrary.simpleMessage("Precio original"),
        "originalpriceerror": MessageLookupByLibrary.simpleMessage(
          "Por favor introduce un precio válido",
        ),
        "otherOptions": MessageLookupByLibrary.simpleMessage("Otras opciones"),
        "password": MessageLookupByLibrary.simpleMessage("Contraseña"),
        "percentOff": m11,
        "postComment": MessageLookupByLibrary.simpleMessage("Publicar"),
        "postedTimeAgo": m12,
        "privacy":
            MessageLookupByLibrary.simpleMessage("Política de privacidad"),
        "productDetails": MessageLookupByLibrary.simpleMessage(
          "Detalles del producto",
        ),
        "profile": MessageLookupByLibrary.simpleMessage("Perfil"),
        "profileUpdated": MessageLookupByLibrary.simpleMessage(
          "Perfil actualizado correctamente.",
        ),
        "publish": MessageLookupByLibrary.simpleMessage("Publicar"),
        "publishedOn": m13,
        "publishing": MessageLookupByLibrary.simpleMessage("Publicando..."),
        "ratingWithStars": m14,
        "readLess": MessageLookupByLibrary.simpleMessage(" Leer menos"),
        "readMore": MessageLookupByLibrary.simpleMessage(" Leer más"),
        "registerbtn": MessageLookupByLibrary.simpleMessage("Registrate"),
        "removedFromFavorites": MessageLookupByLibrary.simpleMessage(
          "Eliminado de favoritos",
        ),
        "resetPassword": MessageLookupByLibrary.simpleMessage(
          "Restablecer contraseña",
        ),
        "saveChanges": MessageLookupByLibrary.simpleMessage("Guardar cambios"),
        "saveSessionData": MessageLookupByLibrary.simpleMessage(
          "Guardar datos de sesión",
        ),
        "searchHint": MessageLookupByLibrary.simpleMessage("Buscar \"ropa\""),
        "searchHint2": MessageLookupByLibrary.simpleMessage(
          "Buscar \"tecnología\"",
        ),
        "searchHint3":
            MessageLookupByLibrary.simpleMessage("Buscar \"muebles\""),
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
        "selectLanguage": MessageLookupByLibrary.simpleMessage(
          "Selecciona un idioma",
        ),
        "selectSubcategoryFilter": MessageLookupByLibrary.simpleMessage(
          "Selecciona una subcategoría",
        ),
        "selectTheme":
            MessageLookupByLibrary.simpleMessage("Selecciona un tema"),
        "selectThemeOption": MessageLookupByLibrary.simpleMessage(
          "Seleccionar tema",
        ),
        "selecthighlights": MessageLookupByLibrary.simpleMessage(
          "Selecciona los destacados para la oferta",
        ),
        "sendMessage": MessageLookupByLibrary.simpleMessage("Enviar mensaje"),
        "settings": MessageLookupByLibrary.simpleMessage("Ajustes"),
        "shareYourListings": MessageLookupByLibrary.simpleMessage(
          "¡Comparte tus anuncios!",
        ),
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
        "storePrefix": m15,
        "subcategorydropdown": MessageLookupByLibrary.simpleMessage(
          "Selecciona una subcategoría",
        ),
        "subcategoryerror": MessageLookupByLibrary.simpleMessage(
          "Por favor selecciona una subcategoría",
        ),
        "subcategorylabel":
            MessageLookupByLibrary.simpleMessage("Subcategoría"),
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
        "systemLanguageDescription": MessageLookupByLibrary.simpleMessage(
          "El idioma de la app se ajustará al idioma de tu dispositivo",
        ),
        "systemThemeDescription": MessageLookupByLibrary.simpleMessage(
          "El tema de la app se ajustará al tema de tu dispositivo",
        ),
        "terms": MessageLookupByLibrary.simpleMessage("Terminos"),
        "themeOptions":
            MessageLookupByLibrary.simpleMessage("Opciones de tema"),
        "themes": MessageLookupByLibrary.simpleMessage("Temas"),
        "tiendaerror": MessageLookupByLibrary.simpleMessage(
          "Por favor introduce el nombre de la tienda",
        ),
        "tiendahint": MessageLookupByLibrary.simpleMessage(
          "Ej: Zalando, Amazon...",
        ),
        "tiendalabel":
            MessageLookupByLibrary.simpleMessage("Nombre de la tienda"),
        "timeAgo": m16,
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
        "titlehint":
            MessageLookupByLibrary.simpleMessage("Nombre del producto"),
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
        "useSystemLanguage": MessageLookupByLibrary.simpleMessage(
          "Usar idioma del sistema",
        ),
        "useSystemTheme": MessageLookupByLibrary.simpleMessage(
          "Usar tema del sistema",
        ),
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
