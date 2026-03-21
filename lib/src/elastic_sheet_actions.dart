import 'package:flutter/widgets.dart';

import 'elastic_sheet_controller.dart';

/// Exposes [ElasticSheetController] actions to descendants.
///
/// This scope is injected automatically by [ElasticSheet.controlled], so any
/// descendant inside the collapsed or expanded content can open, close, toggle,
/// or pulse the surface without wiring those callbacks through the widget tree.
class ElasticSheetActions extends InheritedNotifier<ElasticSheetController> {
  const ElasticSheetActions({
    super.key,
    required ElasticSheetController controller,
    required super.child,
  }) : super(notifier: controller);

  ElasticSheetController get controller => notifier!;

  bool get isExpanded => controller.isExpanded;
  bool get isAnimating => controller.isAnimating;
  bool get isPulsing => controller.isPulsing;

  Future<void> expand() => controller.expand();
  Future<void> collapse() => controller.collapse();
  Future<void> toggle() => controller.toggle();
  Future<void> pulse() => controller.pulse();

  static ElasticSheetActions of(BuildContext context) {
    final actions = maybeOf(context);
    if (actions != null) {
      return actions;
    }

    throw FlutterError.fromParts([
      ErrorSummary('ElasticSheetActions.of() called with no scope in context.'),
      ErrorDescription(
        'ElasticSheetActions are only available below ElasticSheet.controlled.',
      ),
      ErrorHint(
        'Wrap the interactive content inside ElasticSheet.controlled, then call '
        'ElasticSheetActions.of(context) from a descendant widget or Builder.',
      ),
    ]);
  }

  static ElasticSheetActions? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<ElasticSheetActions>();
  }
}
