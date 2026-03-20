import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:spring_surface/spring_surface.dart';

const Key _hostKey = Key('host');
const Size _collapsedSize = Size(100, 40);
const Size _expandedSize = Size(220, 260);
const SpringSurfaceConfig _fastConfig = SpringSurfaceConfig(
  expandDuration: Duration(milliseconds: 40),
  collapseDuration: Duration(milliseconds: 40),
);

void main() {
  test('overshootClamp increases the visible overshoot amplitude mapping', () {
    expect(SpringSurfaceMotion.overshootAmplitudeForClamp(1.0), 0.0);
    expect(
      SpringSurfaceMotion.overshootAmplitudeForClamp(1.12),
      greaterThan(SpringSurfaceMotion.overshootAmplitudeForClamp(1.03)),
    );
  });

  test('axisProgress adds a subtle anticipation before expansion', () {
    const config = SpringSurfaceConfig();

    expect(
      SpringSurfaceMotion.axisProgress(
        0.05,
        isCollapsing: false,
        axis: SpringSurfaceAxis.horizontal,
        config: config,
      ),
      lessThan(0.0),
    );
    expect(
      SpringSurfaceMotion.axisProgress(
        0.05,
        isCollapsing: false,
        axis: SpringSurfaceAxis.vertical,
        config: config,
      ),
      lessThan(0.0),
    );
    expect(
      SpringSurfaceMotion.axisProgress(
        0.24,
        isCollapsing: false,
        axis: SpringSurfaceAxis.vertical,
        config: config,
      ),
      greaterThan(0.0),
    );
  });

  test('overshootPulse settles back toward rest near the end', () {
    final mid = SpringSurfaceMotion.overshootPulse(0.78);
    final late = SpringSurfaceMotion.overshootPulse(0.95);

    expect(mid, greaterThan(1.0));
    expect(late, greaterThanOrEqualTo(1.0));
    expect(late, lessThan(mid));
    expect(SpringSurfaceMotion.overshootPulse(1.0), 1.0);
  });

  testWidgets('fixed sizing keeps the explicit expandedSize', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      _buildHarness(
        SpringSurface(
          isExpanded: true,
          collapsedSize: _collapsedSize,
          expandedSize: _expandedSize,
          collapsedChild: const Text('Open'),
          expandedChild: _buildShortExpandedChild(),
        ),
      ),
    );

    expect(_surfaceSize(tester).width, closeTo(_expandedSize.width, 0.01));
    expect(_surfaceSize(tester).height, closeTo(_expandedSize.height, 0.01));
    expect(find.byType(SingleChildScrollView), findsNothing);
  });

  testWidgets(
    'dynamicHeight uses fallback first then measured content height',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        _buildHarness(
          SpringSurface(
            isExpanded: true,
            collapsedSize: _collapsedSize,
            expandedSize: _expandedSize,
            expandedSizing: SpringSurfaceExpandedSizing.dynamicHeight,
            collapsedChild: const Text('Open'),
            expandedChild: _buildShortExpandedChild(),
          ),
        ),
      );

      expect(tester.takeException(), isNull);
      expect(_surfaceSize(tester).width, closeTo(_expandedSize.width, 0.01));
      expect(_surfaceSize(tester).height, closeTo(_expandedSize.height, 0.01));

      await tester.pump();

      expect(_surfaceSize(tester).width, closeTo(_expandedSize.width, 0.01));
      expect(_surfaceSize(tester).height, closeTo(120, 0.01));
      expect(find.byType(SingleChildScrollView), findsNothing);
    },
  );

  testWidgets('dynamicHeight caps height and enables scroll', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      _buildHarness(
        SpringSurface(
          isExpanded: true,
          collapsedSize: _collapsedSize,
          expandedSize: _expandedSize,
          expandedSizing: SpringSurfaceExpandedSizing.dynamicHeight,
          maxExpandedHeight: 180,
          collapsedChild: const Text('Open'),
          expandedChild: _buildTallExpandedChild(),
        ),
      ),
    );

    await tester.pump();

    expect(_surfaceSize(tester).width, closeTo(_expandedSize.width, 0.01));
    expect(_surfaceSize(tester).height, closeTo(180, 0.01));
    expect(find.byType(SingleChildScrollView), findsOneWidget);
  });

  testWidgets('fixed sizing keeps the selected corner pinned while expanding', (
    WidgetTester tester,
  ) async {
    final anchors = <SpringSurfaceAnchor>[
      SpringSurfaceAnchor.topLeft,
      SpringSurfaceAnchor.topRight,
      SpringSurfaceAnchor.bottomLeft,
      SpringSurfaceAnchor.bottomRight,
    ];

    for (final anchor in anchors) {
      await tester.pumpWidget(
        _buildHarness(
          _buildSurface(isExpanded: false, anchor: anchor, config: _fastConfig),
        ),
      );

      final hostRect = _hostRect(tester);
      _expectPinnedCorner(anchor, _surfaceRect(tester), hostRect);

      await tester.pumpWidget(
        _buildHarness(
          _buildSurface(isExpanded: true, anchor: anchor, config: _fastConfig),
        ),
      );
      await tester.pumpAndSettle();

      _expectPinnedCorner(anchor, _surfaceRect(tester), hostRect);
    }
  });

  testWidgets('legacy origin still controls dynamic vertical alignment', (
    WidgetTester tester,
  ) async {
    final cases = <SpringSurfaceOrigin, double>{
      SpringSurfaceOrigin.top: 0,
      SpringSurfaceOrigin.center: 90,
      SpringSurfaceOrigin.bottom: 180,
    };

    for (final entry in cases.entries) {
      await tester.pumpWidget(
        _buildHarness(
          SpringSurface(
            isExpanded: true,
            collapsedSize: _collapsedSize,
            expandedSize: _expandedSize,
            expandedSizing: SpringSurfaceExpandedSizing.dynamicHeight,
            origin: entry.key,
            collapsedChild: const Text('Open'),
            expandedChild: _buildShortExpandedChild(),
          ),
        ),
      );

      await tester.pump();

      expect(_surfaceTopOffset(tester), closeTo(entry.value, 0.01));
    }
  });

  testWidgets('anchor overrides origin when both are provided', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      _buildHarness(
        SpringSurface(
          isExpanded: true,
          anchor: SpringSurfaceAnchor.topLeft,
          origin: SpringSurfaceOrigin.bottom,
          collapsedSize: _collapsedSize,
          expandedSize: _expandedSize,
          collapsedChild: const Text('Open'),
          expandedChild: _buildShortExpandedChild(),
        ),
      ),
    );

    final hostRect = _hostRect(tester);
    final surfaceRect = _surfaceRect(tester);

    expect(surfaceRect.left, closeTo(hostRect.left, 0.01));
    expect(surfaceRect.top, closeTo(hostRect.top, 0.01));
  });

  testWidgets('dynamicHeight ignores the horizontal anchor component', (
    WidgetTester tester,
  ) async {
    final cases = <SpringSurfaceAnchor, double>{
      SpringSurfaceAnchor.topLeft: 0,
      SpringSurfaceAnchor.topCenter: 0,
      SpringSurfaceAnchor.topRight: 0,
      SpringSurfaceAnchor.centerLeft: 90,
      SpringSurfaceAnchor.center: 90,
      SpringSurfaceAnchor.centerRight: 90,
      SpringSurfaceAnchor.bottomLeft: 180,
      SpringSurfaceAnchor.bottomCenter: 180,
      SpringSurfaceAnchor.bottomRight: 180,
    };

    for (final entry in cases.entries) {
      await tester.pumpWidget(
        _buildHarness(
          SpringSurface(
            isExpanded: true,
            anchor: entry.key,
            collapsedSize: _collapsedSize,
            expandedSize: _expandedSize,
            expandedSizing: SpringSurfaceExpandedSizing.dynamicHeight,
            collapsedChild: const Text('Open'),
            expandedChild: _buildShortExpandedChild(),
          ),
        ),
      );

      await tester.pump();

      expect(_surfaceTopOffset(tester), closeTo(entry.value, 0.01));
      expect(_surfaceLeftOffset(tester), closeTo(40, 0.01));
    }
  });

  testWidgets('expand and collapse callbacks still fire once each', (
    WidgetTester tester,
  ) async {
    var expandedCount = 0;
    var collapsedCount = 0;

    Widget build(bool isExpanded) {
      return _buildHarness(
        SpringSurface(
          isExpanded: isExpanded,
          config: _fastConfig,
          collapsedSize: _collapsedSize,
          expandedSize: _expandedSize,
          collapsedChild: const Text('Open'),
          expandedChild: _buildShortExpandedChild(),
          onExpanded: () => expandedCount += 1,
          onCollapsed: () => collapsedCount += 1,
        ),
      );
    }

    await tester.pumpWidget(build(false));
    await tester.pumpWidget(build(true));
    await tester.pumpAndSettle();

    expect(expandedCount, 1);
    expect(collapsedCount, 0);

    await tester.pumpWidget(build(false));
    await tester.pumpAndSettle();

    expect(expandedCount, 1);
    expect(collapsedCount, 1);
  });

  testWidgets('ready surfaces still require expanded content and size', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      _buildHarness(
        SpringSurface(
          isExpanded: false,
          contentState: SpringSurfaceContentState.ready,
          collapsedSize: _collapsedSize,
          collapsedChild: const Text('Open'),
        ),
      ),
    );

    expect(tester.takeException(), isA<AssertionError>());
  });

  testWidgets('pending accepts missing expanded data and pulses on tap', (
    WidgetTester tester,
  ) async {
    var pendingTapCount = 0;

    await tester.pumpWidget(
      _buildHarness(
        SpringSurface(
          isExpanded: false,
          contentState: SpringSurfaceContentState.pending,
          config: _fastConfig,
          collapsedSize: _collapsedSize,
          collapsedChild: const Text('Pending'),
          onPendingTap: () => pendingTapCount += 1,
        ),
      ),
    );

    expect(_surfaceSize(tester).width, closeTo(_collapsedSize.width, 0.01));

    await tester.tap(find.text('Pending'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 45));

    expect(_surfaceSize(tester).width, greaterThan(_collapsedSize.width));

    await tester.pumpAndSettle();

    expect(pendingTapCount, 1);
    expect(_surfaceSize(tester).width, closeTo(_collapsedSize.width, 0.01));
    expect(find.byType(SingleChildScrollView), findsNothing);
  });

  testWidgets('unavailable stays collapsed and ignores taps', (
    WidgetTester tester,
  ) async {
    var pendingTapCount = 0;

    await tester.pumpWidget(
      _buildHarness(
        SpringSurface(
          isExpanded: false,
          contentState: SpringSurfaceContentState.unavailable,
          config: _fastConfig,
          collapsedSize: _collapsedSize,
          collapsedChild: const Text('Unavailable'),
          onPendingTap: () => pendingTapCount += 1,
        ),
      ),
    );

    await tester.tapAt(_surfaceRect(tester).center);
    await tester.pumpAndSettle();

    expect(pendingTapCount, 0);
    expect(_surfaceSize(tester).width, closeTo(_collapsedSize.width, 0.01));
  });

  testWidgets('controller pulse returns to a collapsed resting state', (
    WidgetTester tester,
  ) async {
    late SpringSurfaceController controller;

    await tester.pumpWidget(
      _ControlledPulseHarness(onControllerReady: (value) => controller = value),
    );

    final pulse = controller.pulse();
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 45));

    expect(_surfaceSize(tester).width, greaterThan(_collapsedSize.width));

    await tester.pumpAndSettle();
    await pulse;

    expect(controller.isExpanded, isFalse);
    expect(controller.isPulsing, isFalse);
    expect(_surfaceSize(tester).width, closeTo(_collapsedSize.width, 0.01));
  });
}

class _ControlledPulseHarness extends StatefulWidget {
  const _ControlledPulseHarness({required this.onControllerReady});

  final ValueChanged<SpringSurfaceController> onControllerReady;

  @override
  State<_ControlledPulseHarness> createState() =>
      _ControlledPulseHarnessState();
}

class _ControlledPulseHarnessState extends State<_ControlledPulseHarness>
    with SingleTickerProviderStateMixin {
  late final SpringSurfaceController _controller;

  @override
  void initState() {
    super.initState();
    _controller = SpringSurfaceController(vsync: this, config: _fastConfig);
    widget.onControllerReady(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _buildHarness(
      SpringSurface.controlled(
        controller: _controller,
        contentState: SpringSurfaceContentState.pending,
        collapsedSize: _collapsedSize,
        collapsedChild: const Text('Pulse'),
      ),
    );
  }
}

Widget _buildHarness(Widget child, {Size hostSize = const Size(300, 300)}) {
  return MaterialApp(
    home: Scaffold(
      body: Align(
        alignment: Alignment.topLeft,
        child: SizedBox(
          key: _hostKey,
          width: hostSize.width,
          height: hostSize.height,
          child: child,
        ),
      ),
    ),
  );
}

SpringSurface _buildSurface({
  required bool isExpanded,
  SpringSurfaceAnchor? anchor,
  SpringSurfaceOrigin origin = SpringSurfaceOrigin.bottom,
  SpringSurfaceConfig config = const SpringSurfaceConfig(),
}) {
  return SpringSurface(
    isExpanded: isExpanded,
    anchor: anchor,
    origin: origin,
    config: config,
    collapsedSize: _collapsedSize,
    expandedSize: _expandedSize,
    collapsedChild: const Text('Open'),
    expandedChild: _buildShortExpandedChild(),
  );
}

Widget _buildShortExpandedChild() {
  return const SizedBox(
    height: 120,
    width: double.infinity,
    child: ColoredBox(color: Colors.orange),
  );
}

Widget _buildTallExpandedChild() {
  return Column(
    mainAxisSize: MainAxisSize.min,
    children: List.generate(
      4,
      (_) => const SizedBox(
        height: 100,
        width: double.infinity,
        child: ColoredBox(color: Colors.blue),
      ),
    ),
  );
}

void _expectPinnedCorner(
  SpringSurfaceAnchor anchor,
  Rect surfaceRect,
  Rect hostRect,
) {
  switch (anchor) {
    case SpringSurfaceAnchor.topLeft:
      expect(surfaceRect.left, closeTo(hostRect.left, 0.01));
      expect(surfaceRect.top, closeTo(hostRect.top, 0.01));
      return;
    case SpringSurfaceAnchor.topRight:
      expect(surfaceRect.right, closeTo(hostRect.right, 0.01));
      expect(surfaceRect.top, closeTo(hostRect.top, 0.01));
      return;
    case SpringSurfaceAnchor.bottomLeft:
      expect(surfaceRect.left, closeTo(hostRect.left, 0.01));
      expect(surfaceRect.bottom, closeTo(hostRect.bottom, 0.01));
      return;
    case SpringSurfaceAnchor.bottomRight:
      expect(surfaceRect.right, closeTo(hostRect.right, 0.01));
      expect(surfaceRect.bottom, closeTo(hostRect.bottom, 0.01));
      return;
    case SpringSurfaceAnchor.topCenter:
    case SpringSurfaceAnchor.centerLeft:
    case SpringSurfaceAnchor.center:
    case SpringSurfaceAnchor.centerRight:
    case SpringSurfaceAnchor.bottomCenter:
      throw ArgumentError.value(anchor, 'anchor', 'Expected a corner anchor.');
  }
}

Rect _hostRect(WidgetTester tester) {
  return tester.getRect(find.byKey(_hostKey));
}

Rect _surfaceRect(WidgetTester tester) {
  return tester.getRect(find.byType(ClipRRect));
}

Size _surfaceSize(WidgetTester tester) {
  return tester.getSize(find.byType(ClipRRect));
}

double _surfaceTopOffset(WidgetTester tester) {
  final hostTopLeft = tester.getTopLeft(find.byKey(_hostKey));
  final surfaceTopLeft = tester.getTopLeft(find.byType(ClipRRect));
  return surfaceTopLeft.dy - hostTopLeft.dy;
}

double _surfaceLeftOffset(WidgetTester tester) {
  final hostTopLeft = tester.getTopLeft(find.byKey(_hostKey));
  final surfaceTopLeft = tester.getTopLeft(find.byType(ClipRRect));
  return surfaceTopLeft.dx - hostTopLeft.dx;
}
