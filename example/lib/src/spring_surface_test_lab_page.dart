import 'package:flutter/material.dart';

import 'test_lab/booking_slot_showcase.dart';
import 'test_lab/checkout_summary_showcase.dart';
import 'test_lab/message_composer_showcase.dart';
import 'test_lab/search_suggestions_showcase.dart';
import 'test_lab/settings_inline_showcase.dart';
import 'test_lab/showcase_models.dart';
import 'test_lab/showcase_shell.dart';
import 'test_lab/ticket_actions_showcase.dart';

final List<ShowcaseFamilyDefinition> _showcaseFamilies = [
  ShowcaseFamilyDefinition(
    id: 'top_surface',
    title: 'Top Surface',
    description:
        'أمثلة تبدأ من حقل أو صف داخل الواجهة ثم تتمدد للأعلى مع الحفاظ على السياق المحيط.',
    layoutStyle: FamilyLayoutStyle.featuredSwitcher,
    variants: [
      ShowcaseVariantDefinition(
        id: 'search_suggestions',
        title: 'اقتراحات البحث',
        description:
            'حقل بحث يتمدد إلى نتائج حية وإجراءات سريعة بدون أن يبدو كعنصر عائم منفصل.',
        builder:
            ({
              required String keyPrefix,
              required ScenarioDisplayMode displayMode,
            }) => SearchSuggestionsScenario(
              keyPrefix: keyPrefix,
              displayMode: displayMode,
            ),
      ),
      ShowcaseVariantDefinition(
        id: 'settings_inline',
        title: 'إعدادات موسعة',
        description:
            'صف إعدادات واحد يكشف خيارات إضافية داخل نفس الشاشة مع تمدد علوي قصير ومباشر.',
        builder:
            ({
              required String keyPrefix,
              required ScenarioDisplayMode displayMode,
            }) => SettingsInlineScenario(
              keyPrefix: keyPrefix,
              displayMode: displayMode,
            ),
      ),
    ],
  ),
  ShowcaseFamilyDefinition(
    id: 'inline_trigger',
    title: 'Inline Trigger',
    description:
        'أمثلة تتمدد من نفس العنصر داخل البطاقة أو الشبكة من غير مغادرة موضعه الأصلي.',
    layoutStyle: FamilyLayoutStyle.stackedCards,
    variants: [
      ShowcaseVariantDefinition(
        id: 'ticket_actions',
        title: 'إجراءات التذكرة',
        description:
            'شريط إجراء مدمج داخل بطاقة دعم يتوسع حول مكانه ليكشف إجراءات المتابعة السريعة.',
        builder:
            ({
              required String keyPrefix,
              required ScenarioDisplayMode displayMode,
            }) => TicketActionsScenario(
              keyPrefix: keyPrefix,
              displayMode: displayMode,
            ),
      ),
      ShowcaseVariantDefinition(
        id: 'booking_slot',
        title: 'حجز سريع مع فلترة',
        description:
            'شاشة حجز واحدة تضم شريحة فلترة علوية وسطح حجز سريع مستقل داخل نفس المشهد.',
        builder:
            ({
              required String keyPrefix,
              required ScenarioDisplayMode displayMode,
            }) => BookingSlotScenario(
              keyPrefix: keyPrefix,
              displayMode: displayMode,
            ),
      ),
    ],
  ),
  ShowcaseFamilyDefinition(
    id: 'bottom_dock',
    title: 'Bottom Dock',
    description:
        'أشرطة سفلية مثبتة تتحول إلى لوحات كاملة من أسفل الشاشة مع احتفاظ المحتوى بالخلفية.',
    layoutStyle: FamilyLayoutStyle.featuredSwitcher,
    variants: [
      ShowcaseVariantDefinition(
        id: 'message_composer',
        title: 'مؤلف الرسائل',
        description:
            'شريط كتابة سفلي يكشف خيارات الإرسال السريع والمرفقات داخل نفس الشريط.',
        builder:
            ({
              required String keyPrefix,
              required ScenarioDisplayMode displayMode,
            }) => MessageComposerScenario(
              keyPrefix: keyPrefix,
              displayMode: displayMode,
            ),
      ),
      ShowcaseVariantDefinition(
        id: 'checkout_summary',
        title: 'ملخص الدفع',
        description:
            'Dock bar في أسفل السلة يتمدد إلى ملخص دفع كامل مع وسيلة الدفع والتفاصيل.',
        builder:
            ({
              required String keyPrefix,
              required ScenarioDisplayMode displayMode,
            }) => CheckoutSummaryScenario(
              keyPrefix: keyPrefix,
              displayMode: displayMode,
            ),
      ),
    ],
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
            key: const Key('test_family_list'),
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
            children: [
              const PageHero(),
              for (final family in _showcaseFamilies) ...[
                const SizedBox(height: 18),
                _FamilyShowcaseSection(definition: family),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _FamilyShowcaseSection extends StatelessWidget {
  const _FamilyShowcaseSection({required this.definition});

  final ShowcaseFamilyDefinition definition;

  @override
  Widget build(BuildContext context) {
    return FamilySection(
      familyId: definition.id,
      title: definition.title,
      description: definition.description,
      child: switch (definition.layoutStyle) {
        FamilyLayoutStyle.featuredSwitcher => _FeaturedFamilyShowcase(
          definition: definition,
        ),
        FamilyLayoutStyle.stackedCards => _StackedFamilyShowcase(
          definition: definition,
        ),
      },
    );
  }
}

class _FeaturedFamilyShowcase extends StatefulWidget {
  const _FeaturedFamilyShowcase({required this.definition});

  final ShowcaseFamilyDefinition definition;

  @override
  State<_FeaturedFamilyShowcase> createState() =>
      _FeaturedFamilyShowcaseState();
}

class _FeaturedFamilyShowcaseState extends State<_FeaturedFamilyShowcase> {
  late String _activeVariantId;

  @override
  void initState() {
    super.initState();
    _activeVariantId = widget.definition.variants.first.id;
  }

  @override
  Widget build(BuildContext context) {
    final activeVariant = widget.definition.variants.firstWhere(
      (variant) => variant.id == _activeVariantId,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        VariantSwitcher(
          familyId: widget.definition.id,
          variants: widget.definition.variants,
          activeVariantId: _activeVariantId,
          onVariantSelected: (variantId) {
            if (variantId == _activeVariantId) {
              return;
            }
            setState(() => _activeVariantId = variantId);
          },
        ),
        const SizedBox(height: 16),
        Text(
          activeVariant.title,
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 6),
        Text(
          activeVariant.description,
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: Colors.black54, height: 1.5),
        ),
        const SizedBox(height: 18),
        FeaturedScenarioFrame(
          child: activeVariant.builder(
            keyPrefix: '${widget.definition.id}_${activeVariant.id}',
            displayMode: ScenarioDisplayMode.featured,
          ),
        ),
      ],
    );
  }
}

class _StackedFamilyShowcase extends StatelessWidget {
  const _StackedFamilyShowcase({required this.definition});

  final ShowcaseFamilyDefinition definition;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (var index = 0; index < definition.variants.length; index++) ...[
          if (index > 0) const SizedBox(height: 18),
          CompactScenarioCard(
            title: definition.variants[index].title,
            description: definition.variants[index].description,
            child: definition.variants[index].builder(
              keyPrefix: '${definition.id}_${definition.variants[index].id}',
              displayMode: ScenarioDisplayMode.compact,
            ),
          ),
        ],
      ],
    );
  }
}
