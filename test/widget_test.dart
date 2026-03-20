import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:spring_surface/spring_surface.dart';

const Key _hostKey = Key('host');
const Size _collapsedSize = Size(100, 40);
const Size _expandedSize = Size(220, 260);

void main() {
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

  testWidgets(
    'dynamicHeight keeps origin alignment for top center and bottom',
    (WidgetTester tester) async {
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
    },
  );
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

Size _surfaceSize(WidgetTester tester) {
  return tester.getSize(find.byType(ClipRRect));
}

double _surfaceTopOffset(WidgetTester tester) {
  final hostTopLeft = tester.getTopLeft(find.byKey(_hostKey));
  final surfaceTopLeft = tester.getTopLeft(find.byType(ClipRRect));
  return surfaceTopLeft.dy - hostTopLeft.dy;
}
