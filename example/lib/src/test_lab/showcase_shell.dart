import 'package:flutter/material.dart';
import 'package:spring_surface/spring_surface.dart';

import 'showcase_models.dart';
import 'showcase_shared_widgets.dart';

class PageHero extends StatelessWidget {
  const PageHero({super.key});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0F172A), Color(0xFF1D3557)],
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
        ),
        borderRadius: BorderRadius.circular(28),
        boxShadow: const [
          BoxShadow(
            color: Color(0x18000000),
            blurRadius: 28,
            offset: Offset(0, 14),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'ثلاث عائلات سلوكية تجمع ستة أمثلة واقعية في شاشة واحدة.',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'كل قسم يركز على نمط تمدد مختلف لـ SpringSurface: من الأعلى، داخل العنصر نفسه، أو من الشريط السفلي.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.white.withAlpha(215),
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FamilySection extends StatelessWidget {
  const FamilySection({
    super.key,
    required this.familyId,
    required this.title,
    required this.description,
    required this.child,
  });

  final String familyId;
  final String title;
  final String description;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      key: Key('${familyId}_section'),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: const [
          BoxShadow(
            color: Color(0x12000000),
            blurRadius: 28,
            offset: Offset(0, 14),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 8),
            Text(
              description,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.black54,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 18),
            child,
          ],
        ),
      ),
    );
  }
}

class VariantSwitcher extends StatelessWidget {
  const VariantSwitcher({
    super.key,
    required this.familyId,
    required this.variants,
    required this.activeVariantId,
    required this.onVariantSelected,
  });

  final String familyId;
  final List<ShowcaseVariantDefinition> variants;
  final String activeVariantId;
  final ValueChanged<String> onVariantSelected;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: [
        for (final variant in variants)
          _VariantChip(
            key: Key('${familyId}_variant_${variant.id}'),
            label: variant.title,
            selected: variant.id == activeVariantId,
            onTap: () => onVariantSelected(variant.id),
          ),
      ],
    );
  }
}

class _VariantChip extends StatelessWidget {
  const _VariantChip({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: selected ? const Color(0xFF0F172A) : const Color(0xFFF5F7FB),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: selected
                  ? const Color(0xFF0F172A)
                  : const Color(0xFFE2E8F0),
            ),
          ),
          child: Text(
            label,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: selected ? Colors.white : const Color(0xFF0F172A),
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}

class FeaturedScenarioFrame extends StatelessWidget {
  const FeaturedScenarioFrame({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return PreviewFrame(child: child);
  }
}

class CompactScenarioCard extends StatelessWidget {
  const CompactScenarioCard({
    super.key,
    required this.title,
    required this.description,
    required this.child,
  });

  final String title;
  final String description;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 6),
            Text(
              description,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.black54,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 16),
            PreviewFrame(child: child),
          ],
        ),
      ),
    );
  }
}

class BottomDockScenarioShell extends StatelessWidget {
  const BottomDockScenarioShell({
    super.key,
    required this.keyPrefix,
    required this.displayMode,
    required this.isExpanded,
    required this.onToggle,
    required this.onClose,
    required this.accent,
    required this.gradient,
    required this.title,
    required this.badgeLabel,
    required this.surfaceConfig,
    required this.collapsedHeight,
    required this.expandedHeightCompact,
    required this.expandedHeightFeatured,
    required this.surfaceHostHeightCompact,
    required this.surfaceHostHeightFeatured,
    required this.backgroundBuilder,
    required this.collapsedChild,
    required this.expandedChild,
    this.wrapCollapsedChildWithToggle = true,
    this.surfaceController,
  });

  final String keyPrefix;
  final ScenarioDisplayMode displayMode;
  final bool isExpanded;
  final VoidCallback onToggle;
  final VoidCallback onClose;
  final Color accent;
  final Gradient gradient;
  final String title;
  final String badgeLabel;
  final SpringSurfaceConfig surfaceConfig;
  final double collapsedHeight;
  final double expandedHeightCompact;
  final double expandedHeightFeatured;
  final double surfaceHostHeightCompact;
  final double surfaceHostHeightFeatured;
  final WidgetBuilder backgroundBuilder;
  final Widget collapsedChild;
  final Widget expandedChild;
  final bool wrapCollapsedChildWithToggle;
  final SpringSurfaceController? surfaceController;

  @override
  Widget build(BuildContext context) {
    final surfaceHostHeight = displayMode.isFeatured
        ? surfaceHostHeightFeatured
        : surfaceHostHeightCompact;
    final expandedHeight = displayMode.isFeatured
        ? expandedHeightFeatured
        : expandedHeightCompact;

    return LayoutBuilder(
      builder: (context, constraints) {
        final surfaceWidth = constraints.maxWidth - 32;
        final controlledSurface = surfaceController != null;

        Widget buildScene(bool expanded) {
          return Stack(
            children: [
              Positioned.fill(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              title,
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(fontWeight: FontWeight.w800),
                            ),
                          ),
                          ShowcaseBadge(label: badgeLabel),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Expanded(child: backgroundBuilder(context)),
                    ],
                  ),
                ),
              ),
              if (expanded)
                ScenarioBackdrop(
                  backdropKey: Key('${keyPrefix}_backdrop'),
                  onTap: onClose,
                ),
              Positioned(
                left: 16,
                right: 16,
                bottom: 16,
                height: surfaceHostHeight,
                child: controlledSurface
                    ? SpringSurface.controlled(
                        controller: surfaceController!,
                        origin: SpringSurfaceOrigin.bottom,
                        collapsedSize: Size(surfaceWidth, collapsedHeight),
                        expandedSize: Size(surfaceWidth, expandedHeight),
                        collapsedDecoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(color: accent.withAlpha(34)),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x12000000),
                              blurRadius: 22,
                              offset: Offset(0, 12),
                            ),
                          ],
                        ),
                        expandedDecoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(color: accent.withAlpha(36)),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x14000000),
                              blurRadius: 28,
                              offset: Offset(0, 14),
                            ),
                          ],
                        ),
                        collapsedChild: wrapCollapsedChildWithToggle
                            ? GestureDetector(
                                key: Key('${keyPrefix}_toggle'),
                                behavior: HitTestBehavior.opaque,
                                onTap: onToggle,
                                child: collapsedChild,
                              )
                            : collapsedChild,
                        expandedChild: expandedChild,
                      )
                    : SpringSurface(
                        isExpanded: expanded,
                        origin: SpringSurfaceOrigin.bottom,
                        config: surfaceConfig,
                        collapsedSize: Size(surfaceWidth, collapsedHeight),
                        expandedSize: Size(surfaceWidth, expandedHeight),
                        collapsedDecoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(color: accent.withAlpha(34)),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x12000000),
                              blurRadius: 22,
                              offset: Offset(0, 12),
                            ),
                          ],
                        ),
                        expandedDecoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(color: accent.withAlpha(36)),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x14000000),
                              blurRadius: 28,
                              offset: Offset(0, 14),
                            ),
                          ],
                        ),
                        collapsedChild: wrapCollapsedChildWithToggle
                            ? GestureDetector(
                                key: Key('${keyPrefix}_toggle'),
                                behavior: HitTestBehavior.opaque,
                                onTap: onToggle,
                                child: collapsedChild,
                              )
                            : collapsedChild,
                        expandedChild: expandedChild,
                      ),
              ),
            ],
          );
        }

        return DecoratedBox(
          key: Key('${keyPrefix}_canvas'),
          decoration: BoxDecoration(gradient: gradient),
          child: controlledSurface
              ? ListenableBuilder(
                  listenable: surfaceController!,
                  builder: (context, _) {
                    return buildScene(surfaceController!.isExpanded);
                  },
                )
              : buildScene(isExpanded),
        );
      },
    );
  }
}

class PreviewFrame extends StatelessWidget {
  const PreviewFrame({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 520,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: const Color(0xFF0F172A),
          borderRadius: BorderRadius.circular(34),
          boxShadow: const [
            BoxShadow(
              color: Color(0x24000000),
              blurRadius: 32,
              offset: Offset(0, 18),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}

class ScenarioBackdrop extends StatelessWidget {
  const ScenarioBackdrop({
    super.key,
    required this.backdropKey,
    required this.onTap,
  });

  final Key backdropKey;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: GestureDetector(
        key: backdropKey,
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: ColoredBox(color: Colors.black.withAlpha(14)),
      ),
    );
  }
}

abstract class ExpandableSceneState<T extends StatefulWidget> extends State<T> {
  bool isExpanded = false;

  void setExpanded(bool value) {
    if (isExpanded == value) {
      return;
    }
    setState(() => isExpanded = value);
  }

  void open() => setExpanded(true);

  void toggle() => setExpanded(!isExpanded);

  void close() => setExpanded(false);
}
