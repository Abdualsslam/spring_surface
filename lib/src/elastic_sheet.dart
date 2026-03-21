import 'dart:math' as math;
import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'elastic_sheet_actions.dart';
import 'elastic_sheet_config.dart';
import 'elastic_sheet_controller.dart';
import 'elastic_sheet_motion.dart';

/// Legacy vertical-only anchor for expansion.
///
/// Prefer [SpringSurfaceAnchor] for new code.
enum SpringSurfaceOrigin { center, bottom, top }

/// A 9-point anchor for fixed-size expansion.
///
/// For `dynamicHeight`, the horizontal component is collapsed to the center
/// column so the surface keeps the current vertical-only behavior.
enum SpringSurfaceAnchor {
  topLeft,
  topCenter,
  topRight,
  centerLeft,
  center,
  centerRight,
  bottomLeft,
  bottomCenter,
  bottomRight,
}

/// Controls how the expanded surface height is resolved.
enum SpringSurfaceExpandedSizing {
  /// Use the explicit [SpringSurface.expandedSize] height.
  fixed,

  /// Measure [SpringSurface.expandedChild] and expand to its height.
  dynamicHeight,
}

/// Describes whether the surface currently has expandable content.
enum SpringSurfaceContentState {
  /// The surface has expanded content and can open normally.
  ready,

  /// The collapsed surface is interactive but has no expanded content yet.
  pending,

  /// The surface is visible but not interactive.
  unavailable,
}

/// A surface that expands and collapses with a liquid spring animation.
///
/// Declarative usage:
/// ```dart
/// SpringSurface(
///   isExpanded: _open,
///   anchor: SpringSurfaceAnchor.bottomCenter,
///   collapsedSize: const Size(200, 52),
///   expandedSize: const Size(360, 480),
///   expandedSizing: SpringSurfaceExpandedSizing.dynamicHeight,
///   collapsedChild: const Text('Open'),
///   expandedChild: MySheet(),
/// )
/// ```
///
/// Pending usage:
/// ```dart
/// SpringSurface(
///   isExpanded: false,
///   contentState: SpringSurfaceContentState.pending,
///   collapsedSize: const Size(200, 52),
///   collapsedChild: const Text('Waiting for data'),
///   onPendingTap: _refreshData,
/// )
/// ```
///
/// Controller usage:
/// ```dart
/// SpringSurface.controlled(
///   controller: _ctrl,
///   anchor: SpringSurfaceAnchor.center,
///   collapsedSize: const Size(200, 52),
///   expandedSize: const Size(360, 480),
///   expandedSizing: SpringSurfaceExpandedSizing.dynamicHeight,
///   collapsedChild: Builder(
///     builder: (context) => IconButton(
///       onPressed: () => SpringSurfaceActions.of(context).expand(),
///       icon: const Icon(Icons.add_rounded),
///     ),
///   ),
///   expandedChild: MySheet(),
/// )
/// ```
class SpringSurface extends StatefulWidget {
  const SpringSurface({
    super.key,
    required this.isExpanded,
    required this.collapsedSize,
    this.expandedSize,
    required this.collapsedChild,
    this.expandedChild,
    this.anchor,
    this.origin = SpringSurfaceOrigin.bottom,
    this.config = const SpringSurfaceConfig(),
    this.contentState = SpringSurfaceContentState.ready,
    this.expandedSizing = SpringSurfaceExpandedSizing.fixed,
    this.maxExpandedHeight,
    this.collapsedDecoration,
    this.expandedDecoration,
    this.collapsedBorderRadius = const BorderRadius.all(Radius.circular(32)),
    this.expandedBorderRadius = const BorderRadius.all(Radius.circular(20)),
    this.onExpanded,
    this.onCollapsed,
    this.onPendingTap,
  }) : controller = null;

  const SpringSurface.controlled({
    super.key,
    required SpringSurfaceController this.controller,
    required this.collapsedSize,
    this.expandedSize,
    required this.collapsedChild,
    this.expandedChild,
    this.anchor,
    this.origin = SpringSurfaceOrigin.bottom,
    this.contentState = SpringSurfaceContentState.ready,
    this.expandedSizing = SpringSurfaceExpandedSizing.fixed,
    this.maxExpandedHeight,
    this.collapsedDecoration,
    this.expandedDecoration,
    this.collapsedBorderRadius = const BorderRadius.all(Radius.circular(32)),
    this.expandedBorderRadius = const BorderRadius.all(Radius.circular(20)),
    this.onExpanded,
    this.onCollapsed,
    this.onPendingTap,
  }) : isExpanded = null,
       config = const SpringSurfaceConfig();

  final bool? isExpanded;
  final SpringSurfaceController? controller;
  final SpringSurfaceConfig config;

  /// Preferred 9-point growth anchor.
  final SpringSurfaceAnchor? anchor;

  /// Legacy vertical-only expansion shortcut.
  ///
  /// When both [anchor] and [origin] are provided, [anchor] wins.
  final SpringSurfaceOrigin origin;

  /// Whether the surface currently has expandable data.
  final SpringSurfaceContentState contentState;
  final SpringSurfaceExpandedSizing expandedSizing;
  final double? maxExpandedHeight;

  final Size collapsedSize;
  final Size? expandedSize;
  final Widget collapsedChild;
  final Widget? expandedChild;
  final BoxDecoration? collapsedDecoration;
  final BoxDecoration? expandedDecoration;
  final BorderRadius collapsedBorderRadius;
  final BorderRadius expandedBorderRadius;
  final VoidCallback? onExpanded;
  final VoidCallback? onCollapsed;
  final VoidCallback? onPendingTap;

  @override
  State<SpringSurface> createState() => _SpringSurfaceState();
}

class _SpringSurfaceState extends State<SpringSurface>
    with SingleTickerProviderStateMixin {
  static const double _defaultMaxExpandedHeightFactor = 0.8;
  static const double _sizeChangeEpsilon = 0.5;

  late AnimationController _rawController;
  SpringSurfaceController? _ownedController;
  bool _lastIsExpanded = false;
  double? _measuredExpandedChildHeight;

  SpringSurfaceController get _effectiveController =>
      widget.controller ?? _ownedController!;

  SpringSurfaceConfig get _config => widget.controller?.config ?? widget.config;
  SpringSurfaceContentState get _contentState => widget.contentState;
  bool get _isReady => _contentState == SpringSurfaceContentState.ready;
  bool get _isPending => _contentState == SpringSurfaceContentState.pending;
  bool get _isUnavailable =>
      _contentState == SpringSurfaceContentState.unavailable;
  bool get _isPulsing => _effectiveController.isPulsing;

  bool get _usesDynamicExpandedHeight =>
      _isReady &&
      widget.expandedSizing == SpringSurfaceExpandedSizing.dynamicHeight;

  SpringSurfaceAnchor get _configuredAnchor =>
      widget.anchor ?? _anchorFromOrigin(widget.origin);

  SpringSurfaceAnchor get _resolvedAnchor => _usesDynamicExpandedHeight
      ? _normalizeAnchorForDynamicHeight(_configuredAnchor)
      : _configuredAnchor;

  Size get _effectiveExpandedSize =>
      widget.expandedSize ?? widget.collapsedSize;

  Widget get _effectiveExpandedChild =>
      widget.expandedChild ?? const SizedBox.shrink();

  Widget get _scopedCollapsedChild =>
      _wrapWithActionsScope(widget.collapsedChild);

  Widget get _scopedExpandedChild =>
      _wrapWithActionsScope(_effectiveExpandedChild);

  @override
  void initState() {
    super.initState();
    assert(_debugValidateInputs());

    if (widget.controller != null) {
      _rawController = widget.controller!.rawController;
    } else {
      _ownedController = SpringSurfaceController(
        vsync: this,
        config: widget.config,
      );
      _rawController = _ownedController!.rawController;
    }

    _rawController.addStatusListener(_onAnimationStatus);
    if (_isReady && widget.isExpanded == true) {
      _rawController.value = 1.0;
      _lastIsExpanded = true;
    }
  }

  @override
  void didUpdateWidget(covariant SpringSurface oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.contentState != oldWidget.contentState ||
        widget.expandedSize != oldWidget.expandedSize ||
        widget.expandedSizing != oldWidget.expandedSizing ||
        widget.maxExpandedHeight != oldWidget.maxExpandedHeight) {
      _measuredExpandedChildHeight = null;
    }

    if (_ownedController != null && widget.config != oldWidget.config) {
      _ownedController!.config = widget.config;
    }

    if (!_isReady) {
      _lastIsExpanded = false;
      if (!_isPulsing && _rawController.value != 0.0) {
        _rawController.value = 0.0;
      }
      return;
    }

    if (widget.isExpanded != null && widget.isExpanded != _lastIsExpanded) {
      _lastIsExpanded = widget.isExpanded!;
      widget.isExpanded! ? _rawController.forward() : _rawController.reverse();
    }
  }

  void _onAnimationStatus(AnimationStatus status) {
    if (!mounted || !_isReady || _isPulsing) {
      return;
    }
    if (status == AnimationStatus.completed) {
      widget.onExpanded?.call();
    }
    if (status == AnimationStatus.dismissed) {
      widget.onCollapsed?.call();
    }
  }

  Future<void> _handlePendingTap() async {
    if (!_isPending || _isPulsing) {
      return;
    }
    await _effectiveController.pulse();
    if (mounted) {
      widget.onPendingTap?.call();
    }
  }

  @override
  void dispose() {
    _rawController.removeStatusListener(_onAnimationStatus);
    _ownedController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget child = LayoutBuilder(
      builder: (context, constraints) {
        return Stack(
          fit: StackFit.passthrough,
          children: [
            AnimatedBuilder(
              animation: _rawController,
              builder: (context, _) {
                if (_isPulsing || !_isReady) {
                  return _buildCollapsedOnlySurface(context);
                }
                return _buildReadySurface(context, constraints);
              },
            ),
            if (_usesDynamicExpandedHeight && !_isPulsing)
              _buildExpandedChildMeasurement(),
          ],
        );
      },
    );

    if (_isPending) {
      child = GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: _handlePendingTap,
        child: child,
      );
    } else if (_isUnavailable) {
      child = IgnorePointer(ignoring: true, child: child);
    }

    return Semantics(button: true, enabled: !_isUnavailable, child: child);
  }

  Widget _buildReadySurface(BuildContext context, BoxConstraints constraints) {
    final t = _rawController.value;
    final isCollapsing = _rawController.status == AnimationStatus.reverse;
    final cfg = _config;
    final targetExpandedHeight = _resolvedExpandedHeight(context, constraints);
    final shouldScrollExpandedContent = _shouldScrollExpandedContent(
      context,
      constraints,
    );

    final wProgress = SpringSurfaceMotion.axisProgress(
      t,
      isCollapsing: isCollapsing,
      axis: SpringSurfaceAxis.horizontal,
      config: cfg,
    );
    final hProgress = SpringSurfaceMotion.axisProgress(
      t,
      isCollapsing: isCollapsing,
      axis: SpringSurfaceAxis.vertical,
      config: cfg,
    );

    final baseW = lerpDouble(
      widget.collapsedSize.width,
      _effectiveExpandedSize.width,
      wProgress,
    )!;
    final baseH = lerpDouble(
      widget.collapsedSize.height,
      targetExpandedHeight,
      hProgress,
    )!;
    final currentW =
        baseW *
        SpringSurfaceMotion.axisReboundScale(
          t,
          axis: SpringSurfaceAxis.horizontal,
          isCollapsing: isCollapsing,
          config: cfg,
        );
    final currentH =
        baseH *
        SpringSurfaceMotion.axisReboundScale(
          t,
          axis: SpringSurfaceAxis.vertical,
          isCollapsing: isCollapsing,
          config: cfg,
        );

    final rProgress = SpringSurfaceMotion.radiusProgress(
      t,
      isCollapsing: isCollapsing,
    );
    final currentRadius = BorderRadius.lerp(
      widget.collapsedBorderRadius,
      widget.expandedBorderRadius,
      rProgress,
    )!;

    final theme = Theme.of(context);
    final defaultCollapsed = BoxDecoration(
      color: theme.colorScheme.primary,
      borderRadius: currentRadius,
    );
    final defaultExpanded = BoxDecoration(
      color: theme.colorScheme.surface,
      borderRadius: currentRadius,
    );
    final surfP = SpringSurfaceMotion.surfaceProgress(
      t,
      isCollapsing: isCollapsing,
    );
    final decoration = BoxDecoration.lerp(
      (widget.collapsedDecoration ?? defaultCollapsed).copyWith(
        borderRadius: currentRadius,
      ),
      (widget.expandedDecoration ?? defaultExpanded).copyWith(
        borderRadius: currentRadius,
      ),
      surfP,
    )!;

    final collapsedOpacity =
        1.0 -
        SpringSurfaceMotion.segment(
          t,
          begin: 0.05,
          end: 0.28,
          curve: Curves.easeOutCubic,
        );
    final expandedOpacity = isCollapsing
        ? SpringSurfaceMotion.segment(
            t,
            begin: 0.68,
            end: 0.95,
            curve: Curves.easeOutCubic,
          )
        : SpringSurfaceMotion.segment(
            t,
            begin: 0.48,
            end: 0.84,
            curve: Curves.easeOutCubic,
          );
    final contentOffset = (1 - expandedOpacity) * (isCollapsing ? 12.0 : 18.0);

    final surface = SizedBox(
      width: currentW,
      height: currentH,
      child: ClipRRect(
        borderRadius: currentRadius,
        child: DecoratedBox(
          decoration: decoration,
          child: Stack(
            fit: StackFit.expand,
            children: [
              IgnorePointer(
                ignoring: expandedOpacity < 0.01,
                child: Opacity(
                  opacity: expandedOpacity.clamp(0.0, 1.0),
                  child: Transform.translate(
                    offset: Offset(0, contentOffset),
                    child: _buildExpandedContent(
                      shouldScroll: shouldScrollExpandedContent,
                    ),
                  ),
                ),
              ),
              IgnorePointer(
                ignoring: collapsedOpacity < 0.01,
                child: Opacity(
                  opacity: collapsedOpacity.clamp(0.0, 1.0),
                  child: Center(child: _scopedCollapsedChild),
                ),
              ),
            ],
          ),
        ),
      ),
    );

    return Align(
      alignment: _alignmentForAnchor(_resolvedAnchor),
      child: surface,
    );
  }

  Widget _buildCollapsedOnlySurface(BuildContext context) {
    final pulseProgress = _isPulsing
        ? math.sin(_rawController.value * math.pi).clamp(0.0, 1.0)
        : 0.0;
    final currentRadius = BorderRadius.lerp(
      widget.collapsedBorderRadius,
      widget.expandedBorderRadius,
      pulseProgress * 0.18,
    )!;
    final width = widget.collapsedSize.width * (1.0 + (pulseProgress * 0.035));
    final height =
        widget.collapsedSize.height * (1.0 + (pulseProgress * 0.045));

    final surface = SizedBox(
      width: width,
      height: height,
      child: ClipRRect(
        borderRadius: currentRadius,
        child: DecoratedBox(
          decoration: _buildCollapsedOnlyDecoration(
            context: context,
            currentRadius: currentRadius,
            pulseProgress: pulseProgress,
          ),
          child: Opacity(
            opacity: _isUnavailable ? 0.6 : 1.0,
            child: Center(child: _scopedCollapsedChild),
          ),
        ),
      ),
    );

    return Align(
      alignment: _alignmentForAnchor(_resolvedAnchor),
      child: surface,
    );
  }

  bool _debugValidateInputs() {
    assert(
      widget.collapsedSize.width > 0 && widget.collapsedSize.height > 0,
      'collapsedSize must have positive dimensions',
    );
    assert(
      widget.expandedSize == null ||
          (widget.expandedSize!.width > 0 && widget.expandedSize!.height > 0),
      'expandedSize must have positive dimensions when provided',
    );
    assert(
      !_isReady || widget.expandedSize != null,
      'expandedSize is required when contentState is ready',
    );
    assert(
      !_isReady || widget.expandedChild != null,
      'expandedChild is required when contentState is ready',
    );
    assert(
      widget.maxExpandedHeight == null || widget.maxExpandedHeight! > 0,
      'maxExpandedHeight must be positive when provided',
    );
    return true;
  }

  BoxDecoration _buildCollapsedOnlyDecoration({
    required BuildContext context,
    required BorderRadius currentRadius,
    required double pulseProgress,
  }) {
    final theme = Theme.of(context);
    final baseDecoration =
        widget.collapsedDecoration ??
        BoxDecoration(
          color: theme.colorScheme.primary,
          borderRadius: currentRadius,
        );

    if (_isUnavailable) {
      return baseDecoration.copyWith(borderRadius: currentRadius);
    }

    if (!_isPending) {
      return baseDecoration.copyWith(borderRadius: currentRadius);
    }

    final primary = theme.colorScheme.primary;
    final pendingDecoration = baseDecoration.copyWith(
      borderRadius: currentRadius,
      border: Border.all(color: primary.withAlpha(34)),
      boxShadow: [
        ...?baseDecoration.boxShadow,
        BoxShadow(
          color: primary.withAlpha((18 + (pulseProgress * 18)).round()),
          blurRadius: 14 + (pulseProgress * 6),
          offset: const Offset(0, 8),
        ),
      ],
    );

    return BoxDecoration.lerp(
      baseDecoration.copyWith(borderRadius: currentRadius),
      pendingDecoration,
      1.0,
    )!;
  }

  Widget _buildExpandedContent({required bool shouldScroll}) {
    if (shouldScroll) {
      return SingleChildScrollView(primary: false, child: _scopedExpandedChild);
    }
    if (_usesDynamicExpandedHeight) {
      return OverflowBox(
        alignment: Alignment.topCenter,
        minHeight: 0,
        maxHeight: double.infinity,
        child: _scopedExpandedChild,
      );
    }
    return _scopedExpandedChild;
  }

  Widget _buildExpandedChildMeasurement() {
    return IgnorePointer(
      child: Offstage(
        offstage: true,
        child: OverflowBox(
          alignment: Alignment.topCenter,
          minWidth: _effectiveExpandedSize.width,
          maxWidth: _effectiveExpandedSize.width,
          minHeight: 0,
          maxHeight: double.infinity,
          child: SizedBox(
            width: _effectiveExpandedSize.width,
            child: _SizeReporter(
              onSizeChanged: _handleExpandedChildMeasuredSize,
              child: _scopedExpandedChild,
            ),
          ),
        ),
      ),
    );
  }

  Widget _wrapWithActionsScope(Widget child) {
    final controller = widget.controller;
    if (controller == null) {
      return child;
    }
    return SpringSurfaceActions(controller: controller, child: child);
  }

  void _handleExpandedChildMeasuredSize(Size size) {
    if (!mounted || size.height <= 0) {
      return;
    }
    final oldHeight = _measuredExpandedChildHeight;
    if (oldHeight != null &&
        (size.height - oldHeight).abs() < _sizeChangeEpsilon) {
      return;
    }
    setState(() {
      _measuredExpandedChildHeight = size.height;
    });
  }

  double _resolvedExpandedHeight(
    BuildContext context,
    BoxConstraints constraints,
  ) {
    if (!_usesDynamicExpandedHeight) {
      return _effectiveExpandedSize.height;
    }

    final effectiveMaxHeight = _effectiveMaxExpandedHeight(
      context,
      constraints,
    );
    final fallbackHeight = math.min(
      _effectiveExpandedSize.height,
      effectiveMaxHeight,
    );
    final measuredHeight = _measuredExpandedChildHeight ?? fallbackHeight;
    return math.min(measuredHeight, effectiveMaxHeight);
  }

  double _effectiveMaxExpandedHeight(
    BuildContext context,
    BoxConstraints constraints,
  ) {
    final configuredMaxHeight =
        widget.maxExpandedHeight ??
        (MediaQuery.sizeOf(context).height * _defaultMaxExpandedHeightFactor);
    if (!constraints.hasBoundedHeight) {
      return configuredMaxHeight;
    }
    return math.min(configuredMaxHeight, constraints.maxHeight);
  }

  bool _shouldScrollExpandedContent(
    BuildContext context,
    BoxConstraints constraints,
  ) {
    if (!_usesDynamicExpandedHeight || _measuredExpandedChildHeight == null) {
      return false;
    }
    return _measuredExpandedChildHeight! >
        _effectiveMaxExpandedHeight(context, constraints) + _sizeChangeEpsilon;
  }

  SpringSurfaceAnchor _anchorFromOrigin(SpringSurfaceOrigin origin) {
    switch (origin) {
      case SpringSurfaceOrigin.top:
        return SpringSurfaceAnchor.topCenter;
      case SpringSurfaceOrigin.center:
        return SpringSurfaceAnchor.center;
      case SpringSurfaceOrigin.bottom:
        return SpringSurfaceAnchor.bottomCenter;
    }
  }

  SpringSurfaceAnchor _normalizeAnchorForDynamicHeight(
    SpringSurfaceAnchor anchor,
  ) {
    switch (anchor) {
      case SpringSurfaceAnchor.topLeft:
      case SpringSurfaceAnchor.topCenter:
      case SpringSurfaceAnchor.topRight:
        return SpringSurfaceAnchor.topCenter;
      case SpringSurfaceAnchor.centerLeft:
      case SpringSurfaceAnchor.center:
      case SpringSurfaceAnchor.centerRight:
        return SpringSurfaceAnchor.center;
      case SpringSurfaceAnchor.bottomLeft:
      case SpringSurfaceAnchor.bottomCenter:
      case SpringSurfaceAnchor.bottomRight:
        return SpringSurfaceAnchor.bottomCenter;
    }
  }

  Alignment _alignmentForAnchor(SpringSurfaceAnchor anchor) {
    switch (anchor) {
      case SpringSurfaceAnchor.topLeft:
        return Alignment.topLeft;
      case SpringSurfaceAnchor.topCenter:
        return Alignment.topCenter;
      case SpringSurfaceAnchor.topRight:
        return Alignment.topRight;
      case SpringSurfaceAnchor.centerLeft:
        return Alignment.centerLeft;
      case SpringSurfaceAnchor.center:
        return Alignment.center;
      case SpringSurfaceAnchor.centerRight:
        return Alignment.centerRight;
      case SpringSurfaceAnchor.bottomLeft:
        return Alignment.bottomLeft;
      case SpringSurfaceAnchor.bottomCenter:
        return Alignment.bottomCenter;
      case SpringSurfaceAnchor.bottomRight:
        return Alignment.bottomRight;
    }
  }
}

class _SizeReporter extends SingleChildRenderObjectWidget {
  const _SizeReporter({required this.onSizeChanged, required super.child});

  final ValueChanged<Size> onSizeChanged;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return _RenderSizeReporter(onSizeChanged);
  }

  @override
  void updateRenderObject(
    BuildContext context,
    covariant _RenderSizeReporter renderObject,
  ) {
    renderObject.onSizeChanged = onSizeChanged;
  }
}

class _RenderSizeReporter extends RenderProxyBox {
  _RenderSizeReporter(this.onSizeChanged);

  Size? _oldSize;
  ValueChanged<Size> onSizeChanged;

  @override
  void performLayout() {
    super.performLayout();
    final newSize = child?.size;
    if (newSize == null || _oldSize == newSize) {
      return;
    }
    _oldSize = newSize;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      onSizeChanged(newSize);
    });
  }
}
