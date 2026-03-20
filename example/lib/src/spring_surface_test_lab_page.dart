import 'package:flutter/material.dart';

import 'test_lab/booking_slot_showcase.dart';
import 'test_lab/checkout_summary_showcase.dart';
import 'test_lab/message_composer_showcase.dart';
import 'test_lab/orders_filter_showcase.dart';
import 'test_lab/search_suggestions_showcase.dart';
import 'test_lab/settings_inline_showcase.dart';
import 'test_lab/showcase_models.dart';
import 'test_lab/showcase_shell.dart';
import 'test_lab/ticket_actions_showcase.dart';

final List<ShowcaseScenarioDefinition> _showcaseScenarioDefinitions = [
  ShowcaseScenarioDefinition(
    id: 'orders_filter',
    title: 'فلتر الطلبات',
    description:
        'Chip طبيعي داخل شريط الأدوات يتمدد إلى الأسفل فوق قائمة الطلبات.',
    detailSummary:
        'يعرض هذا المثال كيف يصبح الفلتر جزءاً من شريط العمليات نفسه، مع بيانات حية تتغير حسب نوع الفرز المختار.',
    compactPreviewBuilder: () => const OrdersFilterScenario(),
    detailExperienceBuilder: () => const OrdersFilterDetailExperience(),
  ),
  ShowcaseScenarioDefinition(
    id: 'search_suggestions',
    title: 'اقتراحات البحث',
    description:
        'حقل البحث نفسه يتمدد إلى اقتراحات حية بدون أن يبدو كعنصر عائم.',
    detailSummary:
        'هذا السيناريو يحاكي بحثاً حقيقياً داخل قائمة محادثات، ويُظهر كيف تتغير الاقتراحات والنتائج مع عبارة البحث.',
    compactPreviewBuilder: () => const SearchSuggestionsScenario(),
    detailExperienceBuilder: () => const SearchSuggestionsDetailExperience(),
  ),
  ShowcaseScenarioDefinition(
    id: 'ticket_actions',
    title: 'إجراءات التذكرة',
    description:
        'شريط إجراء مدمج داخل بطاقة دعم يتمدد من الوسط فوق محتوى البطاقة.',
    detailSummary:
        'المثال يوضح سيناريو مكتب دعم حقيقي، حيث تتبدل حالة التذكرة ويستجيب السطح المتمدد بمحتوى مناسب لكل حالة.',
    compactPreviewBuilder: () => const TicketActionsScenario(),
    detailExperienceBuilder: () => const TicketActionsDetailExperience(),
  ),
  ShowcaseScenarioDefinition(
    id: 'booking_slot',
    title: 'إنشاء حجز سريع',
    description:
        'خلية مواعيد صغيرة تتحول إلى محرر حجز مختصر من نفس الموضع.',
    detailSummary:
        'يعرض المثال كيف يمكن لسطح صغير داخل شبكة المواعيد أن يتمدد إلى محرر حجز سريع مع تبديل نوع الزيارة.',
    compactPreviewBuilder: () => const BookingSlotScenario(),
    detailExperienceBuilder: () => const BookingSlotDetailExperience(),
  ),
  ShowcaseScenarioDefinition(
    id: 'settings_inline',
    title: 'إعدادات موسعة',
    description:
        'صف إعدادات inline يكشف خيارات إضافية داخل شاشة تفضيلات حقيقية.',
    detailSummary:
        'هذا المثال يركز على الإعدادات المضمنة داخل القوائم، مع تغيير نمط الإشعارات وانعكاسه مباشرة على الواجهة.',
    compactPreviewBuilder: () => const SettingsInlineScenario(),
    detailExperienceBuilder: () => const SettingsInlineDetailExperience(),
  ),
  ShowcaseScenarioDefinition(
    id: 'message_composer',
    title: 'مؤلف الرسائل',
    description:
        'شريط كتابة سفلي يتمدد للأعلى ليكشف المرفقات والإجراءات السريعة.',
    detailSummary:
        'المشهد يحاكي مؤلف رسائل فعلي، مع تبديل وضع الإرسال بين ملف وصورة وملاحظة صوتية داخل نفس الواجهة.',
    compactPreviewBuilder: () => const MessageComposerScenario(),
    detailExperienceBuilder: () => const MessageComposerDetailExperience(),
  ),
  ShowcaseScenarioDefinition(
    id: 'checkout_summary',
    title: 'ملخص الدفع',
    description:
        'Checkout dock bar مثبت أسفل السلة يتمدد إلى ملخص دفع كامل.',
    detailSummary:
        'يعرض المثال شريط الدفع السفلي داخل سلة شراء، مع تبديل طريقة الدفع وانعكاسها على الملخص والسطر السفلي.',
    compactPreviewBuilder: () => const CheckoutSummaryScenario(),
    detailExperienceBuilder: () => const CheckoutSummaryDetailExperience(),
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
              const PageHero(),
              for (final definition in _showcaseScenarioDefinitions) ...[
                const SizedBox(height: 18),
                ScenarioSection(definition: definition),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
