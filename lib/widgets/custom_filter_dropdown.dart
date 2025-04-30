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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: colorScheme.surface.withAlpha(26),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: colorScheme.onSurface.withAlpha(51),
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
                    color: colorScheme.onSurface.withAlpha(179),
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                ],
                Text(
                  hint,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurface.withAlpha(179),
                  ),
                ),
              ],
            ),
            icon: Icon(
              Icons.arrow_drop_down_rounded,
              color: colorScheme.onSurface.withAlpha(179),
            ),
            dropdownColor: colorScheme.surface,
            items: items.map((DropdownItem item) {
              return DropdownMenuItem<String>(
                value: item.value,
                child: Row(
                  children: [
                    if (item.icon != null) ...[
                      Icon(
                        item.icon,
                        color: colorScheme.onSurface.withAlpha(179),
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                    ],
                    Text(
                      item.label,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurface.withAlpha(230),
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
