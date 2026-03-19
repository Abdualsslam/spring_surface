import 'dart:ui' show lerpDouble;
import 'package:flutter/material.dart';
import 'spring_surface_config.dart';
import 'spring_surface_motion.dart';
import 'spring_surface.dart' show SpringSurfaceOrigin;
import 'spring_surface_test_lab_page.dart';

class SpringSurfacePlayground extends StatefulWidget {
  const SpringSurfacePlayground({super.key});

  @override
  State<SpringSurfacePlayground> createState() =>
      _SpringSurfacePlaygroundState();
}

class _SpringSurfacePlaygroundState extends State<SpringSurfacePlayground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  bool _isCollapsing = false;

  // ── sliders ────────────────────────────────────────────────────────────────
  double _stiffness = 220;
  double _damping = 18;
  double _mass = 1.0;
  double _vStretch = 0.065;
  double _hStretch = 0.028;
  int _durationMs = 600;
  SpringSurfaceOrigin _origin = SpringSurfaceOrigin.bottom;

  // pulse = التضخم المطاطي قبل الاستقرار
  double _pulseAmplitude = 0.09; // 0 = معطل، 0.20 = 20% أكبر من الهدف
  double _pulseStart = 0.55; // متى يبدأ (من 0.0 إلى 1.0)

  SpringSurfaceConfig get _config => SpringSurfaceConfig(
    stiffness: _stiffness,
    damping: _damping,
    mass: _mass,
    overshootClamp: 1.0,
    verticalStretchAmplitude: _vStretch,
    horizontalStretchAmplitude: _hStretch,
  );

  // ── geometry ───────────────────────────────────────────────────────────────
  static const Size _collapsed = Size(240, 54);
  static const Size _expanded = Size(320, 440);
  static const double _collapsedRadius = 32;
  static const double _expandedRadius = 20;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: _durationMs),
      reverseDuration: Duration(milliseconds: _durationMs),
    );
    _controller.addStatusListener((_) => setState(() {}));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggle() {
    setState(() => _isCollapsing = _controller.value > 0);
    _controller.value > 0 ? _controller.reverse() : _controller.forward();
  }

  void _setDuration(int ms) {
    setState(() => _durationMs = ms);
    _controller.duration = Duration(milliseconds: ms);
    _controller.reverseDuration = Duration(milliseconds: ms);
  }

  // ── presets ────────────────────────────────────────────────────────────────
  static const _presets = <String, Map<String, dynamic>>{
    'gentle': {
      'stiffness': 160.0,
      'damping': 22.0,
      'mass': 1.0,
      'vStretch': 0.040,
      'hStretch': 0.018,
      'pulseAmplitude': 0.05,
      'pulseStart': 0.58,
      'duration': 700,
    },
    'default': {
      'stiffness': 220.0,
      'damping': 18.0,
      'mass': 1.0,
      'vStretch': 0.065,
      'hStretch': 0.028,
      'pulseAmplitude': 0.09,
      'pulseStart': 0.55,
      'duration': 600,
    },
    'bouncy': {
      'stiffness': 280.0,
      'damping': 12.0,
      'mass': 1.2,
      'vStretch': 0.090,
      'hStretch': 0.040,
      'pulseAmplitude': 0.16,
      'pulseStart': 0.50,
      'duration': 550,
    },
    'snappy': {
      'stiffness': 380.0,
      'damping': 28.0,
      'mass': 0.8,
      'vStretch': 0.025,
      'hStretch': 0.010,
      'pulseAmplitude': 0.03,
      'pulseStart': 0.62,
      'duration': 400,
    },
  };

  void _applyPreset(Map<String, dynamic> p) {
    final durationMs = p['duration'] as int;
    setState(() {
      _stiffness = p['stiffness'];
      _damping = p['damping'];
      _mass = p['mass'];
      _vStretch = p['vStretch'];
      _hStretch = p['hStretch'];
      _pulseAmplitude = p['pulseAmplitude'];
      _pulseStart = p['pulseStart'];
      _durationMs = durationMs;
      _controller.duration = Duration(milliseconds: durationMs);
      _controller.reverseDuration = Duration(milliseconds: durationMs);
    });
  }

  // ── build ──────────────────────────────────────────────────────────────────
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
                child: AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) => _buildSurface(),
                ),
              ),
            ),
            _ControlsPanel(
              stiffness: _stiffness,
              damping: _damping,
              mass: _mass,
              vStretch: _vStretch,
              hStretch: _hStretch,
              durationMs: _durationMs,
              origin: _origin,
              pulseAmplitude: _pulseAmplitude,
              pulseStart: _pulseStart,
              presets: _presets,
              onStiffness: (v) => setState(() => _stiffness = v),
              onDamping: (v) => setState(() => _damping = v),
              onMass: (v) => setState(() => _mass = v),
              onVStretch: (v) => setState(() => _vStretch = v),
              onHStretch: (v) => setState(() => _hStretch = v),
              onDuration: _setDuration,
              onOrigin: (v) => setState(() => _origin = v),
              onPulseAmplitude: (v) => setState(() => _pulseAmplitude = v),
              onPulseStart: (v) => setState(() => _pulseStart = v),
              onPreset: _applyPreset,
              onToggle: _toggle,
            ),
          ],
        ),
      ),
    );
  }

  // ── surface builder ────────────────────────────────────────────────────────
  Widget _buildSurface() {
    final t = _controller.value;
    final cfg = _config;

    final wP = SpringSurfaceMotion.axisProgress(
      t,
      isCollapsing: _isCollapsing,
      axis: SpringSurfaceAxis.horizontal,
      config: cfg,
    );
    final hP = SpringSurfaceMotion.axisProgress(
      t,
      isCollapsing: _isCollapsing,
      axis: SpringSurfaceAxis.vertical,
      config: cfg,
    );
    final rP = SpringSurfaceMotion.radiusProgress(
      t,
      isCollapsing: _isCollapsing,
    );

    // ── pulse: التضخم المطاطي ──────────────────────────────────────────────
    // sin(t*π): يبدأ من 0، يصل للذروة في المنتصف، يرجع لـ 0 — مضمون
    // يعمل فقط عند الفتح
    final pulse = _isCollapsing
        ? 1.0
        : SpringSurfaceMotion.overshootPulse(
            t,
            pulseStart: _pulseStart,
            amplitude: _pulseAmplitude,
          );

    // الحجم الأساسي + الـ pulse يضرب فيه
    final baseW = _collapsed.width + (_expanded.width - _collapsed.width) * wP;
    final baseH =
        _collapsed.height + (_expanded.height - _collapsed.height) * hP;

    final w = baseW * (1.0 + (pulse - 1.0) * 0.45); // أفقي أقل تضخماً
    final h = baseH * pulse; // عمودي التضخم الكامل

    final r = lerpDouble(
      _collapsedRadius,
      _expandedRadius,
      rP,
    )!.clamp(_expandedRadius.toDouble(), _collapsedRadius.toDouble());

    final ctaOp = SpringSurfaceMotion.ctaOpacity(t);
    final contentOp = SpringSurfaceMotion.contentOpacity(
      t,
      isCollapsing: _isCollapsing,
    );
    final contentOffset = (1 - contentOp) * (_isCollapsing ? 12.0 : 18.0);
    final surfP = SpringSurfaceMotion.surfaceProgress(
      t,
      isCollapsing: _isCollapsing,
    );
    final color = Color.lerp(const Color(0xFF4F46E5), Colors.white, surfP)!;

    // حساب الـ alignment بناءً على الـ origin
    final Alignment originAlignment;
    switch (_origin) {
      case SpringSurfaceOrigin.bottom:
        originAlignment = Alignment.bottomCenter;
      case SpringSurfaceOrigin.top:
        originAlignment = Alignment.topCenter;
      case SpringSurfaceOrigin.center:
        originAlignment = Alignment.center;
    }

    return Align(
      alignment: originAlignment,
      child: SizedBox(
        width: w,
        height: h,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(r),
          child: ColoredBox(
            color: color,
            child: Stack(
              fit: StackFit.expand,
              children: [
                IgnorePointer(
                  ignoring: contentOp < 0.01,
                  child: Opacity(
                    opacity: contentOp.clamp(0.0, 1.0),
                    child: Transform.translate(
                      offset: Offset(0, contentOffset),
                      child: const _ExpandedContent(),
                    ),
                  ),
                ),
                IgnorePointer(
                  ignoring: ctaOp < 0.01,
                  child: Opacity(
                    opacity: ctaOp.clamp(0.0, 1.0),
                    child: const Center(
                      child: Text(
                        'تنفيذ الطلب',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ── expanded content ───────────────────────────────────────────────────────────
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
        ],
      ),
    );
  }

  Widget _placeholder(double h) => Container(
    height: h,
    decoration: BoxDecoration(
      color: Colors.grey.shade100,
      borderRadius: BorderRadius.circular(12),
    ),
  );
}

// ── controls panel ─────────────────────────────────────────────────────────────
class _ControlsPanel extends StatelessWidget {
  const _ControlsPanel({
    required this.stiffness,
    required this.damping,
    required this.mass,
    required this.vStretch,
    required this.hStretch,
    required this.durationMs,
    required this.origin,
    required this.onOrigin,
    required this.pulseAmplitude,
    required this.pulseStart,
    required this.presets,
    required this.onStiffness,
    required this.onDamping,
    required this.onMass,
    required this.onVStretch,
    required this.onHStretch,
    required this.onDuration,
    required this.onPulseAmplitude,
    required this.onPulseStart,
    required this.onPreset,
    required this.onToggle,
  });

  final double stiffness, damping, mass, vStretch, hStretch;
  final double pulseAmplitude, pulseStart;
  final int durationMs;
  final SpringSurfaceOrigin origin;
  final Map<String, Map<String, dynamic>> presets;
  final ValueChanged<double> onStiffness,
      onDamping,
      onMass,
      onVStretch,
      onHStretch,
      onPulseAmplitude,
      onPulseStart;
  final ValueChanged<SpringSurfaceOrigin> onOrigin;
  final ValueChanged<int> onDuration;
  final ValueChanged<Map<String, dynamic>> onPreset;
  final VoidCallback onToggle;

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
          // presets
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: presets.entries
                .map(
                  (e) => GestureDetector(
                    onTap: () => onPreset(e.value),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 7,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF0F0F8),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        e.key,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF4F46E5),
                        ),
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 8),

          _Slider(
            label: 'stiffness',
            value: stiffness,
            min: 50,
            max: 500,
            digits: 0,
            onChanged: onStiffness,
          ),
          _Slider(
            label: 'damping',
            value: damping,
            min: 5,
            max: 40,
            digits: 1,
            onChanged: onDamping,
          ),
          _Slider(
            label: 'mass',
            value: mass,
            min: 0.5,
            max: 3.0,
            digits: 2,
            onChanged: onMass,
          ),
          _Slider(
            label: 'v-stretch',
            value: vStretch,
            min: 0,
            max: 0.15,
            digits: 3,
            onChanged: onVStretch,
          ),
          _Slider(
            label: 'h-stretch',
            value: hStretch,
            min: 0,
            max: 0.08,
            digits: 3,
            onChanged: onHStretch,
          ),
          _Slider(
            label: 'duration',
            value: durationMs.toDouble(),
            min: 200,
            max: 1000,
            digits: 0,
            onChanged: (v) => onDuration(v.round()),
            unit: 'ms',
          ),

          // origin chips
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Row(
              children: [
                const Expanded(child: Divider()),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    'origin — نقطة البداية',
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
                label: 'bottom ↑',
                value: SpringSurfaceOrigin.bottom,
                current: origin,
                onTap: onOrigin,
              ),
              _OriginChip(
                label: 'center ↔',
                value: SpringSurfaceOrigin.center,
                current: origin,
                onTap: onOrigin,
              ),
              _OriginChip(
                label: 'top ↓',
                value: SpringSurfaceOrigin.top,
                current: origin,
                onTap: onOrigin,
              ),
            ],
          ),
          const SizedBox(height: 4),

          // divider
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Row(
              children: [
                const Expanded(child: Divider()),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    'pulse — التضخم المطاطي',
                    style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
                  ),
                ),
                const Expanded(child: Divider()),
              ],
            ),
          ),

          _Slider(
            label: 'amplitude',
            value: pulseAmplitude,
            min: 0,
            max: 0.30,
            digits: 2,
            onChanged: onPulseAmplitude,
          ),
          _Slider(
            label: 'start',
            value: pulseStart,
            min: 0.40,
            max: 0.90,
            digits: 2,
            onChanged: onPulseStart,
          ),

          const SizedBox(height: 10),
          GestureDetector(
            onTap: onToggle,
            child: Container(
              width: double.infinity,
              height: 52,
              decoration: BoxDecoration(
                color: const Color(0xFF4F46E5),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Center(
                child: Text(
                  'toggle  ↕',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
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

class _Slider extends StatelessWidget {
  const _Slider({
    required this.label,
    required this.value,
    required this.min,
    required this.max,
    required this.digits,
    required this.onChanged,
    this.unit = '',
  });

  final String label;
  final double value, min, max;
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
