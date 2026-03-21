import 'package:flutter/material.dart';

import 'unified_showcase_models.dart';
import 'unified_showcase_shared_widgets.dart';

class UnifiedShowcaseActivitySection extends StatelessWidget {
  const UnifiedShowcaseActivitySection({super.key, required this.strings});

  final UnifiedShowcaseStrings strings;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(26),
        boxShadow: const [
          BoxShadow(
            color: Color(0x12000000),
            blurRadius: 22,
            offset: Offset(0, 12),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              strings.activityTitle,
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 4),
            Text(
              strings.activitySubtitle,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: Colors.black54),
            ),
            const SizedBox(height: 14),
            UnifiedShowcaseMessageTile(
              title: strings.activityMessageTitle,
              subtitle: strings.activityMessageSubtitle,
              trailing: strings.activityMessageTrailing,
              tone: const Color(0xFFE8F7EE),
            ),
            const SizedBox(height: 10),
            UnifiedShowcaseChatBubble(
              text: strings.activityInboundMessage,
              mine: false,
            ),
            const SizedBox(height: 10),
            UnifiedShowcaseChatBubble(
              text: strings.activityOutboundMessage,
              mine: true,
            ),
          ],
        ),
      ),
    );
  }
}
