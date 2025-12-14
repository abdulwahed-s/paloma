import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ThemeCard extends StatelessWidget {
  const ThemeCard({
    super.key,
    required this.colorScheme,
    required this.theme,
    required this.isDarkMode,
    required this.onToggle,
  });

  final ColorScheme colorScheme;
  final ThemeData theme;
  final RxBool isDarkMode;
  final Future<void> Function() onToggle;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: colorScheme.surfaceVariant,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: colorScheme.outline.withValues(alpha: 0.1),
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: colorScheme.tertiaryContainer,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.palette_outlined,
                color: colorScheme.onTertiaryContainer,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Theme',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Obx(
                    () => Text(
                      isDarkMode.value ? 'Dark Mode' : 'Light Mode',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onSurface,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Obx(
              () => Switch(
                value: isDarkMode.value,
                onChanged: (_) => onToggle(),
                activeColor: colorScheme.primary,
                trackColor: MaterialStateProperty.resolveWith((states) {
                  if (states.contains(MaterialState.selected)) {
                    return colorScheme.primaryContainer;
                  }
                  return colorScheme.surfaceVariant;
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
