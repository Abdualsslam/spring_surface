part of '../spring_surface_test_lab_page.dart';

class _TicketActionsDetailExperience extends StatefulWidget {
  const _TicketActionsDetailExperience();

  @override
  State<_TicketActionsDetailExperience> createState() =>
      _TicketActionsDetailExperienceState();
}

class _TicketActionsDetailExperienceState
    extends State<_TicketActionsDetailExperience> {
  final _sceneKey = GlobalKey<_TicketActionsScenarioState>();

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
      child: _TicketActionsScenario(
        key: _sceneKey,
        presentation: _ScenarioPresentation.detail,
        keyPrefix: 'ticket_actions_detail',
      ),
    );
  }
}

class _TicketActionsScenario extends StatefulWidget {
  const _TicketActionsScenario({
    super.key,
    this.presentation = _ScenarioPresentation.compact,
    this.keyPrefix = 'ticket_actions',
  });

  final _ScenarioPresentation presentation;
  final String keyPrefix;

  @override
  State<_TicketActionsScenario> createState() => _TicketActionsScenarioState();
}

class _TicketActionsScenarioState
    extends _ExpandableSceneState<_TicketActionsScenario> {
  @override
  Widget build(BuildContext context) {
    const accent = Color(0xFF0F766E);
    const currentStatus = _TicketStatus.open;

    late final String badgeText;
    late final String stripLabel;
    late final String stripDetail;
    late final String cardNote;
    late final String lastReply;
    late final String assignee;
    late final String hintText;
    late final List<Widget> panelActions;

    switch (currentStatus) {
      case _TicketStatus.open:
        badgeText = 'مفتوحة';
        stripLabel = 'تحديث الحالة';
        stripDetail = 'إرسال رد سريع أو تحويل التذكرة';
        cardNote = 'العميل يطلب تحديثاً نهائياً على العقد قبل نهاية اليوم.';
        lastReply = 'منذ 6 دقائق';
        assignee = 'فريق العقود';
        hintText =
            'ملاحظة داخلية: أرسل تحديثاً مختصراً ثم حوّل النسخة النهائية للمراجعة.';
        panelActions = const [
          Row(
            children: [
              Expanded(
                child: _ActionTile(
                  title: 'رد سريع',
                  subtitle: 'اعتماد النص الجاهز',
                  icon: Icons.reply_rounded,
                  tint: Color(0xFFDFF7F1),
                ),
              ),
              SizedBox(width: 8),
              Expanded(
                child: _ActionTile(
                  title: 'تحويل',
                  subtitle: 'إلى الفريق القانوني',
                  icon: Icons.swap_horiz_rounded,
                  tint: Color(0xFFEAF5FF),
                ),
              ),
            ],
          ),
        ];
      case _TicketStatus.waitingCustomer:
        badgeText = 'بانتظار العميل';
        stripLabel = 'متابعة العميل';
        stripDetail = 'إرسال تذكير أو جدولة متابعة';
        cardNote = 'بانتظار تأكيد العميل على النسخة المختصرة قبل الإغلاق.';
        lastReply = 'منذ 42 دقيقة';
        assignee = 'نجاح العملاء';
        hintText =
            'المتابعة القادمة: إرسال تذكير آلي عند الخامسة إذا لم يصل رد.';
        panelActions = const [
          Row(
            children: [
              Expanded(
                child: _ActionTile(
                  title: 'تذكير',
                  subtitle: 'رسالة متابعة جاهزة',
                  icon: Icons.notifications_active_outlined,
                  tint: Color(0xFFEAF5FF),
                ),
              ),
              SizedBox(width: 8),
              Expanded(
                child: _ActionTile(
                  title: 'إعادة جدولة',
                  subtitle: 'بعد ساعتين',
                  icon: Icons.schedule_rounded,
                  tint: Color(0xFFDFF7F1),
                ),
              ),
            ],
          ),
        ];
      case _TicketStatus.escalated:
        badgeText = 'مصعدة';
        stripLabel = 'تصعيد التذكرة';
        stripDetail = 'إشعار الإدارة ومراقبة الاستجابة';
        cardNote = 'بانتظار موافقة المدير على الاستثناء قبل إصدار العقد.';
        lastReply = 'منذ 3 دقائق';
        assignee = 'إدارة الحسابات الرئيسية';
        hintText =
            'المطلوب الآن: مشاركة موجز سريع مع المدير ثم تحديث العميل بعد الموافقة.';
        panelActions = const [
          Row(
            children: [
              Expanded(
                child: _ActionTile(
                  title: 'إشعار الإدارة',
                  subtitle: 'تحديث فوري للمدير',
                  icon: Icons.campaign_outlined,
                  tint: Color(0xFFEAF5FF),
                ),
              ),
              SizedBox(width: 8),
              Expanded(
                child: _ActionTile(
                  title: 'مراقبة SLA',
                  subtitle: 'متابعة الاستجابة',
                  icon: Icons.query_stats_rounded,
                  tint: Color(0xFFDFF7F1),
                ),
              ),
            ],
          ),
        ];
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final surfaceWidth = math.min(
          constraints.maxWidth - 80,
          widget.presentation.isDetail ? 320.0 : 286.0,
        );

        return DecoratedBox(
          key: Key('${widget.keyPrefix}_canvas'),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFF5FFFC), Color(0xFFEFFAF7)],
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
                              'مكتب الدعم',
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(fontWeight: FontWeight.w800),
                            ),
                          ),
                          const _Badge(label: 'SLA مرتفع'),
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
                          color: const Color(0xFFE5FAF3),
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
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      'تذكرة عميل شركة الندى',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall
                                          ?.copyWith(
                                            fontWeight: FontWeight.w800,
                                          ),
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFE5FAF3),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      badgeText,
                                      style: const TextStyle(
                                        color: accent,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                cardNote,
                                style: Theme.of(context).textTheme.bodySmall
                                    ?.copyWith(
                                      color: Colors.black54,
                                      height: 1.5,
                                    ),
                              ),
                              const SizedBox(height: 12),
                              _InfoRow(label: 'آخر رد', value: lastReply),
                              const SizedBox(height: 8),
                              _InfoRow(
                                label: 'المسؤول الحالي',
                                value: assignee,
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
                                  hintText,
                                  style: Theme.of(context).textTheme.bodySmall
                                      ?.copyWith(
                                        color: Colors.black54,
                                        height: 1.45,
                                      ),
                                ),
                              ),
                              const Spacer(),
                            ],
                          ),
                        ),
                      ),
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
                left: 40,
                right: 40,
                bottom: 28,
                height: widget.presentation.isDetail ? 230 : 214,
                child: SpringSurface(
                  isExpanded: isExpanded,
                  origin: SpringSurfaceOrigin.center,
                  config: const SpringSurfaceConfig.gentle(),
                  collapsedSize: Size(surfaceWidth, 54),
                  expandedSize: Size(
                    surfaceWidth,
                    widget.presentation.isDetail ? 208 : 194,
                  ),
                  collapsedDecoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: accent.withAlpha(38)),
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
                    border: Border.all(color: accent.withAlpha(36)),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x14000000),
                        blurRadius: 24,
                        offset: Offset(0, 14),
                      ),
                    ],
                  ),
                  collapsedChild: GestureDetector(
                    key: Key('${widget.keyPrefix}_toggle'),
                    behavior: HitTestBehavior.opaque,
                    onTap: toggle,
                    child: _CaseActionStrip(
                      label: stripLabel,
                      detail: stripDetail,
                      accent: accent,
                    ),
                  ),
                  expandedChild: _TicketActionsPanel(
                    onToggle: toggle,
                    label: stripLabel,
                    actions: panelActions,
                    hintText: hintText,
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

class _TicketActionsPanel extends StatelessWidget {
  const _TicketActionsPanel({
    required this.onToggle,
    required this.label,
    required this.actions,
    required this.hintText,
  });

  final VoidCallback onToggle;
  final String label;
  final List<Widget> actions;
  final String hintText;

  @override
  Widget build(BuildContext context) {
    return _SurfaceScrollableContent(
      children: [
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: onToggle,
          child: _PanelHeaderButton(
            label: label,
            icon: Icons.bolt_rounded,
            accent: const Color(0xFF0F766E),
          ),
        ),
        const SizedBox(height: 12),
        ...actions,
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFFF6F8FB),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(
            hintText,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Colors.black54,
              height: 1.45,
            ),
          ),
        ),
      ],
    );
  }
}
