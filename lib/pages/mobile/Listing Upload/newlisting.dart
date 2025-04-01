import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:confirmation_success/confirmation_success.dart';
import 'package:dister/controller/firebase/services/firebase_services.dart';
import 'package:dister/generated/l10n.dart';
import 'package:dister/model/categorie.dart';
import 'package:dister/model/highlight.dart';
import 'package:dister/widgets/mydropdown.dart';
import 'package:dister/widgets/mytextfield.dart';
import 'package:dister/widgets/primarybtn.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
  final List<XFile?> _selectedImages = [null, null, null];
  final GlobalKey<FormState> _formkey2 = GlobalKey<FormState>();

  final TextEditingController _dateController = TextEditingController();

  final FirebaseServices fs = FirebaseServices();

  bool _isUploading = false;

  Future<void> _pickImage(int index) async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile =
        await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedImages[index] = pickedFile;
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
        automaticallyImplyLeading: false,
        title: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0),
          child: Text(
            S.of(context).upload,
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
                thirdPage(context),
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
              S.of(context).firstpage,
              minFontSize: 14,
              maxLines: 2,
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w800,
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
            Text(
              S.of(context).firstpagesubtitle,
              style: const TextStyle(fontSize: 16),
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
                      helptext: S.of(context).linkhelptext,
                      validator: (value) {
                        final RegExp urlPattern = RegExp(
                            r'^(https?:\/\/)?(www\.)?[\w\-]+(\.[\w\-]+)+([\/?].*)?$',
                            caseSensitive: false);
                        if (value == null || value.isEmpty) {
                          return S.of(context).linkempty;
                        } else if (!urlPattern.hasMatch(value)) {
                          return S.of(context).linkerror;
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 15),
                    CustomTextField(
                      controller: _titlecontroller,
                      isPassword: false,
                      hintText: S.of(context).titlehint,
                      label: S.of(context).titlelabel,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return S.of(context).titleerror;
                        } else if (value.length < 3) {
                          return S.of(context).titleerror2;
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 15),
                    CustomTextField(
                      controller: _shopcontroller,
                      isPassword: false,
                      hintText: S.of(context).tiendahint,
                      label: S.of(context).tiendalabel,
                      validator: (value) => value == null || value.isEmpty
                          ? S.of(context).tiendaerror
                          : null,
                    ),
                    const SizedBox(height: 15),
                    CustomTextField(
                      controller: _descriptioncontroller,
                      isPassword: false,
                      hintText: S.of(context).descriptionhint,
                      label: S.of(context).descriptionlabel,
                      maxLines: 5,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return S.of(context).descriptionerror;
                        }
                        if (value.length < 10) {
                          return S.of(context).descriptionerror2;
                        }
                        if (value.length > 200) {
                          return S.of(context).descriptionerror3;
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 15),
                    CustomTextField(
                      controller: _originalcontroller,
                      isPassword: false,
                      hintText: '90',
                      label: S.of(context).originalprice,
                      validator: (value) {
                        final double? originalPrice =
                            double.tryParse(value ?? '');
                        if (originalPrice == null || originalPrice <= 0) {
                          return S.of(context).originalpriceerror;
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 15),
                    CustomTextField(
                      controller: _finalpricecontroller,
                      isPassword: false,
                      hintText: '30',
                      label: S.of(context).finalpricelabel,
                      validator: (value) {
                        final double? finalPrice = double.tryParse(value ?? '');
                        final double originalPrice =
                            double.tryParse(_originalcontroller.text) ?? 0;
                        if (finalPrice == null || finalPrice < 0) {
                          return S.of(context).finalpriceerror;
                        }
                        if (finalPrice >= originalPrice) {
                          return S.of(context).finalpriceerror2;
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
                            SnackBar(
                              content: Text(S.of(context).formError),
                            ),
                          );
                        }
                      },
                      child: primaryBtn(
                          text: S.of(context).continuebtn, context: context),
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
              S.of(context).secondpagetitle,
              minFontSize: 14,
              maxLines: 1,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
            Text(
              S.of(context).secondpagesubtitle,
              style: const TextStyle(
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
                              image:
                                  FileImage(File(_selectedImages[index]!.path)),
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
            const SizedBox(height: 20),
            Form(
              key: _formkey2,
              child: Column(
                children: [
                  CustomDropdown(
                    selectedValue: _selectedCategory,
                    hintText: S.of(context).categorydropdown,
                    label: S.of(context).categorylabel,
                    items: _categories
                        .map((category) => category.getName(
                            Localizations.localeOf(context).toString()))
                        .toList(),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return S.of(context).categoryerror;
                      }
                      return null;
                    },
                    onChanged: (newValue) {
                      setState(() {
                        _selectedCategory = newValue;
                        _selectedSubCategory = null;
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                  if (_selectedCategory != null) ...[
                    CustomDropdown(
                      selectedValue: _selectedSubCategory,
                      hintText: S.of(context).subcategorydropdown,
                      label: S.of(context).subcategorylabel,
                      items: _categories
                          .firstWhere((category) =>
                              category.getName(
                                  Localizations.localeOf(context).toString()) ==
                              _selectedCategory)
                          .getSubcategories(
                              Localizations.localeOf(context).toString()),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return S.of(context).subcategoryerror;
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
                      height: 20,
                    )
                  ],
                  CustomTextField(
                    controller: _dateController,
                    isPassword: false,
                    hintText: S.of(context).datehintText,
                    label: S.of(context).datelabel,
                    isDateField: true,
                    helptext: S.of(context).datehintText,
                  ),
                  const SizedBox(
                    height: 20, // Cambié el tamaño a 20 aquí
                  ),
                ],
              ),
            ),
            AutoSizeText(
              S.of(context).selecthighlights,
              minFontSize: 14,
              maxLines: 1,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
            Text(
              S.of(context).subtitlehigh,
              style: const TextStyle(
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
                      if (_selectedHighlights.contains(
                          HighlightOptions.options.keys.elementAt(index))) {
                        _selectedHighlights.remove(
                            HighlightOptions.options.keys.elementAt(index));
                      } else {
                        _selectedHighlights.add(
                            HighlightOptions.options.keys.elementAt(index));
                      }
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: _selectedHighlights.contains(
                              HighlightOptions.options.keys.elementAt(index))
                          ? Theme.of(context).colorScheme.primary
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(
                        color: _selectedHighlights.contains(
                                HighlightOptions.options.keys.elementAt(index))
                            ? Theme.of(context).colorScheme.primary
                            : Colors.grey,
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(
                      vertical: 8.0,
                      horizontal: 12.0,
                    ),
                    child: Text(
                      HighlightOptions.getLocalizedOptions(
                          Localizations.localeOf(context).toString())[index],
                      style: TextStyle(
                        color: _selectedHighlights.contains(
                                HighlightOptions.options.keys.elementAt(index))
                            ? Colors.white
                            : Theme.of(context).colorScheme.secondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                );
              }),
            ),
            const SizedBox(height: 20),
            ValueListenableBuilder<bool>(
              valueListenable: _isFormValidNotifier,
              builder: (context, isFormValid, child) {
                return GestureDetector(
                  onTap: _isUploading
                      ? null
                      : () async {
                          if (_selectedImages.any((image) => image != null)) {
                            _validateForm();
                            if (_selectedHighlights.isNotEmpty) {
                              if (_formkey2.currentState?.validate() ?? false) {
                                setState(() {
                                  _isUploading = true;
                                });

                                final user = FirebaseAuth.instance.currentUser;

                                fs
                                    .uploadListing(
                                  title: _titlecontroller.text,
                                  desc: _descriptioncontroller.text,
                                  expiresAtStr: _dateController.text,
                                  link: _linkcontroller.text,
                                  originalPrice: double.tryParse(
                                          _originalcontroller.text) ??
                                      0.0,
                                  discountPrice: double.tryParse(
                                          _finalpricecontroller.text) ??
                                      0.0,
                                  storeName: _shopcontroller.text,
                                  userId: user!.uid,
                                  categories: _selectedCategory ?? '',
                                  subcategories: _selectedSubCategory ?? '',
                                  highlights: _selectedHighlights,
                                  selectedImages: _selectedImages,
                                )
                                    .then((success) async {
                                  setState(() {
                                    _isUploading = false; // Reset the flag
                                  });
                                  if (success) {
                                    // Increment the user's listings count
                                    await fs.incrementUserListings(user.uid);

                                    _pageController.nextPage(
                                      duration:
                                          const Duration(milliseconds: 300),
                                      curve: Curves.easeIn,
                                    );
                                  } else {
                                    // ignore: use_build_context_synchronously
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content:
                                            // ignore: use_build_context_synchronously
                                            Text(S.of(context).erroruploading),
                                      ),
                                    );
                                  }
                                });
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(S.of(context).formError),
                                  ),
                                );
                              }
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(S.of(context).errorhighlight),
                                ),
                              );
                            }
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(S.of(context).errorimage),
                              ),
                            );
                          }
                        },
                  child: primaryBtn(
                    text: _isUploading ? "Publishing..." : "Publish",
                    context: context,
                  ),
                );
              },
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget thirdPage(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        Expanded(
          child: Center(
            child: ConfirmationSuccess(
              reactColor: Theme.of(context).colorScheme.primary,
              child: Icon(
                Icons.check,
                size: 100,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: () {},
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 26.0),
            child: primaryBtn(context: context, text: S.of(context).goback),
          ),
        ),
      ],
    );
  }
}
