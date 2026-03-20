// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:spring_surface/spring_surface.dart';

import 'showcase_models.dart';
import 'showcase_shell.dart';
import 'showcase_shared_widgets.dart';

enum _ComposerMode { file, image, voice }

class MessageComposerScenario extends StatefulWidget {
  const MessageComposerScenario({
    super.key,
    this.displayMode = ScenarioDisplayMode.compact,
    this.keyPrefix = 'message_composer',
  });

  final ScenarioDisplayMode displayMode;
  final String keyPrefix;

  @override
  State<MessageComposerScenario> createState() =>
      MessageComposerScenarioState();
}

class MessageComposerScenarioState
    extends ExpandableSceneState<MessageComposerScenario> {
  late final TextEditingController _draftController;
  late final FocusNode _draftFocusNode;

  @override
  void initState() {
    super.initState();
    _draftController = TextEditingController(
      text: _initialDraftFor(_ComposerMode.file),
    );
    _draftFocusNode = FocusNode();
  }

  @override
  void dispose() {
    _draftController.dispose();
    _draftFocusNode.dispose();
    super.dispose();
  }

  String _initialDraftFor(_ComposerMode mode) {
    switch (mode) {
      case _ComposerMode.file:
        return 'أرفق ملف المراجعة النهائية';
      case _ComposerMode.image:
        return 'أرفق صورة مرجعية للواجهة';
      case _ComposerMode.voice:
        return 'سجل ملاحظة صوتية مختصرة';
    }
  }

  void _expandComposer() {
    if (isExpanded) {
      return;
    }
    _draftFocusNode.unfocus();
    toggle();
  }

  @override
  Widget build(BuildContext context) {
    const accent = Color(0xFF039855);
    const currentComposerMode = _ComposerMode.file;

    late final String bubbleOne;
    late final String bubbleThree;
    late final String panelLabel;
    late final List<Widget> panelRows;

    switch (currentComposerMode) {
      case _ComposerMode.file:
        bubbleOne = 'هل نرسل النسخة المختصرة الآن أم بعد المراجعة الأخيرة؟';
        bubbleThree = 'ممتاز، سأرفق ملف النقاط الرئيسية أيضاً.';
        panelLabel = 'إرفاق سريع';
        panelRows = const [
          Row(
            children: [
              Expanded(
                child: ActionTile(
                  title: 'ملف',
                  subtitle: 'PDF أو Docx',
                  icon: Icons.insert_drive_file_outlined,
                  tint: Color(0xFFE6F7EC),
                ),
              ),
              SizedBox(width: 8),
              Expanded(
                child: ActionTile(
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
        bubbleOne = 'نحتاج لقطة الشاشة الأخيرة قبل إرسال التوضيح للعميل.';
        bubbleThree = 'سأرفق صورة مرجعية مع تمييز الجزء المطلوب.';
        panelLabel = 'إرسال صورة';
        panelRows = const [
          Row(
            children: [
              Expanded(
                child: ActionTile(
                  title: 'صورة',
                  subtitle: 'من المعرض',
                  icon: Icons.image_outlined,
                  tint: Color(0xFFE9F7EF),
                ),
              ),
              SizedBox(width: 8),
              Expanded(
                child: ActionTile(
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
        bubbleOne = 'هل نكتفي بتحديث مكتوب أم نرسل شرحاً صوتياً للفريق؟';
        bubbleThree = 'سأضيف ملاحظة صوتية قصيرة مع أهم النقاط.';
        panelLabel = 'ملاحظة صوتية';
        panelRows = const [
          Row(
            children: [
              Expanded(
                child: ActionTile(
                  title: 'تسجيل',
                  subtitle: 'ابدأ الآن',
                  icon: Icons.mic_none_rounded,
                  tint: Color(0xFFE6F7EC),
                ),
              ),
              SizedBox(width: 8),
              Expanded(
                child: ActionTile(
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

    return BottomDockScenarioShell(
      keyPrefix: widget.keyPrefix,
      displayMode: widget.displayMode,
      isExpanded: isExpanded,
      onToggle: toggle,
      onClose: close,
      accent: accent,
      gradient: const LinearGradient(
        colors: [Color(0xFFF6FFF9), Color(0xFFEEF9F2)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ),
      title: 'محادثة الفريق',
      badgeLabel: 'متصل الآن',
      surfaceConfig: const SpringSurfaceConfig.gentle(),
      collapsedHeight: 52,
      expandedHeightCompact: 196,
      expandedHeightFeatured: 208,
      surfaceHostHeightCompact: 226,
      surfaceHostHeightFeatured: 242,
      wrapCollapsedChildWithToggle: false,
      backgroundBuilder: (context) {
        return Column(
          children: [
            ChatBubble(text: bubbleOne, mine: false),
            const SizedBox(height: 10),
            const ChatBubble(
              text: 'أرسل المختصرة الآن، والنسخة الكاملة بعد اعتماد المدير.',
              mine: true,
            ),
            const SizedBox(height: 10),
            ChatBubble(text: bubbleThree, mine: false),
            const Spacer(),
            const SizedBox(height: 58),
          ],
        );
      },
      collapsedChild: ComposerBar(
        placeholder: 'اكتب رسالة أو أضف مرفقاً',
        accent: accent,
        controller: _draftController,
        focusNode: _draftFocusNode,
        onExpandTap: _expandComposer,
        inputFieldKey: Key('${widget.keyPrefix}_input_field'),
        expandButtonKey: Key('${widget.keyPrefix}_expand_button'),
      ),
      expandedChild: _MessageComposerPanel(
        onToggle: toggle,
        label: panelLabel,
        rows: panelRows,
        draftController: _draftController,
        draftPreviewKey: Key('${widget.keyPrefix}_draft_preview'),
      ),
    );
  }
}

class _MessageComposerPanel extends StatelessWidget {
  const _MessageComposerPanel({
    required this.onToggle,
    required this.label,
    required this.rows,
    required this.draftController,
    required this.draftPreviewKey,
  });

  final VoidCallback onToggle;
  final String label;
  final List<Widget> rows;
  final TextEditingController draftController;
  final Key draftPreviewKey;

  @override
  Widget build(BuildContext context) {
    return SurfaceScrollableContent(
      children: [
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: onToggle,
          child: PanelHeaderButton(
            label: label,
            icon: Icons.attach_file_rounded,
            accent: const Color(0xFF039855),
          ),
        ),
        const SizedBox(height: 12),
        ComposerDraftCard(
          cardKey: draftPreviewKey,
          controller: draftController,
          label: 'المسودة الحالية',
          emptyLabel: 'ابدأ بكتابة الرسالة من الشريط السفلي.',
        ),
        const SizedBox(height: 12),
        ...rows,
      ],
    );
  }
}
