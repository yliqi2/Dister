class FormValidator {
  // [username] comprobación de formato correcto
  static String? usernameValidator(String? value) {
    // [Rules] Mapa para falicitar la lectura
    final validationRules = {
      'empty': 'Please enter your username',
      'short': 'Username must be more than 5 characters',
      'long': 'Username cannot be more than 15 characters',
      'containsSpace': 'Username cannot contain spaces',
    };

    if (value == null || value.isEmpty) {
      return validationRules['empty'];
    }
    if (value.length < 5) {
      return validationRules['short'];
    }
    if (value.length > 15) {
      return validationRules['long'];
    }
    if (value.contains(' ')) {
      return validationRules['containsSpace'];
    }
    return null;
  }

  //[email]
  static String? emailValidator(String? value) {
    final validationRules = {
      'empty': 'Please enter your email address',
      'invalid': 'Please enter a valid email address',
      'notValidDomain': 'Email must end with @gmail.com',
    };

    if (value == null || value.isEmpty) {
      return validationRules['empty'];
    }
    final emailRegex =
        RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');

    if (!emailRegex.hasMatch(value)) {
      return validationRules['invalid'];
    }
    if (!value.endsWith('@gmail.com')) {
      return validationRules['notValidDomain'];
    }

    return null;
  }
}
