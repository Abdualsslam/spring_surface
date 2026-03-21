import 'package:flutter/material.dart';
import 'package:elastic_sheet/elastic_sheet.dart';

import 'unified_showcase_models.dart';
import 'unified_showcase_shared_widgets.dart';
import 'unified_showcase_styles.dart';

class UnifiedShowcaseComposerDock extends StatelessWidget {
  const UnifiedShowcaseComposerDock({
    super.key,
    required this.controller,
    required this.draftController,
    required this.draftFocusNode,
    required this.strings,
    required this.onExpand,
  });

  final ElasticSheetController controller;
  final TextEditingController draftController;
  final FocusNode draftFocusNode;
  final UnifiedShowcaseStrings strings;
  final VoidCallback onExpand;

  @override
  Widget build(BuildContext context) {
    const accent = Color(0xFF0F766E);

    return SizedBox(
      height: 230,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final dockWidth = constraints.maxWidth.clamp(260.0, 360.0).toDouble();

          return ElasticSheet.controlled(
            controller: controller,
            anchor: ElasticSheetAnchor.bottomCenter,
            expandedSizing: ElasticSheetExpandedSizing.dynamicHeight,
            maxExpandedHeight: 214,
            collapsedSize: Size(dockWidth, 58),
            expandedSize: Size(dockWidth, 188),
            collapsedDecoration: collapsedSurfaceDecoration(accent),
            expandedDecoration: expandedSurfaceDecoration(accent),
            collapsedChild: UnifiedShowcaseComposerBar(
              accent: accent,
              onExpand: onExpand,
              controller: draftController,
              focusNode: draftFocusNode,
              hintText: strings.composerInputHint,
              expandButtonKey: const Key(
                'unified_showcase_bottom_composer_expand_button',
              ),
              inputFieldKey: const Key(
                'unified_showcase_bottom_composer_input_field',
              ),
            ),
            expandedChild: UnifiedShowcaseSurfacePanel(
              children: [
                UnifiedShowcasePanelTitle(
                  icon: Icons.chat_bubble_outline_rounded,
                  title: strings.composerPanelTitle,
                ),
                const SizedBox(height: 12),
                KeyedSubtree(
                  key: const Key(
                    'unified_showcase_bottom_composer_draft_preview',
                  ),
                  child: UnifiedShowcaseComposerDraftCard(
                    controller: draftController,
                    title: strings.composerDraftTitle,
                    emptyText: strings.composerDraftEmpty,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: UnifiedShowcaseActionTile(
                        title: strings.composerAttachTitle,
                        subtitle: strings.composerAttachSubtitle,
                        icon: Icons.attach_file_rounded,
                        tone: const Color(0xFFDDF4E7),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: UnifiedShowcaseActionTile(
                        title: strings.composerFollowUpTitle,
                        subtitle: strings.composerFollowUpSubtitle,
                        icon: Icons.task_alt_rounded,
                        tone: const Color(0xFFE8F1FF),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                UnifiedShowcaseInfoRow(
                  label: strings.composerChannelLabel,
                  value: strings.composerChannelValue,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
