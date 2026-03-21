import 'package:flutter/material.dart';

class UnifiedShowcaseSurfacePanel extends StatelessWidget {
  const UnifiedShowcaseSurfacePanel({super.key, required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        const padding = EdgeInsets.all(14);
        final boundedHeight = constraints.maxHeight.isFinite
            ? constraints.maxHeight
            : 0.0;
        final minHeight = boundedHeight > padding.vertical
            ? boundedHeight - padding.vertical
            : 0.0;

        return SingleChildScrollView(
          primary: false,
          padding: padding,
          child: minHeight > 0
              ? ConstrainedBox(
                  constraints: BoxConstraints(minHeight: minHeight),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: children,
                  ),
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: children,
                ),
        );
      },
    );
  }
}

class UnifiedShowcaseSectionBackdrop extends StatelessWidget {
  const UnifiedShowcaseSectionBackdrop({
    super.key,
    required this.onTap,
    this.color = const Color(0x11000000),
  });

  final VoidCallback onTap;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: ColoredBox(color: color),
      ),
    );
  }
}

class UnifiedShowcasePanelTitle extends StatelessWidget {
  const UnifiedShowcasePanelTitle({
    super.key,
    required this.icon,
    required this.title,
  });

  final IconData icon;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Colors.black54),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w800),
          ),
        ),
      ],
    );
  }
}

class UnifiedShowcaseSearchTrigger extends StatelessWidget {
  const UnifiedShowcaseSearchTrigger({
    super.key,
    required this.label,
    required this.accent,
    required this.isArabic,
  });

  final String label;
  final Color accent;
  final bool isArabic;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14),
        child: Row(
          children: [
            const Icon(Icons.search_rounded, color: Colors.black45, size: 18),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: Colors.black45),
              ),
            ),
            const SizedBox(width: 8),
            Icon(
              isArabic ? Icons.arrow_back_rounded : Icons.arrow_forward_rounded,
              color: accent,
              size: 18,
            ),
          ],
        ),
      ),
    );
  }
}

class UnifiedShowcaseLocaleTrigger extends StatelessWidget {
  const UnifiedShowcaseLocaleTrigger({
    super.key,
    required this.label,
    required this.accent,
    this.labelKey,
  });

  final String label;
  final Color accent;
  final Key? labelKey;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Row(
          children: [
            Icon(Icons.translate_rounded, color: accent, size: 18),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                key: labelKey,
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: accent,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class UnifiedShowcaseFilterTrigger extends StatelessWidget {
  const UnifiedShowcaseFilterTrigger({
    super.key,
    required this.label,
    required this.accent,
    this.labelKey,
  });

  final String label;
  final Color accent;
  final Key? labelKey;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Row(
          children: [
            const Icon(Icons.tune_rounded, size: 18),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                key: labelKey,
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: accent,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class UnifiedShowcaseChoicePill extends StatelessWidget {
  const UnifiedShowcaseChoicePill({
    super.key,
    required this.label,
    required this.selected,
    required this.accent,
    this.onTap,
    this.tapTargetKey,
  });

  final String label;
  final bool selected;
  final Color accent;
  final VoidCallback? onTap;
  final Key? tapTargetKey;

  @override
  Widget build(BuildContext context) {
    final child = Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
      decoration: BoxDecoration(
        color: selected ? accent.withAlpha(18) : const Color(0xFFF6F8FB),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
          color: selected ? accent : Colors.black87,
          fontWeight: FontWeight.w700,
        ),
      ),
    );

    if (onTap == null) {
      return child;
    }

    return GestureDetector(
      key: tapTargetKey,
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: child,
    );
  }
}

class UnifiedShowcaseMetricCard extends StatelessWidget {
  const UnifiedShowcaseMetricCard({
    super.key,
    required this.label,
    required this.value,
    required this.tone,
  });

  final String label;
  final String value;
  final Color tone;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: tone,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: Theme.of(
              context,
            ).textTheme.labelMedium?.copyWith(color: Colors.black54),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
          ),
        ],
      ),
    );
  }
}

class UnifiedShowcasePatientCard extends StatelessWidget {
  const UnifiedShowcasePatientCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.detail,
    required this.tone,
  });

  final String title;
  final String subtitle;
  final String detail;
  final Color tone;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: tone,
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(Icons.favorite_border_rounded),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: Colors.black54),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Text(
            detail,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Colors.black54,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class UnifiedShowcaseInfoRow extends StatelessWidget {
  const UnifiedShowcaseInfoRow({
    super.key,
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
      decoration: BoxDecoration(
        color: const Color(0xFFF7FAFD),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: Colors.black54),
            ),
          ),
          const SizedBox(width: 12),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w800),
            ),
          ),
        ],
      ),
    );
  }
}

class UnifiedShowcaseInlineNote extends StatelessWidget {
  const UnifiedShowcaseInlineNote({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF3E4),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        text,
        style: Theme.of(
          context,
        ).textTheme.bodySmall?.copyWith(color: Colors.black54, height: 1.45),
      ),
    );
  }
}

class UnifiedShowcaseDayChip extends StatelessWidget {
  const UnifiedShowcaseDayChip({
    super.key,
    required this.label,
    required this.active,
  });

  final String label;
  final bool active;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      decoration: BoxDecoration(
        color: active ? const Color(0xFFFFF0DD) : const Color(0xFFF7FAFD),
        borderRadius: BorderRadius.circular(18),
      ),
      alignment: Alignment.center,
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
          color: active ? const Color(0xFFD97706) : Colors.black54,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class UnifiedShowcaseDaySurfaceButton extends StatelessWidget {
  const UnifiedShowcaseDaySurfaceButton({
    super.key,
    required this.accent,
    required this.shortLabel,
    required this.title,
  });

  final Color accent;
  final String shortLabel;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Icon(Icons.event_available_rounded, color: accent, size: 16),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  shortLabel,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: accent,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w800),
          ),
        ],
      ),
    );
  }
}

class UnifiedShowcaseScheduleCard extends StatelessWidget {
  const UnifiedShowcaseScheduleCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.trailing,
  });

  final String title;
  final String subtitle;
  final String trailing;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF7FAFD),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: const Color(0xFFFFF0DD),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(Icons.health_and_safety_outlined),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: Colors.black54),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Text(
            trailing,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Colors.black54,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class UnifiedShowcaseMessageTile extends StatelessWidget {
  const UnifiedShowcaseMessageTile({
    super.key,
    required this.title,
    required this.subtitle,
    required this.trailing,
    required this.tone,
  });

  final String title;
  final String subtitle;
  final String trailing;
  final Color tone;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: tone,
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(Icons.forum_outlined),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: Colors.black54),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Text(
            trailing,
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: Colors.black45),
          ),
        ],
      ),
    );
  }
}

class UnifiedShowcaseChatBubble extends StatelessWidget {
  const UnifiedShowcaseChatBubble({
    super.key,
    required this.text,
    required this.mine,
  });

  final String text;
  final bool mine;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: mine
          ? AlignmentDirectional.centerEnd
          : AlignmentDirectional.centerStart,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 280),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: mine ? const Color(0xFFDDF4E7) : const Color(0xFFF7FAFD),
            borderRadius: BorderRadius.circular(18),
          ),
          child: Text(
            text,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Colors.black87,
              height: 1.45,
            ),
          ),
        ),
      ),
    );
  }
}

class UnifiedShowcaseComposerBar extends StatelessWidget {
  const UnifiedShowcaseComposerBar({
    super.key,
    required this.accent,
    required this.onExpand,
    required this.controller,
    required this.focusNode,
    required this.hintText,
    this.expandButtonKey,
    this.inputFieldKey,
  });

  final Color accent;
  final VoidCallback onExpand;
  final TextEditingController controller;
  final FocusNode focusNode;
  final String hintText;
  final Key? expandButtonKey;
  final Key? inputFieldKey;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Row(
          children: [
            GestureDetector(
              key: expandButtonKey,
              behavior: HitTestBehavior.opaque,
              onTap: onExpand,
              child: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: accent.withAlpha(18),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Icons.add_rounded, color: accent),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Container(
                height: 40,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: const Color(0xFFF7FAFD),
                  borderRadius: BorderRadius.circular(14),
                ),
                alignment: AlignmentDirectional.centerStart,
                child: TextField(
                  key: inputFieldKey,
                  controller: controller,
                  focusNode: focusNode,
                  maxLines: 1,
                  textInputAction: TextInputAction.done,
                  decoration: InputDecoration(
                    hintText: hintText,
                    border: InputBorder.none,
                    isCollapsed: true,
                  ),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.black87,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Icon(Icons.mic_none_rounded, color: accent),
          ],
        ),
      ),
    );
  }
}

class UnifiedShowcaseComposerDraftCard extends StatelessWidget {
  const UnifiedShowcaseComposerDraftCard({
    super.key,
    required this.controller,
    required this.title,
    required this.emptyText,
  });

  final TextEditingController controller;
  final String title;
  final String emptyText;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<TextEditingValue>(
      valueListenable: controller,
      builder: (context, value, _) {
        final draft = value.text.trim();

        return Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFFF7FAFD),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: Colors.black54,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                draft.isEmpty ? emptyText : draft,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.black87,
                  height: 1.4,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class UnifiedShowcaseActionTile extends StatelessWidget {
  const UnifiedShowcaseActionTile({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.tone,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Color tone;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: tone,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon),
          const SizedBox(height: 8),
          Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: Colors.black54),
          ),
        ],
      ),
    );
  }
}
