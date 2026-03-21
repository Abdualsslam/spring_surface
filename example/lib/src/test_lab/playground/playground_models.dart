import 'package:elastic_sheet/elastic_sheet.dart';

enum PlaygroundPlacement { top, center, bottom }

const List<List<ElasticSheetAnchor>> playgroundAnchorGrid = [
  [
    ElasticSheetAnchor.topLeft,
    ElasticSheetAnchor.topCenter,
    ElasticSheetAnchor.topRight,
  ],
  [
    ElasticSheetAnchor.centerLeft,
    ElasticSheetAnchor.center,
    ElasticSheetAnchor.centerRight,
  ],
  [
    ElasticSheetAnchor.bottomLeft,
    ElasticSheetAnchor.bottomCenter,
    ElasticSheetAnchor.bottomRight,
  ],
];

const String playgroundCollapsedLabelText = 'Ø¨ÙŠØ§Ù†Ø§Øª Ø§Ù„Ø·Ù„Ø¨';
const String playgroundExpandedHeadingText = 'Ù…Ø¹Ù„ÙˆÙ…Ø§Øª Ø§Ù„Ø­Ø³Ø§Ø¨';
const String playgroundConfirmPaymentText = 'ØªØ£ÙƒÙŠØ¯ Ø§Ù„Ø¯ÙØ¹';
const String playgroundOvershootDescriptionText =
    'ÙŠØ­Ø¯Ø¯ Ù…Ù‚Ø¯Ø§Ø± Ø§Ù„Ø³Ù…Ø§Ø­ Ø¨ØªØ¬Ø§ÙˆØ² Ø§Ù„Ø­Ø¬Ù… Ø§Ù„Ù…Ø³ØªÙ‡Ø¯Ù Ø£Ø«Ù†Ø§Ø¡ Ø§Ù„Ø­Ø±ÙƒØ©. Ø±ÙØ¹Ù‡ ÙŠØ²ÙŠØ¯ Ø§Ù„Ø§Ø±ØªØ¯Ø§Ø¯ ÙˆØ§Ù„Ø§Ù…ØªÙ„Ø§Ø¡ Ø§Ù„Ø¨ØµØ±ÙŠ.';
const String playgroundExpandedWidthDescriptionText =
    'ÙŠØ­Ø¯Ø¯ Ø§Ù„Ø¹Ø±Ø¶ Ø§Ù„Ù†Ù‡Ø§Ø¦ÙŠ Ù„Ù„Ù‚Ø·Ø¹Ø© Ø¹Ù†Ø¯Ù…Ø§ ØªÙƒÙˆÙ† ÙÙŠ Ø§Ù„Ø­Ø§Ù„Ø© Ø§Ù„Ù…ØªÙ…Ø¯Ø¯Ø©.';
const String playgroundExpandedHeightDescriptionText =
    'ÙŠØ­Ø¯Ø¯ Ø§Ù„Ø§Ø±ØªÙØ§Ø¹ Ø§Ù„Ù†Ù‡Ø§Ø¦ÙŠ Ù„Ù„Ù‚Ø·Ø¹Ø© Ø¹Ù†Ø¯Ù…Ø§ ØªÙƒÙˆÙ† ÙÙŠ Ø§Ù„Ø­Ø§Ù„Ø© Ø§Ù„Ù…ØªÙ…Ø¯Ø¯Ø©.';
const String playgroundExpandDescriptionText =
    'Ù…Ø¯Ø© ÙØªØ­ Ø§Ù„Ù‚Ø·Ø¹Ø© Ø¨Ø§Ù„Ù…Ù„ÙŠ Ø«Ø§Ù†ÙŠØ©. Ø§Ù„Ù‚ÙŠÙ… Ø§Ù„Ø£ÙƒØ¨Ø± ØªØ¹Ø·ÙŠ ÙØªØ­Ø§Ù‹ Ø£Ø¨Ø·Ø£ ÙˆØ£ÙƒØ«Ø± Ù‡Ø¯ÙˆØ¡Ø§Ù‹.';
const String playgroundCollapseDescriptionText =
    'Ù…Ø¯Ø© Ø¥ØºÙ„Ø§Ù‚ Ø§Ù„Ù‚Ø·Ø¹Ø© Ø¨Ø§Ù„Ù…Ù„ÙŠ Ø«Ø§Ù†ÙŠØ©. Ø§Ù„Ù‚ÙŠÙ… Ø§Ù„Ø£ÙƒØ¨Ø± ØªØ¹Ø·ÙŠ Ø¥ØºÙ„Ø§Ù‚Ø§Ù‹ Ø£Ø¨Ø·Ø£ ÙˆØ£ÙƒØ«Ø± Ø³Ù„Ø§Ø³Ø©.';
const String playgroundButtonWidthDescriptionText =
    'ÙŠØªØ­ÙƒÙ… ÙÙŠ Ø¹Ø±Ø¶ Ø§Ù„Ø²Ø± Ø§Ù„Ø£Ø³Ø§Ø³ÙŠ Ù‚Ø¨Ù„ Ø§Ù„ØªÙ…Ø¯Ø¯ Ø¯Ø§Ø®Ù„ ØµÙØ­Ø© Ø§Ù„Ù…Ø«Ø§Ù„.';
const String playgroundButtonHeightDescriptionText =
    'ÙŠØªØ­ÙƒÙ… ÙÙŠ Ø§Ø±ØªÙØ§Ø¹ Ø§Ù„Ø²Ø± Ø§Ù„Ø£Ø³Ø§Ø³ÙŠ Ù‚Ø¨Ù„ Ø§Ù„ØªÙ…Ø¯Ø¯ Ø¯Ø§Ø®Ù„ ØµÙØ­Ø© Ø§Ù„Ù…Ø«Ø§Ù„.';
const String playgroundPlacementDescriptionText =
    'ÙŠØ­Ø¯Ø¯ Ù…ÙˆØ¶Ø¹ Ø§Ù„Ù‚Ø·Ø¹Ø© Ø¯Ø§Ø®Ù„ Ù…Ø³Ø§Ø­Ø© Ø§Ù„Ø¹Ø±Ø¶ ÙÙŠ Ø§Ù„Ù…Ø«Ø§Ù„: Ø£Ø¹Ù„Ù‰ Ø£Ùˆ ÙˆØ³Ø· Ø£Ùˆ Ø£Ø³ÙÙ„.';
const String playgroundCloseDialogText = 'Ø¥ØºÙ„Ø§Ù‚';
const String playgroundReboundDescriptionText =
    'Choose how the late rebound travels across the surface. Sequential cross-axis transfers tension vertically first on open, then horizontally, and reverses the order on collapse.';
const String playgroundAnchorDescriptionText =
    'Choose the edge or corner that stays pinned while the surface grows. In dynamicHeight, the horizontal part collapses back to the center column.';
const String playgroundAnchorFootnoteText =
    'Combined corner anchors matter in fixed sizing. Dynamic height keeps only the vertical row.';

String playgroundAnchorLabel(ElasticSheetAnchor anchor) {
  switch (anchor) {
    case ElasticSheetAnchor.topLeft:
      return 'TL';
    case ElasticSheetAnchor.topCenter:
      return 'T';
    case ElasticSheetAnchor.topRight:
      return 'TR';
    case ElasticSheetAnchor.centerLeft:
      return 'L';
    case ElasticSheetAnchor.center:
      return 'C';
    case ElasticSheetAnchor.centerRight:
      return 'R';
    case ElasticSheetAnchor.bottomLeft:
      return 'BL';
    case ElasticSheetAnchor.bottomCenter:
      return 'B';
    case ElasticSheetAnchor.bottomRight:
      return 'BR';
  }
}
