// spring_surface - liquid spring expand/collapse widget for Flutter.
//
// Usage (Widget-only):
// SpringSurface(
//   isExpanded: _isExpanded,
//   anchor: SpringSurfaceAnchor.bottomLeft,
//   config: SpringSurfaceConfig.gentle(),
//   collapsedChild: MyButton(),
//   expandedChild: MySheet(),
// )
//
// Pending usage:
// SpringSurface(
//   isExpanded: false,
//   contentState: SpringSurfaceContentState.pending,
//   collapsedSize: const Size(200, 48),
//   collapsedChild: const Text('Waiting for data'),
// )
//
// Usage (Controller):
// final controller = SpringSurfaceController(
//   vsync: this,
//   config: SpringSurfaceConfig(stiffness: 220, damping: 18),
// );
// controller.expand();
// controller.collapse();
export 'src/spring_surface_config.dart';
export 'src/spring_surface_actions.dart';
export 'src/spring_surface_motion.dart';
export 'src/spring_surface_controller.dart';
export 'src/spring_surface.dart';
