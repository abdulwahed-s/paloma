import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EditDialog extends StatefulWidget {
  const EditDialog({
    super.key,
    required this.title,
    required this.initialValue,
    required this.onSave,
    this.maxLines = 1,
  });

  final String title;
  final String initialValue;
  final Function(String) onSave;
  final int maxLines;

  static void show({
    required String title,
    required String initialValue,
    required Function(String) onSave,
    int maxLines = 1,
  }) {
    Get.dialog(
      EditDialog(
        title: title,
        initialValue: initialValue,
        onSave: onSave,
        maxLines: maxLines,
      ),
    );
  }

  @override
  State<EditDialog> createState() => _EditDialogState();
}

class _EditDialogState extends State<EditDialog> {
  late TextEditingController controller;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController(text: widget.initialValue);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(Get.context!).colorScheme;

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Text(
        widget.title,
        style: Theme.of(Get.context!).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
      ),
      content: TextFormField(
        controller: controller,
        maxLines: widget.maxLines,
        decoration: InputDecoration(
          labelText: widget.title,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: colorScheme.primary,
              width: 2,
            ),
          ),
          filled: true,
          fillColor: colorScheme.surfaceContainerHighest,
        ),
      ),
      backgroundColor: colorScheme.surface,
      actions: [
        TextButton(
          onPressed: () => Get.back(),
          child: Text(
            'Cancel',
            style: TextStyle(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ),
        FilledButton(
          onPressed: () {
            widget.onSave(controller.text);
            Get.back();
          },
          style: FilledButton.styleFrom(
            backgroundColor: colorScheme.primary,
            foregroundColor: colorScheme.onPrimary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: const Text('Save'),
        ),
      ],
    );
  }
}

// Extension to capitalize strings
extension StringCasingExtension on String {
  String capitalize() =>
      length > 0 ? '${this[0].toUpperCase()}${substring(1).toLowerCase()}' : '';
}
