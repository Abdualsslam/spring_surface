import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:spring_surface/main.dart';
import 'package:spring_surface/spring_surface.dart';
import 'package:spring_surface/src/spring_surface_playground.dart';
import 'package:spring_surface/src/spring_surface_test_lab_page.dart';

const Key _hostKey = Key('host');
const Size _collapsedSize = Size(100, 40);
const Size _expandedSize = Size(220, 260);

void main() {
  testWidgets('App shows the spring surface playground', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());

    expect(find.byType(MaterialApp), findsOneWidget);
    expect(find.byType(SpringSurfacePlayground), findsOneWidget);
    expect(find.byType(Slider), findsWidgets);
  });

  testWidgets('App opens the realistic showcase page from the playground', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());

    await tester.tap(find.byTooltip('افتح صفحة الاختبارات'));
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(find.byType(SpringSurfaceTestLabPage), findsOneWidget);
    expect(find.text('فلاتر من الأعلى'), findsOneWidget);

    await tester.scrollUntilVisible(
      find.text('إجراء من الوسط'),
      180,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();
    expect(find.text('إجراء من الوسط'), findsOneWidget);

    await tester.scrollUntilVisible(
      find.text('ملخص من الأسفل'),
      180,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();
    expect(find.text('ملخص من الأسفل'), findsOneWidget);
    expect(find.text('قائمة التحقق اليدوية'), findsNothing);
    expect(find.text('سجل الأحداث'), findsNothing);
  });

  testWidgets('Showcase scenarios expand and close from outside tap', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());

    await tester.tap(find.byTooltip('افتح صفحة الاختبارات'));
    await tester.pumpAndSettle();

    final topDismissPoint =
        tester.getCenter(find.byKey(const Key('top_surface_toggle'))) -
        const Offset(240, 0);
    await tester.tap(find.byKey(const Key('top_surface_toggle')));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 150));
    await tester.pumpAndSettle();
    final topBackdrop = find.byKey(const Key('top_surface_backdrop'));
    expect(topBackdrop, findsOneWidget);
    await tester.tapAt(topDismissPoint);
    await tester.pumpAndSettle();
    expect(topBackdrop, findsNothing);

    await tester.scrollUntilVisible(
      find.byKey(const Key('center_surface_toggle')),
      180,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();
    final centerDismissPoint =
        tester.getCenter(find.byKey(const Key('center_surface_toggle'))) -
        const Offset(180, 0);
    await tester.tap(find.byKey(const Key('center_surface_toggle')));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 150));
    await tester.pumpAndSettle();
    final centerBackdrop = find.byKey(const Key('center_surface_backdrop'));
    expect(centerBackdrop, findsOneWidget);
    await tester.tapAt(centerDismissPoint);
    await tester.pumpAndSettle();
    expect(centerBackdrop, findsNothing);

    await tester.scrollUntilVisible(
      find.byKey(const Key('bottom_surface_toggle')),
      180,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();
    await tester.drag(find.byType(Scrollable).first, const Offset(0, -140));
    await tester.pumpAndSettle();
    final bottomToggle = find.byKey(const Key('bottom_surface_toggle'));
    final bottomToggleCenter = tester.getCenter(bottomToggle);
    final bottomDismissPoint = bottomToggleCenter - const Offset(0, 230);
    await tester.tap(bottomToggle);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 150));
    await tester.pumpAndSettle();
    final bottomBackdrop = find.byKey(const Key('bottom_surface_backdrop'));
    expect(bottomBackdrop, findsOneWidget);
    await tester.tapAt(bottomDismissPoint);
    await tester.pumpAndSettle();
    expect(bottomBackdrop, findsNothing);

    expect(tester.takeException(), isNull);
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
