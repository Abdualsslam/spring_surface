part of '../spring_surface_test_lab_page.dart';

class _OrdersFilterDetailExperience extends StatefulWidget {
  const _OrdersFilterDetailExperience();

  @override
  State<_OrdersFilterDetailExperience> createState() =>
      _OrdersFilterDetailExperienceState();
}

class _OrdersFilterDetailExperienceState
    extends State<_OrdersFilterDetailExperience> {
  final _sceneKey = GlobalKey<_OrdersFilterScenarioState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _sceneKey.currentState?.open();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: _OrdersFilterScenario(
        key: _sceneKey,
        presentation: _ScenarioPresentation.detail,
        keyPrefix: 'orders_filter_detail',
      ),
    );
  }
}

class _OrdersFilterScenario extends StatefulWidget {
  const _OrdersFilterScenario({
    super.key,
    this.presentation = _ScenarioPresentation.compact,
    this.keyPrefix = 'orders_filter',
  });

  final _ScenarioPresentation presentation;
  final String keyPrefix;

  @override
  State<_OrdersFilterScenario> createState() => _OrdersFilterScenarioState();
}

class _OrdersFilterScenarioState
    extends _ExpandableSceneState<_OrdersFilterScenario> {
  @override
  Widget build(BuildContext context) {
    const accent = Color(0xFF2563EB);
    final isDetail = widget.presentation.isDetail;
    const currentPreset = _OrdersFilterPreset.today;

    late final String badgeLabel;
    late final String selectedLabel;
    late final String branchValue;
    late final String statusValue;
    late final String primaryValue;
    late final String secondaryValue;
    late final List<Widget> cards;

    switch (currentPreset) {
      case _OrdersFilterPreset.today:
        badgeLabel = '18 طلباً';
        selectedLabel = 'اليوم';
        branchValue = 'وردية الصباح';
        statusValue = 'عرض طلبات اليوم فقط';
        primaryValue = '12';
        secondaryValue = '4';
        cards = const [
          _OrderCard(
            title: 'طلب أحمد سالم',
            subtitle: 'وجبتان عائليتان',
            amount: '42 ر.س',
            status: 'قيد التحضير',
            tint: Color(0xFFE0EEFF),
          ),
          SizedBox(height: 10),
          _OrderCard(
            title: 'طلب نورة مازن',
            subtitle: 'توصيل خلال 20 دقيقة',
            amount: '28 ر.س',
            status: 'بانتظار السائق',
            tint: Color(0xFFFFF1D6),
          ),
        ];
      case _OrdersFilterPreset.urgent:
        badgeLabel = '7 طلبات مستعجلة';
        selectedLabel = 'مستعجل';
        branchValue = 'مسار الأولوية';
        statusValue = 'إبراز الطلبات الحرجة';
        primaryValue = '5';
        secondaryValue = '2';
        cards = const [
          _OrderCard(
            title: 'طلب مستشفى المدينة',
            subtitle: 'تسليم فوري قبل 10 دقائق',
            amount: '96 ر.س',
            status: 'عاجل جداً',
            tint: Color(0xFFFFF1D6),
          ),
          SizedBox(height: 10),
          _OrderCard(
            title: 'طلب مكتب المدار',
            subtitle: 'سائق قريب من الاستلام',
            amount: '58 ر.س',
            status: 'جاهز للتسليم',
            tint: Color(0xFFE0EEFF),
          ),
        ];
      case _OrdersFilterPreset.prepaid:
        badgeLabel = '9 طلبات مدفوعة';
        selectedLabel = 'الدفع المسبق';
        branchValue = 'الدفع الإلكتروني';
        statusValue = 'مطابقة الطلبات المسددة';
        primaryValue = '6';
        secondaryValue = '3';
        cards = const [
          _OrderCard(
            title: 'طلب شركة المدار',
            subtitle: 'بطاقة شركة - تم السداد',
            amount: '128 ر.س',
            status: 'مدفوع مسبقاً',
            tint: Color(0xFFE0EEFF),
          ),
          SizedBox(height: 10),
          _OrderCard(
            title: 'طلب فاطمة خالد',
            subtitle: 'دفع عبر Apple Pay',
            amount: '34 ر.س',
            status: 'بانتظار التحضير',
            tint: Color(0xFFFFF1D6),
          ),
        ];
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final expandedWidth = math.min(
          constraints.maxWidth - 32,
          isDetail ? 332.0 : 284.0,
        );
        final collapsedWidth = isDetail ? 162.0 : 112.0;
        final surfaceHeight = isDetail ? 228.0 : 212.0;
        final expandedHeight = isDetail ? 204.0 : 188.0;

        return DecoratedBox(
          key: Key('${widget.keyPrefix}_canvas'),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFF8FBFF), Color(0xFFF1F6FF)],
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
                              'لوحة العمليات',
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(fontWeight: FontWeight.w800),
                            ),
                          ),
                          _Badge(label: badgeLabel),
                        ],
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        height: 42,
                        child: Row(
                          children: [
                            SizedBox(width: collapsedWidth),
                            const SizedBox(width: 10),
                            const Expanded(
                              child: _GhostSearchField(
                                hint: 'ابحث برقم الطلب أو اسم العميل',
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 14),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            _ChoicePill(
                              label: 'اليوم',
                              selected:
                                  currentPreset == _OrdersFilterPreset.today,
                            ),
                            _ChoicePill(
                              label: 'مستعجل',
                              selected:
                                  currentPreset == _OrdersFilterPreset.urgent,
                            ),
                            _ChoicePill(
                              label: 'الدفع المسبق',
                              selected:
                                  currentPreset == _OrdersFilterPreset.prepaid,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 14),
                      Row(
                        children: [
                          Expanded(
                            child: _MetricTile(
                              label: 'مكتملة',
                              value: primaryValue,
                              tint: const Color(0xFFE0EEFF),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: _MetricTile(
                              label: 'تحتاج متابعة',
                              value: secondaryValue,
                              tint: const Color(0xFFFFF1D6),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      Expanded(child: Column(children: cards)),
                    ],
                  ),
                ),
              ),
              if (isExpanded)
                _ScenarioBackdrop(
                  backdropKey: Key('${widget.keyPrefix}_backdrop'),
                  onTap: close,
                ),
              Positioned(
                top: isDetail ? 74 : 70,
                right: 16,
                width: expandedWidth,
                height: surfaceHeight,
                child: SpringSurface(
                  isExpanded: isExpanded,
                  origin: SpringSurfaceOrigin.top,
                  config: const SpringSurfaceConfig.snappy(),
                  collapsedSize: Size(collapsedWidth, 42),
                  expandedSize: Size(expandedWidth, expandedHeight),
                  collapsedDecoration: BoxDecoration(
                    color: Colors.white.withAlpha(246),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: accent.withAlpha(35)),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x122563EB),
                        blurRadius: 12,
                        offset: Offset(0, 6),
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
                        blurRadius: 24,
                        offset: Offset(0, 12),
                      ),
                    ],
                  ),
                  collapsedChild: GestureDetector(
                    key: Key('${widget.keyPrefix}_toggle'),
                    behavior: HitTestBehavior.opaque,
                    onTap: toggle,
                    child: _FilterChipButton(
                      label: isDetail ? 'الفلاتر · $selectedLabel' : 'الفلاتر',
                      accent: accent,
                    ),
                  ),
                  expandedChild: _OrdersFilterPanel(
                    onToggle: toggle,
                    preset: currentPreset,
                    branchValue: branchValue,
                    statusValue: statusValue,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _OrdersFilterPanel extends StatelessWidget {
  const _OrdersFilterPanel({
    required this.onToggle,
    required this.preset,
    required this.branchValue,
    required this.statusValue,
  });

  final VoidCallback onToggle;
  final _OrdersFilterPreset preset;
  final String branchValue;
  final String statusValue;

  @override
  Widget build(BuildContext context) {
    return _SurfaceScrollableContent(
      children: [
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: onToggle,
          child: const _PanelHeaderButton(
            label: 'الفلاتر',
            icon: Icons.tune_rounded,
            accent: Color(0xFF2563EB),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'اختر ما يجب أن يظهر أولاً للفريق خلال هذه الوردية.',
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(color: Colors.black54, height: 1.45),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _ChoicePill(
              label: 'اليوم',
              selected: preset == _OrdersFilterPreset.today,
            ),
            _ChoicePill(
              label: 'مستعجل',
              selected: preset == _OrdersFilterPreset.urgent,
            ),
            _ChoicePill(
              label: 'الدفع المسبق',
              selected: preset == _OrdersFilterPreset.prepaid,
            ),
          ],
        ),
        const SizedBox(height: 12),
        _InfoRow(label: 'المسار', value: branchValue),
        const SizedBox(height: 8),
        _InfoRow(label: 'الوضع الحالي', value: statusValue),
      ],
    );
  }
}
