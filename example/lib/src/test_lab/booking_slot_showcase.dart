// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:spring_surface/spring_surface.dart';

import 'showcase_models.dart';
import 'showcase_shell.dart';
import 'showcase_shared_widgets.dart';

enum _BookingKind { consultation, followUp, call }

enum _BookingFilterPreset { today, followUp, remote }

const _bookingAccent = Color(0xFFD97706);
const _bookingFilterAccent = Color(0xFF2563EB);

class _BookingFilterPresetData {
  const _BookingFilterPresetData({
    required this.label,
    required this.badgeLabel,
    required this.summaryTitle,
    required this.summaryDetail,
  });

  final String label;
  final String badgeLabel;
  final String summaryTitle;
  final String summaryDetail;
}

const _bookingFilterPresetData = <_BookingFilterPreset, _BookingFilterPresetData>{
  _BookingFilterPreset.today: _BookingFilterPresetData(
    label: 'اليوم',
    badgeLabel: '6 مواعيد اليوم',
    summaryTitle: 'فرز حجوزات اليوم',
    summaryDetail:
        'اعرض المواعيد السريعة التي يمكن تأكيدها مباشرة قبل نهاية الدوام.',
  ),
  _BookingFilterPreset.followUp: _BookingFilterPresetData(
    label: 'متابعة',
    badgeLabel: '3 جلسات متابعة',
    summaryTitle: 'جلسات المتابعة',
    summaryDetail:
        'يركز هذا العرض على الجلسات القصيرة التي تحتاج فقط إلى تثبيت الوقت والطبيب.',
  ),
  _BookingFilterPreset.remote: _BookingFilterPresetData(
    label: 'عن بعد',
    badgeLabel: '4 حجوزات عن بعد',
    summaryTitle: 'جلسات عن بعد',
    summaryDetail:
        'استخدم هذا الفلتر عندما تريد إبراز الحجوزات التي لا تحتاج حضوراً مباشراً.',
  ),
};

class BookingSlotScenario extends StatefulWidget {
  const BookingSlotScenario({
    super.key,
    this.displayMode = ScenarioDisplayMode.compact,
    this.keyPrefix = 'booking_slot',
  });

  final ScenarioDisplayMode displayMode;
  final String keyPrefix;

  @override
  State<BookingSlotScenario> createState() => BookingSlotScenarioState();
}

class BookingSlotScenarioState
    extends ExpandableSceneState<BookingSlotScenario> {
  late _BookingFilterPreset _activeFilterPreset;
  bool _isFilterExpanded = false;

  _BookingFilterPresetData get _activeFilterData =>
      _bookingFilterPresetData[_activeFilterPreset]!;

  @override
  void initState() {
    super.initState();
    _activeFilterPreset = _BookingFilterPreset.today;
  }

  void _setFilterExpanded(bool value) {
    if (_isFilterExpanded == value) {
      return;
    }
    setState(() => _isFilterExpanded = value);
  }

  void _toggleFilter() {
    if (isExpanded) {
      close();
    }
    _setFilterExpanded(!_isFilterExpanded);
  }

  void _closeFilter() => _setFilterExpanded(false);

  void _toggleBookingSurface() {
    if (_isFilterExpanded) {
      _closeFilter();
    }
    toggle();
  }

  void _selectFilterPreset(_BookingFilterPreset preset) {
    if (_activeFilterPreset == preset) {
      return;
    }

    setState(() {
      _activeFilterPreset = preset;
      _isFilterExpanded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final filterData = _activeFilterData;
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

    final filterSurfaceWidth = widget.displayMode.isFeatured ? 258.0 : 238.0;
    final filterCollapsedWidth = widget.displayMode.isFeatured ? 150.0 : 138.0;
    final filterSurfaceHeight = widget.displayMode.isFeatured ? 184.0 : 170.0;
    final filterExpandedHeight = widget.displayMode.isFeatured ? 156.0 : 144.0;
    final bookingSurfaceTop = widget.displayMode.isFeatured ? 236.0 : 224.0;

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
                      KeyedSubtree(
                        key: Key('${widget.keyPrefix}_filter_badge'),
                        child: ShowcaseBadge(label: filterData.badgeLabel),
                      ),
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
          if (_isFilterExpanded)
            Positioned.fill(
              child: GestureDetector(
                key: Key('${widget.keyPrefix}_filter_backdrop'),
                behavior: HitTestBehavior.opaque,
                onTap: _closeFilter,
                child: ColoredBox(color: _bookingFilterAccent.withAlpha(10)),
              ),
            ),
          if (isExpanded)
            ScenarioBackdrop(
              backdropKey: Key('${widget.keyPrefix}_backdrop'),
              onTap: close,
            ),
          Positioned(
            top: widget.displayMode.isFeatured ? 90 : 84,
            right: 16,
            width: filterSurfaceWidth,
            height: filterSurfaceHeight,
            child: SpringSurface(
              isExpanded: _isFilterExpanded,
              origin: SpringSurfaceOrigin.top,
              config: const SpringSurfaceConfig.gentle(),
              collapsedSize: Size(filterCollapsedWidth, 42),
              expandedSize: Size(filterSurfaceWidth, filterExpandedHeight),
              collapsedDecoration: BoxDecoration(
                color: Colors.white.withAlpha(248),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: _bookingFilterAccent.withAlpha(30)),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x102563EB),
                    blurRadius: 16,
                    offset: Offset(0, 8),
                  ),
                ],
              ),
              expandedDecoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(22),
                border: Border.all(color: _bookingFilterAccent.withAlpha(34)),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x12000000),
                    blurRadius: 22,
                    offset: Offset(0, 12),
                  ),
                ],
              ),
              collapsedChild: GestureDetector(
                key: Key('${widget.keyPrefix}_filter_toggle'),
                behavior: HitTestBehavior.opaque,
                onTap: _toggleFilter,
                child: FilterChipButton(
                  label: 'الفلترة · ${filterData.label}',
                  accent: _bookingFilterAccent,
                ),
              ),
              expandedChild: _BookingFilterPanel(
                keyPrefix: widget.keyPrefix,
                selectedPreset: _activeFilterPreset,
                activeData: filterData,
                onToggle: _toggleFilter,
                onPresetSelected: _selectFilterPreset,
              ),
            ),
          ),
          Positioned(
            top: bookingSurfaceTop,
            right: widget.displayMode.isFeatured ? 58 : 50,
            width: widget.displayMode.isFeatured ? 206 : 188,
            height: widget.displayMode.isFeatured ? 198 : 184,
            child: SpringSurface(
              isExpanded: isExpanded,
              origin: SpringSurfaceOrigin.center,
              config: const SpringSurfaceConfig.bouncy(),
              collapsedSize: const Size(88, 68),
              expandedSize: Size(
                widget.displayMode.isFeatured ? 206 : 188,
                widget.displayMode.isFeatured ? 178 : 168,
              ),
              collapsedDecoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: _bookingAccent.withAlpha(44)),
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
                border: Border.all(color: _bookingAccent.withAlpha(36)),
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
                onTap: _toggleBookingSurface,
                child: BookingSlotButton(
                  time: selectedTime,
                  title: selectedTitle,
                  accent: _bookingAccent,
                ),
              ),
              expandedChild: _BookingPanel(
                onToggle: _toggleBookingSurface,
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

class _BookingFilterPanel extends StatelessWidget {
  const _BookingFilterPanel({
    required this.keyPrefix,
    required this.selectedPreset,
    required this.activeData,
    required this.onToggle,
    required this.onPresetSelected,
  });

  final String keyPrefix;
  final _BookingFilterPreset selectedPreset;
  final _BookingFilterPresetData activeData;
  final VoidCallback onToggle;
  final ValueChanged<_BookingFilterPreset> onPresetSelected;

  @override
  Widget build(BuildContext context) {
    return SurfaceScrollableContent(
      children: [
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: onToggle,
          child: const PanelHeaderButton(
            label: 'فلترة الحجوزات',
            icon: Icons.tune_rounded,
            accent: _bookingFilterAccent,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _BookingFilterPreset.values
              .map(
                (preset) => _BookingFilterPresetChip(
                  chipKey: Key(
                    '${keyPrefix}_filter_panel_preset_${_bookingFilterPresetId(preset)}',
                  ),
                  label: _bookingFilterPresetData[preset]!.label,
                  selected: preset == selectedPreset,
                  onTap: () => onPresetSelected(preset),
                ),
              )
              .toList(),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFFF4F8FF),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                activeData.summaryTitle,
                key: Key('${keyPrefix}_filter_summary_title'),
                style: Theme.of(
                  context,
                ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 6),
              Text(
                activeData.summaryDetail,
                key: Key('${keyPrefix}_filter_summary_detail'),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.black54,
                  height: 1.45,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _BookingFilterPresetChip extends StatelessWidget {
  const _BookingFilterPresetChip({
    required this.chipKey,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final Key chipKey;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      key: chipKey,
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: ChoicePill(
        label: label,
        selected: selected,
        accent: _bookingFilterAccent,
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
            accent: _bookingAccent,
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
              accent: _bookingAccent,
            ),
            ChoicePill(label: format, accent: _bookingAccent),
          ],
        ),
      ],
    );
  }
}

String _bookingFilterPresetId(_BookingFilterPreset preset) {
  switch (preset) {
    case _BookingFilterPreset.today:
      return 'today';
    case _BookingFilterPreset.followUp:
      return 'follow_up';
    case _BookingFilterPreset.remote:
      return 'remote';
  }
}
