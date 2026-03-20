import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:spring_surface/main.dart';
import 'package:spring_surface/spring_surface.dart';
import 'package:spring_surface/src/spring_surface_playground.dart';
import 'package:spring_surface/src/spring_surface_test_lab_page.dart';

const Key _hostKey = Key('host');
const Size _collapsedSize = Size(100, 40);
const Size _expandedSize = Size(220, 260);

class _ShowcaseSceneSpec {
  const _ShowcaseSceneSpec({
    required this.title,
    required this.toggleKey,
    required this.backdropKey,
    required this.dismissDelta,
  });

  final String title;
  final Key toggleKey;
  final Key backdropKey;
  final Offset dismissDelta;
}

const _showcaseScenes = <_ShowcaseSceneSpec>[
  _ShowcaseSceneSpec(
    title: 'فلتر الطلبات',
    toggleKey: Key('orders_filter_toggle'),
    backdropKey: Key('orders_filter_backdrop'),
    dismissDelta: Offset(-220, 0),
  ),
  _ShowcaseSceneSpec(
    title: 'اقتراحات البحث',
    toggleKey: Key('search_suggestions_toggle'),
    backdropKey: Key('search_suggestions_backdrop'),
    dismissDelta: Offset(0, 180),
  ),
  _ShowcaseSceneSpec(
    title: 'إجراءات التذكرة',
    toggleKey: Key('ticket_actions_toggle'),
    backdropKey: Key('ticket_actions_backdrop'),
    dismissDelta: Offset(-220, -110),
  ),
  _ShowcaseSceneSpec(
    title: 'إنشاء حجز سريع',
    toggleKey: Key('booking_slot_toggle'),
    backdropKey: Key('booking_slot_backdrop'),
    dismissDelta: Offset(-180, -120),
  ),
  _ShowcaseSceneSpec(
    title: 'إعدادات موسعة',
    toggleKey: Key('settings_inline_toggle'),
    backdropKey: Key('settings_inline_backdrop'),
    dismissDelta: Offset(0, 190),
  ),
  _ShowcaseSceneSpec(
    title: 'مؤلف الرسائل',
    toggleKey: Key('message_composer_toggle'),
    backdropKey: Key('message_composer_backdrop'),
    dismissDelta: Offset(0, -170),
  ),
  _ShowcaseSceneSpec(
    title: 'ملخص الدفع',
    toggleKey: Key('checkout_summary_toggle'),
    backdropKey: Key('checkout_summary_backdrop'),
    dismissDelta: Offset(0, -220),
  ),
];

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
    expect(find.text(_showcaseScenes.first.title), findsWidgets);

    for (final scene in _showcaseScenes.skip(1)) {
      await _dragPageUntilVisible(tester, find.text(scene.title));
      expect(find.text(scene.title), findsWidgets);
    }
    expect(find.text('قائمة التحقق اليدوية'), findsNothing);
    expect(find.text('سجل الأحداث'), findsNothing);
  });

  testWidgets('Detail pages open as immersive expanded examples', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());

    await tester.tap(find.byTooltip('افتح صفحة الاختبارات'));
    await tester.pumpAndSettle();

    final detailButton = find.byKey(const Key('orders_filter_detail_button'));
    await _bringFinderIntoComfortableView(tester, detailButton);
    await tester.tap(detailButton);
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('orders_filter_detail_page')), findsOneWidget);
    expect(
      find.byKey(const Key('orders_filter_detail_backdrop')),
      findsOneWidget,
    );
    expect(find.byKey(const Key('orders_filter_detail_open')), findsNothing);

    await tester.tap(find.byKey(const Key('orders_filter_detail_backdrop')));
    await tester.pumpAndSettle();

    expect(
      find.byKey(const Key('orders_filter_detail_backdrop')),
      findsNothing,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('Showcase scenarios expand and close from outside tap', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());

    await tester.tap(find.byTooltip('افتح صفحة الاختبارات'));
    await tester.pumpAndSettle();

    for (final scene in _showcaseScenes) {
      final toggleFinder = find.byKey(scene.toggleKey);
      await _bringFinderIntoComfortableView(tester, toggleFinder);

      final toggleCenter = tester.getCenter(toggleFinder);
      await tester.tap(toggleFinder.hitTestable());
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 150));
      await tester.pumpAndSettle();

      final backdropFinder = find.byKey(scene.backdropKey);
      expect(backdropFinder, findsOneWidget);
      await tester.tapAt(toggleCenter + scene.dismissDelta);
      await tester.pumpAndSettle();
      expect(backdropFinder, findsNothing);
    }

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

Future<void> _bringFinderIntoComfortableView(
  WidgetTester tester,
  Finder finder,
) async {
  final page = find.byType(Scrollable).first;

  await _dragPageUntilVisible(tester, finder);
  await tester.ensureVisible(finder);
  await tester.pumpAndSettle();

  final center = tester.getCenter(finder);
  const targetY = 320.0;
  final delta = center.dy - targetY;

  if (delta.abs() > 40) {
    await tester.drag(page, Offset(0, -delta));
    await tester.pumpAndSettle();
  }
}

Future<void> _dragPageUntilVisible(WidgetTester tester, Finder finder) async {
  final page = find.byType(Scrollable).first;
  var attempts = 0;

  while (finder.evaluate().isEmpty && attempts < 20) {
    await tester.drag(page, const Offset(0, -260));
    await tester.pumpAndSettle();
    attempts += 1;
  }
}
