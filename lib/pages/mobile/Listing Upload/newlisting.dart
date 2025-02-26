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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
          child: IconButton(
            onPressed: () {},
            icon: const Icon(Icons.chevron_left_rounded),
          ),
        ),
        title: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0),
          child: Text(
            'Upload',
            style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.secondary),
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          // This enables scrolling when the keyboard appears
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
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 15.0),
                  child: Form(
                    child: Column(
                      children: [
                        CustomTextField(
                          controller: _linkcontroller,
                          isPassword: false,
                          hintText: "www.dister.com/example",
                          label: 'Link',
                          helptext:
                              'Paste the link to where other users can get more information on the deal',
                        ),
                        const SizedBox(height: 15),
                        CustomTextField(
                          controller: _titlecontroller,
                          isPassword: false,
                          hintText: 'Name of the deal, product...',
                          label: 'Title',
                        ),
                        const SizedBox(height: 15),
                        CustomTextField(
                          controller: _shopcontroller,
                          isPassword: false,
                          hintText: "Eg: Zalando, Mediamarkt",
                          label: 'Shop name',
                        ),
                        const SizedBox(height: 15),
                        CustomTextField(
                          controller: _descriptioncontroller,
                          isPassword: false,
                          hintText: 'Enter a description for the product',
                          label: 'Description',
                          maxLines: 5,
                        ),
                        const SizedBox(height: 15),
                        Row(
                          children: [
                            Expanded(
                              child: CustomTextField(
                                controller: _originalcontroller,
                                isPassword: false,
                                hintText: '90€',
                                label: 'Original Price',
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: CustomTextField(
                                controller: _finalpricecontroller,
                                isPassword: false,
                                hintText: '30€',
                                label: 'Final Price',
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        primaryBtn(text: "Continue", context: context),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
