import 'dart:math' as math;

import 'package:flutter/animation.dart';
import 'package:flutter/foundation.dart';

import 'elastic_sheet_config.dart';

/// Controller-based API for [SpringSurface].
///
/// Mount it in a [State] that mixes in [TickerProviderStateMixin], then pass
/// it to [SpringSurface.controller]. Dispose it in [State.dispose].
///
/// ```dart
/// late final SpringSurfaceController _controller;
///
/// @override
/// void initState() {
///   super.initState();
///   _controller = SpringSurfaceController(vsync: this);
/// }
///
/// @override
/// void dispose() {
///   _controller.dispose();
///   super.dispose();
/// }
/// ```
class SpringSurfaceController extends ChangeNotifier {
  SpringSurfaceController({
    required TickerProvider vsync,
    SpringSurfaceConfig config = const SpringSurfaceConfig(),
  }) : _config = config,
       _animationController = AnimationController(
         vsync: vsync,
         duration: config.expandDuration,
         reverseDuration: config.collapseDuration,
       ) {
    _animationController.addListener(notifyListeners);
  }

  SpringSurfaceConfig _config;
  final AnimationController _animationController;
  bool _isPulsing = false;

  /// The current config. Changing this live re-configures the animation
  /// durations immediately.
  SpringSurfaceConfig get config => _config;
  set config(SpringSurfaceConfig value) {
    if (_config == value) {
      return;
    }
    _config = value;
    _animationController.duration = value.expandDuration;
    _animationController.reverseDuration = value.collapseDuration;
    notifyListeners();
  }

  /// Raw [0..1] animation value - useful for driving other animations.
  double get value => _animationController.value;

  /// Whether the surface is currently expanding or is fully expanded.
  bool get isExpanded => !_isPulsing && _animationController.value > 0;

  /// Whether a collapsed hint pulse is currently running.
  bool get isPulsing => _isPulsing;

  /// Whether an animation is currently running.
  bool get isAnimating => _animationController.isAnimating;

  /// The underlying [AnimationController] - exposed only for [SpringSurface]
  /// to wire up its [AnimatedBuilder].
  AnimationController get rawController => _animationController;

  /// Animate to the expanded state.
  Future<void> expand() async {
    _cancelPulseIfNeeded();
    return _animationController.forward();
  }

  /// Animate to the collapsed state.
  Future<void> collapse() async {
    _cancelPulseIfNeeded();
    return _animationController.reverse();
  }

  /// Toggle between expanded and collapsed.
  Future<void> toggle() => isExpanded ? collapse() : expand();

  /// Play a short pulse while keeping the surface logically collapsed.
  Future<void> pulse() async {
    final previousDuration = _animationController.duration;
    final previousReverseDuration = _animationController.reverseDuration;

    _animationController.stop();
    _animationController.value = 0.0;
    _isPulsing = true;
    notifyListeners();

    final pulseDuration = _pulseDuration;
    _animationController.duration = pulseDuration;
    _animationController.reverseDuration = pulseDuration;

    try {
      await _animationController.animateTo(
        1.0,
        duration: pulseDuration,
        curve: Curves.easeOutCubic,
      );
    } finally {
      _animationController.duration = previousDuration;
      _animationController.reverseDuration = previousReverseDuration;
      _animationController.value = 0.0;
      _isPulsing = false;
      notifyListeners();
    }
  }

  /// Jump to a specific progress value without animation.
  void jumpTo(double value) {
    _cancelPulseIfNeeded();
    _animationController.value = value;
  }

  Duration get _pulseDuration {
    final expandMs = (_config.expandDuration.inMilliseconds * 0.35).round();
    final collapseMs = (_config.collapseDuration.inMilliseconds * 0.35).round();
    final clampedMs = math.min(expandMs, collapseMs).clamp(90, 180);
    return Duration(milliseconds: clampedMs);
  }

  void _cancelPulseIfNeeded() {
    if (!_isPulsing) {
      return;
    }
    _animationController.stop();
    _animationController.value = 0.0;
    _isPulsing = false;
    notifyListeners();
  }

  @override
  void dispose() {
    _animationController
      ..removeListener(notifyListeners)
      ..dispose();
    super.dispose();
  }
}
