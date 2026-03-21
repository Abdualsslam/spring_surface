import 'package:flutter/widgets.dart';

import 'elastic_sheet_controller.dart';

/// Exposes [SpringSurfaceController] actions to descendants.
///
/// This scope is injected automatically by [SpringSurface.controlled], so any
/// descendant inside the collapsed or expanded content can open, close, toggle,
/// or pulse the surface without wiring those callbacks through the widget tree.
class SpringSurfaceActions extends InheritedNotifier<SpringSurfaceController> {
  const SpringSurfaceActions({
    super.key,
    required SpringSurfaceController controller,
    required super.child,
  }) : super(notifier: controller);

  SpringSurfaceController get controller => notifier!;

  bool get isExpanded => controller.isExpanded;
  bool get isAnimating => controller.isAnimating;
  bool get isPulsing => controller.isPulsing;

  Future<void> expand() => controller.expand();
  Future<void> collapse() => controller.collapse();
  Future<void> toggle() => controller.toggle();
  Future<void> pulse() => controller.pulse();

  static SpringSurfaceActions of(BuildContext context) {
    final actions = maybeOf(context);
    if (actions != null) {
      return actions;
    }

    throw FlutterError.fromParts([
      ErrorSummary(
        'SpringSurfaceActions.of() called with no scope in context.',
      ),
      ErrorDescription(
        'SpringSurfaceActions are only available below SpringSurface.controlled.',
      ),
      ErrorHint(
        'Wrap the interactive content inside SpringSurface.controlled, then call '
        'SpringSurfaceActions.of(context) from a descendant widget or Builder.',
      ),
    ]);
  }

  static SpringSurfaceActions? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<SpringSurfaceActions>();
  }
}
