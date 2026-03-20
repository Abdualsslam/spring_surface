// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:spring_surface/spring_surface.dart';
import 'showcase_models.dart';
import 'showcase_shell.dart';
import 'showcase_shared_widgets.dart';

enum _NotificationMode { all, importantOnly, silent }

class SettingsInlineScenario extends StatefulWidget {
  const SettingsInlineScenario({
    super.key,
    this.displayMode = ScenarioDisplayMode.compact,
    this.keyPrefix = 'settings_inline',
  });

  final ScenarioDisplayMode displayMode;
  final String keyPrefix;

  @override
  State<SettingsInlineScenario> createState() => SettingsInlineScenarioState();
}

class SettingsInlineScenarioState
    extends ExpandableSceneState<SettingsInlineScenario> {
  @override
  Widget build(BuildContext context) {
    const accent = Color(0xFF475467);
    const currentNotificationMode = _NotificationMode.all;

    late final String valueLabel;
    late final String detailText;
    late final String scheduleText;

    switch (currentNotificationMode) {
      case _NotificationMode.all:
        valueLabel = 'الكل';
        detailText = 'تنبيهات كاملة مع ملخص يومي';
        scheduleText = 'كل ساعتين';
      case _NotificationMode.importantOnly:
        valueLabel = 'مهم فقط';
        detailText = 'تنبيهات عاجلة فقط';
        scheduleText = 'فوراً عند الطوارئ';
      case _NotificationMode.silent:
        valueLabel = 'صامت';
        detailText = 'بدون تنبيهات فورية';
        scheduleText = 'ملخص عند التاسعة';
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final surfaceWidth = constraints.maxWidth - 48;

        return DecoratedBox(
          key: Key('${widget.keyPrefix}_canvas'),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFF8FAFC), Color(0xFFF2F5F9)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Stack(
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
                              'التفضيلات',
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(fontWeight: FontWeight.w800),
                            ),
                          ),
                          const ShowcaseBadge(label: 'الحساب الشخصي'),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                color: const Color(0xFFE9EEF6),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: const Icon(Icons.person_outline_rounded),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'عبدالرحمن سالم',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleSmall
                                        ?.copyWith(fontWeight: FontWeight.w800),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'إشعارات وتفضيلات الحساب',
                                    style: Theme.of(context).textTheme.bodySmall
                                        ?.copyWith(color: Colors.black54),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      Expanded(
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(24),
                          ),
                          child: Column(
                            children: [
                              const SettingsRowGhost(
                                label: 'اللغة',
                                value: 'العربية',
                              ),
                              const SizedBox(height: 10),
                              const SizedBox(height: 52),
                              const SizedBox(height: 10),
                              SettingsRowGhost(
                                label: 'الوضع الليلي',
                                value: valueLabel,
                              ),
                              const SizedBox(height: 10),
                              const SettingsRowGhost(
                                label: 'حماية الحساب',
                                value: 'مفعلة',
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (isExpanded)
                ScenarioBackdrop(
                  backdropKey: Key('${widget.keyPrefix}_backdrop'),
                  onTap: close,
                ),
              Positioned(
                top: 160,
                left: 24,
                right: 24,
                height: widget.displayMode.isFeatured ? 252 : 236,
                child: SpringSurface(
                  isExpanded: isExpanded,
                  origin: SpringSurfaceOrigin.top,
                  config: const SpringSurfaceConfig.snappy(),
                  collapsedSize: Size(surfaceWidth, 52),
                  expandedSize: Size(
                    surfaceWidth,
                    widget.displayMode.isFeatured ? 202 : 190,
                  ),
                  expandedSizing: SpringSurfaceExpandedSizing.dynamicHeight,
                  maxExpandedHeight: widget.displayMode.isFeatured ? 202 : 188,
                  collapsedDecoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: accent.withAlpha(26)),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x12000000),
                        blurRadius: 18,
                        offset: Offset(0, 8),
                      ),
                    ],
                  ),
                  expandedDecoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(color: accent.withAlpha(28)),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x14000000),
                        blurRadius: 24,
                        offset: Offset(0, 12),
                      ),
                    ],
                  ),
                  collapsedChild: GestureDetector(
                    key: Key('${widget.keyPrefix}_toggle'),
                    behavior: HitTestBehavior.opaque,
                    onTap: toggle,
                    child: SettingsRowTrigger(
                      label: 'تنبيهات البريد',
                      value: valueLabel,
                      accent: accent,
                    ),
                  ),
                  expandedChild: _SettingsExpandedPanel(
                    onToggle: toggle,
                    mode: currentNotificationMode,
                    detailText: detailText,
                    scheduleText: scheduleText,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _SettingsExpandedPanel extends StatelessWidget {
  const _SettingsExpandedPanel({
    required this.onToggle,
    required this.mode,
    required this.detailText,
    required this.scheduleText,
  });

  final VoidCallback onToggle;
  final _NotificationMode mode;
  final String detailText;
  final String scheduleText;

  @override
  Widget build(BuildContext context) {
    return SurfaceScrollableContent(
      children: [
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: onToggle,
          child: const PanelHeaderButton(
            label: 'تنبيهات البريد',
            icon: Icons.notifications_outlined,
            accent: Color(0xFF475467),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'عدّل نوع الرسائل التي تصلك مباشرة من لوحة الإعدادات.',
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(color: Colors.black54, height: 1.45),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            ChoicePill(
              label: 'الكل',
              selected: mode == _NotificationMode.all,
              accent: const Color(0xFF475467),
            ),
            ChoicePill(
              label: 'مهم فقط',
              selected: mode == _NotificationMode.importantOnly,
              accent: const Color(0xFF475467),
            ),
            ChoicePill(
              label: 'صامت',
              selected: mode == _NotificationMode.silent,
              accent: const Color(0xFF475467),
            ),
          ],
        ),
        const SizedBox(height: 12),
        InfoRow(label: 'الوضع الحالي', value: detailText),
        const SizedBox(height: 8),
        InfoRow(label: 'وقت الإرسال', value: scheduleText),
      ],
    );
  }
}
