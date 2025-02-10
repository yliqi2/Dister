import 'package:dister/controller/firebase/form_validator.dart';
import 'package:dister/controller/provider/authnotifier.dart';
import 'package:dister/theme/dark_mode.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Importar provider
import 'package:dister/controller/firebase/auth.dart'; // Importar AuthService
import 'package:dister/pages/mobile/home/homescreen.dart'; // Pantalla principal después de login
import 'package:dister/pages/mobile/auth/register.dart'; // Pantalla de registro
import 'package:dister/pages/mobile/auth/primarybtn.dart'; // El widget de botón de login
import 'package:dister/pages/mobile/auth/mytextfield.dart'; // El widget de campo de texto personalizado
import 'package:dister/generated/l10n.dart'; // Soporte para internacionalización (localización)

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Consumer<AuthErrorNotifier>(
        // Usar el provider para escuchar cambios
        builder: (context, errorNotifier, child) {
          // Si hay un error, mostramos un SnackBar
          if (errorNotifier.error != null) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(errorNotifier.error!)),
              );
            });
            errorNotifier.error = null; // Limpiar el error después de mostrarlo
          }

          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 26.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Logo de la aplicación
                    Image.asset('assets/images/dister.png'),

                    // Título y subtítulo
                    Text(
                      S.of(context).loginTitle,
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.w800,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                    Text(
                      S.of(context).loginSubtitle,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: Theme.of(context).colorScheme.tertiary,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Formulario de login
                    Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomTextField(
                            controller: _emailController,
                            isPassword: false,
                            hintText: S.of(context).hintEmail,
                            label: 'Email',
                            validator: (value) {
                              return FormValidator.emailValidator(
                                  value, context);
                            },
                          ),
                          const SizedBox(height: 16),
                          CustomTextField(
                            controller: _passwordController,
                            hintText: S.of(context).hintPass,
                            label: S.of(context).password,
                            isPassword: true,
                          ),
                          const SizedBox(height: 16),
                          Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                  text: S.of(context).forgotPassword,
                                  style: TextStyle(color: subtext),
                                ),
                                TextSpan(
                                  text: S.of(context).resetPassword,
                                  style: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    decoration: TextDecoration.underline,
                                    decorationColor:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 24),

                          // Botón de login
                          GestureDetector(
                            onTap: () async {
                              if (_formKey.currentState?.validate() ?? false) {
                                // Iniciar sesión
                                User? user = await _auth.login(
                                  _emailController.text.toLowerCase(),
                                  _passwordController.text,
                                  context,
                                  errorNotifier, // Pasar el notifier para manejar errores
                                );
                                if (user != null) {
                                  // Si el login es exitoso, navegar a la pantalla principal
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const Homescreen(),
                                    ),
                                  );
                                } else {
                                  // Si el login falla, muestra un mensaje de error
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content: Text(S.of(context).formError)),
                                  );
                                }
                              } else {
                                // Si el formulario no es válido, muestra un mensaje de error
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text(S.of(context).formError)),
                                );
                              }
                            },
                            child: primaryBtn(context: context, text: 'Login'),
                          ),
                        ],
                      ),
                    ),

                    // Enlace a la pantalla de registro
                    const SizedBox(height: 24),
                    Center(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const Register(),
                            ),
                          );
                        },
                        child: Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: S.of(context).noAccount,
                                style: TextStyle(color: subtext),
                              ),
                              TextSpan(
                                text: S.of(context).joinUs,
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
