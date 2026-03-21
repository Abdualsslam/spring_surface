import 'package:flutter/material.dart';
import 'package:elastic_sheet/elastic_sheet.dart';

import '../../spring_surface_unified_showcase_page.dart';
import 'playground_controls_panel.dart';
import 'playground_models.dart';
import 'playground_surface_preview.dart';

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
  SpringSurfaceReboundProfile _reboundProfile =
      SpringSurfaceReboundProfile.simultaneous;
  SpringSurfaceAnchor _anchor = SpringSurfaceAnchor.bottomCenter;
  PlaygroundPlacement _placement = PlaygroundPlacement.center;

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

  double _collapsedLeftOffsetInHost() {
    switch (_anchor) {
      case SpringSurfaceAnchor.topLeft:
      case SpringSurfaceAnchor.centerLeft:
      case SpringSurfaceAnchor.bottomLeft:
        return 0;
      case SpringSurfaceAnchor.topCenter:
      case SpringSurfaceAnchor.center:
      case SpringSurfaceAnchor.bottomCenter:
        return (_surfaceHostWidth - _collapsedWidth) / 2;
      case SpringSurfaceAnchor.topRight:
      case SpringSurfaceAnchor.centerRight:
      case SpringSurfaceAnchor.bottomRight:
        return _surfaceHostWidth - _collapsedWidth;
    }
  }

  double _collapsedTopOffsetInHost() {
    switch (_anchor) {
      case SpringSurfaceAnchor.topLeft:
      case SpringSurfaceAnchor.topCenter:
      case SpringSurfaceAnchor.topRight:
        return 0;
      case SpringSurfaceAnchor.centerLeft:
      case SpringSurfaceAnchor.center:
      case SpringSurfaceAnchor.centerRight:
        return (_surfaceHostHeight - _collapsedHeight) / 2;
      case SpringSurfaceAnchor.bottomLeft:
      case SpringSurfaceAnchor.bottomCenter:
      case SpringSurfaceAnchor.bottomRight:
        return _surfaceHostHeight - _collapsedHeight;
    }
  }

  double _desiredCollapsedLeft(double availableWidth) {
    return (availableWidth - _collapsedWidth) / 2;
  }

  double _desiredCollapsedTop(double availableHeight) {
    switch (_placement) {
      case PlaygroundPlacement.top:
        return 0;
      case PlaygroundPlacement.center:
        return (availableHeight - _collapsedHeight) / 2;
      case PlaygroundPlacement.bottom:
        return availableHeight - _collapsedHeight;
    }
  }

  double _surfaceHostTop(double availableHeight) {
    return _desiredCollapsedTop(availableHeight) - _collapsedTopOffsetInHost();
  }

  double _surfaceHostLeft(double availableWidth) {
    return _desiredCollapsedLeft(availableWidth) - _collapsedLeftOffsetInHost();
  }

  SpringSurfaceConfig get _config => SpringSurfaceConfig(
    overshootClamp: _overshootClamp,
    horizontalStretchAmplitude: _defaultHorizontalStretch,
    verticalStretchAmplitude: _defaultVerticalStretch,
    expandDuration: Duration(milliseconds: _expandDurationMs),
    collapseDuration: Duration(milliseconds: _collapseDurationMs),
    reboundProfile: _reboundProfile,
  );

  void _toggle() => setState(() => _isExpanded = !_isExpanded);

  void _applyPreset(SpringSurfaceConfig config) {
    setState(() {
      _overshootClamp = config.overshootClamp;
      _expandDurationMs = config.expandDuration.inMilliseconds;
      _collapseDurationMs = config.collapseDuration.inMilliseconds;
      _reboundProfile = config.reboundProfile;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEDEDF2),
      appBar: AppBar(
        backgroundColor: const Color(0xFFEDEDF2),
        surfaceTintColor: Colors.transparent,
        title: const Text('Elastic Sheet Playground'),
        actions: [
          IconButton(
            key: const Key('playground_open_unified_showcase'),
            tooltip: 'Unified showcase',
            onPressed: () {
              Navigator.of(
                context,
              ).pushNamed(SpringSurfaceUnifiedShowcasePage.routeName);
            },
            icon: const Icon(Icons.dashboard_customize_outlined),
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
                  bottom: _placement == PlaygroundPlacement.bottom
                      ? _bottomGap
                      : 0,
                ),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final hostLeft = _surfaceHostLeft(constraints.maxWidth);
                    final hostTop = _surfaceHostTop(constraints.maxHeight);

                    return PlaygroundSurfacePreview(
                      isExpanded: _isExpanded,
                      anchor: _anchor,
                      config: _config,
                      collapsedSize: _collapsedSize,
                      expandedSize: _expandedSize,
                      surfaceHostWidth: _surfaceHostWidth,
                      surfaceHostHeight: _surfaceHostHeight,
                      hostLeft: hostLeft,
                      hostTop: hostTop,
                      onToggle: _toggle,
                    );
                  },
                ),
              ),
            ),
            PlaygroundControlsPanel(
              collapsedWidth: _collapsedWidth,
              collapsedHeight: _collapsedHeight,
              expandedWidth: _expandedWidth,
              expandedHeight: _expandedHeight,
              overshootClamp: _overshootClamp,
              expandDurationMs: _expandDurationMs,
              collapseDurationMs: _collapseDurationMs,
              reboundProfile: _reboundProfile,
              anchor: _anchor,
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
              onReboundProfile: (value) =>
                  setState(() => _reboundProfile = value),
              onAnchor: (value) => setState(() => _anchor = value),
              onPlacement: (value) => setState(() => _placement = value),
              onPreset: _applyPreset,
            ),
          ],
        ),
      ),
    );
  }
}
