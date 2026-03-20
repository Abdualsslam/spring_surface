// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:spring_surface/spring_surface.dart';
import 'showcase_models.dart';
import 'showcase_shell.dart';
import 'showcase_shared_widgets.dart';

enum _BookingKind { consultation, followUp, call }

class BookingSlotDetailExperience extends StatefulWidget {
  const BookingSlotDetailExperience();

  @override
  State<BookingSlotDetailExperience> createState() =>
      BookingSlotDetailExperienceState();
}

class BookingSlotDetailExperienceState
    extends State<BookingSlotDetailExperience> {
  final _sceneKey = GlobalKey<BookingSlotScenarioState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _sceneKey.currentState?.open();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: BookingSlotScenario(
        key: _sceneKey,
        presentation: ScenarioPresentation.detail,
        keyPrefix: 'booking_slot_detail',
      ),
    );
  }
}

class BookingSlotScenario extends StatefulWidget {
  const BookingSlotScenario({
    super.key,
    this.presentation = ScenarioPresentation.compact,
    this.keyPrefix = 'booking_slot',
  });

  final ScenarioPresentation presentation;
  final String keyPrefix;

  @override
  State<BookingSlotScenario> createState() => BookingSlotScenarioState();
}

class BookingSlotScenarioState
    extends ExpandableSceneState<BookingSlotScenario> {
  @override
  Widget build(BuildContext context) {
    const accent = Color(0xFFD97706);
    const currentBookingKind = _BookingKind.consultation;

    late final String selectedTime;
    late final String selectedTitle;
    late final String serviceLabel;
    late final String formatLabel;

    switch (currentBookingKind) {
      case _BookingKind.consultation:
        selectedTime = '6:30';
        selectedTitle = 'استشارة';
        serviceLabel = 'استشارة أولية';
        formatLabel = 'حضوري';
      case _BookingKind.followUp:
        selectedTime = '7:00';
        selectedTitle = 'متابعة';
        serviceLabel = 'جلسة متابعة';
        formatLabel = 'عن بعد';
      case _BookingKind.call:
        selectedTime = '7:30';
        selectedTitle = 'مكالمة';
        serviceLabel = 'مكالمة مراجعة';
        formatLabel = 'هاتفياً';
    }

    final slots = <Widget>[
      const CalendarSlotGhost(time: '4:00', detail: 'متاح'),
      const CalendarSlotGhost(time: '4:30', detail: 'محجوز'),
      const CalendarSlotGhost(time: '5:00', detail: 'متاح'),
      const CalendarSlotGhost(time: '5:30', detail: 'متاح'),
      CalendarSlotGhost(
        time: selectedTime,
        detail: selectedTitle,
        highlight: true,
      ),
      const CalendarSlotGhost(time: '7:00', detail: 'متاح'),
      const CalendarSlotGhost(time: '7:30', detail: 'متاح'),
      const CalendarSlotGhost(time: '8:00', detail: 'مؤكد'),
      const CalendarSlotGhost(time: '8:30', detail: 'متاح'),
    ];

    return DecoratedBox(
      key: Key('${widget.keyPrefix}_canvas'),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFFFFBF5), Color(0xFFFFF5EA)],
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
                          'جدول الحجوزات',
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.w800),
                        ),
                      ),
                      const ShowcaseBadge(label: 'الأربعاء'),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Row(
                    children: [
                      Expanded(child: DayChip(label: 'أحد', active: false)),
                      SizedBox(width: 8),
                      Expanded(child: DayChip(label: 'إثنين', active: false)),
                      SizedBox(width: 8),
                      Expanded(child: DayChip(label: 'ثلاثاء', active: false)),
                      SizedBox(width: 8),
                      Expanded(child: DayChip(label: 'أربعاء', active: true)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: GridView.count(
                        crossAxisCount: 3,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        physics: const NeverScrollableScrollPhysics(),
                        children: slots,
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
            top: widget.presentation.isDetail ? 182 : 178,
            right: widget.presentation.isDetail ? 58 : 50,
            width: widget.presentation.isDetail ? 206 : 188,
            height: widget.presentation.isDetail ? 198 : 184,
            child: SpringSurface(
              isExpanded: isExpanded,
              origin: SpringSurfaceOrigin.center,
              config: const SpringSurfaceConfig.bouncy(),
              collapsedSize: const Size(88, 68),
              expandedSize: Size(
                widget.presentation.isDetail ? 206 : 188,
                widget.presentation.isDetail ? 178 : 168,
              ),
              collapsedDecoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: accent.withAlpha(44)),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x12D97706),
                    blurRadius: 18,
                    offset: Offset(0, 10),
                  ),
                ],
              ),
              expandedDecoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: accent.withAlpha(36)),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x16000000),
                    blurRadius: 24,
                    offset: Offset(0, 14),
                  ),
                ],
              ),
              collapsedChild: GestureDetector(
                key: Key('${widget.keyPrefix}_toggle'),
                behavior: HitTestBehavior.opaque,
                onTap: toggle,
                child: BookingSlotButton(
                  time: selectedTime,
                  title: selectedTitle,
                  accent: accent,
                ),
              ),
              expandedChild: _BookingPanel(
                onToggle: toggle,
                appointment: 'الأربعاء $selectedTime م',
                service: serviceLabel,
                format: formatLabel,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BookingPanel extends StatelessWidget {
  const _BookingPanel({
    required this.onToggle,
    required this.appointment,
    required this.service,
    required this.format,
  });

  final VoidCallback onToggle;
  final String appointment;
  final String service;
  final String format;

  @override
  Widget build(BuildContext context) {
    return SurfaceScrollableContent(
      children: [
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: onToggle,
          child: const PanelHeaderButton(
            label: 'حجز سريع',
            icon: Icons.calendar_today_outlined,
            accent: Color(0xFFD97706),
          ),
        ),
        const SizedBox(height: 12),
        InfoRow(label: 'الموعد', value: appointment),
        const SizedBox(height: 8),
        InfoRow(label: 'الخدمة', value: service),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            const ChoicePill(
              label: '45 دقيقة',
              selected: true,
              accent: Color(0xFFD97706),
            ),
            ChoicePill(label: format, accent: const Color(0xFFD97706)),
          ],
        ),
      ],
    );
  }
}
