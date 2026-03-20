import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'spring_surface.dart';
import 'spring_surface_config.dart';

part 'test_lab/showcase_shell.dart';
part 'test_lab/orders_filter_showcase.dart';
part 'test_lab/search_suggestions_showcase.dart';
part 'test_lab/ticket_actions_showcase.dart';
part 'test_lab/booking_slot_showcase.dart';
part 'test_lab/settings_inline_showcase.dart';
part 'test_lab/message_composer_showcase.dart';
part 'test_lab/checkout_summary_showcase.dart';
part 'test_lab/showcase_shared_widgets.dart';

enum _ScenarioPresentation { compact, detail }

extension on _ScenarioPresentation {
  bool get isDetail => this == _ScenarioPresentation.detail;
}

enum _OrdersFilterPreset { today, urgent, prepaid }

enum _SearchQueryPreset { sara, contracts, invoices }

enum _TicketStatus { open, waitingCustomer, escalated }

enum _BookingKind { consultation, followUp, call }

enum _NotificationMode { all, importantOnly, silent }

enum _ComposerMode { file, image, voice }

enum _PaymentMethod { mada, applePay, card }

class _ShowcaseScenarioDefinition {
  const _ShowcaseScenarioDefinition({
    required this.id,
    required this.title,
    required this.description,
    required this.detailSummary,
    required this.compactPreviewBuilder,
    required this.detailExperienceBuilder,
  });

  final String id;
  final String title;
  final String description;
  final String detailSummary;
  final Widget Function() compactPreviewBuilder;
  final Widget Function() detailExperienceBuilder;

  Key get detailButtonKey => Key('${id}_detail_button');
  Key get detailPageKey => Key('${id}_detail_page');
}

final List<_ShowcaseScenarioDefinition> _showcaseScenarioDefinitions = [
  _ShowcaseScenarioDefinition(
    id: 'orders_filter',
    title: 'فلتر الطلبات',
    description:
        'Chip طبيعي داخل شريط الأدوات يمتد إلى الأسفل فوق قائمة الطلبات.',
    detailSummary:
        'يعرض هذا المثال كيف يصبح الفلتر جزءاً من شريط العمليات نفسه، مع بيانات حية تتغير حسب نوع الفرز المختار.',
    compactPreviewBuilder: _buildOrdersFilterCompactPreview,
    detailExperienceBuilder: _buildOrdersFilterDetailExperience,
  ),
  _ShowcaseScenarioDefinition(
    id: 'search_suggestions',
    title: 'اقتراحات البحث',
    description:
        'حقل البحث نفسه يتمدد إلى اقتراحات حية بدون أن يبدو كعنصر عائم.',
    detailSummary:
        'هذا السيناريو يحاكي بحثاً حقيقياً داخل قائمة محادثات، ويُظهر كيف تتغير الاقتراحات والنتائج مع عبارة البحث.',
    compactPreviewBuilder: _buildSearchSuggestionsCompactPreview,
    detailExperienceBuilder: _buildSearchSuggestionsDetailExperience,
  ),
  _ShowcaseScenarioDefinition(
    id: 'ticket_actions',
    title: 'إجراءات التذكرة',
    description:
        'شريط إجراء مدمج داخل بطاقة دعم يتمدد من الوسط فوق محتوى البطاقة.',
    detailSummary:
        'المثال يوضح سيناريو مكتب دعم حقيقي، حيث تتبدل حالة التذكرة ويستجيب السطح المتمدد بمحتوى مناسب لكل حالة.',
    compactPreviewBuilder: _buildTicketActionsCompactPreview,
    detailExperienceBuilder: _buildTicketActionsDetailExperience,
  ),
  _ShowcaseScenarioDefinition(
    id: 'booking_slot',
    title: 'إنشاء حجز سريع',
    description: 'خلية مواعيد صغيرة تتحول إلى محرر حجز مختصر من نفس الموضع.',
    detailSummary:
        'يعرض المثال كيف يمكن لسطح صغير داخل شبكة المواعيد أن يتمدد إلى محرر حجز سريع مع تبديل نوع الزيارة.',
    compactPreviewBuilder: _buildBookingSlotCompactPreview,
    detailExperienceBuilder: _buildBookingSlotDetailExperience,
  ),
  _ShowcaseScenarioDefinition(
    id: 'settings_inline',
    title: 'إعدادات موسعة',
    description:
        'صف إعدادات inline يكشف خيارات إضافية داخل شاشة تفضيلات حقيقية.',
    detailSummary:
        'هذا المثال يركز على الإعدادات المضمنة داخل القوائم، مع تغيير نمط الإشعارات وانعكاسه مباشرة على الواجهة.',
    compactPreviewBuilder: _buildSettingsInlineCompactPreview,
    detailExperienceBuilder: _buildSettingsInlineDetailExperience,
  ),
  _ShowcaseScenarioDefinition(
    id: 'message_composer',
    title: 'مؤلف الرسائل',
    description:
        'شريط كتابة سفلي يتمدد للأعلى ليكشف المرفقات والإجراءات السريعة.',
    detailSummary:
        'المشهد يحاكي مؤلف رسائل فعلي، مع تبديل وضع الإرسال بين ملف وصورة وملاحظة صوتية داخل نفس الواجهة.',
    compactPreviewBuilder: _buildMessageComposerCompactPreview,
    detailExperienceBuilder: _buildMessageComposerDetailExperience,
  ),
  _ShowcaseScenarioDefinition(
    id: 'checkout_summary',
    title: 'ملخص الدفع',
    description: 'Checkout dock bar مثبت أسفل السلة يتمدد إلى ملخص دفع كامل.',
    detailSummary:
        'يعرض المثال شريط الدفع السفلي داخل سلة شراء، مع تبديل طريقة الدفع وانعكاسها على الملخص والسطر السفلي.',
    compactPreviewBuilder: _buildCheckoutSummaryCompactPreview,
    detailExperienceBuilder: _buildCheckoutSummaryDetailExperience,
  ),
];

class SpringSurfaceTestLabPage extends StatelessWidget {
  const SpringSurfaceTestLabPage({super.key});

  static const String routeName = '/test-lab';

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFFF1F4FA),
        appBar: AppBar(
          backgroundColor: const Color(0xFFF1F4FA),
          surfaceTintColor: Colors.transparent,
          title: const Text('معرض Spring Surface'),
        ),
        body: SafeArea(
          child: ListView(
            key: const Key('test_showcase_list'),
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
            children: [
              const _PageHero(),
              for (final definition in _showcaseScenarioDefinitions) ...[
                const SizedBox(height: 18),
                _ScenarioSection(definition: definition),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
