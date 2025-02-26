import 'package:dister/theme/dark_mode.dart';
import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController controller;
  final bool isPassword;
  final String hintText;
  final String label;
  final String? Function(String?)? validator;
  final String? helptext;
  final int? maxLines;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.isPassword,
    required this.hintText,
    required this.label,
    this.validator,
    this.helptext,
    this.maxLines,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late bool _isPasswordVisible;

  @override
  void initState() {
    super.initState();
    _isPasswordVisible = widget.isPassword;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      maxLines: widget.maxLines,
      obscureText: _isPasswordVisible,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: InputDecoration(
        alignLabelWithHint: true,
        suffixIcon: widget.isPassword
            ? IconButton(
                onPressed: () {
                  setState(() {
                    _isPasswordVisible = !_isPasswordVisible;
                  });
                },
                icon: Icon(
                  _isPasswordVisible ? Icons.visibility_off : Icons.visibility,
                ),
              )
            : null,
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        hintText: widget.hintText,
        hintStyle: TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: 12,
          color: subtext,
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        labelText: widget.label,
        labelStyle: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w400,
        ),
        helperText: widget.helptext,
        helperMaxLines: 2, // Aquí se agrega el helperText
        helperStyle: const TextStyle(
          fontSize: 12,
        ),
      ),
      validator: widget.validator,
    );
  }
}
