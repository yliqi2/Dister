import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController controller;
  final bool isPassword;
  final String hintText;
  final String label;
  final String? Function(String?)? validator;
  final String? helptext;
  final int? maxLines;
  final bool isDateField;
  final TextInputType? keyboardType;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.isPassword,
    required this.hintText,
    required this.label,
    this.validator,
    this.helptext,
    this.maxLines,
    this.isDateField = false,
    this.keyboardType,
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
          widget.controller.text =
              "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
        });
      },
      currentTime: DateTime.now(),
      locale: (myLocale.languageCode == 'es') ? LocaleType.es : LocaleType.en,
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.isDateField ? () => _selectDate(context) : null,
      child: widget.isDateField
          ? AbsorbPointer(
              child: TextFormField(
                controller: widget.controller,
                maxLines: widget.maxLines,
                obscureText: _isPasswordVisible,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                keyboardType: widget.keyboardType,
                decoration: InputDecoration(
                  alignLabelWithHint: true,
                  suffixIcon: widget.isPassword
                      ? Padding(
                          padding: const EdgeInsets.only(right: 20.0),
                          child: IconButton(
                            onPressed: () {
                              setState(() {
                                _isPasswordVisible = !_isPasswordVisible;
                              });
                            },
                            icon: Icon(
                              _isPasswordVisible
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                            ),
                          ),
                        )
                      : widget.isDateField
                          ? const Padding(
                              padding: EdgeInsets.only(right: 20.0),
                              child: Icon(Icons.calendar_today),
                            )
                          : null,
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  hintText: widget.hintText,
                  hintStyle: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  labelText: widget.label,
                  labelStyle: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                  ),
                  helperText: widget.helptext,
                  helperMaxLines: 2,
                  helperStyle: const TextStyle(
                    fontSize: 12,
                  ),
                ),
                validator: widget.validator,
                readOnly: widget.isDateField,
              ),
            )
          : TextFormField(
              controller: widget.controller,
              maxLines: widget.maxLines,
              obscureText: _isPasswordVisible,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              keyboardType: widget.keyboardType,
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
                          _isPasswordVisible
                              ? Icons.visibility_off
                              : Icons.visibility,
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
                  color: Colors.grey[600],
                ),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                labelText: widget.label,
                labelStyle: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                ),
                helperText: widget.helptext,
                helperMaxLines: 2,
                helperStyle: const TextStyle(
                  fontSize: 12,
                ),
              ),
              validator: widget.validator,
            ),
    );
  }
}
