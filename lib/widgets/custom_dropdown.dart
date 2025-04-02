import 'package:flutter/material.dart';

class CustomFilterDropdown extends StatelessWidget {
  final String? value;
  final String hint;
  final List<DropdownItem> items;
  final Function(String?) onChanged;
  final IconData? icon;

  const CustomFilterDropdown({
    super.key,
    required this.value,
    required this.hint,
    required this.items,
    required this.onChanged,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: ButtonTheme(
          alignedDropdown: true,
          child: DropdownButton<String>(
            isExpanded: true,
            value: value,
            hint: Row(
              children: [
                if (icon != null) ...[
                  Icon(
                    icon,
                    color: Colors.white.withOpacity(0.7),
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                ],
                Text(
                  hint,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            icon: Icon(
              Icons.arrow_drop_down_rounded,
              color: Colors.white.withOpacity(0.7),
            ),
            dropdownColor: Theme.of(context).colorScheme.surface,
            items: items.map((DropdownItem item) {
              return DropdownMenuItem<String>(
                value: item.value,
                child: Row(
                  children: [
                    if (item.icon != null) ...[
                      Icon(
                        item.icon,
                        color: Colors.white.withOpacity(0.7),
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                    ],
                    Text(
                      item.label,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
            onChanged: onChanged,
          ),
        ),
      ),
    );
  }
}

class DropdownItem {
  final String value;
  final String label;
  final IconData? icon;

  const DropdownItem({
    required this.value,
    required this.label,
    this.icon,
  });
}
