import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:dister/model/categorie.dart';
import 'package:dister/model/highlight.dart';
import 'package:dister/widgets/mydropdown.dart';
import 'package:dister/widgets/mytextfield.dart';
import 'package:dister/widgets/primarybtn.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:image_picker/image_picker.dart';

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
  final PageController _pageController = PageController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final ValueNotifier<bool> _isFormValidNotifier = ValueNotifier(false);
  final List<ProductCategory> _categories = ProductCategories.getCategories();
  String? _selectedCategory;
  String? _selectedSubCategory;
  final List<String> _selectedHighlights = [];
  final List<File?> _selectedImages = [null, null, null];
  final GlobalKey<FormState> _formkey2 = GlobalKey<FormState>();

  final TextEditingController _dateController = TextEditingController();

  // Función para abrir el DatePicker
  void _selectDate(BuildContext context) {
    Locale myLocale = Localizations.localeOf(context);
    DateTime currentDate = DateTime.now();
    DateTime maxDate =
        DateTime(currentDate.year + 10, currentDate.month, currentDate.day);
    DatePicker.showDatePicker(
      context,
      showTitleActions: true,
      minTime: currentDate,
      maxTime: maxDate,
      onConfirm: (date) {
        setState(() {
          _dateController.text = "${date.year}-${date.month}-${date.day}";
        });
      },
      currentTime: DateTime.now(),
      locale: (myLocale.languageCode == 'es') ? LocaleType.es : LocaleType.en,
    );
  }

  Future<void> _pickImage(int index) async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile =
        await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedImages[index] = File(pickedFile.path);
      });
    }
  }

  void _validateForm() {
    _isFormValidNotifier.value = _formKey.currentState?.validate() ?? false;
  }

  @override
  void initState() {
    super.initState();
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
                  ? const BouncingScrollPhysics()
                  : const NeverScrollableScrollPhysics(),
              children: [
                firstPage(context),
                secondPage(context),
                Center(
                  child: Text('3rd page'),
                )
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
                        if (finalPrice == null || finalPrice < 0) {
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

  Widget secondPage(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 26.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AutoSizeText(
              'Add Images for the Deal',
              minFontSize: 14,
              maxLines: 1,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
            const Text(
              'You must upload at least one image to continue.',
              style: TextStyle(
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(3, (index) {
                return GestureDetector(
                  onTap: () => _pickImage(index),
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.grey[200],
                      image: _selectedImages[index] != null
                          ? DecorationImage(
                              image: FileImage(_selectedImages[index]!),
                              fit: BoxFit.cover,
                            )
                          : null,
                    ),
                    child: _selectedImages[index] == null
                        ? const Icon(Icons.add_a_photo,
                            size: 40, color: Colors.grey)
                        : null,
                  ),
                );
              }),
            ),
            const SizedBox(height: 20), // Cambié el tamaño a 20 aquí
            // Ahora envuelves el Form con su propia clave
            Form(
              key: _formkey2,
              child: Column(
                children: [
                  CustomDropdown(
                    selectedValue: _selectedCategory,
                    hintText: 'Select Category',
                    label: 'Category',
                    items:
                        _categories.map((category) => category.name).toList(),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select a category.';
                      }
                      return null;
                    },
                    onChanged: (newValue) {
                      setState(() {
                        _selectedCategory = newValue;
                        _selectedSubCategory =
                            null; // Reset the subcategory when the category changes
                      });
                    },
                  ),
                  const SizedBox(height: 20), // Cambié el tamaño a 20 aquí
                  if (_selectedCategory != null) ...[
                    CustomDropdown(
                      selectedValue: _selectedSubCategory,
                      hintText: 'Select Subcategory',
                      label: 'Subcategory',
                      items: _categories
                          .firstWhere(
                              (category) => category.name == _selectedCategory)
                          .subcategories,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please select a subcategory.';
                        }
                        return null;
                      },
                      onChanged: (newValue) {
                        setState(() {
                          _selectedSubCategory = newValue;
                        });
                      },
                    ),
                    const SizedBox(
                      height: 20, // Cambié el tamaño a 20 aquí
                    )
                  ],
                  CustomTextField(
                    controller: _dateController,
                    isPassword: false,
                    hintText: 'Select a date',
                    label: 'Deal expires at...',
                    isDateField: true,
                  ),
                  const SizedBox(
                    height: 20, // Cambié el tamaño a 20 aquí
                  ),
                ],
              ),
            ),
            AutoSizeText(
              'Select Highlights for the Deal',
              minFontSize: 14,
              maxLines: 1,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
            const Text(
              'Choose any highlights that apply to your deal.',
              style: TextStyle(
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8.0,
              runSpacing: 8.0,
              children: List.generate(HighlightOptions.options.length, (index) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      if (_selectedHighlights
                          .contains(HighlightOptions.options[index])) {
                        _selectedHighlights
                            .remove(HighlightOptions.options[index]);
                      } else {
                        _selectedHighlights
                            .add(HighlightOptions.options[index]);
                      }
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: _selectedHighlights
                              .contains(HighlightOptions.options[index])
                          ? Theme.of(context).colorScheme.primary
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(
                        color: _selectedHighlights
                                .contains(HighlightOptions.options[index])
                            ? Theme.of(context).colorScheme.primary
                            : Colors.grey,
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 12.0),
                    child: Text(
                      HighlightOptions.options[index],
                      style: TextStyle(
                        color: _selectedHighlights
                                .contains(HighlightOptions.options[index])
                            ? Colors.white
                            : Theme.of(context).colorScheme.secondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                );
              }),
            ),
            const SizedBox(height: 20), // Cambié el tamaño a 20 aquí
            ValueListenableBuilder<bool>(
              valueListenable: _isFormValidNotifier,
              builder: (context, isFormValid, child) {
                return GestureDetector(
                  onTap: () {
                    if (_selectedImages.any((image) => image != null)) {
                      _validateForm();
                      if (_selectedHighlights.isNotEmpty) {
                        if (_formkey2.currentState?.validate() ?? false) {
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
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content:
                                Text('Please select at least one Highlight.'),
                          ),
                        );
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please upload at least one image.'),
                        ),
                      );
                    }
                  },
                  child: primaryBtn(text: "Continue", context: context),
                );
              },
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
