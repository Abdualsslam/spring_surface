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
    dismissDelta: Offset(0, 260),
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
    expect(find.byKey(const Key('playground_collapsed_label')), findsOneWidget);
    expect(find.byKey(const Key('playground_surface_toggle')), findsOneWidget);

    await tester.tap(find.byKey(const Key('playground_collapsed_label')));
    await tester.pumpAndSettle();

    expect(
      find.byKey(const Key('playground_expanded_heading')),
      findsOneWidget,
    );

    final expandedSurfaceRect = tester.getRect(find.byType(ClipRRect).first);
    await tester.tapAt(expandedSurfaceRect.bottomCenter - const Offset(0, 12));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('playground_collapsed_label')), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Playground size sliders update the expanded surface size', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());

    await tester.tap(find.byKey(const Key('playground_collapsed_label')));
    await tester.pumpAndSettle();

    final widthValueFinder = find.byKey(
      const Key('playground_expanded_width_value'),
    );
    final heightValueFinder = find.byKey(
      const Key('playground_expanded_height_value'),
    );
    final initialWidthValue = tester.widget<Text>(widthValueFinder).data;
    final initialHeightValue = tester.widget<Text>(heightValueFinder).data;

    await tester.ensureVisible(
      find.byKey(const Key('playground_expanded_width_slider')),
    );
    await tester.pumpAndSettle();

    await tester.drag(
      find.byKey(const Key('playground_expanded_width_slider')),
      const Offset(120, 0),
    );
    await tester.pumpAndSettle();

    await tester.ensureVisible(
      find.byKey(const Key('playground_expanded_height_slider')),
    );
    await tester.pumpAndSettle();

    await tester.drag(
      find.byKey(const Key('playground_expanded_height_slider')),
      const Offset(120, 0),
    );
    await tester.pumpAndSettle();

    final updatedWidthValue = tester.widget<Text>(widthValueFinder).data;
    final updatedHeightValue = tester.widget<Text>(heightValueFinder).data;

    expect(updatedWidthValue, isNot(initialWidthValue));
    expect(updatedHeightValue, isNot(initialHeightValue));
    expect(
      find.byKey(const Key('playground_expanded_heading')),
      findsOneWidget,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('Playground info icon shows the control description', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());

    await tester.ensureVisible(
      find.byKey(const Key('playground_info_overshoot')),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('playground_info_overshoot')));
    await tester.pumpAndSettle();

    expect(
      find.text(
        'يحدد مقدار السماح بتجاوز الحجم المستهدف أثناء الحركة. رفعه يزيد الارتداد والامتلاء البصري.',
      ),
      findsOneWidget,
    );

    await tester.tap(find.text('إغلاق'));
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
  });

  testWidgets('Playground placement chips move the surface vertically', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());

    final hostFinder = find.byKey(const Key('playground_surface_host'));

    await tester.ensureVisible(
      find.byKey(const Key('playground_placement_top')),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('playground_placement_top')));
    await tester.pumpAndSettle();
    final topY = tester.getTopLeft(hostFinder).dy;

    await tester.tap(find.byKey(const Key('playground_placement_center')));
    await tester.pumpAndSettle();
    final centerY = tester.getTopLeft(hostFinder).dy;

    await tester.tap(find.byKey(const Key('playground_placement_bottom')));
    await tester.pumpAndSettle();
    final bottomY = tester.getTopLeft(hostFinder).dy;

    expect(topY, lessThan(centerY));
    expect(centerY, lessThan(bottomY));
    expect(tester.takeException(), isNull);
  });

  testWidgets('Playground origin changes direction without moving the button', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());

    final surfaceFinder = find
        .descendant(
          of: find.byKey(const Key('playground_surface_toggle')),
          matching: find.byType(ClipRRect),
        )
        .first;

    await tester.ensureVisible(
      find.byKey(const Key('playground_placement_bottom')),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('playground_placement_bottom')));
    await tester.pumpAndSettle();

    final bottomOriginY = tester.getTopLeft(surfaceFinder).dy;

    await tester.tap(find.byKey(const Key('playground_origin_center')));
    await tester.pumpAndSettle();
    final centerOriginY = tester.getTopLeft(surfaceFinder).dy;

    await tester.tap(find.byKey(const Key('playground_origin_top')));
    await tester.pumpAndSettle();
    final topOriginY = tester.getTopLeft(surfaceFinder).dy;

    expect(centerOriginY, closeTo(bottomOriginY, 0.01));
    expect(topOriginY, closeTo(bottomOriginY, 0.01));
    expect(tester.takeException(), isNull);
  });

  testWidgets('App opens the realistic showcase page from the playground', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());

    await tester.tap(find.byKey(const Key('playground_open_test_lab')));
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(find.byKey(const Key('test_showcase_list')), findsOneWidget);
    expect(find.byKey(_showcaseScenes.first.detailButtonKey), findsOneWidget);

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

    expect(
      find.byKey(const Key('orders_filter_detail_order_city_hospital')),
      findsOneWidget,
    );
    expect(
      find.descendant(
        of: find.byKey(const Key('orders_filter_detail_metric_primary')),
        matching: find.text('5'),
      ),
      findsOneWidget,
    );
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

    final noteFinder = find.byKey(
      const Key('orders_filter_detail_selected_order_note'),
    );
    final noteBefore = tester.widget<Text>(noteFinder).data;

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

    final noteAfter = tester.widget<Text>(noteFinder).data;
    expect(noteAfter, isNot(noteBefore));
  });

  testWidgets('Search suggestions detail supports typing and actions', (
    WidgetTester tester,
  ) async {
    await _openSearchSuggestionsDetailPage(tester);

    final queryField = find.byKey(
      const Key('search_suggestions_detail_query_field'),
    );
    await tester.tap(queryField);
    await tester.pumpAndSettle();
    await tester.enterText(queryField, 'فاتورة');
    await tester.pumpAndSettle();

    final filesScope = find.byKey(
      const Key('search_suggestions_detail_scope_files'),
    );
    await tester.tap(filesScope.hitTestable());
    await tester.pumpAndSettle();

    expect(
      find.byKey(
        const Key('search_suggestions_detail_result_invoice_april_pdf'),
      ),
      findsOneWidget,
    );
    expect(
      find.byKey(
        const Key('search_suggestions_detail_result_sara_contract_thread'),
      ),
      findsNothing,
    );

    final taskAction = find.byKey(
      const Key('search_suggestions_detail_action_task'),
    );
    final actionBanner = find.byKey(
      const Key('search_suggestions_detail_action_banner'),
    );
    final actionTextBefore = tester
        .widgetList<Text>(
          find.descendant(of: actionBanner, matching: find.byType(Text)),
        )
        .last
        .data;
    await tester.tap(taskAction.hitTestable());
    await tester.pumpAndSettle();
    final actionTextAfter = tester
        .widgetList<Text>(
          find.descendant(of: actionBanner, matching: find.byType(Text)),
        )
        .last
        .data;
    expect(actionTextAfter, isNot(actionTextBefore));
  });

  testWidgets('Showcase scenarios expand and close from outside tap', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());

    await tester.tap(find.byKey(const Key('playground_open_test_lab')));
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

  await tester.tap(find.byKey(const Key('playground_open_test_lab')));
  await tester.pumpAndSettle();

  final detailButton = find.byKey(const Key('orders_filter_detail_button'));
  await _bringFinderIntoComfortableView(tester, detailButton);
  await tester.tap(detailButton);
  await tester.pumpAndSettle();
}

Future<void> _openSearchSuggestionsDetailPage(WidgetTester tester) async {
  await tester.pumpWidget(const MyApp());

  await tester.tap(find.byKey(const Key('playground_open_test_lab')));
  await tester.pumpAndSettle();

  final detailButton = find.byKey(
    const Key('search_suggestions_detail_button'),
  );
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
