import 'package:spring_surface/spring_surface.dart';

enum PlaygroundPlacement { top, center, bottom }

const List<List<SpringSurfaceAnchor>> playgroundAnchorGrid = [
  [
    SpringSurfaceAnchor.topLeft,
    SpringSurfaceAnchor.topCenter,
    SpringSurfaceAnchor.topRight,
  ],
  [
    SpringSurfaceAnchor.centerLeft,
    SpringSurfaceAnchor.center,
    SpringSurfaceAnchor.centerRight,
  ],
  [
    SpringSurfaceAnchor.bottomLeft,
    SpringSurfaceAnchor.bottomCenter,
    SpringSurfaceAnchor.bottomRight,
  ],
];

const String playgroundCollapsedLabelText = 'بيانات الطلب';
const String playgroundExpandedHeadingText = 'معلومات الحساب';
const String playgroundConfirmPaymentText = 'تأكيد الدفع';
const String playgroundOvershootDescriptionText =
    'يحدد مقدار السماح بتجاوز الحجم المستهدف أثناء الحركة. رفعه يزيد الارتداد والامتلاء البصري.';
const String playgroundExpandedWidthDescriptionText =
    'يحدد العرض النهائي للقطعة عندما تكون في الحالة المتمددة.';
const String playgroundExpandedHeightDescriptionText =
    'يحدد الارتفاع النهائي للقطعة عندما تكون في الحالة المتمددة.';
const String playgroundExpandDescriptionText =
    'مدة فتح القطعة بالملي ثانية. القيم الأكبر تعطي فتحاً أبطأ وأكثر هدوءاً.';
const String playgroundCollapseDescriptionText =
    'مدة إغلاق القطعة بالملي ثانية. القيم الأكبر تعطي إغلاقاً أبطأ وأكثر سلاسة.';
const String playgroundButtonWidthDescriptionText =
    'يتحكم في عرض الزر الأساسي قبل التمدد داخل صفحة المثال.';
const String playgroundButtonHeightDescriptionText =
    'يتحكم في ارتفاع الزر الأساسي قبل التمدد داخل صفحة المثال.';
const String playgroundPlacementDescriptionText =
    'يحدد موضع القطعة داخل مساحة العرض في المثال: أعلى أو وسط أو أسفل.';
const String playgroundCloseDialogText = 'إغلاق';
const String playgroundReboundDescriptionText =
    'Choose how the late rebound travels across the surface. Sequential cross-axis transfers tension vertically first on open, then horizontally, and reverses the order on collapse.';
const String playgroundAnchorDescriptionText =
    'Choose the edge or corner that stays pinned while the surface grows. In dynamicHeight, the horizontal part collapses back to the center column.';
const String playgroundAnchorFootnoteText =
    'Combined corner anchors matter in fixed sizing. Dynamic height keeps only the vertical row.';

String playgroundAnchorLabel(SpringSurfaceAnchor anchor) {
  switch (anchor) {
    case SpringSurfaceAnchor.topLeft:
      return 'TL';
    case SpringSurfaceAnchor.topCenter:
      return 'T';
    case SpringSurfaceAnchor.topRight:
      return 'TR';
    case SpringSurfaceAnchor.centerLeft:
      return 'L';
    case SpringSurfaceAnchor.center:
      return 'C';
    case SpringSurfaceAnchor.centerRight:
      return 'R';
    case SpringSurfaceAnchor.bottomLeft:
      return 'BL';
    case SpringSurfaceAnchor.bottomCenter:
      return 'B';
    case SpringSurfaceAnchor.bottomRight:
      return 'BR';
  }
}
