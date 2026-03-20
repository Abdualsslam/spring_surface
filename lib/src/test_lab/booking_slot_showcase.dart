part of '../spring_surface_test_lab_page.dart';

class _BookingSlotDetailExperience extends StatefulWidget {
  const _BookingSlotDetailExperience();

  @override
  State<_BookingSlotDetailExperience> createState() =>
      _BookingSlotDetailExperienceState();
}

class _BookingSlotDetailExperienceState
    extends State<_BookingSlotDetailExperience> {
  final _sceneKey = GlobalKey<_BookingSlotScenarioState>();

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
      child: _BookingSlotScenario(
        key: _sceneKey,
        presentation: _ScenarioPresentation.detail,
        keyPrefix: 'booking_slot_detail',
      ),
    );
  }
}

class _BookingSlotScenario extends StatefulWidget {
  const _BookingSlotScenario({
    super.key,
    this.presentation = _ScenarioPresentation.compact,
    this.keyPrefix = 'booking_slot',
  });

  final _ScenarioPresentation presentation;
  final String keyPrefix;

  @override
  State<_BookingSlotScenario> createState() => _BookingSlotScenarioState();
}

class _BookingSlotScenarioState
    extends _ExpandableSceneState<_BookingSlotScenario> {
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
      const _CalendarSlotGhost(time: '4:00', detail: 'متاح'),
      const _CalendarSlotGhost(time: '4:30', detail: 'محجوز'),
      const _CalendarSlotGhost(time: '5:00', detail: 'متاح'),
      const _CalendarSlotGhost(time: '5:30', detail: 'متاح'),
      _CalendarSlotGhost(
        time: selectedTime,
        detail: selectedTitle,
        highlight: true,
      ),
      const _CalendarSlotGhost(time: '7:00', detail: 'متاح'),
      const _CalendarSlotGhost(time: '7:30', detail: 'متاح'),
      const _CalendarSlotGhost(time: '8:00', detail: 'مؤكد'),
      const _CalendarSlotGhost(time: '8:30', detail: 'متاح'),
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
                      const _Badge(label: 'الأربعاء'),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Row(
                    children: [
                      Expanded(child: _DayChip(label: 'أحد', active: false)),
                      SizedBox(width: 8),
                      Expanded(child: _DayChip(label: 'إثنين', active: false)),
                      SizedBox(width: 8),
                      Expanded(child: _DayChip(label: 'ثلاثاء', active: false)),
                      SizedBox(width: 8),
                      Expanded(child: _DayChip(label: 'أربعاء', active: true)),
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
            _ScenarioBackdrop(
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
                child: _BookingSlotButton(
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
    return _SurfaceScrollableContent(
      children: [
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: onToggle,
          child: const _PanelHeaderButton(
            label: 'حجز سريع',
            icon: Icons.calendar_today_outlined,
            accent: Color(0xFFD97706),
          ),
        ),
        const SizedBox(height: 12),
        _InfoRow(label: 'الموعد', value: appointment),
        const SizedBox(height: 8),
        _InfoRow(label: 'الخدمة', value: service),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            const _ChoicePill(
              label: '45 دقيقة',
              selected: true,
              accent: Color(0xFFD97706),
            ),
            _ChoicePill(label: format, accent: const Color(0xFFD97706)),
          ],
        ),
      ],
    );
  }
}
