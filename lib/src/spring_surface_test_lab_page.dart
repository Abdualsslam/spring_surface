import 'package:flutter/material.dart';

import 'spring_surface.dart';
import 'spring_surface_config.dart';

class SpringSurfaceTestLabPage extends StatelessWidget {
  const SpringSurfaceTestLabPage({super.key});

  static const String routeName = '/test-lab';

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFFF1F3F9),
        appBar: AppBar(
          backgroundColor: const Color(0xFFF1F3F9),
          surfaceTintColor: Colors.transparent,
          title: const Text('مشاهد واقعية لتمدد Spring Surface'),
        ),
        body: SafeArea(
          child: ListView(
            key: const Key('test_showcase_list'),
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
            children: const [
              _PageHero(),
              SizedBox(height: 18),
              _ScenarioSection(
                title: 'فلاتر من الأعلى',
                description:
                    'زر داخل شريط الأدوات يتمدد إلى الأسفل فوق قائمة الطلبات ليكشف لوحة فلاتر سريعة بدون أن يزحزح المحتوى.',
                child: _TopFilterScenario(),
              ),
              SizedBox(height: 18),
              _ScenarioSection(
                title: 'إجراء من الوسط',
                description:
                    'زر مركزي داخل لوحة متابعة يتمدد من المنتصف فوق البطاقات المحيطة ليكشف إجراءات سريعة ونموذجاً مختصراً.',
                child: _CenterActionScenario(),
              ),
              SizedBox(height: 18),
              _ScenarioSection(
                title: 'ملخص من الأسفل',
                description:
                    'زر مثبت قرب أسفل السلة يتمدد إلى الأعلى ليغطي تفاصيل الطلب والدفع فوق العناصر السابقة بدون أخطاء تخطيط.',
                child: _BottomCheckoutScenario(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PageHero extends StatelessWidget {
  const _PageHero();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF101828), Color(0xFF243B72)],
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
        ),
        borderRadius: BorderRadius.circular(28),
        boxShadow: const [
          BoxShadow(
            color: Color(0x18000000),
            blurRadius: 28,
            offset: Offset(0, 14),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'ثلاثة أمثلة مباشرة داخل واجهات تشبه الواقع.',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'اضغط على الزر داخل كل مشهد لتشاهد كيف يغطي السطح المتوسع العناصر المجاورة من الأعلى أو الوسط أو الأسفل، ثم أغلقه بالنقر خارج السطح نفسه.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.white.withAlpha(215),
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ScenarioSection extends StatelessWidget {
  const _ScenarioSection({
    required this.title,
    required this.description,
    required this.child,
  });

  final String title;
  final String description;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: const [
          BoxShadow(
            color: Color(0x12000000),
            blurRadius: 26,
            offset: Offset(0, 12),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 8),
            Text(
              description,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.black54,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 18),
            _PreviewFrame(child: child),
          ],
        ),
      ),
    );
  }
}

class _PreviewFrame extends StatelessWidget {
  const _PreviewFrame({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 430,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: const Color(0xFF0F172A),
          borderRadius: BorderRadius.circular(34),
          boxShadow: const [
            BoxShadow(
              color: Color(0x26000000),
              blurRadius: 30,
              offset: Offset(0, 16),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}

class _ScenarioBackdrop extends StatelessWidget {
  const _ScenarioBackdrop({required this.backdropKey, required this.onTap});

  final Key backdropKey;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: GestureDetector(
        key: backdropKey,
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: ColoredBox(color: Colors.black.withAlpha(14)),
      ),
    );
  }
}

class _TopFilterScenario extends StatefulWidget {
  const _TopFilterScenario();

  @override
  State<_TopFilterScenario> createState() => _TopFilterScenarioState();
}

class _TopFilterScenarioState extends State<_TopFilterScenario> {
  bool _isExpanded = false;

  void _setExpanded(bool value) {
    if (_isExpanded == value) {
      return;
    }
    setState(() => _isExpanded = value);
  }

  void _toggle() {
    _setExpanded(!_isExpanded);
  }

  void _close() {
    _setExpanded(false);
  }

  @override
  Widget build(BuildContext context) {
    const accent = Color(0xFF2563EB);

    return DecoratedBox(
      key: const Key('top_scenario_canvas'),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFF8FBFF), Color(0xFFF2F6FF)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'طلبات اليوم',
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.w800),
                        ),
                      ),
                      const _Badge(label: '18 طلباً'),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const SizedBox(
                    height: 42,
                    child: Row(
                      children: [
                        SizedBox(width: 112),
                        SizedBox(width: 10),
                        Expanded(
                          child: _GhostSearchField(
                            hint: 'ابحث برقم الطلب أو اسم العميل',
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),
                  const Align(
                    alignment: Alignment.centerRight,
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        _ChoicePill(label: 'جميع الطلبات', selected: true),
                        _ChoicePill(label: 'قيد التحضير'),
                        _ChoicePill(label: 'بانتظار السائق'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),
                  const Row(
                    children: [
                      Expanded(
                        child: _SummaryTile(
                          label: 'مكتملة',
                          value: '12',
                          tint: Color(0xFFE0F2FE),
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: _SummaryTile(
                          label: 'مستعجلة',
                          value: '4',
                          tint: Color(0xFFFEF3C7),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  const Expanded(
                    child: SingleChildScrollView(
                      primary: false,
                      child: Column(
                        children: [
                          _OrderItem(
                            title: 'طلب أحمد سالم',
                            subtitle: 'وجبتان عائليتان',
                            amount: '42 ر.س',
                            status: 'قيد التحضير',
                            tint: Color(0xFFE0ECFF),
                          ),
                          SizedBox(height: 10),
                          _OrderItem(
                            title: 'طلب نورة مازن',
                            subtitle: 'توصيل خلال 20 دقيقة',
                            amount: '28 ر.س',
                            status: 'بانتظار السائق',
                            tint: Color(0xFFFFF1D6),
                          ),
                          SizedBox(height: 10),
                          _OrderItem(
                            title: 'طلب سامي علي',
                            subtitle: 'سداد إلكتروني',
                            amount: '65 ر.س',
                            status: 'مؤكد',
                            tint: Color(0xFFE7F8EE),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (_isExpanded)
            _ScenarioBackdrop(
              backdropKey: const Key('top_surface_backdrop'),
              onTap: _close,
            ),
          Positioned(
            top: 70,
            right: 16,
            width: 280,
            height: 204,
            child: SpringSurface(
              isExpanded: _isExpanded,
              origin: SpringSurfaceOrigin.top,
              config: const SpringSurfaceConfig.snappy(),
              collapsedSize: const Size(112, 42),
              expandedSize: const Size(280, 188),
              collapsedDecoration: BoxDecoration(
                color: Colors.white.withAlpha(245),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: accent.withAlpha(35)),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x0F2563EB),
                    blurRadius: 12,
                    offset: Offset(0, 6),
                  ),
                ],
              ),
              expandedDecoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: accent.withAlpha(40)),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x14000000),
                    blurRadius: 26,
                    offset: Offset(0, 14),
                  ),
                ],
              ),
              collapsedChild: GestureDetector(
                key: const Key('top_surface_toggle'),
                behavior: HitTestBehavior.opaque,
                onTap: _toggle,
                child: const _ToolbarFilterChip(
                  label: 'الفلاتر',
                  accent: accent,
                ),
              ),
              expandedChild: _TopFilterPanel(onToggle: _toggle),
            ),
          ),
        ],
      ),
    );
  }
}

class _CenterActionScenario extends StatefulWidget {
  const _CenterActionScenario();

  @override
  State<_CenterActionScenario> createState() => _CenterActionScenarioState();
}

class _CenterActionScenarioState extends State<_CenterActionScenario> {
  bool _isExpanded = false;

  void _setExpanded(bool value) {
    if (_isExpanded == value) {
      return;
    }
    setState(() => _isExpanded = value);
  }

  void _toggle() {
    _setExpanded(!_isExpanded);
  }

  void _close() {
    _setExpanded(false);
  }

  @override
  Widget build(BuildContext context) {
    const accent = Color(0xFF0F766E);

    return DecoratedBox(
      key: const Key('center_scenario_canvas'),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFF6FFFC), Color(0xFFF2FAF8)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'لوحة المتابعة',
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.w800),
                        ),
                      ),
                      const _Badge(label: 'الفريق 6'),
                    ],
                  ),
                  const SizedBox(height: 14),
                  const Row(
                    children: [
                      Expanded(
                        child: _SummaryTile(
                          label: 'التذاكر المفتوحة',
                          value: '24',
                          tint: Color(0xFFDFF7F1),
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: _SummaryTile(
                          label: 'متوسط الرد',
                          value: '4 د',
                          tint: Color(0xFFEAF5FF),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE7FAF5),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.schedule_send_rounded,
                          color: accent,
                          size: 18,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'الحالة الحرجة تحتاج رداً خلال 15 دقيقة.',
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(
                                  color: const Color(0xFF0F5E57),
                                  fontWeight: FontWeight.w700,
                                ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 84),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: SingleChildScrollView(
                        primary: false,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    'تذكرة عميل شركة الندى',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleSmall
                                        ?.copyWith(fontWeight: FontWeight.w800),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFE7FAF5),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: const Text(
                                    'SLA مرتفع',
                                    style: TextStyle(
                                      color: accent,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'العميل يطلب تحديثاً نهائياً على العقد قبل نهاية اليوم.',
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(
                                    color: Colors.black54,
                                    height: 1.5,
                                  ),
                            ),
                            const SizedBox(height: 12),
                            const _InlineDetailRow(
                              label: 'آخر رد',
                              value: 'منذ 6 دقائق',
                            ),
                            const SizedBox(height: 8),
                            const _InlineDetailRow(
                              label: 'المسؤول الحالي',
                              value: 'فريق العقود',
                            ),
                            const SizedBox(height: 12),
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF6F8FB),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Text(
                                'ملاحظة داخلية: أرسل تحديثاً مختصراً ثم حوّل النسخة النهائية للمراجعة.',
                                style: Theme.of(context).textTheme.bodySmall
                                    ?.copyWith(
                                      color: Colors.black54,
                                      height: 1.45,
                                    ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (_isExpanded)
            _ScenarioBackdrop(
              backdropKey: const Key('center_surface_backdrop'),
              onTap: _close,
            ),
          Positioned(
            left: 40,
            right: 40,
            bottom: 28,
            height: 214,
            child: SpringSurface(
              isExpanded: _isExpanded,
              origin: SpringSurfaceOrigin.center,
              config: const SpringSurfaceConfig.gentle(),
              collapsedSize: const Size(244, 52),
              expandedSize: const Size(280, 202),
              collapsedDecoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: accent.withAlpha(45)),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x120F766E),
                    blurRadius: 20,
                    offset: Offset(0, 10),
                  ),
                ],
              ),
              expandedDecoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: accent.withAlpha(35)),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x12000000),
                    blurRadius: 28,
                    offset: Offset(0, 14),
                  ),
                ],
              ),
              collapsedChild: GestureDetector(
                key: const Key('center_surface_toggle'),
                behavior: HitTestBehavior.opaque,
                onTap: _toggle,
                child: const _CaseActionStrip(
                  label: 'تحديث الحالة',
                  detail: 'إرسال رد سريع أو تحويل التذكرة',
                  accent: accent,
                ),
              ),
              expandedChild: _CenterActionPanel(onToggle: _toggle),
            ),
          ),
        ],
      ),
    );
  }
}

class _BottomCheckoutScenario extends StatefulWidget {
  const _BottomCheckoutScenario();

  @override
  State<_BottomCheckoutScenario> createState() =>
      _BottomCheckoutScenarioState();
}

class _BottomCheckoutScenarioState extends State<_BottomCheckoutScenario> {
  bool _isExpanded = false;

  void _setExpanded(bool value) {
    if (_isExpanded == value) {
      return;
    }
    setState(() => _isExpanded = value);
  }

  void _toggle() {
    _setExpanded(!_isExpanded);
  }

  void _close() {
    _setExpanded(false);
  }

  @override
  Widget build(BuildContext context) {
    const accent = Color(0xFFEA580C);

    return DecoratedBox(
      key: const Key('bottom_scenario_canvas'),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFFFFBF6), Color(0xFFFFF4EC)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 18),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'سلة المشتريات',
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.w800),
                        ),
                      ),
                      const _Badge(label: '3 عناصر'),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.location_on_outlined, color: accent),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'التوصيل إلى المنزل',
                                style: Theme.of(context).textTheme.titleSmall
                                    ?.copyWith(fontWeight: FontWeight.w800),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'حي الروضة، شارع الأمير سلطان',
                                style: Theme.of(context).textTheme.bodySmall
                                    ?.copyWith(color: Colors.black54),
                              ),
                            ],
                          ),
                        ),
                        const Icon(Icons.chevron_left_rounded),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Expanded(
                    child: SingleChildScrollView(
                      primary: false,
                      child: Column(
                        children: [
                          _CartLine(
                            title: 'سماعة لاسلكية',
                            subtitle: 'لون رمادي',
                            amount: '79 ر.س',
                          ),
                          SizedBox(height: 10),
                          _CartLine(
                            title: 'غلاف حماية',
                            subtitle: 'مقاس كامل',
                            amount: '18 ر.س',
                          ),
                          SizedBox(height: 10),
                          _CartLine(
                            title: 'شاحن سريع',
                            subtitle: 'منفذ Type-C',
                            amount: '35 ر.س',
                          ),
                          SizedBox(height: 14),
                          _DeliveryNote(),
                          SizedBox(height: 82),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (_isExpanded)
            _ScenarioBackdrop(
              backdropKey: const Key('bottom_surface_backdrop'),
              onTap: _close,
            ),
          Positioned(
            left: 16,
            right: 16,
            bottom: 16,
            height: 282,
            child: SpringSurface(
              isExpanded: _isExpanded,
              origin: SpringSurfaceOrigin.bottom,
              config: const SpringSurfaceConfig(),
              collapsedSize: const Size(316, 58),
              expandedSize: const Size(316, 248),
              collapsedDecoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: accent.withAlpha(35)),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x12000000),
                    blurRadius: 24,
                    offset: Offset(0, 12),
                  ),
                ],
              ),
              expandedDecoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: accent.withAlpha(35)),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x14000000),
                    blurRadius: 28,
                    offset: Offset(0, 14),
                  ),
                ],
              ),
              collapsedChild: GestureDetector(
                key: const Key('bottom_surface_toggle'),
                behavior: HitTestBehavior.opaque,
                onTap: _toggle,
                child: const _CheckoutCollapsedBar(
                  total: '144 ر.س',
                  accent: accent,
                ),
              ),
              expandedChild: _BottomCheckoutPanel(onToggle: _toggle),
            ),
          ),
        ],
      ),
    );
  }
}

class _TopFilterPanel extends StatelessWidget {
  const _TopFilterPanel({required this.onToggle});

  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    return _SurfaceScrollableContent(
      children: [
        GestureDetector(
          onTap: onToggle,
          child: const _SurfaceToggleButton(
            label: 'الفلاتر',
            icon: Icons.tune_rounded,
            accent: Color(0xFF2563EB),
            expanded: true,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'اختر فترة العرض ونوع الطلبات الأكثر أهمية للفريق.',
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(color: Colors.black54, height: 1.5),
        ),
        const SizedBox(height: 12),
        const Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _ChoicePill(label: 'اليوم', selected: true),
            _ChoicePill(label: 'مستعجل'),
            _ChoicePill(label: 'الدفع المسبق'),
            _ChoicePill(label: 'أعلى قيمة'),
          ],
        ),
        const SizedBox(height: 12),
        const _InlineDetailRow(label: 'الفرع', value: 'الواجهة الرئيسية'),
        const SizedBox(height: 8),
        const _InlineDetailRow(label: 'الحالة', value: 'قيد التنفيذ فقط'),
      ],
    );
  }
}

class _CenterActionPanel extends StatelessWidget {
  const _CenterActionPanel({required this.onToggle});

  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    return _SurfaceScrollableContent(
      children: [
        GestureDetector(
          onTap: onToggle,
          child: const _SurfaceToggleButton(
            label: 'تحديث الحالة',
            icon: Icons.bolt_rounded,
            accent: Color(0xFF0F766E),
            expanded: true,
          ),
        ),
        const SizedBox(height: 12),
        const Row(
          children: [
            Expanded(
              child: _QuickActionTile(
                title: 'تذكير',
                subtitle: 'موعد المتابعة',
                icon: Icons.notifications_active_outlined,
                tint: Color(0xFFDFF7F1),
              ),
            ),
            SizedBox(width: 8),
            Expanded(
              child: _QuickActionTile(
                title: 'تحويل',
                subtitle: 'لفريق آخر',
                icon: Icons.swap_horiz_rounded,
                tint: Color(0xFFEAF5FF),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          decoration: BoxDecoration(
            color: const Color(0xFFF6F8FB),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(
            'أضف ملاحظة سريعة: العميل طلب تحديثاً قبل نهاية اليوم.',
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: Colors.black54, height: 1.5),
          ),
        ),
        const SizedBox(height: 10),
        const Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _ChoicePill(label: 'إرسال الآن', selected: true),
            _ChoicePill(label: 'خلال ساعة'),
            _ChoicePill(label: 'إسناد داخلي'),
          ],
        ),
      ],
    );
  }
}

class _BottomCheckoutPanel extends StatelessWidget {
  const _BottomCheckoutPanel({required this.onToggle});

  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    return _SurfaceScrollableContent(
      children: [
        GestureDetector(
          onTap: onToggle,
          child: const _SurfaceToggleButton(
            label: 'ملخص الدفع',
            icon: Icons.receipt_long_outlined,
            accent: Color(0xFFEA580C),
            expanded: true,
          ),
        ),
        const SizedBox(height: 12),
        const _InlineDetailRow(label: 'المجموع الفرعي', value: '132 ر.س'),
        const SizedBox(height: 8),
        const _InlineDetailRow(label: 'رسوم التوصيل', value: '12 ر.س'),
        const SizedBox(height: 8),
        const _InlineDetailRow(label: 'الإجمالي', value: '144 ر.س'),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFFFFF3EA),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              const Icon(Icons.credit_card_rounded, color: Color(0xFFEA580C)),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'بطاقة مدى •••• 8841',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SurfaceScrollableContent extends StatelessWidget {
  const _SurfaceScrollableContent({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        const padding = EdgeInsets.all(14);
        final minHeight = constraints.maxHeight > padding.vertical
            ? constraints.maxHeight - padding.vertical
            : 0.0;

        return SingleChildScrollView(
          primary: false,
          padding: padding,
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: minHeight),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: children,
            ),
          ),
        );
      },
    );
  }
}

class _GhostSearchField extends StatelessWidget {
  const _GhostSearchField({required this.hint});

  final String hint;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 42,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          const Icon(Icons.search_rounded, color: Colors.black45, size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              hint,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: Colors.black45),
            ),
          ),
        ],
      ),
    );
  }
}

class _ToolbarFilterChip extends StatelessWidget {
  const _ToolbarFilterChip({required this.label, required this.accent});

  final String label;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 42,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: accent.withAlpha(18),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          const Icon(Icons.tune_rounded, size: 18),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: accent,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          const Icon(Icons.keyboard_arrow_down_rounded, size: 18),
        ],
      ),
    );
  }
}

class _CaseActionStrip extends StatelessWidget {
  const _CaseActionStrip({
    required this.label,
    required this.detail,
    required this.accent,
  });

  final String label;
  final String detail;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 52,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: accent.withAlpha(18),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(Icons.bolt_rounded, color: accent, size: 18),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 2),
                Text(
                  detail,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: Colors.black54),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Icon(Icons.keyboard_arrow_down_rounded, color: accent),
        ],
      ),
    );
  }
}

class _CheckoutCollapsedBar extends StatelessWidget {
  const _CheckoutCollapsedBar({required this.total, required this.accent});

  final String total;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 58,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: Row(
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'الإجمالي',
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: Colors.black54),
                ),
                const SizedBox(height: 2),
                Text(
                  total,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 11),
            decoration: BoxDecoration(
              color: accent,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.arrow_back_rounded,
                  color: Colors.white,
                  size: 18,
                ),
                const SizedBox(width: 6),
                Text(
                  'الدفع',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SurfaceToggleButton extends StatelessWidget {
  const _SurfaceToggleButton({
    required this.label,
    required this.icon,
    required this.accent,
    this.expanded = false,
  });

  final String label;
  final IconData icon;
  final Color accent;
  final bool expanded;

  @override
  Widget build(BuildContext context) {
    final foreground = expanded ? accent : Colors.white;

    return Container(
      height: 46,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: expanded ? accent.withAlpha(18) : accent,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(icon, color: foreground, size: 19),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: foreground,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          Icon(
            expanded
                ? Icons.keyboard_arrow_up_rounded
                : Icons.keyboard_arrow_down_rounded,
            color: foreground,
          ),
        ],
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(210),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Text(
        label,
        style: Theme.of(
          context,
        ).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w700),
      ),
    );
  }
}

class _SummaryTile extends StatelessWidget {
  const _SummaryTile({
    required this.label,
    required this.value,
    required this.tint,
  });

  final String label;
  final String value;
  final Color tint;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: tint,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: Theme.of(
              context,
            ).textTheme.labelMedium?.copyWith(color: Colors.black54),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
          ),
        ],
      ),
    );
  }
}

class _OrderItem extends StatelessWidget {
  const _OrderItem({
    required this.title,
    required this.subtitle,
    required this.amount,
    required this.status,
    required this.tint,
  });

  final String title;
  final String subtitle;
  final String amount;
  final String status;
  final Color tint;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: tint,
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(Icons.receipt_long_outlined),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: Colors.black54),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                amount,
                style: Theme.of(
                  context,
                ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 4),
              Text(
                status,
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: Colors.black54),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CartLine extends StatelessWidget {
  const _CartLine({
    required this.title,
    required this.subtitle,
    required this.amount,
  });

  final String title;
  final String subtitle;
  final String amount;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: const Color(0xFFFFEDD5),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(Icons.shopping_bag_outlined),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: Colors.black54),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Text(
            amount,
            style: Theme.of(
              context,
            ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w800),
          ),
        ],
      ),
    );
  }
}

class _DeliveryNote extends StatelessWidget {
  const _DeliveryNote();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF0E3),
        borderRadius: BorderRadius.circular(18),
      ),
      child: const Text(
        'التوصيل المتوقع خلال 25 دقيقة بعد تأكيد الطلب.',
        style: TextStyle(color: Color(0xFF9A3412), height: 1.5),
      ),
    );
  }
}

class _ChoicePill extends StatelessWidget {
  const _ChoicePill({required this.label, this.selected = false});

  final String label;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
      decoration: BoxDecoration(
        color: selected ? const Color(0xFFEEF4FF) : const Color(0xFFF6F8FB),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
          color: selected ? const Color(0xFF1D4ED8) : Colors.black87,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _InlineDetailRow extends StatelessWidget {
  const _InlineDetailRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
      decoration: BoxDecoration(
        color: const Color(0xFFF6F8FB),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: Colors.black54),
            ),
          ),
          const SizedBox(width: 12),
          Flexible(
            child: Text(
              value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.end,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w800),
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickActionTile extends StatelessWidget {
  const _QuickActionTile({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.tint,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Color tint;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: tint,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon),
          const SizedBox(height: 8),
          Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: Colors.black54),
          ),
        ],
      ),
    );
  }
}
