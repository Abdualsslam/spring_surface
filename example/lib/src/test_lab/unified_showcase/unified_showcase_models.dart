import 'package:flutter/material.dart';

enum UnifiedShowcaseFilterPreset { urgent, labs, followUps }

enum UnifiedShowcaseLocale { english, arabic }

class UnifiedShowcaseStrings {
  const UnifiedShowcaseStrings({
    required this.appBarTitle,
    required this.headerTitle,
    required this.headerSubtitle,
    required this.metricPatientsWaiting,
    required this.metricLabsToReview,
    required this.headerPatientName,
    required this.headerPatientStatus,
    required this.headerPatientRoom,
    required this.searchTriggerLabel,
    required this.searchPanelTitle,
    required this.searchFieldHint,
    required this.searchPatientsLabel,
    required this.searchLabsLabel,
    required this.searchMessagesLabel,
    required this.searchResultPrimaryTitle,
    required this.searchResultPrimarySubtitle,
    required this.searchResultSecondaryTitle,
    required this.searchResultSecondarySubtitle,
    required this.filterPanelTitle,
    required this.filterUrgentLabel,
    required this.filterLabsLabel,
    required this.filterFollowUpsLabel,
    required this.filterUrgentSummary,
    required this.filterLabsSummary,
    required this.filterFollowUpsSummary,
    required this.scheduleTitle,
    required this.scheduleVisitsCount,
    required this.scheduleDayTuesday,
    required this.scheduleDayWednesday,
    required this.scheduleDayFriday,
    required this.scheduleCardPrimaryTitle,
    required this.scheduleCardPrimarySubtitle,
    required this.scheduleCardPrimaryTrailing,
    required this.scheduleCardSecondaryTitle,
    required this.scheduleCardSecondarySubtitle,
    required this.scheduleCardSecondaryTrailing,
    required this.dayPanelTitle,
    required this.dayPanelPrimaryTime,
    required this.dayPanelPrimaryDetail,
    required this.dayPanelSecondaryTime,
    required this.dayPanelSecondaryDetail,
    required this.dayPanelTertiaryTime,
    required this.dayPanelTertiaryDetail,
    required this.dayPanelNote,
    required this.daySurfaceShortLabel,
    required this.daySurfaceTitle,
    required this.activityTitle,
    required this.activitySubtitle,
    required this.activityMessageTitle,
    required this.activityMessageSubtitle,
    required this.activityMessageTrailing,
    required this.activityInboundMessage,
    required this.activityOutboundMessage,
    required this.composerPanelTitle,
    required this.composerAttachTitle,
    required this.composerAttachSubtitle,
    required this.composerFollowUpTitle,
    required this.composerFollowUpSubtitle,
    required this.composerChannelLabel,
    required this.composerChannelValue,
    required this.composerInputHint,
    required this.composerDraftTitle,
    required this.composerDraftEmpty,
    required this.localePanelTitle,
    required this.localePanelHint,
    required this.localeEnglishLabel,
    required this.localeArabicLabel,
    required this.defaultDraftText,
  });

  final String appBarTitle;
  final String headerTitle;
  final String headerSubtitle;
  final String metricPatientsWaiting;
  final String metricLabsToReview;
  final String headerPatientName;
  final String headerPatientStatus;
  final String headerPatientRoom;
  final String searchTriggerLabel;
  final String searchPanelTitle;
  final String searchFieldHint;
  final String searchPatientsLabel;
  final String searchLabsLabel;
  final String searchMessagesLabel;
  final String searchResultPrimaryTitle;
  final String searchResultPrimarySubtitle;
  final String searchResultSecondaryTitle;
  final String searchResultSecondarySubtitle;
  final String filterPanelTitle;
  final String filterUrgentLabel;
  final String filterLabsLabel;
  final String filterFollowUpsLabel;
  final String filterUrgentSummary;
  final String filterLabsSummary;
  final String filterFollowUpsSummary;
  final String scheduleTitle;
  final String scheduleVisitsCount;
  final String scheduleDayTuesday;
  final String scheduleDayWednesday;
  final String scheduleDayFriday;
  final String scheduleCardPrimaryTitle;
  final String scheduleCardPrimarySubtitle;
  final String scheduleCardPrimaryTrailing;
  final String scheduleCardSecondaryTitle;
  final String scheduleCardSecondarySubtitle;
  final String scheduleCardSecondaryTrailing;
  final String dayPanelTitle;
  final String dayPanelPrimaryTime;
  final String dayPanelPrimaryDetail;
  final String dayPanelSecondaryTime;
  final String dayPanelSecondaryDetail;
  final String dayPanelTertiaryTime;
  final String dayPanelTertiaryDetail;
  final String dayPanelNote;
  final String daySurfaceShortLabel;
  final String daySurfaceTitle;
  final String activityTitle;
  final String activitySubtitle;
  final String activityMessageTitle;
  final String activityMessageSubtitle;
  final String activityMessageTrailing;
  final String activityInboundMessage;
  final String activityOutboundMessage;
  final String composerPanelTitle;
  final String composerAttachTitle;
  final String composerAttachSubtitle;
  final String composerFollowUpTitle;
  final String composerFollowUpSubtitle;
  final String composerChannelLabel;
  final String composerChannelValue;
  final String composerInputHint;
  final String composerDraftTitle;
  final String composerDraftEmpty;
  final String localePanelTitle;
  final String localePanelHint;
  final String localeEnglishLabel;
  final String localeArabicLabel;
  final String defaultDraftText;
}

const englishUnifiedShowcaseStrings = UnifiedShowcaseStrings(
  appBarTitle: 'Care Desk',
  headerTitle: 'Thursday overview',
  headerSubtitle:
      'Morning care plans, labs, and family follow-ups in one place.',
  metricPatientsWaiting: 'Patients waiting',
  metricLabsToReview: 'Labs to review',
  headerPatientName: 'Abdulsalam Muaad',
  headerPatientStatus: 'Needs wound review before 11:00',
  headerPatientRoom: 'Room 4',
  searchTriggerLabel: 'Search patient, lab, or message',
  searchPanelTitle: 'Search records',
  searchFieldHint: 'Type a patient, lab, or message',
  searchPatientsLabel: 'Patients',
  searchLabsLabel: 'Labs',
  searchMessagesLabel: 'Messages',
  searchResultPrimaryTitle: 'Abdulsalam Muaad',
  searchResultPrimarySubtitle: 'Lab review + care note',
  searchResultSecondaryTitle: 'Ali Khaled',
  searchResultSecondarySubtitle: 'Medication callback',
  filterPanelTitle: 'Quick filters',
  filterUrgentLabel: 'Urgent',
  filterLabsLabel: 'Lab results',
  filterFollowUpsLabel: 'Follow-ups',
  filterUrgentSummary:
      'Show patients with overdue replies, escalations, and same-day approvals.',
  filterLabsSummary:
      'Focus on patients waiting for lab review, callbacks, or medication updates.',
  filterFollowUpsSummary:
      'Keep only ongoing care plans that still need outreach after today.',
  scheduleTitle: 'Today schedule',
  scheduleVisitsCount: '5 visits',
  scheduleDayTuesday: 'Tue',
  scheduleDayWednesday: 'Wed',
  scheduleDayFriday: 'Fri',
  scheduleCardPrimaryTitle: '09:15 Abdulsalam Muaad',
  scheduleCardPrimarySubtitle: 'Wound review and care plan update',
  scheduleCardPrimaryTrailing: 'Room 4',
  scheduleCardSecondaryTitle: '11:00 Ali Khaled',
  scheduleCardSecondarySubtitle: 'Medication check after lab callback',
  scheduleCardSecondaryTrailing: 'Call',
  dayPanelTitle: 'Thursday details',
  dayPanelPrimaryTime: '09:15',
  dayPanelPrimaryDetail: 'Maya Hassan · wound review',
  dayPanelSecondaryTime: '11:00',
  dayPanelSecondaryDetail: 'Noor Salem · medication callback',
  dayPanelTertiaryTime: '14:30',
  dayPanelTertiaryDetail: 'Family note · discharge plan',
  dayPanelNote:
      'One callback still depends on lab confirmation, so the day tile expands without moving the rest of the schedule.',
  daySurfaceShortLabel: 'Thu',
  daySurfaceTitle: 'Today',
  activityTitle: 'Care team feed',
  activitySubtitle: 'Latest updates from the shift',
  activityMessageTitle: 'Coordinator',
  activityMessageSubtitle:
      'Lab review is back. Maya can leave after the 11:00 note.',
  activityMessageTrailing: 'Now',
  activityInboundMessage:
      'Please send the wound care steps to the family and book the next visit for Thursday morning.',
  activityOutboundMessage:
      'Shared. I also added a reminder for the medication callback after lunch.',
  composerPanelTitle: 'Care reply',
  composerAttachTitle: 'Attach lab',
  composerAttachSubtitle: 'Send the latest PDF and note',
  composerFollowUpTitle: 'Create follow-up',
  composerFollowUpSubtitle: 'Book next Thursday morning',
  composerChannelLabel: 'Channel',
  composerChannelValue: 'Family thread',
  composerInputHint: 'Reply to the family thread',
  composerDraftTitle: 'Draft in progress',
  composerDraftEmpty: 'Type a reply from the bottom dock.',
  localePanelTitle: 'Language',
  localePanelHint: 'Change the page copy and reading direction instantly.',
  localeEnglishLabel: 'English',
  localeArabicLabel: 'العربية',
  defaultDraftText:
      'Call Maya after the lab review and confirm Thursday follow-up.',
);

const arabicUnifiedShowcaseStrings = UnifiedShowcaseStrings(
  appBarTitle: 'مكتب الرعاية',
  headerTitle: 'نظرة الخميس',
  headerSubtitle:
      'خطط الصباح، مراجعات المختبر، ومتابعات العائلة في شاشة واحدة.',
  metricPatientsWaiting: 'المرضى بانتظار الرد',
  metricLabsToReview: 'نتائج تحتاج مراجعة',
  headerPatientName: 'عبدالسلام معاد',
  headerPatientStatus: 'تحتاج مراجعة الجرح قبل 11:00',
  headerPatientRoom: 'الغرفة 4',
  searchTriggerLabel: 'ابحث عن مريض أو نتيجة أو رسالة',
  searchPanelTitle: 'البحث في السجلات',
  searchFieldHint: 'اكتب اسم مريض أو نتيجة أو رسالة',
  searchPatientsLabel: 'المرضى',
  searchLabsLabel: 'المختبر',
  searchMessagesLabel: 'الرسائل',
  searchResultPrimaryTitle: 'عبدالسلام معاد',
  searchResultPrimarySubtitle: 'مراجعة مختبر + ملاحظة رعاية',
  searchResultSecondaryTitle: 'نور سالم',
  searchResultSecondarySubtitle: 'متابعة الدواء',
  filterPanelTitle: 'فلاتر سريعة',
  filterUrgentLabel: 'عاجل',
  filterLabsLabel: 'نتائج المختبر',
  filterFollowUpsLabel: 'متابعات',
  filterUrgentSummary:
      'اعرض الحالات ذات الردود المتأخرة، والتصعيدات، والموافقات المطلوبة اليوم.',
  filterLabsSummary:
      'ركز على المرضى المنتظرين لمراجعة المختبر أو الاتصال أو تحديث العلاج.',
  filterFollowUpsSummary:
      'احتفظ فقط بخطط الرعاية المستمرة التي ما زالت تحتاج متابعة بعد اليوم.',
  scheduleTitle: 'جدول اليوم',
  scheduleVisitsCount: '5 زيارات',
  scheduleDayTuesday: 'الث',
  scheduleDayWednesday: 'الأر',
  scheduleDayFriday: 'الجم',
  scheduleCardPrimaryTitle: '09:15 عبدالسلام معاد',
  scheduleCardPrimarySubtitle: 'مراجعة الجرح وتحديث خطة الرعاية',
  scheduleCardPrimaryTrailing: 'الغرفة 4',
  scheduleCardSecondaryTitle: '11:00 علي خالد',
  scheduleCardSecondarySubtitle: 'متابعة الدواء بعد الاتصال بنتيجة المختبر',
  scheduleCardSecondaryTrailing: 'اتصال',
  dayPanelTitle: 'تفاصيل الخميس',
  dayPanelPrimaryTime: '09:15',
  dayPanelPrimaryDetail: 'عبدالسلام معاد · مراجعة الجرح',
  dayPanelSecondaryTime: '11:00',
  dayPanelSecondaryDetail: 'علي خالد · متابعة الدواء',
  dayPanelTertiaryTime: '14:30',
  dayPanelTertiaryDetail: 'ملاحظة عائلية · خطة الخروج',
  dayPanelNote:
      'ما زال هناك اتصال واحد يعتمد على تأكيد المختبر، لذلك تتمدد بطاقة اليوم بدون تحريك بقية الجدول.',
  daySurfaceShortLabel: 'الخم',
  daySurfaceTitle: 'اليوم',
  activityTitle: 'موجز فريق الرعاية',
  activitySubtitle: 'آخر المستجدات في الوردية',
  activityMessageTitle: 'المنسق',
  activityMessageSubtitle:
      'وصلت نتيجة المختبر. يمكن لعبدالسلام المغادرة بعد ملاحظة 11:00.',
  activityMessageTrailing: 'الآن',
  activityInboundMessage:
      'أرسلوا خطوات العناية بالجرح للعائلة وحددوا الزيارة التالية صباح الخميس.',
  activityOutboundMessage:
      'تم الإرسال، وأضفت أيضاً تذكيراً لمتابعة الدواء بعد الظهر.',
  composerPanelTitle: 'رد الرعاية',
  composerAttachTitle: 'إرفاق نتيجة',
  composerAttachSubtitle: 'أرسل آخر ملف PDF مع الملاحظة',
  composerFollowUpTitle: 'إنشاء متابعة',
  composerFollowUpSubtitle: 'احجز صباح الخميس القادم',
  composerChannelLabel: 'القناة',
  composerChannelValue: 'محادثة العائلة',
  composerInputHint: 'اكتب رداً لمحادثة العائلة',
  composerDraftTitle: 'مسودة قيد التحرير',
  composerDraftEmpty: 'اكتب الرد من الشريط السفلي.',
  localePanelTitle: 'اللغة',
  localePanelHint: 'غيّر نصوص الصفحة واتجاه القراءة مباشرة.',
  localeEnglishLabel: 'English',
  localeArabicLabel: 'العربية',
  defaultDraftText:
      'اتصل بعبدالسلام بعد مراجعة المختبر وأكد متابعة يوم الخميس.',
);

extension UnifiedShowcaseLocaleX on UnifiedShowcaseLocale {
  bool get isArabic => this == UnifiedShowcaseLocale.arabic;

  TextDirection get textDirection =>
      isArabic ? TextDirection.rtl : TextDirection.ltr;

  UnifiedShowcaseStrings get strings =>
      isArabic ? arabicUnifiedShowcaseStrings : englishUnifiedShowcaseStrings;
}
