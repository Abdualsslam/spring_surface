import 'dart:math' as math;

import 'package:flutter/animation.dart';

import 'spring_surface_config.dart';

enum SpringSurfaceAxis { horizontal, vertical }

class SpringSurfaceMotion {
  const SpringSurfaceMotion._();

  static double overshootAmplitudeForClamp(double overshootClamp) {
    if (overshootClamp <= 1.0) {
      return 0.0;
    }
    return ((overshootClamp - 1.0) * 3.0).clamp(0.0, 0.18);
  }

  static double axisProgress(
    double progress, {
    required bool isCollapsing,
    required SpringSurfaceAxis axis,
    required SpringSurfaceConfig config,
  }) {
    final isHorizontal = axis == SpringSurfaceAxis.horizontal;

    final base = isCollapsing
        ? segment(
            progress,
            begin: isHorizontal ? 0.0 : 0.1,
            end: isHorizontal ? 1.0 : 0.93,
            curve: Curves.easeInOutCubic,
          )
        : segment(
            progress,
            begin: isHorizontal ? 0.10 : 0.05,
            end: isHorizontal ? 0.88 : 0.74,
            curve: Curves.easeOutCubic,
          );

    final anticipation = isCollapsing
        ? 0.0
        : _anticipationPulse(
            segment(
              progress,
              begin: 0.0,
              end: isHorizontal ? 0.16 : 0.18,
              curve: Curves.easeOutCubic,
            ),
            amplitude: _anticipationAmplitude(axis: axis, config: config),
          );

    final stretchProgress = isCollapsing
        ? segment(
            1 - progress,
            begin: 0.10,
            end: 0.52,
            curve: Curves.easeOutCubic,
          )
        : segment(progress, begin: 0.52, end: 0.90, curve: Curves.easeOutCubic);

    final stretch = _liquidStretchPulse(
      stretchProgress,
      isHorizontal: isHorizontal,
      isCollapsing: isCollapsing,
      config: config,
    );

    return (base + anticipation + stretch).clamp(
      isCollapsing ? 0.0 : -0.05,
      config.overshootClamp,
    );
  }

  static double overshootPulse(
    double progress, {
    double pulseStart = 0.55,
    double amplitude = 0.09,
  }) {
    final t = segment(
      progress,
      begin: pulseStart,
      end: 1.0,
      curve: Curves.easeOutCubic,
    );
    if (t <= 0) {
      return 1.0;
    }
    final main = math.sin(t * math.pi) * amplitude;
    final settleT = segment(
      t,
      begin: 0.58,
      end: 1.0,
      curve: Curves.easeOutCubic,
    );
    final settle = math.sin(settleT * math.pi) * amplitude * 0.18;
    return 1.0 + main - settle;
  }

  static double axisReboundScale(
    double progress, {
    required SpringSurfaceAxis axis,
    required bool isCollapsing,
    required SpringSurfaceConfig config,
  }) {
    if (config.reboundProfile == SpringSurfaceReboundProfile.simultaneous) {
      if (isCollapsing) {
        return 1.0;
      }

      final pulse = overshootPulse(
        progress,
        amplitude: overshootAmplitudeForClamp(config.overshootClamp),
      );

      if (axis == SpringSurfaceAxis.horizontal) {
        return 1.0 + (pulse - 1.0) * 0.45;
      }

      return pulse;
    }

    final motionProgress = isCollapsing ? 1.0 - progress : progress;
    final primaryAxis = isCollapsing
        ? SpringSurfaceAxis.horizontal
        : SpringSurfaceAxis.vertical;
    final firstPhase = segment(
      motionProgress,
      begin: 0.56,
      end: 0.78,
      curve: Curves.easeInOutCubic,
    );
    final secondPhase = segment(
      motionProgress,
      begin: 0.74,
      end: 0.98,
      curve: Curves.easeInOutCubic,
    );
    final activeAxisScale = _phaseReboundMultiplier(
      axis == primaryAxis ? firstPhase : secondPhase,
      amplitude: _activeReboundAmplitude(axis: axis, config: config),
    );
    final counterAxisScale = _counterCompressionMultiplier(
      axis == primaryAxis ? secondPhase : firstPhase,
      amplitude: _counterCompressionAmplitude(axis: axis, config: config),
    );

    return (activeAxisScale * counterAxisScale).clamp(0.88, 1.12);
  }

  static double bottomEdgeProgress(
    double progress, {
    required bool isCollapsing,
  }) {
    final base = isCollapsing
        ? segment(progress, begin: 0.04, end: 1.0, curve: Curves.easeInOutCubic)
        : segment(
            progress,
            begin: 0.08,
            end: 0.90,
            curve: Curves.easeInOutCubic,
          );

    final pulseProgress = isCollapsing
        ? segment(
            1 - progress,
            begin: 0.08,
            end: 0.42,
            curve: Curves.easeOutCubic,
          )
        : segment(progress, begin: 0.68, end: 1.0, curve: Curves.easeOutCubic);

    return (base +
            _dampedPulse(
              pulseProgress,
              amplitude: isCollapsing ? 0.004 : 0.010,
            ))
        .clamp(0.0, 1.02);
  }

  static double radiusProgress(double progress, {required bool isCollapsing}) {
    final base = segment(
      progress,
      begin: isCollapsing ? 0.18 : 0.24,
      end: isCollapsing ? 1.0 : 0.96,
      curve: Curves.easeInOutCubic,
    );

    final pulseProgress = isCollapsing
        ? segment(
            1 - progress,
            begin: 0.12,
            end: 0.42,
            curve: Curves.easeOutCubic,
          )
        : segment(progress, begin: 0.62, end: 0.94, curve: Curves.easeOutCubic);

    return (base +
            _dampedPulse(
              pulseProgress,
              amplitude: isCollapsing ? 0.006 : 0.018,
            ))
        .clamp(0.0, 1.03);
  }

  static double surfaceProgress(double progress, {required bool isCollapsing}) {
    return segment(
      progress,
      begin: isCollapsing ? 0.06 : 0.08,
      end: isCollapsing ? 0.92 : 0.78,
      curve: Curves.easeInOutCubic,
    );
  }

  static double ctaOpacity(double progress) {
    return 1.0 -
        segment(progress, begin: 0.05, end: 0.28, curve: Curves.easeOutCubic);
  }

  static double contentOpacity(double progress, {required bool isCollapsing}) {
    return isCollapsing
        ? segment(progress, begin: 0.68, end: 0.95, curve: Curves.easeOutCubic)
        : segment(progress, begin: 0.48, end: 0.84, curve: Curves.easeOutCubic);
  }

  static double segment(
    double value, {
    required double begin,
    required double end,
    required Curve curve,
  }) {
    if (value <= begin) {
      return 0.0;
    }
    if (value >= end) {
      return 1.0;
    }
    return curve.transform((value - begin) / (end - begin));
  }

  static double _liquidStretchPulse(
    double progress, {
    required bool isHorizontal,
    required bool isCollapsing,
    required SpringSurfaceConfig config,
  }) {
    if (progress <= 0 || progress >= 1) {
      return 0.0;
    }

    final envelope = math.pow(1 - progress, 1.35).toDouble();
    final main = math.sin(progress * math.pi) * envelope;
    final recoil =
        math.sin(progress * math.pi * 2.0) *
        math.pow(1 - progress, 2.1).toDouble();
    final hAmp = config.horizontalStretchAmplitude;
    final vAmp = config.verticalStretchAmplitude;

    if (isCollapsing) {
      return isHorizontal
          ? (main * hAmp) + (recoil * hAmp * 0.21)
          : -(main * vAmp) - (recoil * vAmp * 0.15);
    }

    return isHorizontal
        ? -(main * hAmp) - (recoil * hAmp * 0.21)
        : (main * vAmp) + (recoil * vAmp * 0.15);
  }

  static double _anticipationAmplitude({
    required SpringSurfaceAxis axis,
    required SpringSurfaceConfig config,
  }) {
    if (axis == SpringSurfaceAxis.horizontal) {
      return math.min(config.horizontalStretchAmplitude * 0.45, 0.016);
    }
    return math.min(config.verticalStretchAmplitude * 0.28, 0.02);
  }

  static double _anticipationPulse(
    double progress, {
    required double amplitude,
  }) {
    if (progress <= 0 || progress >= 1 || amplitude <= 0) {
      return 0.0;
    }
    final envelope = math.pow(1 - progress, 1.4).toDouble();
    return -math.sin(progress * math.pi) * envelope * amplitude;
  }

  static double _dampedPulse(double progress, {required double amplitude}) {
    if (progress <= 0 || progress >= 1) {
      return 0.0;
    }
    final envelope = math.pow(1 - progress, 1.6).toDouble();
    return math.sin(progress * math.pi) * envelope * amplitude;
  }

  static double _activeReboundAmplitude({
    required SpringSurfaceAxis axis,
    required SpringSurfaceConfig config,
  }) {
    final overshoot = overshootAmplitudeForClamp(config.overshootClamp);
    if (axis == SpringSurfaceAxis.horizontal) {
      return math.min(overshoot * 0.34, 0.045);
    }
    return math.min(overshoot * 0.60, 0.072);
  }

  static double _counterCompressionAmplitude({
    required SpringSurfaceAxis axis,
    required SpringSurfaceConfig config,
  }) {
    final activeAmplitude = _activeReboundAmplitude(axis: axis, config: config);
    if (axis == SpringSurfaceAxis.horizontal) {
      return math.min(activeAmplitude * 0.30, 0.014);
    }
    return math.min(activeAmplitude * 0.26, 0.018);
  }

  static double _phaseReboundMultiplier(
    double progress, {
    required double amplitude,
  }) {
    if (progress <= 0 || progress >= 1 || amplitude <= 0) {
      return 1.0;
    }
    final envelope = math.pow(1.0 - (progress * 0.35), 1.1).toDouble();
    return 1.0 + (math.sin(progress * math.pi) * amplitude * envelope);
  }

  static double _counterCompressionMultiplier(
    double progress, {
    required double amplitude,
  }) {
    if (progress <= 0 || progress >= 1 || amplitude <= 0) {
      return 1.0;
    }
    final envelope = math.pow(1.0 - (progress * 0.28), 1.2).toDouble();
    return 1.0 - (math.sin(progress * math.pi) * amplitude * envelope);
  }
}
