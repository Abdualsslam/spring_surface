import 'package:flutter/animation.dart';
import 'package:flutter/foundation.dart';

import 'spring_surface_config.dart';

/// Controller-based API for [SpringSurface].
///
/// Mount it in a [State] that mixes in [TickerProviderStateMixin], then pass
/// it to [SpringSurface.controller].  Dispose it in [State.dispose].
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
  })  : _config = config,
        _animationController = AnimationController(
          vsync: vsync,
          duration: config.expandDuration,
          reverseDuration: config.collapseDuration,
        ) {
    _animationController.addListener(notifyListeners);
  }

  SpringSurfaceConfig _config;
  final AnimationController _animationController;

  /// The current config. Changing this live re-configures the animation
  /// durations immediately.
  SpringSurfaceConfig get config => _config;
  set config(SpringSurfaceConfig value) {
    if (_config == value) return;
    _config = value;
    _animationController.duration = value.expandDuration;
    _animationController.reverseDuration = value.collapseDuration;
    notifyListeners();
  }

  /// Raw [0..1] animation value — useful for driving other animations.
  double get value => _animationController.value;

  /// Whether the surface is currently expanding or is fully expanded.
  bool get isExpanded => _animationController.value > 0;

  /// Whether an animation is currently running.
  bool get isAnimating => _animationController.isAnimating;

  // ─── internal ──────────────────────────────────────────────────────────────

  /// The underlying [AnimationController] — exposed only for [SpringSurface]
  /// to wire up its [AnimatedBuilder].
  AnimationController get rawController => _animationController;

  // ─── public control ────────────────────────────────────────────────────────

  /// Animate to the expanded state.
  Future<void> expand() => _animationController.forward();

  /// Animate to the collapsed state.
  Future<void> collapse() => _animationController.reverse();

  /// Toggle between expanded and collapsed.
  Future<void> toggle() =>
      isExpanded ? collapse() : expand();

  /// Jump to a specific progress value without animation.
  void jumpTo(double value) => _animationController.value = value;

  @override
  void dispose() {
    _animationController
      ..removeListener(notifyListeners)
      ..dispose();
    super.dispose();
  }
}
