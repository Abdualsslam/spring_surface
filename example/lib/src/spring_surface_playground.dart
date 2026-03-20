import 'package:flutter/material.dart';
import 'package:spring_surface/spring_surface.dart';

import 'spring_surface_test_lab_page.dart';

enum _PlaygroundPlacement { top, center, bottom }

class SpringSurfacePlayground extends StatefulWidget {
  const SpringSurfacePlayground({super.key});

  @override
  State<SpringSurfacePlayground> createState() =>
      _SpringSurfacePlaygroundState();
}

class _SpringSurfacePlaygroundState extends State<SpringSurfacePlayground> {
  static const double _defaultCollapsedWidth = 240;
  static const double _defaultCollapsedHeight = 54;
  static const double _defaultExpandedWidth = 320;
  static const double _defaultExpandedHeight = 350;
  static const double _bottomGap = 10;
  static const double _defaultHorizontalStretch = 0.028;
  static const double _defaultVerticalStretch = 0.065;

  bool _isExpanded = false;
  double _collapsedWidth = _defaultCollapsedWidth;
  double _collapsedHeight = _defaultCollapsedHeight;
  double _expandedWidth = _defaultExpandedWidth;
  double _expandedHeight = _defaultExpandedHeight;
  double _overshootClamp = 1.03;
  int _expandDurationMs = 600;
  int _collapseDurationMs = 600;
  SpringSurfaceOrigin _origin = SpringSurfaceOrigin.bottom;
  _PlaygroundPlacement _placement = _PlaygroundPlacement.center;

  Size get _collapsedSize => Size(_collapsedWidth, _collapsedHeight);
  Size get _expandedSize => Size(_expandedWidth, _expandedHeight);
  double get _surfaceHostWidth =>
      (_expandedWidth > _collapsedWidth ? _expandedWidth : _collapsedWidth) +
      56;
  double get _surfaceHostHeight =>
      (_expandedHeight > _collapsedHeight
          ? _expandedHeight
          : _collapsedHeight) +
      56;

  double _collapsedTopOffsetInHost() {
    switch (_origin) {
      case SpringSurfaceOrigin.top:
        return 0;
      case SpringSurfaceOrigin.center:
        return (_surfaceHostHeight - _collapsedHeight) / 2;
      case SpringSurfaceOrigin.bottom:
        return _surfaceHostHeight - _collapsedHeight;
    }
  }

  double _desiredCollapsedTop(double availableHeight) {
    switch (_placement) {
      case _PlaygroundPlacement.top:
        return 0;
      case _PlaygroundPlacement.center:
        return (availableHeight - _collapsedHeight) / 2;
      case _PlaygroundPlacement.bottom:
        return availableHeight - _collapsedHeight;
    }
  }

  double _surfaceHostTop(double availableHeight) {
    return _desiredCollapsedTop(availableHeight) - _collapsedTopOffsetInHost();
  }

  SpringSurfaceConfig get _config => SpringSurfaceConfig(
    overshootClamp: _overshootClamp,
    horizontalStretchAmplitude: _defaultHorizontalStretch,
    verticalStretchAmplitude: _defaultVerticalStretch,
    expandDuration: Duration(milliseconds: _expandDurationMs),
    collapseDuration: Duration(milliseconds: _collapseDurationMs),
  );

  void _toggle() => setState(() => _isExpanded = !_isExpanded);

  void _applyPreset(SpringSurfaceConfig config) {
    setState(() {
      _overshootClamp = config.overshootClamp;
      _expandDurationMs = config.expandDuration.inMilliseconds;
      _collapseDurationMs = config.collapseDuration.inMilliseconds;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEDEDF2),
      appBar: AppBar(
        backgroundColor: const Color(0xFFEDEDF2),
        surfaceTintColor: Colors.transparent,
        title: const Text('Spring Surface Playground'),
        actions: [
          IconButton(
            key: const Key('playground_open_test_lab'),
            tooltip: 'افتح صفحة الاختبارات',
            onPressed: () {
              Navigator.of(
                context,
              ).pushNamed(SpringSurfaceTestLabPage.routeName);
            },
            icon: const Icon(Icons.science_outlined),
          ),
        ],
      ),
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(
                  bottom: _placement == _PlaygroundPlacement.bottom
                      ? _bottomGap
                      : 0,
                ),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final hostLeft =
                        (constraints.maxWidth - _surfaceHostWidth) / 2;
                    final hostTop = _surfaceHostTop(constraints.maxHeight);

                    return Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Positioned(
                          left: hostLeft,
                          top: hostTop,
                          width: _surfaceHostWidth,
                          height: _surfaceHostHeight,
                          child: GestureDetector(
                            key: const Key('playground_surface_toggle'),
                            behavior: HitTestBehavior.opaque,
                            onTap: _toggle,
                            child: SizedBox(
                              key: const Key('playground_surface_host'),
                              width: _surfaceHostWidth,
                              height: _surfaceHostHeight,
                              child: SpringSurface(
                                isExpanded: _isExpanded,
                                origin: _origin,
                                config: _config,
                                collapsedSize: _collapsedSize,
                                expandedSize: _expandedSize,
                                collapsedBorderRadius: const BorderRadius.all(
                                  Radius.circular(32),
                                ),
                                expandedBorderRadius: const BorderRadius.all(
                                  Radius.circular(22),
                                ),
                                collapsedDecoration: BoxDecoration(
                                  color: const Color(0xFF4F46E5),
                                  borderRadius: BorderRadius.circular(32),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Color(0x224F46E5),
                                      blurRadius: 22,
                                      offset: Offset(0, 12),
                                    ),
                                  ],
                                ),
                                expandedDecoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(22),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Color(0x16000000),
                                      blurRadius: 26,
                                      offset: Offset(0, 14),
                                    ),
                                  ],
                                ),
                                collapsedChild: const Center(
                                  child: Text(
                                    key: Key('playground_collapsed_label'),
                                    'بيانات الطلب',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 17,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                expandedChild: const SingleChildScrollView(
                                  primary: false,
                                  child: _ExpandedContent(),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
            _ControlsPanel(
              collapsedWidth: _collapsedWidth,
              collapsedHeight: _collapsedHeight,
              expandedWidth: _expandedWidth,
              expandedHeight: _expandedHeight,
              overshootClamp: _overshootClamp,
              expandDurationMs: _expandDurationMs,
              collapseDurationMs: _collapseDurationMs,
              origin: _origin,
              placement: _placement,
              onCollapsedWidth: (value) =>
                  setState(() => _collapsedWidth = value),
              onCollapsedHeight: (value) =>
                  setState(() => _collapsedHeight = value),
              onOvershootClamp: (value) =>
                  setState(() => _overshootClamp = value),
              onExpandedWidth: (value) =>
                  setState(() => _expandedWidth = value),
              onExpandedHeight: (value) =>
                  setState(() => _expandedHeight = value),
              onExpandDuration: (value) =>
                  setState(() => _expandDurationMs = value),
              onCollapseDuration: (value) =>
                  setState(() => _collapseDurationMs = value),
              onOrigin: (value) => setState(() => _origin = value),
              onPlacement: (value) => setState(() => _placement = value),
              onPreset: _applyPreset,
            ),
          ],
        ),
      ),
    );
  }
}

class _ExpandedContent extends StatelessWidget {
  const _ExpandedContent();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 8),
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Container(
            height: 90,
            decoration: BoxDecoration(
              color: const Color(0xFFF0F0F8),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Center(
              child: Text(
                key: Key('playground_expanded_heading'),
                'معلومات الحساب',
                style: TextStyle(
                  color: Color(0xFF4F46E5),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          _placeholder(52),
          const SizedBox(height: 8),
          _placeholder(52),
          const SizedBox(height: 16),
          Container(
            height: 52,
            decoration: BoxDecoration(
              color: const Color(0xFF4F46E5),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Center(
              child: Text(
                'تأكيد الدفع',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _placeholder(double height) => Container(
    height: height,
    decoration: BoxDecoration(
      color: Colors.grey.shade100,
      borderRadius: BorderRadius.circular(12),
    ),
  );
}

class _ControlsPanel extends StatelessWidget {
  const _ControlsPanel({
    required this.collapsedWidth,
    required this.collapsedHeight,
    required this.expandedWidth,
    required this.expandedHeight,
    required this.overshootClamp,
    required this.expandDurationMs,
    required this.collapseDurationMs,
    required this.origin,
    required this.placement,
    required this.onCollapsedWidth,
    required this.onCollapsedHeight,
    required this.onOvershootClamp,
    required this.onExpandedWidth,
    required this.onExpandedHeight,
    required this.onExpandDuration,
    required this.onCollapseDuration,
    required this.onOrigin,
    required this.onPlacement,
    required this.onPreset,
  });

  final double collapsedWidth;
  final double collapsedHeight;
  final double expandedWidth;
  final double expandedHeight;
  final double overshootClamp;
  final int expandDurationMs;
  final int collapseDurationMs;
  final SpringSurfaceOrigin origin;
  final _PlaygroundPlacement placement;
  final ValueChanged<double> onCollapsedWidth;
  final ValueChanged<double> onCollapsedHeight;
  final ValueChanged<double> onOvershootClamp;
  final ValueChanged<double> onExpandedWidth;
  final ValueChanged<double> onExpandedHeight;
  final ValueChanged<int> onExpandDuration;
  final ValueChanged<int> onCollapseDuration;
  final ValueChanged<SpringSurfaceOrigin> onOrigin;
  final ValueChanged<_PlaygroundPlacement> onPlacement;
  final ValueChanged<SpringSurfaceConfig> onPreset;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 320,
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: Color(0x10000000),
            blurRadius: 20,
            offset: Offset(0, -4),
          ),
        ],
      ),
      child: SingleChildScrollView(
        primary: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _PresetChip(
                  label: 'gentle',
                  onTap: () => onPreset(const SpringSurfaceConfig.gentle()),
                ),
                _PresetChip(
                  label: 'default',
                  onTap: () => onPreset(const SpringSurfaceConfig()),
                ),
                _PresetChip(
                  label: 'bouncy',
                  onTap: () => onPreset(const SpringSurfaceConfig.bouncy()),
                ),
                _PresetChip(
                  label: 'snappy',
                  onTap: () => onPreset(const SpringSurfaceConfig.snappy()),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const _SectionLabel(title: 'Controls from SpringSurface'),
            _SliderRow(
              label: 'overshoot',
              value: overshootClamp,
              min: 1.0,
              max: 1.12,
              digits: 2,
              onChanged: onOvershootClamp,
              infoKey: const Key('playground_info_overshoot'),
              description:
                  'يحدد مقدار السماح بتجاوز الحجم المستهدف أثناء الحركة. رفعه يزيد الارتداد والامتلاء البصري.',
            ),
            _SliderRow(
              label: 'expanded width',
              value: expandedWidth,
              min: 260,
              max: 420,
              digits: 0,
              onChanged: onExpandedWidth,
              sliderKey: const Key('playground_expanded_width_slider'),
              valueKey: const Key('playground_expanded_width_value'),
              infoKey: const Key('playground_info_width'),
              description:
                  'يحدد العرض النهائي للقطعة عندما تكون في الحالة المتمددة.',
            ),
            _SliderRow(
              label: 'expanded height',
              value: expandedHeight,
              min: 220,
              max: 520,
              digits: 0,
              onChanged: onExpandedHeight,
              sliderKey: const Key('playground_expanded_height_slider'),
              valueKey: const Key('playground_expanded_height_value'),
              infoKey: const Key('playground_info_height'),
              description:
                  'يحدد الارتفاع النهائي للقطعة عندما تكون في الحالة المتمددة.',
            ),
            _SliderRow(
              label: 'expand',
              value: expandDurationMs.toDouble(),
              min: 200,
              max: 1000,
              digits: 0,
              unit: 'ms',
              onChanged: (value) => onExpandDuration(value.round()),
              infoKey: const Key('playground_info_expand'),
              description:
                  'مدة فتح القطعة بالمللي ثانية. القيم الأكبر تعطي فتحًا أبطأ وأكثر هدوءًا.',
            ),
            _SliderRow(
              label: 'collapse',
              value: collapseDurationMs.toDouble(),
              min: 200,
              max: 1000,
              digits: 0,
              unit: 'ms',
              onChanged: (value) => onCollapseDuration(value.round()),
              infoKey: const Key('playground_info_collapse'),
              description:
                  'مدة إغلاق القطعة بالمللي ثانية. القيم الأكبر تعطي إغلاقًا أبطأ وأكثر سلاسة.',
            ),
            _SectionHeader(
              title: 'origin',
              infoKey: const Key('playground_info_origin'),
              description:
                  'يحدد نقطة بداية التمدد: من الأسفل أو الوسط أو الأعلى حسب إحساس الحركة الذي تريده.',
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _OriginChip(
                  key: const Key('playground_origin_bottom'),
                  label: 'bottom',
                  value: SpringSurfaceOrigin.bottom,
                  current: origin,
                  onTap: onOrigin,
                ),
                _OriginChip(
                  key: const Key('playground_origin_center'),
                  label: 'center',
                  value: SpringSurfaceOrigin.center,
                  current: origin,
                  onTap: onOrigin,
                ),
                _OriginChip(
                  key: const Key('playground_origin_top'),
                  label: 'top',
                  value: SpringSurfaceOrigin.top,
                  current: origin,
                  onTap: onOrigin,
                ),
              ],
            ),
            const SizedBox(height: 14),
            const _SectionLabel(title: 'Local Playground Controls'),
            _SliderRow(
              label: 'button width',
              value: collapsedWidth,
              min: 180,
              max: 320,
              digits: 0,
              onChanged: onCollapsedWidth,
              infoKey: const Key('playground_info_button_width'),
              description:
                  'يتحكم في عرض الزر الأساسي قبل التمدد داخل صفحة المثال.',
            ),
            _SliderRow(
              label: 'button height',
              value: collapsedHeight,
              min: 44,
              max: 90,
              digits: 0,
              onChanged: onCollapsedHeight,
              infoKey: const Key('playground_info_button_height'),
              description:
                  'يتحكم في ارتفاع الزر الأساسي قبل التمدد داخل صفحة المثال.',
            ),
            _SectionHeader(
              title: 'placement',
              infoKey: const Key('playground_info_placement'),
              description:
                  'يحدد موضع القطعة داخل مساحة العرض في المثال: أعلى أو وسط أو أسفل.',
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _PlacementChip(
                  key: const Key('playground_placement_top'),
                  label: 'top',
                  value: _PlaygroundPlacement.top,
                  current: placement,
                  onTap: onPlacement,
                ),
                _PlacementChip(
                  key: const Key('playground_placement_center'),
                  label: 'center',
                  value: _PlaygroundPlacement.center,
                  current: placement,
                  onTap: onPlacement,
                ),
                _PlacementChip(
                  key: const Key('playground_placement_bottom'),
                  label: 'bottom',
                  value: _PlaygroundPlacement.bottom,
                  current: placement,
                  onTap: onPlacement,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 10, 0, 6),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                color: Color(0xFF4F46E5),
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(child: Divider()),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.title,
    required this.infoKey,
    required this.description,
  });

  final String title;
  final Key infoKey;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          const Expanded(child: Divider()),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
                ),
                const SizedBox(width: 6),
                _InfoButton(
                  buttonKey: infoKey,
                  title: title,
                  description: description,
                ),
              ],
            ),
          ),
          const Expanded(child: Divider()),
        ],
      ),
    );
  }
}

class _PresetChip extends StatelessWidget {
  const _PresetChip({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          color: const Color(0xFFF0F0F8),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Color(0xFF4F46E5),
          ),
        ),
      ),
    );
  }
}

class _PlacementChip extends StatelessWidget {
  const _PlacementChip({
    super.key,
    required this.label,
    required this.value,
    required this.current,
    required this.onTap,
  });

  final String label;
  final _PlaygroundPlacement value;
  final _PlaygroundPlacement current;
  final ValueChanged<_PlaygroundPlacement> onTap;

  @override
  Widget build(BuildContext context) {
    final selected = value == current;
    return GestureDetector(
      onTap: () => onTap(value),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFF4F46E5) : const Color(0xFFF0F0F8),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: selected ? Colors.white : const Color(0xFF4F46E5),
          ),
        ),
      ),
    );
  }
}

class _OriginChip extends StatelessWidget {
  const _OriginChip({
    super.key,
    required this.label,
    required this.value,
    required this.current,
    required this.onTap,
  });

  final String label;
  final SpringSurfaceOrigin value;
  final SpringSurfaceOrigin current;
  final ValueChanged<SpringSurfaceOrigin> onTap;

  @override
  Widget build(BuildContext context) {
    final selected = value == current;
    return GestureDetector(
      onTap: () => onTap(value),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFF4F46E5) : const Color(0xFFF0F0F8),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: selected ? Colors.white : const Color(0xFF4F46E5),
          ),
        ),
      ),
    );
  }
}

class _SliderRow extends StatelessWidget {
  const _SliderRow({
    required this.label,
    required this.value,
    required this.min,
    required this.max,
    required this.digits,
    required this.onChanged,
    required this.description,
    this.sliderKey,
    this.valueKey,
    this.infoKey,
    this.unit = '',
  });

  final String label;
  final double value;
  final double min;
  final double max;
  final int digits;
  final ValueChanged<double> onChanged;
  final String description;
  final Key? sliderKey;
  final Key? valueKey;
  final Key? infoKey;
  final String unit;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 128,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 11, color: Colors.grey),
                ),
              ),
              const SizedBox(width: 6),
              _InfoButton(
                buttonKey: infoKey,
                title: label,
                description: description,
              ),
            ],
          ),
        ),
        Expanded(
          child: SliderTheme(
            data: SliderTheme.of(context).copyWith(
              trackHeight: 2,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 7),
              overlayShape: const RoundSliderOverlayShape(overlayRadius: 14),
              activeTrackColor: const Color(0xFF4F46E5),
              thumbColor: const Color(0xFF4F46E5),
              inactiveTrackColor: const Color(0xFFE0E0E8),
              overlayColor: const Color(0x1A4F46E5),
            ),
            child: Slider(
              key: sliderKey,
              value: value.clamp(min, max),
              min: min,
              max: max,
              onChanged: onChanged,
            ),
          ),
        ),
        SizedBox(
          width: 52,
          child: Text(
            key: valueKey,
            '${value.toStringAsFixed(digits)}$unit',
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: Color(0xFF4F46E5),
            ),
            textAlign: TextAlign.end,
          ),
        ),
      ],
    );
  }
}

class _InfoButton extends StatelessWidget {
  const _InfoButton({
    required this.title,
    required this.description,
    this.buttonKey,
  });

  final String title;
  final String description;
  final Key? buttonKey;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      key: buttonKey,
      behavior: HitTestBehavior.opaque,
      onTap: () => _showInfoDialog(context),
      child: Container(
        width: 18,
        height: 18,
        decoration: BoxDecoration(
          color: const Color(0xFFF0F0F8),
          shape: BoxShape.circle,
          border: Border.all(color: const Color(0x334F46E5)),
        ),
        child: const Center(
          child: Text(
            'i',
            style: TextStyle(
              color: Color(0xFF4F46E5),
              fontSize: 11,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _showInfoDialog(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (context) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
            title: Text(title),
            content: Text(description),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('إغلاق'),
              ),
            ],
          ),
        );
      },
    );
  }
}
