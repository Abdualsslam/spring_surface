import 'package:flutter/material.dart';
import 'package:elastic_sheet/elastic_sheet.dart';

import 'unified_showcase_models.dart';
import 'unified_showcase_shared_widgets.dart';
import 'unified_showcase_styles.dart';

class UnifiedShowcaseLocaleSurface extends StatelessWidget {
  const UnifiedShowcaseLocaleSurface({
    super.key,
    required this.isExpanded,
    required this.isArabic,
    required this.strings,
    required this.onToggle,
    required this.onSelectEnglish,
    required this.onSelectArabic,
    required this.expandedWidth,
  });

  final bool isExpanded;
  final bool isArabic;
  final UnifiedShowcaseStrings strings;
  final VoidCallback onToggle;
  final VoidCallback onSelectEnglish;
  final VoidCallback onSelectArabic;
  final double expandedWidth;

  @override
  Widget build(BuildContext context) {
    const accent = Color(0xFF1F2937);

    return SpringSurface(
      key: const ValueKey('unified_showcase_locale_surface'),
      isExpanded: isExpanded,
      anchor: isArabic
          ? SpringSurfaceAnchor.topLeft
          : SpringSurfaceAnchor.topRight,
      expandedSizing: SpringSurfaceExpandedSizing.fixed,
      collapsedSize: const Size(58, 44),
      expandedSize: Size(expandedWidth, 208),
      config: const SpringSurfaceConfig.gentle(),
      collapsedDecoration: collapsedSurfaceDecoration(accent),
      expandedDecoration: expandedSurfaceDecoration(accent),
      collapsedChild: GestureDetector(
        key: const Key('unified_showcase_locale_toggle'),
        behavior: HitTestBehavior.opaque,
        onTap: onToggle,
        child: UnifiedShowcaseLocaleTrigger(
          labelKey: const Key('unified_showcase_locale_label'),
          label: isArabic ? 'AR' : 'EN',
          accent: accent,
        ),
      ),
      expandedChild: UnifiedShowcaseSurfacePanel(
        children: [
          UnifiedShowcasePanelTitle(
            icon: Icons.translate_rounded,
            title: strings.localePanelTitle,
          ),
          const SizedBox(height: 10),
          Text(
            strings.localePanelHint,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Colors.black54,
              height: 1.45,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              UnifiedShowcaseChoicePill(
                label: strings.localeEnglishLabel,
                selected: !isArabic,
                accent: accent,
                tapTargetKey: const Key('unified_showcase_locale_option_en'),
                onTap: onSelectEnglish,
              ),
              UnifiedShowcaseChoicePill(
                label: strings.localeArabicLabel,
                selected: isArabic,
                accent: accent,
                tapTargetKey: const Key('unified_showcase_locale_option_ar'),
                onTap: onSelectArabic,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
