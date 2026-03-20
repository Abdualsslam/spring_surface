import 'package:flutter/material.dart';
import 'package:spring_surface/spring_surface.dart';

import 'spring_surface_test_lab_page.dart';

class SpringSurfacePlayground extends StatefulWidget {
  const SpringSurfacePlayground({super.key});

  @override
  State<SpringSurfacePlayground> createState() =>
      _SpringSurfacePlaygroundState();
}

class _SpringSurfacePlaygroundState extends State<SpringSurfacePlayground> {
  static const Size _collapsedSize = Size(240, 54);
  static const Size _expandedSize = Size(320, 350);

  bool _isExpanded = false;
  double _stiffness = 220;
  double _damping = 18;
  double _mass = 1.0;
  double _verticalStretch = 0.065;
  double _horizontalStretch = 0.028;
  int _expandDurationMs = 600;
  int _collapseDurationMs = 600;
  SpringSurfaceOrigin _origin = SpringSurfaceOrigin.bottom;

  SpringSurfaceConfig get _config => SpringSurfaceConfig(
    stiffness: _stiffness,
    damping: _damping,
    mass: _mass,
    overshootClamp: 1.03,
    horizontalStretchAmplitude: _horizontalStretch,
    verticalStretchAmplitude: _verticalStretch,
    expandDuration: Duration(milliseconds: _expandDurationMs),
    collapseDuration: Duration(milliseconds: _collapseDurationMs),
  );

  void _toggle() => setState(() => _isExpanded = !_isExpanded);

  void _applyPreset(SpringSurfaceConfig config) {
    setState(() {
      _stiffness = config.stiffness;
      _damping = config.damping;
      _mass = config.mass;
      _horizontalStretch = config.horizontalStretchAmplitude;
      _verticalStretch = config.verticalStretchAmplitude;
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
              child: Center(
                child: GestureDetector(
                  key: const Key('playground_surface_toggle'),
                  behavior: HitTestBehavior.opaque,
                  onTap: _toggle,
                  child: SpringSurface(
                    isExpanded: _isExpanded,
                    origin: _origin,
                    config: _config,
                    expandedSizing: SpringSurfaceExpandedSizing.dynamicHeight,
                    collapsedSize: _collapsedSize,
                    expandedSize: _expandedSize,
                    maxExpandedHeight: 420,
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
                        'بيانات الطلب',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    expandedChild: const _ExpandedContent(),
                  ),
                ),
              ),
            ),
            _ControlsPanel(
              stiffness: _stiffness,
              damping: _damping,
              mass: _mass,
              verticalStretch: _verticalStretch,
              horizontalStretch: _horizontalStretch,
              expandDurationMs: _expandDurationMs,
              collapseDurationMs: _collapseDurationMs,
              origin: _origin,
              onStiffness: (value) => setState(() => _stiffness = value),
              onDamping: (value) => setState(() => _damping = value),
              onMass: (value) => setState(() => _mass = value),
              onVerticalStretch: (value) =>
                  setState(() => _verticalStretch = value),
              onHorizontalStretch: (value) =>
                  setState(() => _horizontalStretch = value),
              onExpandDuration: (value) =>
                  setState(() => _expandDurationMs = value),
              onCollapseDuration: (value) =>
                  setState(() => _collapseDurationMs = value),
              onOrigin: (value) => setState(() => _origin = value),
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
          const SizedBox(height: 20),
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
    required this.stiffness,
    required this.damping,
    required this.mass,
    required this.verticalStretch,
    required this.horizontalStretch,
    required this.expandDurationMs,
    required this.collapseDurationMs,
    required this.origin,
    required this.onStiffness,
    required this.onDamping,
    required this.onMass,
    required this.onVerticalStretch,
    required this.onHorizontalStretch,
    required this.onExpandDuration,
    required this.onCollapseDuration,
    required this.onOrigin,
    required this.onPreset,
  });

  final double stiffness;
  final double damping;
  final double mass;
  final double verticalStretch;
  final double horizontalStretch;
  final int expandDurationMs;
  final int collapseDurationMs;
  final SpringSurfaceOrigin origin;
  final ValueChanged<double> onStiffness;
  final ValueChanged<double> onDamping;
  final ValueChanged<double> onMass;
  final ValueChanged<double> onVerticalStretch;
  final ValueChanged<double> onHorizontalStretch;
  final ValueChanged<int> onExpandDuration;
  final ValueChanged<int> onCollapseDuration;
  final ValueChanged<SpringSurfaceOrigin> onOrigin;
  final ValueChanged<SpringSurfaceConfig> onPreset;

  @override
  Widget build(BuildContext context) {
    return Container(
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
          _SliderRow(
            label: 'stiffness',
            value: stiffness,
            min: 50,
            max: 500,
            digits: 0,
            onChanged: onStiffness,
          ),
          _SliderRow(
            label: 'damping',
            value: damping,
            min: 5,
            max: 40,
            digits: 1,
            onChanged: onDamping,
          ),
          _SliderRow(
            label: 'mass',
            value: mass,
            min: 0.5,
            max: 3.0,
            digits: 2,
            onChanged: onMass,
          ),
          _SliderRow(
            label: 'v-stretch',
            value: verticalStretch,
            min: 0,
            max: 0.15,
            digits: 3,
            onChanged: onVerticalStretch,
          ),
          _SliderRow(
            label: 'h-stretch',
            value: horizontalStretch,
            min: 0,
            max: 0.08,
            digits: 3,
            onChanged: onHorizontalStretch,
          ),
          _SliderRow(
            label: 'expand',
            value: expandDurationMs.toDouble(),
            min: 200,
            max: 1000,
            digits: 0,
            unit: 'ms',
            onChanged: (value) => onExpandDuration(value.round()),
          ),
          _SliderRow(
            label: 'collapse',
            value: collapseDurationMs.toDouble(),
            min: 200,
            max: 1000,
            digits: 0,
            unit: 'ms',
            onChanged: (value) => onCollapseDuration(value.round()),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Row(
              children: [
                const Expanded(child: Divider()),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    'origin',
                    style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
                  ),
                ),
                const Expanded(child: Divider()),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _OriginChip(
                label: 'bottom',
                value: SpringSurfaceOrigin.bottom,
                current: origin,
                onTap: onOrigin,
              ),
              _OriginChip(
                label: 'center',
                value: SpringSurfaceOrigin.center,
                current: origin,
                onTap: onOrigin,
              ),
              _OriginChip(
                label: 'top',
                value: SpringSurfaceOrigin.top,
                current: origin,
                onTap: onOrigin,
              ),
            ],
          ),
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

class _OriginChip extends StatelessWidget {
  const _OriginChip({
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
    this.unit = '',
  });

  final String label;
  final double value;
  final double min;
  final double max;
  final int digits;
  final ValueChanged<double> onChanged;
  final String unit;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 76,
          child: Text(
            label,
            style: const TextStyle(fontSize: 11, color: Colors.grey),
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
