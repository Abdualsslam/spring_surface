import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:spring_surface_example/main.dart';

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

  testWidgets('Playground anchor changes direction without moving the button', (
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

    final bottomAnchorY = tester.getTopLeft(surfaceFinder).dy;

    await tester.ensureVisible(
      find.byKey(const Key('playground_anchor_center')),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('playground_anchor_center')));
    await tester.pumpAndSettle();
    final centerAnchorY = tester.getTopLeft(surfaceFinder).dy;

    await tester.ensureVisible(
      find.byKey(const Key('playground_anchor_topCenter')),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('playground_anchor_topCenter')));
    await tester.pumpAndSettle();
    final topAnchorY = tester.getTopLeft(surfaceFinder).dy;

    expect(centerAnchorY, closeTo(bottomAnchorY, 0.01));
    expect(topAnchorY, closeTo(bottomAnchorY, 0.01));
    expect(tester.takeException(), isNull);
  });

  testWidgets('App opens the unified showcase families from the playground', (
    WidgetTester tester,
  ) async {
    await _openTestLab(tester);

    expect(tester.takeException(), isNull);
    expect(find.byKey(const Key('test_family_list')), findsOneWidget);
    expect(find.byKey(const Key('top_surface_section')), findsOneWidget);
    expect(
      find.byKey(const Key('top_surface_variant_orders_filter')),
      findsNothing,
    );
    expect(
      find.byKey(const Key('top_surface_variant_search_suggestions')),
      findsOneWidget,
    );
    expect(
      find.byKey(const Key('top_surface_variant_settings_inline')),
      findsOneWidget,
    );
    await _bringFinderIntoComfortableView(
      tester,
      find.byKey(const Key('inline_trigger_section')),
    );
    expect(find.byKey(const Key('inline_trigger_section')), findsOneWidget);
    await _bringFinderIntoComfortableView(
      tester,
      find.byKey(const Key('bottom_dock_section')),
    );
    expect(find.byKey(const Key('bottom_dock_section')), findsOneWidget);
    expect(
      find.byKey(const Key('bottom_dock_variant_message_composer')),
      findsOneWidget,
    );
    expect(
      find.byKey(const Key('bottom_dock_variant_checkout_summary')),
      findsOneWidget,
    );
  });

  testWidgets('Top surface family switches variants inside one frame', (
    WidgetTester tester,
  ) async {
    await _openTestLab(tester);

    expect(
      find.byKey(const Key('top_surface_search_suggestions_toggle')),
      findsOneWidget,
    );
    expect(
      find.byKey(const Key('top_surface_orders_filter_toggle')),
      findsNothing,
    );

    await tester.tap(
      find.byKey(const Key('top_surface_variant_settings_inline')),
    );
    await tester.pumpAndSettle();

    expect(
      find.byKey(const Key('top_surface_settings_inline_toggle')),
      findsOneWidget,
    );
    expect(
      find.byKey(const Key('top_surface_search_suggestions_toggle')),
      findsNothing,
    );
  });

  testWidgets('Search suggestions featured supports typing and actions', (
    WidgetTester tester,
  ) async {
    await _openSearchSuggestionsFeaturedScene(tester);

    final queryField = find.byKey(
      const Key('top_surface_search_suggestions_query_field'),
    );
    await tester.tap(queryField);
    await tester.pumpAndSettle();
    await tester.enterText(queryField, 'فاتورة');
    await tester.pumpAndSettle();

    final filesScope = find.byKey(
      const Key('top_surface_search_suggestions_scope_files'),
    );
    await tester.tap(filesScope.hitTestable());
    await tester.pumpAndSettle();

    expect(
      find.byKey(
        const Key('top_surface_search_suggestions_result_invoice_april_pdf'),
      ),
      findsOneWidget,
    );
    expect(
      find.byKey(
        const Key('top_surface_search_suggestions_result_sara_contract_thread'),
      ),
      findsNothing,
    );

    final taskAction = find.byKey(
      const Key('top_surface_search_suggestions_action_task'),
    );
    final actionBanner = find.byKey(
      const Key('top_surface_search_suggestions_action_banner'),
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

  testWidgets('Bottom dock family switches between composer and checkout', (
    WidgetTester tester,
  ) async {
    await _openTestLab(tester);

    await _bringFinderIntoComfortableView(
      tester,
      find.byKey(const Key('bottom_dock_message_composer_toggle')),
    );

    final composerToggle = find.byKey(
      const Key('bottom_dock_message_composer_toggle'),
    );
    await tester.tap(composerToggle);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 150));
    await tester.pumpAndSettle();

    final composerBackdrop = find.byKey(
      const Key('bottom_dock_message_composer_backdrop'),
    );
    expect(composerBackdrop, findsOneWidget);
    await _tapBackdropAtSafeSpot(tester, composerBackdrop);
    expect(composerBackdrop, findsNothing);

    await _bringFinderIntoComfortableView(
      tester,
      find.byKey(const Key('bottom_dock_variant_checkout_summary')),
    );
    await tester.tap(
      find.byKey(const Key('bottom_dock_variant_checkout_summary')),
    );
    await tester.pumpAndSettle();

    expect(
      find.byKey(const Key('bottom_dock_checkout_summary_toggle')),
      findsOneWidget,
    );
    expect(
      find.byKey(const Key('bottom_dock_message_composer_toggle')),
      findsNothing,
    );

    final checkoutToggle = find.byKey(
      const Key('bottom_dock_checkout_summary_toggle'),
    );
    await _bringFinderIntoComfortableView(tester, checkoutToggle);
    await tester.tap(checkoutToggle);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 150));
    await tester.pumpAndSettle();

    final checkoutBackdrop = find.byKey(
      const Key('bottom_dock_checkout_summary_backdrop'),
    );
    expect(checkoutBackdrop, findsOneWidget);
    await _tapBackdropAtSafeSpot(tester, checkoutBackdrop);
    expect(checkoutBackdrop, findsNothing);
  });

  testWidgets(
    'Booking slot merged scene shows filter and quick booking surfaces',
    (WidgetTester tester) async {
      await _openTestLab(tester);

      final filterToggle = find.byKey(
        const Key('inline_trigger_booking_slot_filter_toggle'),
      );
      final bookingToggle = find.byKey(
        const Key('inline_trigger_booking_slot_toggle'),
      );

      await _bringFinderIntoComfortableView(tester, filterToggle);

      expect(filterToggle, findsOneWidget);
      expect(bookingToggle, findsOneWidget);
      expect(
        find.byKey(const Key('inline_trigger_booking_slot_filter_badge')),
        findsOneWidget,
      );
    },
  );

  testWidgets('Booking slot filter updates badge and summary by preset', (
    WidgetTester tester,
  ) async {
    await _openBookingFilterPanel(tester);
    expect(find.text('6 مواعيد اليوم'), findsOneWidget);
    expect(find.text('فرز حجوزات اليوم'), findsOneWidget);

    final followUpPreset = find.byKey(
      const Key('inline_trigger_booking_slot_filter_panel_preset_follow_up'),
    );
    await tester.tap(followUpPreset.hitTestable());
    await tester.pumpAndSettle();

    expect(
      find.byKey(const Key('inline_trigger_booking_slot_filter_backdrop')),
      findsOneWidget,
    );
    expect(find.text('3 جلسات متابعة'), findsOneWidget);
    expect(find.text('جلسات المتابعة'), findsOneWidget);
    expect(find.text('6 مواعيد اليوم'), findsNothing);
  });

  testWidgets('Booking slot filter closes from its own backdrop', (
    WidgetTester tester,
  ) async {
    await _openBookingFilterPanel(tester);

    final filterBackdrop = find.byKey(
      const Key('inline_trigger_booking_slot_filter_backdrop'),
    );
    expect(filterBackdrop, findsOneWidget);

    await _tapFilterBackdropAtSafeSpot(tester, filterBackdrop);

    expect(filterBackdrop, findsNothing);
  });

  testWidgets(
    'Booking slot filter and quick booking can be used sequentially',
    (WidgetTester tester) async {
      await _openBookingFilterPanel(tester);

      final filterBackdrop = find.byKey(
        const Key('inline_trigger_booking_slot_filter_backdrop'),
      );
      await _tapFilterBackdropAtSafeSpot(tester, filterBackdrop);

      final bookingToggle = find.byKey(
        const Key('inline_trigger_booking_slot_toggle'),
      );
      await _bringFinderIntoComfortableView(tester, bookingToggle);
      await tester.tap(bookingToggle.hitTestable());
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 150));
      await tester.pumpAndSettle();

      final bookingBackdrop = find.byKey(
        const Key('inline_trigger_booking_slot_backdrop'),
      );
      expect(bookingBackdrop, findsOneWidget);

      await _tapBackdropAtSafeSpot(tester, bookingBackdrop);

      expect(bookingBackdrop, findsNothing);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('Ticket actions still expands and closes from outside tap', (
    WidgetTester tester,
  ) async {
    await _openTestLab(tester);

    final toggleFinder = find.byKey(
      const Key('inline_trigger_ticket_actions_toggle'),
    );
    final backdropFinder = find.byKey(
      const Key('inline_trigger_ticket_actions_backdrop'),
    );

    await _bringFinderIntoComfortableView(tester, toggleFinder);
    await tester.tap(toggleFinder.hitTestable());
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 150));
    await tester.pumpAndSettle();

    expect(backdropFinder, findsOneWidget);
    await _tapBackdropAtSafeSpot(tester, backdropFinder);
    expect(backdropFinder, findsNothing);

    expect(tester.takeException(), isNull);
  });

  testWidgets('Playground opens the new unified showcase route', (
    WidgetTester tester,
  ) async {
    await _openUnifiedShowcase(tester);

    expect(find.byKey(const Key('unified_showcase_page')), findsOneWidget);
    expect(find.byKey(const Key('unified_showcase_top_zone')), findsOneWidget);
    await _bringUnifiedFinderIntoComfortableView(
      tester,
      find.byKey(const Key('unified_showcase_middle_zone')),
    );
    expect(
      find.byKey(const Key('unified_showcase_middle_zone')),
      findsOneWidget,
    );
    await _bringUnifiedFinderIntoComfortableView(
      tester,
      find.byKey(const Key('unified_showcase_bottom_zone')),
    );
    expect(
      find.byKey(const Key('unified_showcase_bottom_zone')),
      findsOneWidget,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('Unified showcase top search surface opens and closes', (
    WidgetTester tester,
  ) async {
    await _openUnifiedShowcase(tester);

    final toggle = find.byKey(const Key('unified_showcase_top_search_toggle'));
    await tester.tap(toggle);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 150));
    await tester.pumpAndSettle();

    final backdrop = find.byKey(
      const Key('unified_showcase_top_search_backdrop'),
    );
    expect(backdrop, findsOneWidget);
    expect(
      find.byKey(const Key('unified_showcase_top_search_query_field')),
      findsOneWidget,
    );

    await tester.tap(find.text('Search workspace'));
    await tester.pumpAndSettle();

    expect(backdrop, findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Unified showcase middle day surface expands from the center', (
    WidgetTester tester,
  ) async {
    await _openUnifiedShowcase(tester);

    final toggle = find.byKey(const Key('unified_showcase_middle_day_toggle'));
    await _bringUnifiedFinderIntoComfortableView(tester, toggle);
    await tester.tap(toggle.hitTestable());
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 150));
    await tester.pumpAndSettle();

    final backdrop = find.byKey(
      const Key('unified_showcase_middle_day_backdrop'),
    );
    expect(backdrop, findsOneWidget);

    await _tapBackdropAtSafeSpot(tester, backdrop);

    expect(backdrop, findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'Unified showcase side availability surface opens without overflow',
    (WidgetTester tester) async {
      await _openUnifiedShowcase(tester);

      final toggle = find.byKey(
        const Key('unified_showcase_middle_availability_toggle'),
      );
      await _bringUnifiedFinderIntoComfortableView(tester, toggle);
      await tester.tap(toggle.hitTestable());
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 150));
      await tester.pumpAndSettle();

      final backdrop = find.byKey(
        const Key('unified_showcase_middle_availability_backdrop'),
      );
      expect(backdrop, findsOneWidget);

      await tester.tap(find.text('Provider availability'));
      await tester.pumpAndSettle();

      expect(backdrop, findsNothing);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('Unified showcase bottom composer opens and closes', (
    WidgetTester tester,
  ) async {
    await _openUnifiedShowcase(tester);

    await _bringUnifiedFinderIntoComfortableView(
      tester,
      find.byKey(const Key('unified_showcase_middle_zone')),
    );
    await _bringUnifiedFinderIntoComfortableView(
      tester,
      find.byKey(const Key('unified_showcase_bottom_zone')),
    );
    final toggle = find.byKey(
      const Key('unified_showcase_bottom_composer_toggle'),
    );
    expect(toggle, findsOneWidget);
    await tester.ensureVisible(toggle);
    await tester.pumpAndSettle();
    await tester.tap(toggle.hitTestable());
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 150));
    await tester.pumpAndSettle();

    final backdrop = find.byKey(
      const Key('unified_showcase_bottom_composer_backdrop'),
    );
    expect(backdrop, findsOneWidget);

    await _tapFilterBackdropAtSafeSpot(tester, backdrop);

    expect(backdrop, findsNothing);
    expect(tester.takeException(), isNull);
  });
}

Future<void> _openTestLab(WidgetTester tester) async {
  await tester.pumpWidget(const MyApp());

  await tester.tap(find.byKey(const Key('playground_open_test_lab')));
  await tester.pumpAndSettle();
}

Future<void> _openUnifiedShowcase(WidgetTester tester) async {
  await tester.pumpWidget(const MyApp());

  await tester.tap(find.byKey(const Key('playground_open_unified_showcase')));
  await tester.pumpAndSettle();
}

Future<void> _openSearchSuggestionsFeaturedScene(WidgetTester tester) async {
  await _openTestLab(tester);

  final toggle = find.byKey(const Key('top_surface_search_suggestions_toggle'));
  await _bringFinderIntoComfortableView(tester, toggle);
  await tester.tap(toggle.hitTestable());
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 150));
  await tester.pumpAndSettle();
}

Future<void> _openBookingFilterPanel(WidgetTester tester) async {
  await _openTestLab(tester);

  final toggle = find.byKey(
    const Key('inline_trigger_booking_slot_filter_toggle'),
  );
  await _bringFinderIntoComfortableView(tester, toggle);
  await tester.tap(toggle.hitTestable());
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 150));
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

Future<void> _tapFilterBackdropAtSafeSpot(
  WidgetTester tester,
  Finder backdropFinder,
) async {
  final backdropRect = tester.getRect(backdropFinder);
  final target = backdropRect.topLeft + const Offset(12, 12);

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

Future<void> _bringUnifiedFinderIntoComfortableView(
  WidgetTester tester,
  Finder finder,
) async {
  final page = _unifiedShowcasePageScrollable();

  var attempts = 0;
  while (finder.evaluate().isEmpty && attempts < 20) {
    await tester.drag(page, const Offset(0, -260));
    await tester.pumpAndSettle();
    attempts += 1;
  }

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
        of: find.byKey(const Key('test_family_list')),
        matching: find.byType(Scrollable),
      )
      .first;
}

Finder _unifiedShowcasePageScrollable() {
  return find
      .descendant(
        of: find.byKey(const Key('unified_showcase_page')),
        matching: find.byType(Scrollable),
      )
      .first;
}
