part of '../spring_surface_test_lab_page.dart';

class _SearchSuggestionsDetailExperience extends StatefulWidget {
  const _SearchSuggestionsDetailExperience();

  @override
  State<_SearchSuggestionsDetailExperience> createState() =>
      _SearchSuggestionsDetailExperienceState();
}

class _SearchSuggestionsDetailExperienceState
    extends State<_SearchSuggestionsDetailExperience> {
  final _sceneKey = GlobalKey<_SearchSuggestionsScenarioState>();

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
      child: _SearchSuggestionsScenario(
        key: _sceneKey,
        presentation: _ScenarioPresentation.detail,
        keyPrefix: 'search_suggestions_detail',
      ),
    );
  }
}

class _SearchSuggestionsScenario extends StatefulWidget {
  const _SearchSuggestionsScenario({
    super.key,
    this.presentation = _ScenarioPresentation.compact,
    this.keyPrefix = 'search_suggestions',
  });

  final _ScenarioPresentation presentation;
  final String keyPrefix;

  @override
  State<_SearchSuggestionsScenario> createState() =>
      _SearchSuggestionsScenarioState();
}

class _SearchSuggestionsScenarioState
    extends _ExpandableSceneState<_SearchSuggestionsScenario> {
  @override
  Widget build(BuildContext context) {
    const accent = Color(0xFF4F46E5);
    const currentQueryPreset = _SearchQueryPreset.sara;

    late final String queryLabel;
    late final String collapsedText;
    late final String badgeLabel;
    late final List<Widget> backgroundTiles;
    late final List<Widget> panelTiles;

    switch (currentQueryPreset) {
      case _SearchQueryPreset.sara:
        queryLabel = 'سارة - العقود';
        collapsedText = widget.presentation.isDetail
            ? 'سارة'
            : 'ابحث في المحادثات أو العملاء';
        badgeLabel = 'نتائج سريعة 3';
        backgroundTiles = const [
          _MessageListTile(
            title: 'سارة - العقود',
            subtitle: 'هل وصلت النسخة النهائية؟',
            time: '11:20',
            tint: Color(0xFFEAEAFF),
          ),
          SizedBox(height: 10),
          _MessageListTile(
            title: 'سارة - الحسابات',
            subtitle: 'طلب مراجعة نسخة الفاتورة',
            time: '10:52',
            tint: Color(0xFFE0EEFF),
          ),
          SizedBox(height: 10),
          _MessageListTile(
            title: 'فريق الدعم',
            subtitle: 'تم إغلاق الحالة رقم 2031.',
            time: 'أمس',
            tint: Color(0xFFE7F8EE),
          ),
        ];
        panelTiles = const [
          _MessageListTile(
            title: 'سارة - العقود',
            subtitle: 'آخر تحديث على ملف الشركة',
            time: 'محادثة',
            tint: Color(0xFFEAEAFF),
          ),
          SizedBox(height: 8),
          _MessageListTile(
            title: 'سارة - الحسابات',
            subtitle: 'طلب مراجعة نسخة الفاتورة',
            time: 'محادثة',
            tint: Color(0xFFE7F8EE),
          ),
          SizedBox(height: 8),
          _MessageListTile(
            title: 'المواعيد المرتبطة بسارة',
            subtitle: 'موعدان مرتبطان بنفس الاسم',
            time: 'سجلات',
            tint: Color(0xFFE0EEFF),
          ),
        ];
      case _SearchQueryPreset.contracts:
        queryLabel = 'العقود المعتمدة';
        collapsedText = 'العقود';
        badgeLabel = 'ملفات مطابقة 4';
        backgroundTiles = const [
          _MessageListTile(
            title: 'العقود المعتمدة',
            subtitle: 'ثلاث نسخ حديثة من العقد السنوي',
            time: 'ملفات',
            tint: Color(0xFFE0EEFF),
          ),
          SizedBox(height: 10),
          _MessageListTile(
            title: 'فريق العقود',
            subtitle: 'بانتظار موافقة الإدارة القانونية',
            time: '09:18',
            tint: Color(0xFFEAEAFF),
          ),
          SizedBox(height: 10),
          _MessageListTile(
            title: 'الأرشيف',
            subtitle: 'نسخ أقدم مرتبطة بالشركة نفسها',
            time: 'أرشيف',
            tint: Color(0xFFE7F8EE),
          ),
        ];
        panelTiles = const [
          _MessageListTile(
            title: 'العقود المعتمدة',
            subtitle: '3 ملفات تطابق عبارة البحث',
            time: 'ملفات',
            tint: Color(0xFFE0EEFF),
          ),
          SizedBox(height: 8),
          _MessageListTile(
            title: 'آخر موافقة قانونية',
            subtitle: 'تم الاعتماد خلال هذا الأسبوع',
            time: 'معلومة',
            tint: Color(0xFFEAEAFF),
          ),
          SizedBox(height: 8),
          _MessageListTile(
            title: 'مسار المراجعة',
            subtitle: 'المرحلة النهائية مع الإدارة',
            time: 'حالة',
            tint: Color(0xFFE7F8EE),
          ),
        ];
      case _SearchQueryPreset.invoices:
        queryLabel = 'الفواتير المستحقة';
        collapsedText = 'الفواتير';
        badgeLabel = 'مستحقات 2';
        backgroundTiles = const [
          _MessageListTile(
            title: 'الفواتير المستحقة',
            subtitle: 'فاتورتان متأخرتان عن موعد السداد',
            time: 'مالية',
            tint: Color(0xFFEAEAFF),
          ),
          SizedBox(height: 10),
          _MessageListTile(
            title: 'إشعار الحسابات',
            subtitle: 'بانتظار تأكيد إيصال التحويل',
            time: '08:44',
            tint: Color(0xFFE0EEFF),
          ),
          SizedBox(height: 10),
          _MessageListTile(
            title: 'متابعة العميل',
            subtitle: 'تم إرسال تذكير آلي اليوم',
            time: 'اليوم',
            tint: Color(0xFFE7F8EE),
          ),
        ];
        panelTiles = const [
          _MessageListTile(
            title: 'الفواتير المستحقة',
            subtitle: 'نتيجتان تتطلبان متابعة فورية',
            time: 'مالية',
            tint: Color(0xFFEAEAFF),
          ),
          SizedBox(height: 8),
          _MessageListTile(
            title: 'إيصال التحويل',
            subtitle: 'مرفق مفقود في الطلب الأخير',
            time: 'تنبيه',
            tint: Color(0xFFE0EEFF),
          ),
          SizedBox(height: 8),
          _MessageListTile(
            title: 'فريق التحصيل',
            subtitle: 'رسالة متابعة جاهزة للإرسال',
            time: 'إجراء',
            tint: Color(0xFFE7F8EE),
          ),
        ];
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final surfaceWidth = constraints.maxWidth - 32;

        return DecoratedBox(
          key: Key('${widget.keyPrefix}_canvas'),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFF6F7FF), Color(0xFFF1F3FF)],
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
                              'المحادثات',
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(fontWeight: FontWeight.w800),
                            ),
                          ),
                          _Badge(label: badgeLabel),
                        ],
                      ),
                      const SizedBox(height: 12),
                      const SizedBox(height: 46),
                      const SizedBox(height: 14),
                      Expanded(child: Column(children: backgroundTiles)),
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
                top: 50,
                left: 16,
                right: 16,
                height: widget.presentation.isDetail ? 254 : 238,
                child: SpringSurface(
                  isExpanded: isExpanded,
                  origin: SpringSurfaceOrigin.top,
                  config: const SpringSurfaceConfig.gentle(),
                  collapsedSize: Size(surfaceWidth, 46),
                  expandedSize: Size(
                    surfaceWidth,
                    widget.presentation.isDetail ? 204 : 186,
                  ),
                  expandedSizing: SpringSurfaceExpandedSizing.dynamicHeight,
                  maxExpandedHeight: widget.presentation.isDetail ? 212 : 188,
                  collapsedDecoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: accent.withAlpha(26)),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x10000000),
                        blurRadius: 16,
                        offset: Offset(0, 8),
                      ),
                    ],
                  ),
                  expandedDecoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(color: accent.withAlpha(30)),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x12000000),
                        blurRadius: 24,
                        offset: Offset(0, 12),
                      ),
                    ],
                  ),
                  collapsedChild: GestureDetector(
                    key: Key('${widget.keyPrefix}_toggle'),
                    behavior: HitTestBehavior.opaque,
                    onTap: toggle,
                    child: _SearchFieldTrigger(
                      text: collapsedText,
                      accent: accent,
                    ),
                  ),
                  expandedChild: _SearchSuggestionsPanel(
                    onToggle: toggle,
                    queryLabel: queryLabel,
                    tiles: panelTiles,
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

class _SearchSuggestionsPanel extends StatelessWidget {
  const _SearchSuggestionsPanel({
    required this.onToggle,
    required this.queryLabel,
    required this.tiles,
  });

  final VoidCallback onToggle;
  final String queryLabel;
  final List<Widget> tiles;

  @override
  Widget build(BuildContext context) {
    return _SurfaceScrollableContent(
      children: [
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: onToggle,
          child: _SearchFieldTrigger(
            text: queryLabel,
            accent: const Color(0xFF4F46E5),
            expanded: true,
          ),
        ),
        const SizedBox(height: 12),
        ...tiles,
      ],
    );
  }
}
