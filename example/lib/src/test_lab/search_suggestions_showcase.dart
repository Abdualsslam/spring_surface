// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:spring_surface/spring_surface.dart';
import 'showcase_models.dart';
import 'showcase_shell.dart';
import 'showcase_shared_widgets.dart';

enum _SearchQueryPreset { sara, contracts, invoices }

class SearchSuggestionsDetailExperience extends StatefulWidget {
  const SearchSuggestionsDetailExperience();

  @override
  State<SearchSuggestionsDetailExperience> createState() =>
      SearchSuggestionsDetailExperienceState();
}

class SearchSuggestionsDetailExperienceState
    extends State<SearchSuggestionsDetailExperience> {
  final _sceneKey = GlobalKey<SearchSuggestionsScenarioState>();

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
      child: SearchSuggestionsScenario(
        key: _sceneKey,
        presentation: ScenarioPresentation.detail,
        keyPrefix: 'search_suggestions_detail',
      ),
    );
  }
}

class SearchSuggestionsScenario extends StatefulWidget {
  const SearchSuggestionsScenario({
    super.key,
    this.presentation = ScenarioPresentation.compact,
    this.keyPrefix = 'search_suggestions',
  });

  final ScenarioPresentation presentation;
  final String keyPrefix;

  @override
  State<SearchSuggestionsScenario> createState() =>
      SearchSuggestionsScenarioState();
}

class SearchSuggestionsScenarioState
    extends ExpandableSceneState<SearchSuggestionsScenario> {
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
          MessageListTile(
            title: 'سارة - العقود',
            subtitle: 'هل وصلت النسخة النهائية؟',
            time: '11:20',
            tint: Color(0xFFEAEAFF),
          ),
          SizedBox(height: 10),
          MessageListTile(
            title: 'سارة - الحسابات',
            subtitle: 'طلب مراجعة نسخة الفاتورة',
            time: '10:52',
            tint: Color(0xFFE0EEFF),
          ),
          SizedBox(height: 10),
          MessageListTile(
            title: 'فريق الدعم',
            subtitle: 'تم إغلاق الحالة رقم 2031.',
            time: 'أمس',
            tint: Color(0xFFE7F8EE),
          ),
        ];
        panelTiles = const [
          MessageListTile(
            title: 'سارة - العقود',
            subtitle: 'آخر تحديث على ملف الشركة',
            time: 'محادثة',
            tint: Color(0xFFEAEAFF),
          ),
          SizedBox(height: 8),
          MessageListTile(
            title: 'سارة - الحسابات',
            subtitle: 'طلب مراجعة نسخة الفاتورة',
            time: 'محادثة',
            tint: Color(0xFFE7F8EE),
          ),
          SizedBox(height: 8),
          MessageListTile(
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
          MessageListTile(
            title: 'العقود المعتمدة',
            subtitle: 'ثلاث نسخ حديثة من العقد السنوي',
            time: 'ملفات',
            tint: Color(0xFFE0EEFF),
          ),
          SizedBox(height: 10),
          MessageListTile(
            title: 'فريق العقود',
            subtitle: 'بانتظار موافقة الإدارة القانونية',
            time: '09:18',
            tint: Color(0xFFEAEAFF),
          ),
          SizedBox(height: 10),
          MessageListTile(
            title: 'الأرشيف',
            subtitle: 'نسخ أقدم مرتبطة بالشركة نفسها',
            time: 'أرشيف',
            tint: Color(0xFFE7F8EE),
          ),
        ];
        panelTiles = const [
          MessageListTile(
            title: 'العقود المعتمدة',
            subtitle: '3 ملفات تطابق عبارة البحث',
            time: 'ملفات',
            tint: Color(0xFFE0EEFF),
          ),
          SizedBox(height: 8),
          MessageListTile(
            title: 'آخر موافقة قانونية',
            subtitle: 'تم الاعتماد خلال هذا الأسبوع',
            time: 'معلومة',
            tint: Color(0xFFEAEAFF),
          ),
          SizedBox(height: 8),
          MessageListTile(
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
          MessageListTile(
            title: 'الفواتير المستحقة',
            subtitle: 'فاتورتان متأخرتان عن موعد السداد',
            time: 'مالية',
            tint: Color(0xFFEAEAFF),
          ),
          SizedBox(height: 10),
          MessageListTile(
            title: 'إشعار الحسابات',
            subtitle: 'بانتظار تأكيد إيصال التحويل',
            time: '08:44',
            tint: Color(0xFFE0EEFF),
          ),
          SizedBox(height: 10),
          MessageListTile(
            title: 'متابعة العميل',
            subtitle: 'تم إرسال تذكير آلي اليوم',
            time: 'اليوم',
            tint: Color(0xFFE7F8EE),
          ),
        ];
        panelTiles = const [
          MessageListTile(
            title: 'الفواتير المستحقة',
            subtitle: 'نتيجتان تتطلبان متابعة فورية',
            time: 'مالية',
            tint: Color(0xFFEAEAFF),
          ),
          SizedBox(height: 8),
          MessageListTile(
            title: 'إيصال التحويل',
            subtitle: 'مرفق مفقود في الطلب الأخير',
            time: 'تنبيه',
            tint: Color(0xFFE0EEFF),
          ),
          SizedBox(height: 8),
          MessageListTile(
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
                          ShowcaseBadge(label: badgeLabel),
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
                ScenarioBackdrop(
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
                    child: SearchFieldTrigger(
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
    return SurfaceScrollableContent(
      children: [
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: onToggle,
          child: SearchFieldTrigger(
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
