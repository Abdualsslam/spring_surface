import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:spring_surface_example/main.dart';

class _ShowcaseSceneSpec {
  const _ShowcaseSceneSpec({
    required this.title,
    required this.detailButtonKey,
    required this.toggleKey,
    required this.backdropKey,
    required this.dismissDelta,
  });

  final String title;
  final Key detailButtonKey;
  final Key toggleKey;
  final Key backdropKey;
  final Offset dismissDelta;
}

const _showcaseScenes = <_ShowcaseSceneSpec>[
  _ShowcaseSceneSpec(
    title: 'فلتر الطلبات',
    detailButtonKey: Key('orders_filter_detail_button'),
    toggleKey: Key('orders_filter_toggle'),
    backdropKey: Key('orders_filter_backdrop'),
    dismissDelta: Offset(-220, 0),
  ),
  _ShowcaseSceneSpec(
    title: 'اقتراحات البحث',
    detailButtonKey: Key('search_suggestions_detail_button'),
    toggleKey: Key('search_suggestions_toggle'),
    backdropKey: Key('search_suggestions_backdrop'),
    dismissDelta: Offset(0, 180),
  ),
  _ShowcaseSceneSpec(
    title: 'إجراءات التذكرة',
    detailButtonKey: Key('ticket_actions_detail_button'),
    toggleKey: Key('ticket_actions_toggle'),
    backdropKey: Key('ticket_actions_backdrop'),
    dismissDelta: Offset(-220, -110),
  ),
  _ShowcaseSceneSpec(
    title: 'إنشاء حجز سريع',
    detailButtonKey: Key('booking_slot_detail_button'),
    toggleKey: Key('booking_slot_toggle'),
    backdropKey: Key('booking_slot_backdrop'),
    dismissDelta: Offset(-180, -120),
  ),
  _ShowcaseSceneSpec(
    title: 'إعدادات موسعة',
    detailButtonKey: Key('settings_inline_detail_button'),
    toggleKey: Key('settings_inline_toggle'),
    backdropKey: Key('settings_inline_backdrop'),
    dismissDelta: Offset(0, 190),
  ),
  _ShowcaseSceneSpec(
    title: 'مؤلف الرسائل',
    detailButtonKey: Key('message_composer_detail_button'),
    toggleKey: Key('message_composer_toggle'),
    backdropKey: Key('message_composer_backdrop'),
    dismissDelta: Offset(0, -170),
  ),
  _ShowcaseSceneSpec(
    title: 'ملخص الدفع',
    detailButtonKey: Key('checkout_summary_detail_button'),
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
    expect(find.text('Spring Surface Playground'), findsOneWidget);
    expect(find.byType(Slider), findsWidgets);
  });

  testWidgets('Playground surface toggles directly without a toggle button', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('toggle  ↕'), findsNothing);
    expect(find.text('بيانات الطلب'), findsOneWidget);
    expect(find.byKey(const Key('playground_surface_toggle')), findsOneWidget);

    await tester.tap(find.byKey(const Key('playground_surface_toggle')));
    await tester.pumpAndSettle();

    expect(find.text('معلومات الحساب'), findsOneWidget);

    await tester.tap(find.byKey(const Key('playground_surface_toggle')));
    await tester.pumpAndSettle();

    expect(find.text('بيانات الطلب'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('App opens the realistic showcase page from the playground', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());

    await tester.tap(find.byTooltip('افتح صفحة الاختبارات'));
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(find.byKey(const Key('test_showcase_list')), findsOneWidget);
    expect(find.text(_showcaseScenes.first.title), findsWidgets);

    for (final scene in _showcaseScenes.skip(1)) {
      final detailButton = find.byKey(scene.detailButtonKey);
      await _bringFinderIntoComfortableView(tester, detailButton);
      expect(detailButton, findsOneWidget);
    }
  });

  testWidgets('Detail pages open as immersive expanded examples', (
    WidgetTester tester,
  ) async {
    await _openOrdersFilterDetailPage(tester);

    expect(find.byKey(const Key('orders_filter_detail_page')), findsOneWidget);
    expect(
      find.byKey(const Key('orders_filter_detail_backdrop')),
      findsOneWidget,
    );
    expect(find.byKey(const Key('orders_filter_detail_open')), findsNothing);

    await _tapBackdropAtSafeSpot(
      tester,
      find.byKey(const Key('orders_filter_detail_backdrop')),
    );

    expect(
      find.byKey(const Key('orders_filter_detail_backdrop')),
      findsNothing,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('Orders filter detail keeps search and filter surface aligned', (
    WidgetTester tester,
  ) async {
    await _openOrdersFilterDetailPage(tester);

    final searchRect = tester.getRect(
      find.byKey(const Key('orders_filter_detail_search_field')),
    );
    final surfaceRect = tester.getRect(
      find.byKey(const Key('orders_filter_detail_surface_host')),
    );
    final metricsRect = tester.getRect(
      find.byKey(const Key('orders_filter_detail_metrics_row')),
    );

    expect(searchRect.right, lessThan(surfaceRect.left));
    expect(searchRect.bottom, lessThanOrEqualTo(metricsRect.top));
    expect(surfaceRect.bottom, lessThanOrEqualTo(metricsRect.top));
  });

  testWidgets('Orders filter detail updates metrics and content by preset', (
    WidgetTester tester,
  ) async {
    await _openOrdersFilterDetailPage(tester);

    final urgentPreset = find.byKey(
      const Key('orders_filter_detail_panel_preset_urgent'),
    );
    await tester.ensureVisible(urgentPreset);
    await tester.pumpAndSettle();
    await tester.tap(urgentPreset.hitTestable());
    await tester.pumpAndSettle();

    expect(find.text('7 طلبات مستعجلة'), findsWidgets);
    expect(find.text('مسار الأولوية'), findsWidgets);
    expect(find.text('طلب مستشفى المدينة'), findsWidgets);
    expect(find.text('5'), findsWidgets);
  });

  testWidgets('Orders filter detail updates selected order summary', (
    WidgetTester tester,
  ) async {
    await _openOrdersFilterDetailPage(tester);

    final urgentPreset = find.byKey(
      const Key('orders_filter_detail_panel_preset_urgent'),
    );
    await tester.ensureVisible(urgentPreset);
    await tester.pumpAndSettle();
    await tester.tap(urgentPreset.hitTestable());
    await tester.pumpAndSettle();

    expect(
      find.text(
        'أرسل الطلب مباشرة إلى محطة التغليف السريع مع إشعار السائق المناوب.',
      ),
      findsOneWidget,
    );

    final orderCard = find.byKey(
      const Key('orders_filter_detail_order_madar_office'),
    );
    await tester.scrollUntilVisible(
      orderCard,
      180,
      scrollable: find.descendant(
        of: find.byKey(const Key('orders_filter_detail_orders_list')),
        matching: find.byType(Scrollable),
      ),
    );
    await tester.ensureVisible(orderCard);
    await tester.pumpAndSettle();
    await tester.tap(orderCard.hitTestable());
    await tester.pumpAndSettle();

    expect(
      find.text('ثبّت الفاتورة أعلى الكيس وأعط السائق أولوية عند الوصول.'),
      findsOneWidget,
    );
    expect(
      find.text(
        'أرسل الطلب مباشرة إلى محطة التغليف السريع مع إشعار السائق المناوب.',
      ),
      findsNothing,
    );
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
}

Future<void> _openOrdersFilterDetailPage(WidgetTester tester) async {
  await tester.pumpWidget(const MyApp());

  await tester.tap(find.byTooltip('افتح صفحة الاختبارات'));
  await tester.pumpAndSettle();

  final detailButton = find.byKey(const Key('orders_filter_detail_button'));
  await _bringFinderIntoComfortableView(tester, detailButton);
  await tester.tap(detailButton);
  await tester.pumpAndSettle();
}

Future<void> _tapBackdropAtSafeSpot(
  WidgetTester tester,
  Finder backdropFinder,
) async {
  final backdropRect = tester.getRect(backdropFinder);
  final target = backdropRect.bottomLeft + const Offset(12, -12);

  await tester.tapAt(target);
  await tester.pumpAndSettle();
}

Future<void> _bringFinderIntoComfortableView(
  WidgetTester tester,
  Finder finder,
) async {
  final page = _showcasePageScrollable();

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
  if (finder.evaluate().isEmpty) {
    await tester.scrollUntilVisible(
      finder,
      260,
      scrollable: _showcasePageScrollable(),
      maxScrolls: 20,
    );
  }
}

Finder _showcasePageScrollable() {
  return find
      .descendant(
        of: find.byKey(const Key('test_showcase_list')),
        matching: find.byType(Scrollable),
      )
      .first;
}
