part of '../spring_surface_test_lab_page.dart';

class _MessageComposerDetailExperience extends StatefulWidget {
  const _MessageComposerDetailExperience();

  @override
  State<_MessageComposerDetailExperience> createState() =>
      _MessageComposerDetailExperienceState();
}

class _MessageComposerDetailExperienceState
    extends State<_MessageComposerDetailExperience> {
  final _sceneKey = GlobalKey<_MessageComposerScenarioState>();

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
      child: _MessageComposerScenario(
        key: _sceneKey,
        presentation: _ScenarioPresentation.detail,
        keyPrefix: 'message_composer_detail',
      ),
    );
  }
}

class _MessageComposerScenario extends StatefulWidget {
  const _MessageComposerScenario({
    super.key,
    this.presentation = _ScenarioPresentation.compact,
    this.keyPrefix = 'message_composer',
  });

  final _ScenarioPresentation presentation;
  final String keyPrefix;

  @override
  State<_MessageComposerScenario> createState() =>
      _MessageComposerScenarioState();
}

class _MessageComposerScenarioState
    extends _ExpandableSceneState<_MessageComposerScenario> {
  @override
  Widget build(BuildContext context) {
    const accent = Color(0xFF039855);
    const currentComposerMode = _ComposerMode.file;

    late final String placeholder;
    late final String bubbleOne;
    late final String bubbleThree;
    late final String panelLabel;
    late final List<Widget> panelRows;

    switch (currentComposerMode) {
      case _ComposerMode.file:
        placeholder = 'أرفق ملف المراجعة النهائية';
        bubbleOne = 'هل نرسل النسخة المختصرة الآن أم بعد المراجعة الأخيرة؟';
        bubbleThree = 'ممتاز، سأرفق ملف النقاط الرئيسية أيضاً.';
        panelLabel = 'إرفاق سريع';
        panelRows = const [
          Row(
            children: [
              Expanded(
                child: _ActionTile(
                  title: 'ملف',
                  subtitle: 'PDF أو Docx',
                  icon: Icons.insert_drive_file_outlined,
                  tint: Color(0xFFE6F7EC),
                ),
              ),
              SizedBox(width: 8),
              Expanded(
                child: _ActionTile(
                  title: 'قالب',
                  subtitle: 'رد جاهز',
                  icon: Icons.text_snippet_outlined,
                  tint: Color(0xFFEFF9F3),
                ),
              ),
            ],
          ),
        ];
      case _ComposerMode.image:
        placeholder = 'أرفق صورة مرجعية للواجهة';
        bubbleOne = 'نحتاج لقطة الشاشة الأخيرة قبل إرسال التوضيح للعميل.';
        bubbleThree = 'سأرفق صورة مرجعية مع تمييز الجزء المطلوب.';
        panelLabel = 'إرسال صورة';
        panelRows = const [
          Row(
            children: [
              Expanded(
                child: _ActionTile(
                  title: 'صورة',
                  subtitle: 'من المعرض',
                  icon: Icons.image_outlined,
                  tint: Color(0xFFE9F7EF),
                ),
              ),
              SizedBox(width: 8),
              Expanded(
                child: _ActionTile(
                  title: 'كاميرا',
                  subtitle: 'التقاط الآن',
                  icon: Icons.photo_camera_outlined,
                  tint: Color(0xFFE6F7EC),
                ),
              ),
            ],
          ),
        ];
      case _ComposerMode.voice:
        placeholder = 'سجل ملاحظة صوتية مختصرة';
        bubbleOne = 'هل نكتفي بتحديث مكتوب أم نرسل شرحاً صوتياً للفريق؟';
        bubbleThree = 'سأضيف ملاحظة صوتية قصيرة مع أهم النقاط.';
        panelLabel = 'ملاحظة صوتية';
        panelRows = const [
          Row(
            children: [
              Expanded(
                child: _ActionTile(
                  title: 'تسجيل',
                  subtitle: 'ابدأ الآن',
                  icon: Icons.mic_none_rounded,
                  tint: Color(0xFFE6F7EC),
                ),
              ),
              SizedBox(width: 8),
              Expanded(
                child: _ActionTile(
                  title: 'تذكير',
                  subtitle: 'بعد ساعة',
                  icon: Icons.alarm_rounded,
                  tint: Color(0xFFEFF9F3),
                ),
              ),
            ],
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
              colors: [Color(0xFFF6FFF9), Color(0xFFEEF9F2)],
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
                              'محادثة الفريق',
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(fontWeight: FontWeight.w800),
                            ),
                          ),
                          const _Badge(label: 'متصل الآن'),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Expanded(
                        child: Column(
                          children: [
                            _ChatBubble(text: bubbleOne, mine: false),
                            const SizedBox(height: 10),
                            const _ChatBubble(
                              text:
                                  'أرسل المختصرة الآن، والنسخة الكاملة بعد اعتماد المدير.',
                              mine: true,
                            ),
                            const SizedBox(height: 10),
                            _ChatBubble(text: bubbleThree, mine: false),
                            const Spacer(),
                            const SizedBox(height: 58),
                          ],
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
                left: 16,
                right: 16,
                bottom: 16,
                height: widget.presentation.isDetail ? 230 : 214,
                child: SpringSurface(
                  isExpanded: isExpanded,
                  origin: SpringSurfaceOrigin.bottom,
                  config: const SpringSurfaceConfig.gentle(),
                  collapsedSize: Size(surfaceWidth, 52),
                  expandedSize: Size(
                    surfaceWidth,
                    widget.presentation.isDetail ? 196 : 184,
                  ),
                  collapsedDecoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(color: accent.withAlpha(30)),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x12000000),
                        blurRadius: 18,
                        offset: Offset(0, 10),
                      ),
                    ],
                  ),
                  expandedDecoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: accent.withAlpha(34)),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x16000000),
                        blurRadius: 24,
                        offset: Offset(0, 14),
                      ),
                    ],
                  ),
                  collapsedChild: GestureDetector(
                    key: Key('${widget.keyPrefix}_toggle'),
                    behavior: HitTestBehavior.opaque,
                    onTap: toggle,
                    child: _ComposerBar(
                      placeholder: placeholder,
                      accent: accent,
                    ),
                  ),
                  expandedChild: _MessageComposerPanel(
                    onToggle: toggle,
                    label: panelLabel,
                    rows: panelRows,
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

class _MessageComposerPanel extends StatelessWidget {
  const _MessageComposerPanel({
    required this.onToggle,
    required this.label,
    required this.rows,
  });

  final VoidCallback onToggle;
  final String label;
  final List<Widget> rows;

  @override
  Widget build(BuildContext context) {
    return _SurfaceScrollableContent(
      children: [
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: onToggle,
          child: _PanelHeaderButton(
            label: label,
            icon: Icons.attach_file_rounded,
            accent: const Color(0xFF039855),
          ),
        ),
        const SizedBox(height: 12),
        ...rows,
      ],
    );
  }
}
