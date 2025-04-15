import 'package:flutter/material.dart';

class CustomDropdown extends StatefulWidget {
  final String? selectedValue;
  final String hintText;
  final String label;
  final List<String> items;
  final String? Function(String?)? validator;
  final Function(String?)? onChanged;

  const CustomDropdown({
    super.key,
    required this.selectedValue,
    required this.hintText,
    required this.label,
    required this.items,
    this.validator,
    this.onChanged,
  });

  @override
  State<CustomDropdown> createState() => _CustomDropdownState();
}

class _CustomDropdownState extends State<CustomDropdown> {
  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: widget.selectedValue,
      validator: widget.validator,
      decoration: InputDecoration(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        labelText: widget.label,
        labelStyle: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w400,
        ),
        hintText: widget.hintText,
        hintStyle: const TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: 12,
        ),
      ),
      isExpanded: true,
      items: widget.items
          .map<DropdownMenuItem<String>>(
            (String value) => DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            ),
          )
          .toList(),
      onChanged: widget.onChanged,
    );
  }
}
