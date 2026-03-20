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

    expect(find.byType(AlertDialog), findsOneWidget);

    await tester.tap(find.byType(TextButton));
    await tester.pumpAndSettle();

    expect(find.byType(AlertDialog), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Playground exposes and switches rebound profiles', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());

    await tester.ensureVisible(
      find.byKey(const Key('playground_rebound_sequential')),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('playground_rebound_sequential')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('playground_rebound_simultaneous')));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('playground_preset_natural')), findsOneWidget);
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

  testWidgets('Playground only exposes the grouped showcase entry', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());

    expect(find.byKey(const Key('playground_open_test_lab')), findsNothing);
    expect(
      find.byKey(const Key('playground_open_unified_showcase')),
      findsOneWidget,
    );
  });

  testWidgets('Playground opens the unified showcase route', (
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

  testWidgets('Unified showcase pending queue cell pulses only', (
    WidgetTester tester,
  ) async {
    await _openUnifiedShowcase(tester);

    final surface = find.byKey(
      const Key('unified_showcase_middle_queue_surface'),
    );
    final clip = find.descendant(of: surface, matching: find.byType(ClipRRect));
    await _bringUnifiedFinderIntoComfortableView(tester, surface);

    final initialSize = tester.getSize(clip);

    await tester.tapAt(tester.getCenter(clip));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 45));

    expect(tester.getSize(clip).width, closeTo(initialSize.width, 0.01));
    expect(
      find.byKey(const Key('unified_showcase_middle_day_backdrop')),
      findsNothing,
    );
    expect(
      find.byKey(const Key('unified_showcase_middle_availability_backdrop')),
      findsNothing,
    );

    await tester.pumpAndSettle();

    expect(tester.getSize(clip).width, closeTo(initialSize.width, 0.01));
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

  testWidgets('Unified showcase unavailable cell ignores taps', (
    WidgetTester tester,
  ) async {
    await _openUnifiedShowcase(tester);

    final surface = find.byKey(
      const Key('unified_showcase_middle_unavailable_surface'),
    );
    final clip = find.descendant(of: surface, matching: find.byType(ClipRRect));
    await _bringUnifiedFinderIntoComfortableView(tester, surface);

    final initialSize = tester.getSize(clip);

    await tester.tapAt(tester.getCenter(clip));
    await tester.pumpAndSettle();

    expect(tester.getSize(clip).width, closeTo(initialSize.width, 0.01));
    expect(
      find.byKey(const Key('unified_showcase_middle_day_backdrop')),
      findsNothing,
    );
    expect(
      find.byKey(const Key('unified_showcase_middle_availability_backdrop')),
      findsNothing,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('Unified showcase bottom composer edits and opens from plus', (
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
    final inputField = find.byKey(
      const Key('unified_showcase_bottom_composer_input_field'),
    );
    final expandButton = find.byKey(
      const Key('unified_showcase_bottom_composer_expand_button'),
    );
    const updatedDraft = 'Send the final review file tonight';

    expect(inputField, findsOneWidget);
    await tester.ensureVisible(inputField);
    await tester.pumpAndSettle();

    await tester.tap(inputField);
    await tester.pumpAndSettle();
    expect(
      find.byKey(const Key('unified_showcase_bottom_composer_backdrop')),
      findsNothing,
    );

    await tester.enterText(inputField, updatedDraft);
    await tester.pumpAndSettle();
    expect(_textFieldValue(tester, inputField), updatedDraft);

    await tester.tap(expandButton.hitTestable());
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 150));
    await tester.pumpAndSettle();

    final backdrop = find.byKey(
      const Key('unified_showcase_bottom_composer_backdrop'),
    );
    final draftPreview = find.byKey(
      const Key('unified_showcase_bottom_composer_draft_preview'),
    );
    expect(backdrop, findsOneWidget);
    expect(
      find.descendant(of: draftPreview, matching: find.text(updatedDraft)),
      findsOneWidget,
    );

    await _tapFilterBackdropAtSafeSpot(tester, backdrop);

    expect(_textFieldValue(tester, inputField), updatedDraft);
    expect(backdrop, findsNothing);
    expect(tester.takeException(), isNull);
  });
}

Future<void> _openUnifiedShowcase(WidgetTester tester) async {
  await tester.pumpWidget(const MyApp());

  await tester.tap(find.byKey(const Key('playground_open_unified_showcase')));
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

Finder _unifiedShowcasePageScrollable() {
  return find
      .descendant(
        of: find.byKey(const Key('unified_showcase_page')),
        matching: find.byType(Scrollable),
      )
      .first;
}

String _textFieldValue(WidgetTester tester, Finder finder) {
  final field = tester.widget<TextField>(finder);
  return field.controller?.text ?? '';
}
