// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:spring_surface/spring_surface.dart';

import 'showcase_models.dart';
import 'showcase_shell.dart';
import 'showcase_shared_widgets.dart';

const _searchAccent = Color(0xFF4F46E5);

enum _SearchScope { all, conversations, files, tasks }

enum _SearchQuickAction { open, pin, task }

class _SearchRecord {
  const _SearchRecord({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.meta,
    required this.scope,
    required this.tint,
    required this.icon,
    required this.keywords,
  });

  final String id;
  final String title;
  final String subtitle;
  final String meta;
  final _SearchScope scope;
  final Color tint;
  final IconData icon;
  final String keywords;
}

const _searchRecords = <_SearchRecord>[
  _SearchRecord(
    id: 'sara_contract_thread',
    title: 'سارة - العقود',
    subtitle: 'هل وصلت النسخة النهائية من ملف الشركة؟',
    meta: 'محادثة',
    scope: _SearchScope.conversations,
    tint: Color(0xFFEAEAFF),
    icon: Icons.chat_bubble_outline_rounded,
    keywords: 'سارة عقود نسخة نهائية شركة',
  ),
  _SearchRecord(
    id: 'sara_accounts_thread',
    title: 'سارة - الحسابات',
    subtitle: 'طلب مراجعة نسخة الفاتورة قبل الإرسال.',
    meta: 'محادثة',
    scope: _SearchScope.conversations,
    tint: Color(0xFFE0EEFF),
    icon: Icons.forum_outlined,
    keywords: 'سارة حسابات فاتورة مراجعة',
  ),
  _SearchRecord(
    id: 'support_ticket_history',
    title: 'فريق الدعم',
    subtitle: 'تم إغلاق الحالة رقم 2031 مع آخر تحديثات العميل.',
    meta: 'محادثة',
    scope: _SearchScope.conversations,
    tint: Color(0xFFE7F8EE),
    icon: Icons.support_agent_rounded,
    keywords: 'دعم حالة عميل تحديث',
  ),
  _SearchRecord(
    id: 'sara_contract_pdf',
    title: 'عقد سارة 2026.pdf',
    subtitle: 'آخر نسخة مع تعليقات الإدارة القانونية.',
    meta: 'ملف',
    scope: _SearchScope.files,
    tint: Color(0xFFE0EEFF),
    icon: Icons.description_outlined,
    keywords: 'سارة عقد pdf قانونية نسخة',
  ),
  _SearchRecord(
    id: 'contracts_review_board',
    title: 'جدول اعتماد العقود',
    subtitle: 'يتضمن آخر مرحلة مراجعة لكل عميل.',
    meta: 'ملف',
    scope: _SearchScope.files,
    tint: Color(0xFFEAEAFF),
    icon: Icons.table_chart_outlined,
    keywords: 'عقود اعتماد مراجعة عملاء جدول',
  ),
  _SearchRecord(
    id: 'invoice_april_pdf',
    title: 'فاتورة أبريل - سارة',
    subtitle: 'نسخة PDF جاهزة للمشاركة والتحصيل.',
    meta: 'ملف',
    scope: _SearchScope.files,
    tint: Color(0xFFFFF1D6),
    icon: Icons.receipt_long_outlined,
    keywords: 'فاتورة أبريل سارة تحصيل pdf',
  ),
  _SearchRecord(
    id: 'follow_sara_signature',
    title: 'متابعة توقيع سارة',
    subtitle: 'ذكّر الفريق قبل 2:00 م بإرسال النسخة المعتمدة.',
    meta: 'مهمة',
    scope: _SearchScope.tasks,
    tint: Color(0xFFE7F8EE),
    icon: Icons.task_alt_rounded,
    keywords: 'سارة توقيع متابعة نسخة معتمدة',
  ),
  _SearchRecord(
    id: 'collect_overdue_invoices',
    title: 'تحصيل الفواتير المستحقة',
    subtitle: 'مهمة مفتوحة تحتاج تأكيد وصول إيصال التحويل.',
    meta: 'مهمة',
    scope: _SearchScope.tasks,
    tint: Color(0xFFFFF1D6),
    icon: Icons.assignment_late_outlined,
    keywords: 'فواتير مستحقة تحصيل إيصال تحويل',
  ),
  _SearchRecord(
    id: 'schedule_contract_review',
    title: 'جدولة مراجعة العقود',
    subtitle: 'جهّز موعدًا مع القانونية لإقفال المرحلة النهائية.',
    meta: 'مهمة',
    scope: _SearchScope.tasks,
    tint: Color(0xFFEAEAFF),
    icon: Icons.event_note_rounded,
    keywords: 'عقود مراجعة قانونية موعد',
  ),
];

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
  late final TextEditingController _queryController;
  late final FocusNode _queryFocusNode;
  _SearchScope _activeScope = _SearchScope.all;
  _SearchQuickAction _activeAction = _SearchQuickAction.open;
  String? _lastActionMessage;

  bool get _isDetail => widget.presentation.isDetail;

  String get _query => _queryController.text.trim();

  List<_SearchRecord> get _visibleRecords {
    final normalizedQuery = _normalize(_query);

    return _searchRecords.where((record) {
      final matchesScope =
          _activeScope == _SearchScope.all || record.scope == _activeScope;
      if (!matchesScope) {
        return false;
      }

      if (normalizedQuery.isEmpty) {
        return true;
      }

      final haystack = _normalize(
        '${record.title} ${record.subtitle} ${record.meta} ${record.keywords}',
      );
      return haystack.contains(normalizedQuery);
    }).toList();
  }

  List<_SearchRecord> get _backgroundRecords =>
      _visibleRecords.take(3).toList(growable: false);

  String get _collapsedText {
    if (_query.isEmpty) {
      return _isDetail
          ? 'ابحث باسم العميل أو الملف'
          : 'ابحث في المحادثات أو الملفات';
    }
    return _query;
  }

  String get _badgeLabel {
    if (_query.isEmpty) {
      return '٣ مصادر بحث';
    }
    return 'نتائج ${_visibleRecords.length}';
  }

  String get _actionSummary {
    final scopeLabel = _scopeLabel(_activeScope);
    switch (_activeAction) {
      case _SearchQuickAction.open:
        return 'الإجراء النشط: فتح النتيجة المناسبة مباشرة من $scopeLabel.';
      case _SearchQuickAction.pin:
        return 'الإجراء النشط: تثبيت البحث الحالي لاستخدامه لاحقًا داخل $scopeLabel.';
      case _SearchQuickAction.task:
        return 'الإجراء النشط: تحويل النتيجة المختارة إلى مهمة متابعة.';
    }
  }

  @override
  void initState() {
    super.initState();
    _queryController = TextEditingController(text: _isDetail ? 'سارة' : '');
    _queryFocusNode = FocusNode();
    _queryController.addListener(_handleQueryChanged);
    if (_isDetail) {
      _activeScope = _SearchScope.conversations;
    }
  }

  @override
  void dispose() {
    _queryController.removeListener(_handleQueryChanged);
    _queryController.dispose();
    _queryFocusNode.dispose();
    super.dispose();
  }

  @override
  void setExpanded(bool value) {
    final wasExpanded = isExpanded;
    super.setExpanded(value);

    if (value == wasExpanded) {
      return;
    }

    if (value) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) {
          return;
        }
        _queryFocusNode.requestFocus();
        _queryController.selection = TextSelection.collapsed(
          offset: _queryController.text.length,
        );
      });
    } else {
      _queryFocusNode.unfocus();
    }
  }

  void _handleQueryChanged() {
    if (!mounted) {
      return;
    }
    setState(() {
      _lastActionMessage = null;
    });
  }

  void _setScope(_SearchScope scope) {
    setState(() {
      _activeScope = scope;
      _lastActionMessage = null;
    });
    if (!isExpanded) {
      open();
    }
  }

  void _setAction(_SearchQuickAction action) {
    setState(() {
      _activeAction = action;
      _lastActionMessage = null;
    });
  }

  void _clearQuery() {
    _queryController.clear();
    _queryFocusNode.requestFocus();
  }

  void _applySuggestion(_SearchRecord record) {
    _queryController.value = TextEditingValue(
      text: record.title,
      selection: TextSelection.collapsed(offset: record.title.length),
    );
    _setScope(record.scope);
  }

  void _executeAction(_SearchRecord record) {
    final message = switch (_activeAction) {
      _SearchQuickAction.open =>
        'تم تجهيز فتح "${record.title}" من قسم ${_scopeLabel(record.scope)}.',
      _SearchQuickAction.pin =>
        'تم تثبيت "${record.title}" ضمن عمليات البحث السريعة.',
      _SearchQuickAction.task =>
        'تم إنشاء متابعة جديدة انطلاقًا من "${record.title}".',
    };

    setState(() {
      _lastActionMessage = message;
    });
  }

  @override
  Widget build(BuildContext context) {
    final backgroundRecords = _backgroundRecords;

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
                          ShowcaseBadge(label: _badgeLabel),
                        ],
                      ),
                      const SizedBox(height: 12),
                      const SizedBox(height: 46),
                      const SizedBox(height: 14),
                      Expanded(
                        child: Column(
                          children: [
                            for (
                              var i = 0;
                              i < backgroundRecords.length;
                              i++
                            ) ...[
                              _SearchHistoryTile(record: backgroundRecords[i]),
                              if (i < backgroundRecords.length - 1)
                                const SizedBox(height: 10),
                            ],
                          ],
                        ),
                      ),
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
                height: _isDetail ? 420 : 304,
                child: SpringSurface(
                  isExpanded: isExpanded,
                  origin: SpringSurfaceOrigin.top,
                  config: const SpringSurfaceConfig.gentle(),
                  collapsedSize: Size(surfaceWidth, 46),
                  expandedSize: Size(surfaceWidth, _isDetail ? 360 : 252),
                  expandedSizing: SpringSurfaceExpandedSizing.dynamicHeight,
                  maxExpandedHeight: _isDetail ? 368 : 260,
                  collapsedDecoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: _searchAccent.withAlpha(26)),
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
                    border: Border.all(color: _searchAccent.withAlpha(30)),
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
                      text: _collapsedText,
                      accent: _searchAccent,
                    ),
                  ),
                  expandedChild: _SearchSuggestionsPanel(
                    keyPrefix: widget.keyPrefix,
                    queryController: _queryController,
                    queryFocusNode: _queryFocusNode,
                    onToggle: toggle,
                    onClearQuery: _clearQuery,
                    activeScope: _activeScope,
                    onScopeSelected: _setScope,
                    activeAction: _activeAction,
                    onActionSelected: _setAction,
                    results: _visibleRecords,
                    actionSummary: _actionSummary,
                    lastActionMessage: _lastActionMessage,
                    onResultSelected: _applySuggestion,
                    onResultAction: _executeAction,
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
    required this.keyPrefix,
    required this.queryController,
    required this.queryFocusNode,
    required this.onToggle,
    required this.onClearQuery,
    required this.activeScope,
    required this.onScopeSelected,
    required this.activeAction,
    required this.onActionSelected,
    required this.results,
    required this.actionSummary,
    required this.lastActionMessage,
    required this.onResultSelected,
    required this.onResultAction,
  });

  final String keyPrefix;
  final TextEditingController queryController;
  final FocusNode queryFocusNode;
  final VoidCallback onToggle;
  final VoidCallback onClearQuery;
  final _SearchScope activeScope;
  final ValueChanged<_SearchScope> onScopeSelected;
  final _SearchQuickAction activeAction;
  final ValueChanged<_SearchQuickAction> onActionSelected;
  final List<_SearchRecord> results;
  final String actionSummary;
  final String? lastActionMessage;
  final ValueChanged<_SearchRecord> onResultSelected;
  final ValueChanged<_SearchRecord> onResultAction;

  @override
  Widget build(BuildContext context) {
    return SurfaceScrollableContent(
      children: [
        _SearchEditorBar(
          fieldKey: Key('${keyPrefix}_query_field'),
          controller: queryController,
          focusNode: queryFocusNode,
          onToggle: onToggle,
          onClearQuery: onClearQuery,
        ),
        const SizedBox(height: 12),
        Text(
          'نطاق البحث',
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
            color: Colors.black54,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _SearchScope.values
              .map(
                (scope) => _SearchScopeChip(
                  chipKey: Key('${keyPrefix}_scope_${scope.name}'),
                  label: _scopeLabel(scope),
                  icon: _scopeIcon(scope),
                  selected: scope == activeScope,
                  onTap: () => onScopeSelected(scope),
                ),
              )
              .toList(),
        ),
        const SizedBox(height: 12),
        _SearchStatusBanner(
          bannerKey: Key('${keyPrefix}_action_banner'),
          accent: _searchAccent,
          icon: Icons.auto_awesome_rounded,
          text: actionSummary,
          background: const Color(0xFFF4F3FF),
        ),
        const SizedBox(height: 12),
        Text(
          'عمليات سريعة',
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
            color: Colors.black54,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _SearchQuickAction.values
              .map(
                (action) => _SearchQuickActionChip(
                  chipKey: Key('${keyPrefix}_action_${action.name}'),
                  label: _quickActionLabel(action),
                  detail: _quickActionDetail(action),
                  selected: action == activeAction,
                  onTap: () => onActionSelected(action),
                ),
              )
              .toList(),
        ),
        if (lastActionMessage != null) ...[
          const SizedBox(height: 12),
          _SearchStatusBanner(
            bannerKey: Key('${keyPrefix}_execution_banner'),
            accent: const Color(0xFF0F9D58),
            icon: Icons.check_circle_outline_rounded,
            text: lastActionMessage!,
            background: const Color(0xFFEFFAF4),
          ),
        ],
        const SizedBox(height: 12),
        Text(
          'نتائج حية',
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
            color: Colors.black54,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 8),
        if (results.isEmpty)
          const _SearchEmptyState()
        else
          ...results.map(
            (record) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: _SearchResultTile(
                tileKey: Key('${keyPrefix}_result_${record.id}'),
                actionKey: Key('${keyPrefix}_result_action_${record.id}'),
                record: record,
                actionLabel: _quickActionLabel(activeAction),
                onTap: () {
                  onResultSelected(record);
                  onResultAction(record);
                },
                onActionTap: () => onResultAction(record),
              ),
            ),
          ),
      ],
    );
  }
}

class _SearchEditorBar extends StatelessWidget {
  const _SearchEditorBar({
    required this.fieldKey,
    required this.controller,
    required this.focusNode,
    required this.onToggle,
    required this.onClearQuery,
  });

  final Key fieldKey;
  final TextEditingController controller;
  final FocusNode focusNode;
  final VoidCallback onToggle;
  final VoidCallback onClearQuery;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 46,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F7FF),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _searchAccent.withAlpha(18)),
      ),
      child: Row(
        children: [
          const Icon(Icons.search_rounded, color: _searchAccent, size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              key: fieldKey,
              controller: controller,
              focusNode: focusNode,
              textInputAction: TextInputAction.search,
              decoration: const InputDecoration(
                isCollapsed: true,
                border: InputBorder.none,
                hintText: 'ابحث باسم العميل أو الملف أو المهمة',
              ),
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
          ),
          if (controller.text.isNotEmpty)
            IconButton(
              key: const Key('search_suggestions_clear_query'),
              onPressed: onClearQuery,
              icon: const Icon(Icons.close_rounded, size: 18),
              color: Colors.black45,
              splashRadius: 18,
              tooltip: 'مسح',
            ),
          IconButton(
            key: const Key('search_suggestions_collapse'),
            onPressed: onToggle,
            icon: const Icon(Icons.keyboard_arrow_up_rounded),
            color: _searchAccent,
            splashRadius: 18,
            tooltip: 'إغلاق',
          ),
        ],
      ),
    );
  }
}

class _SearchHistoryTile extends StatelessWidget {
  const _SearchHistoryTile({required this.record});

  final _SearchRecord record;

  @override
  Widget build(BuildContext context) {
    return MessageListTile(
      title: record.title,
      subtitle: record.subtitle,
      time: _scopeLabel(record.scope),
      tint: record.tint,
    );
  }
}

class _SearchScopeChip extends StatelessWidget {
  const _SearchScopeChip({
    required this.chipKey,
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  final Key chipKey;
  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      key: chipKey,
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: selected ? _searchAccent.withAlpha(16) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: selected
                ? _searchAccent.withAlpha(44)
                : const Color(0xFFDADFF3),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 16,
              color: selected ? _searchAccent : Colors.black54,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: selected ? _searchAccent : Colors.black87,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SearchQuickActionChip extends StatelessWidget {
  const _SearchQuickActionChip({
    required this.chipKey,
    required this.label,
    required this.detail,
    required this.selected,
    required this.onTap,
  });

  final Key chipKey;
  final String label;
  final String detail;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      key: chipKey,
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        width: 110,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFFF4F3FF) : Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: selected
                ? _searchAccent.withAlpha(42)
                : const Color(0xFFE2E7F7),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: selected ? _searchAccent : Colors.black87,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              detail,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.black54,
                height: 1.35,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SearchStatusBanner extends StatelessWidget {
  const _SearchStatusBanner({
    required this.bannerKey,
    required this.accent,
    required this.icon,
    required this.text,
    required this.background,
  });

  final Key bannerKey;
  final Color accent;
  final IconData icon;
  final String text;
  final Color background;

  @override
  Widget build(BuildContext context) {
    return Container(
      key: bannerKey,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: accent),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.black87,
                height: 1.45,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SearchResultTile extends StatelessWidget {
  const _SearchResultTile({
    required this.tileKey,
    required this.actionKey,
    required this.record,
    required this.actionLabel,
    required this.onTap,
    required this.onActionTap,
  });

  final Key tileKey;
  final Key actionKey;
  final _SearchRecord record;
  final String actionLabel;
  final VoidCallback onTap;
  final VoidCallback onActionTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      key: tileKey,
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: const Color(0xFFE3E7F4)),
        ),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: record.tint,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(record.icon, color: Colors.black87, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    record.title,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    record.subtitle,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.black54,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _scopeLabel(record.scope),
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: _searchAccent,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            FilledButton.tonal(
              key: actionKey,
              onPressed: onActionTap,
              style: FilledButton.styleFrom(
                backgroundColor: _searchAccent.withAlpha(14),
                foregroundColor: _searchAccent,
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: Text(actionLabel),
            ),
          ],
        ),
      ),
    );
  }
}

class _SearchEmptyState extends StatelessWidget {
  const _SearchEmptyState();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FF),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE2E7F7)),
      ),
      child: Row(
        children: [
          const Icon(Icons.search_off_rounded, color: Colors.black45),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'لا توجد نتائج مطابقة الآن. جرّب تغيير النص أو نطاق البحث أو العملية المطلوبة.',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.black54,
                height: 1.45,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

String _scopeLabel(_SearchScope scope) {
  switch (scope) {
    case _SearchScope.all:
      return 'الكل';
    case _SearchScope.conversations:
      return 'المحادثات';
    case _SearchScope.files:
      return 'الملفات';
    case _SearchScope.tasks:
      return 'المهام';
  }
}

IconData _scopeIcon(_SearchScope scope) {
  switch (scope) {
    case _SearchScope.all:
      return Icons.dashboard_customize_outlined;
    case _SearchScope.conversations:
      return Icons.chat_bubble_outline_rounded;
    case _SearchScope.files:
      return Icons.description_outlined;
    case _SearchScope.tasks:
      return Icons.task_alt_rounded;
  }
}

String _quickActionLabel(_SearchQuickAction action) {
  switch (action) {
    case _SearchQuickAction.open:
      return 'فتح';
    case _SearchQuickAction.pin:
      return 'تثبيت';
    case _SearchQuickAction.task:
      return 'مهمة';
  }
}

String _quickActionDetail(_SearchQuickAction action) {
  switch (action) {
    case _SearchQuickAction.open:
      return 'افتح النتيجة فورًا.';
    case _SearchQuickAction.pin:
      return 'احفظ البحث الحالي.';
    case _SearchQuickAction.task:
      return 'حوّل النتيجة لمتابعة.';
  }
}

String _normalize(String value) => value.toLowerCase();
