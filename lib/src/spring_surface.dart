import 'dart:math' as math;
import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'spring_surface_config.dart';
import 'spring_surface_controller.dart';
import 'spring_surface_motion.dart';

/// The anchor point from which the surface expands.
enum SpringSurfaceOrigin { center, bottom, top }

/// Controls how the expanded surface height is resolved.
enum SpringSurfaceExpandedSizing {
  /// Use the explicit [SpringSurface.expandedSize] height.
  fixed,

  /// Measure [SpringSurface.expandedChild] and expand to its height.
  dynamicHeight,
}

/// A surface that expands and collapses with a liquid spring animation.
///
/// Declarative usage:
/// ```dart
/// SpringSurface(
///   isExpanded: _open,
///   origin: SpringSurfaceOrigin.bottom,
///   collapsedSize: const Size(200, 52),
///   expandedSize: const Size(360, 480),
///   expandedSizing: SpringSurfaceExpandedSizing.dynamicHeight,
///   collapsedChild: const Text('Open'),
///   expandedChild: MySheet(),
/// )
/// ```
///
/// Controller usage:
/// ```dart
/// SpringSurface.controlled(
///   controller: _ctrl,
///   origin: SpringSurfaceOrigin.center,
///   collapsedSize: const Size(200, 52),
///   expandedSize: const Size(360, 480),
///   expandedSizing: SpringSurfaceExpandedSizing.dynamicHeight,
///   collapsedChild: const Text('Open'),
///   expandedChild: MySheet(),
/// )
/// ```
class SpringSurface extends StatefulWidget {
  const SpringSurface({
    super.key,
    required this.isExpanded,
    required this.collapsedSize,
    required this.expandedSize,
    required this.collapsedChild,
    required this.expandedChild,
    this.origin = SpringSurfaceOrigin.bottom,
    this.config = const SpringSurfaceConfig(),
    this.expandedSizing = SpringSurfaceExpandedSizing.fixed,
    this.maxExpandedHeight,
    this.collapsedDecoration,
    this.expandedDecoration,
    this.collapsedBorderRadius = const BorderRadius.all(Radius.circular(32)),
    this.expandedBorderRadius = const BorderRadius.all(Radius.circular(20)),
    this.onExpanded,
    this.onCollapsed,
  }) : controller = null;

  const SpringSurface.controlled({
    super.key,
    required SpringSurfaceController this.controller,
    required this.collapsedSize,
    required this.expandedSize,
    required this.collapsedChild,
    required this.expandedChild,
    this.origin = SpringSurfaceOrigin.bottom,
    this.expandedSizing = SpringSurfaceExpandedSizing.fixed,
    this.maxExpandedHeight,
    this.collapsedDecoration,
    this.expandedDecoration,
    this.collapsedBorderRadius = const BorderRadius.all(Radius.circular(32)),
    this.expandedBorderRadius = const BorderRadius.all(Radius.circular(20)),
    this.onExpanded,
    this.onCollapsed,
  }) : isExpanded = null,
       config = const SpringSurfaceConfig();

  final bool? isExpanded;
  final SpringSurfaceController? controller;
  final SpringSurfaceConfig config;
  final SpringSurfaceOrigin origin;
  final SpringSurfaceExpandedSizing expandedSizing;
  final double? maxExpandedHeight;

  final Size collapsedSize;
  final Size expandedSize;
  final Widget collapsedChild;
  final Widget expandedChild;
  final BoxDecoration? collapsedDecoration;
  final BoxDecoration? expandedDecoration;
  final BorderRadius collapsedBorderRadius;
  final BorderRadius expandedBorderRadius;
  final VoidCallback? onExpanded;
  final VoidCallback? onCollapsed;

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

  SpringSurfaceConfig get _config => widget.controller?.config ?? widget.config;

  bool get _usesDynamicExpandedHeight =>
      widget.expandedSizing == SpringSurfaceExpandedSizing.dynamicHeight;

  @override
  void initState() {
    super.initState();
    assert(
      widget.collapsedSize.width > 0 && widget.collapsedSize.height > 0,
      'collapsedSize must have positive dimensions',
    );
    assert(
      widget.expandedSize.width > 0 && widget.expandedSize.height > 0,
      'expandedSize must have positive dimensions',
    );
    assert(
      widget.maxExpandedHeight == null || widget.maxExpandedHeight! > 0,
      'maxExpandedHeight must be positive when provided',
    );

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
    if (widget.isExpanded == true) {
      _rawController.value = 1.0;
      _lastIsExpanded = true;
    }
  }

  @override
  void didUpdateWidget(covariant SpringSurface oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.expandedChild != oldWidget.expandedChild ||
        widget.expandedSize.width != oldWidget.expandedSize.width ||
        widget.expandedSize.height != oldWidget.expandedSize.height ||
        widget.expandedSizing != oldWidget.expandedSizing ||
        widget.maxExpandedHeight != oldWidget.maxExpandedHeight) {
      _measuredExpandedChildHeight = null;
    }

    if (_ownedController != null && widget.config != oldWidget.config) {
      _ownedController!.config = widget.config;
    }
    if (widget.isExpanded != null && widget.isExpanded != _lastIsExpanded) {
      _lastIsExpanded = widget.isExpanded!;
      widget.isExpanded! ? _rawController.forward() : _rawController.reverse();
    }
  }

  void _onAnimationStatus(AnimationStatus status) {
    if (!mounted) {
      return;
    }
    if (status == AnimationStatus.completed) {
      widget.onExpanded?.call();
    }
    if (status == AnimationStatus.dismissed) {
      widget.onCollapsed?.call();
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
    return LayoutBuilder(
      builder: (context, constraints) {
        return Stack(
          fit: StackFit.passthrough,
          children: [
            AnimatedBuilder(
              animation: _rawController,
              builder: (context, _) => _buildSurface(context, constraints),
            ),
            if (_usesDynamicExpandedHeight) _buildExpandedChildMeasurement(),
          ],
        );
      },
    );
  }

  Widget _buildSurface(BuildContext context, BoxConstraints constraints) {
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

    final pulse = isCollapsing ? 1.0 : SpringSurfaceMotion.overshootPulse(t);

    final baseW = lerpDouble(
      widget.collapsedSize.width,
      widget.expandedSize.width,
      wProgress,
    )!;
    final baseH = lerpDouble(
      widget.collapsedSize.height,
      targetExpandedHeight,
      hProgress,
    )!;

    final currentW = baseW * (1.0 + (pulse - 1.0) * 0.45);
    final currentH = baseH * pulse;

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

    final Alignment stackAlignment;
    final AlignmentGeometry childAlignment;

    switch (widget.origin) {
      case SpringSurfaceOrigin.bottom:
        stackAlignment = Alignment.bottomCenter;
        childAlignment = Alignment.bottomCenter;
      case SpringSurfaceOrigin.top:
        stackAlignment = Alignment.topCenter;
        childAlignment = Alignment.topCenter;
      case SpringSurfaceOrigin.center:
        stackAlignment = Alignment.center;
        childAlignment = Alignment.center;
    }

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
                  child: Center(child: widget.collapsedChild),
                ),
              ),
            ],
          ),
        ),
      ),
    );

    return Align(
      alignment: stackAlignment,
      child: Align(alignment: childAlignment, child: surface),
    );
  }

  Widget _buildExpandedContent({required bool shouldScroll}) {
    if (shouldScroll) {
      return SingleChildScrollView(primary: false, child: widget.expandedChild);
    }
    if (_usesDynamicExpandedHeight) {
      return OverflowBox(
        alignment: Alignment.topCenter,
        minHeight: 0,
        maxHeight: double.infinity,
        child: widget.expandedChild,
      );
    }
    return widget.expandedChild;
  }

  Widget _buildExpandedChildMeasurement() {
    return IgnorePointer(
      child: Offstage(
        offstage: true,
        child: OverflowBox(
          alignment: Alignment.topCenter,
          minWidth: widget.expandedSize.width,
          maxWidth: widget.expandedSize.width,
          minHeight: 0,
          maxHeight: double.infinity,
          child: SizedBox(
            width: widget.expandedSize.width,
            child: _SizeReporter(
              onSizeChanged: _handleExpandedChildMeasuredSize,
              child: widget.expandedChild,
            ),
          ),
        ),
      ),
    );
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
      return widget.expandedSize.height;
    }

    final effectiveMaxHeight = _effectiveMaxExpandedHeight(
      context,
      constraints,
    );
    final fallbackHeight = math.min(
      widget.expandedSize.height,
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
