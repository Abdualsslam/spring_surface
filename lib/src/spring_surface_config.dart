/// All parameters that control the liquid spring animation.
///
/// Use the named constructors for sensible presets, or fine-tune
/// every value yourself.
class SpringSurfaceConfig {
  /// Controls how fast the spring pulls toward the target.
  /// Higher = snappier.  Range: 50–500.  Default: 220.
  final double stiffness;

  /// Controls how quickly oscillation dies out.
  /// Lower = more bouncy.  Range: 5–40.  Default: 18.
  final double damping;

  /// Virtual mass on the spring.
  /// Higher = heavier feel, slower peak velocity.  Default: 1.0.
  final double mass;

  /// Maximum allowed overshoot as a fraction of the target size.
  /// 1.03 = 3% past target.  Set to 1.0 to disable overshoot.
  final double overshootClamp;

  /// Amplitude of the liquid stretch pulse on the horizontal axis.
  /// Default: 0.028.
  final double horizontalStretchAmplitude;

  /// Amplitude of the liquid stretch pulse on the vertical axis.
  /// Default: 0.065.
  final double verticalStretchAmplitude;

  /// Duration of the expand animation.
  final Duration expandDuration;

  /// Duration of the collapse animation.
  final Duration collapseDuration;

  const SpringSurfaceConfig({
    this.stiffness = 220,
    this.damping = 18,
    this.mass = 1.0,
    this.overshootClamp = 1.03,
    this.horizontalStretchAmplitude = 0.028,
    this.verticalStretchAmplitude = 0.065,
    this.expandDuration = const Duration(milliseconds: 600),
    this.collapseDuration = const Duration(milliseconds: 600),
  });

  /// Gentle — subtle overshoot, soft feel.
  const SpringSurfaceConfig.gentle()
      : stiffness = 160,
        damping = 22,
        mass = 1.0,
        overshootClamp = 1.02,
        horizontalStretchAmplitude = 0.018,
        verticalStretchAmplitude = 0.040,
        expandDuration = const Duration(milliseconds: 700),
        collapseDuration = const Duration(milliseconds: 600);

  /// Bouncy — exaggerated overshoot, playful feel.
  const SpringSurfaceConfig.bouncy()
      : stiffness = 280,
        damping = 12,
        mass = 1.2,
        overshootClamp = 1.08,
        horizontalStretchAmplitude = 0.040,
        verticalStretchAmplitude = 0.090,
        expandDuration = const Duration(milliseconds: 550),
        collapseDuration = const Duration(milliseconds: 500);

  /// Snappy — fast, minimal overshoot, utilitarian.
  const SpringSurfaceConfig.snappy()
      : stiffness = 380,
        damping = 28,
        mass = 0.8,
        overshootClamp = 1.01,
        horizontalStretchAmplitude = 0.010,
        verticalStretchAmplitude = 0.025,
        expandDuration = const Duration(milliseconds: 400),
        collapseDuration = const Duration(milliseconds: 380);

  SpringSurfaceConfig copyWith({
    double? stiffness,
    double? damping,
    double? mass,
    double? overshootClamp,
    double? horizontalStretchAmplitude,
    double? verticalStretchAmplitude,
    Duration? expandDuration,
    Duration? collapseDuration,
  }) {
    return SpringSurfaceConfig(
      stiffness: stiffness ?? this.stiffness,
      damping: damping ?? this.damping,
      mass: mass ?? this.mass,
      overshootClamp: overshootClamp ?? this.overshootClamp,
      horizontalStretchAmplitude:
          horizontalStretchAmplitude ?? this.horizontalStretchAmplitude,
      verticalStretchAmplitude:
          verticalStretchAmplitude ?? this.verticalStretchAmplitude,
      expandDuration: expandDuration ?? this.expandDuration,
      collapseDuration: collapseDuration ?? this.collapseDuration,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SpringSurfaceConfig &&
          stiffness == other.stiffness &&
          damping == other.damping &&
          mass == other.mass &&
          overshootClamp == other.overshootClamp &&
          horizontalStretchAmplitude == other.horizontalStretchAmplitude &&
          verticalStretchAmplitude == other.verticalStretchAmplitude &&
          expandDuration == other.expandDuration &&
          collapseDuration == other.collapseDuration;

  @override
  int get hashCode => Object.hash(
        stiffness,
        damping,
        mass,
        overshootClamp,
        horizontalStretchAmplitude,
        verticalStretchAmplitude,
        expandDuration,
        collapseDuration,
      );
}
