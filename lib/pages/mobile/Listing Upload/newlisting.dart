import 'package:auto_size_text/auto_size_text.dart';
import 'package:dister/widgets/mytextfield.dart';
import 'package:dister/widgets/primarybtn.dart';
import 'package:flutter/material.dart';

class Newlisting extends StatefulWidget {
  const Newlisting({super.key});

  @override
  State<Newlisting> createState() => _NewlistingState();
}

class _NewlistingState extends State<Newlisting> {
  final _linkcontroller = TextEditingController();
  final _titlecontroller = TextEditingController();
  final _shopcontroller = TextEditingController();
  final _descriptioncontroller = TextEditingController();
  final _originalcontroller = TextEditingController();
  final _finalpricecontroller = TextEditingController();

  // Controlador para el PageView
  final PageController _pageController = PageController();

  // Clave global para el formulario
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Notificador para actualizar la validez del formulario
  final ValueNotifier<bool> _isFormValidNotifier = ValueNotifier(false);

  // Función para validar el formulario y actualizar el estado
  void _validateForm() {
    _isFormValidNotifier.value = _formKey.currentState?.validate() ?? false;
  }

  @override
  void initState() {
    super.initState();

    // Listener para validar el formulario cuando se cambia de página
    _pageController.addListener(() {
      _validateForm();
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _isFormValidNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0),
          child: Text(
            'Upload',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: ValueListenableBuilder<bool>(
          valueListenable: _isFormValidNotifier,
          builder: (context, isFormValid, child) {
            return PageView(
              controller: _pageController,
              physics: isFormValid
                  ? BouncingScrollPhysics() // Bloquea el scroll si no es válido
                  : NeverScrollableScrollPhysics(), // Permite scroll cuando es válido
              children: [
                firstPage(context),
                Center(
                  child: Text(
                    'Second Page',
                    style: TextStyle(fontSize: 24),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget firstPage(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 26.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AutoSizeText(
              'Share a deal\nwith millions of users',
              minFontSize: 14,
              maxLines: 2,
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w800,
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
            const Text(
              'Reach millions and make the offer stand out!',
              style: TextStyle(fontSize: 16),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 15.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    CustomTextField(
                      controller: _linkcontroller,
                      isPassword: false,
                      hintText: "www.dister.com/example",
                      label: 'Link',
                      helptext:
                          'Paste the link to where other users can get more information on the deal',
                      validator: (value) {
                        final RegExp urlPattern = RegExp(
                            r'^(?:[a-zA-Z0-9-]+\.)+[a-zA-Z]{2,6}(?:/[^\s]*)?$',
                            caseSensitive: false);

                        if (value == null || value.isEmpty) {
                          return 'Please enter a link.';
                        } else if (!urlPattern.hasMatch(value)) {
                          return 'Please enter a valid URL.';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 15),
                    CustomTextField(
                      controller: _titlecontroller,
                      isPassword: false,
                      hintText: 'Name of the deal, product...',
                      label: 'Title',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a title.';
                        } else if (value.length < 3) {
                          return 'Title must be at least 3 characters long.';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 15),
                    CustomTextField(
                      controller: _shopcontroller,
                      isPassword: false,
                      hintText: "Eg: Zalando, Mediamarkt",
                      label: 'Shop name',
                      validator: (value) => value == null || value.isEmpty
                          ? 'Please enter a shop.'
                          : null,
                    ),
                    const SizedBox(height: 15),
                    CustomTextField(
                      controller: _descriptioncontroller,
                      isPassword: false,
                      hintText: 'Enter a description for the product',
                      label: 'Description',
                      maxLines: 5,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a description.';
                        }
                        if (value.length < 10) {
                          return 'Description must be at least 10 characters long.';
                        }
                        if (value.length > 200) {
                          return 'Description cannot exceed 200 characters.';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 15),
                    CustomTextField(
                      controller: _originalcontroller,
                      isPassword: false,
                      hintText: '90',
                      label: 'Original Price',
                      validator: (value) {
                        final double? originalPrice =
                            double.tryParse(value ?? '');
                        if (originalPrice == null || originalPrice <= 0) {
                          return 'Please enter a valid price.';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 15),
                    CustomTextField(
                      controller: _finalpricecontroller,
                      isPassword: false,
                      hintText: '30',
                      label: 'Final Price',
                      validator: (value) {
                        final double? finalPrice = double.tryParse(value ?? '');
                        final double originalPrice =
                            double.tryParse(_originalcontroller.text) ?? 0;
                        if (finalPrice == null || finalPrice <= 0) {
                          return 'Please enter a valid price.';
                        }
                        if (finalPrice >= originalPrice) {
                          return 'Final price must be less than original price.';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 15),
                    GestureDetector(
                      onTap: () {
                        _validateForm();
                        if (_isFormValidNotifier.value) {
                          _pageController.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeIn,
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content:
                                  Text('Please fill in all fields correctly.'),
                            ),
                          );
                        }
                      },
                      child: primaryBtn(text: "Continue", context: context),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
