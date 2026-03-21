// elastic_sheet - elastic expand/collapse widget for Flutter.
//
// Usage (Widget-only):
// ElasticSheet(
//   isExpanded: _isExpanded,
//   anchor: ElasticSheetAnchor.bottomLeft,
//   config: ElasticSheetConfig.gentle(),
//   collapsedChild: MyButton(),
//   expandedChild: MySheet(),
// )
//
// Pending usage:
// ElasticSheet(
//   isExpanded: false,
//   contentState: ElasticSheetContentState.pending,
//   collapsedSize: const Size(200, 48),
//   collapsedChild: const Text('Waiting for data'),
// )
//
// Usage (Controller):
// final controller = ElasticSheetController(
//   vsync: this,
//   config: ElasticSheetConfig(stiffness: 220, damping: 18),
// );
// controller.expand();
// controller.collapse();
export 'src/elastic_sheet_actions.dart';
export 'src/elastic_sheet_config.dart';
export 'src/elastic_sheet_controller.dart';
export 'src/elastic_sheet_motion.dart';
export 'src/elastic_sheet.dart';
