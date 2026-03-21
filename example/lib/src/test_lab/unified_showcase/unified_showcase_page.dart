import 'package:flutter/material.dart';
import 'package:spring_surface/spring_surface.dart';

import 'unified_showcase_activity_section.dart';
import 'unified_showcase_composer_dock.dart';
import 'unified_showcase_header_section.dart';
import 'unified_showcase_locale_surface.dart';
import 'unified_showcase_models.dart';
import 'unified_showcase_schedule_section.dart';
import 'unified_showcase_shared_widgets.dart';

class SpringSurfaceUnifiedShowcasePage extends StatefulWidget {
  const SpringSurfaceUnifiedShowcasePage({super.key});

  static const routeName = '/unified-showcase';

  @override
  State<SpringSurfaceUnifiedShowcasePage> createState() =>
      _SpringSurfaceUnifiedShowcasePageState();
}

class _SpringSurfaceUnifiedShowcasePageState
    extends State<SpringSurfaceUnifiedShowcasePage>
    with TickerProviderStateMixin {
  bool _searchExpanded = false;
  bool _filterExpanded = false;
  bool _localeExpanded = false;
  bool _dayExpanded = false;
  UnifiedShowcaseFilterPreset _filterPreset =
      UnifiedShowcaseFilterPreset.urgent;
  UnifiedShowcaseLocale _locale = UnifiedShowcaseLocale.english;
  late final SpringSurfaceController _composerController;
  late final TextEditingController _draftController;
  late final FocusNode _draftFocusNode;

  bool get _isArabic => _locale.isArabic;
  TextDirection get _pageTextDirection => _locale.textDirection;
  UnifiedShowcaseStrings get _strings => _locale.strings;

  @override
  void initState() {
    super.initState();
    _draftController = TextEditingController(
      text: englishUnifiedShowcaseStrings.defaultDraftText,
    );
    _draftFocusNode = FocusNode();
    _composerController = SpringSurfaceController(
      vsync: this,
      config: const SpringSurfaceConfig.bouncy(),
    );
  }

  @override
  void dispose() {
    _draftController.dispose();
    _draftFocusNode.dispose();
    _composerController.dispose();
    super.dispose();
  }

  String get _filterLabel => switch (_filterPreset) {
    UnifiedShowcaseFilterPreset.urgent => _strings.filterUrgentLabel,
    UnifiedShowcaseFilterPreset.labs => _strings.filterLabsLabel,
    UnifiedShowcaseFilterPreset.followUps => _strings.filterFollowUpsLabel,
  };

  String get _filterSummary => switch (_filterPreset) {
    UnifiedShowcaseFilterPreset.urgent => _strings.filterUrgentSummary,
    UnifiedShowcaseFilterPreset.labs => _strings.filterLabsSummary,
    UnifiedShowcaseFilterPreset.followUps => _strings.filterFollowUpsSummary,
  };

  void _toggleSearchPanel() {
    setState(() {
      _dayExpanded = false;
      _localeExpanded = false;
      final nextValue = !_searchExpanded;
      _searchExpanded = nextValue;
      if (nextValue) {
        _filterExpanded = false;
      }
    });
  }

  void _toggleFilterPanel() {
    setState(() {
      _dayExpanded = false;
      _localeExpanded = false;
      final nextValue = !_filterExpanded;
      _filterExpanded = nextValue;
      if (nextValue) {
        _searchExpanded = false;
      }
    });
  }

  void _closeSearchPanel() {
    if (!_searchExpanded) return;
    setState(() => _searchExpanded = false);
  }

  void _closeFilterPanel() {
    if (!_filterExpanded) return;
    setState(() => _filterExpanded = false);
  }

  void _selectFilterPreset(UnifiedShowcaseFilterPreset preset) {
    setState(() {
      _filterPreset = preset;
      _filterExpanded = true;
      _searchExpanded = false;
      _localeExpanded = false;
    });
  }

  void _toggleDayDetail() {
    setState(() {
      _searchExpanded = false;
      _filterExpanded = false;
      _localeExpanded = false;
      _dayExpanded = !_dayExpanded;
    });
  }

  void _closeDayDetail() {
    if (!_dayExpanded) return;
    setState(() => _dayExpanded = false);
  }

  void _closeTransientPanels() {
    if (!_searchExpanded &&
        !_filterExpanded &&
        !_localeExpanded &&
        !_dayExpanded) {
      return;
    }
    setState(() {
      _searchExpanded = false;
      _filterExpanded = false;
      _localeExpanded = false;
      _dayExpanded = false;
    });
  }

  Future<void> _toggleLocalePanel() async {
    if (_composerController.isExpanded) {
      await _closeComposer();
    }
    if (!mounted) return;

    setState(() {
      _searchExpanded = false;
      _filterExpanded = false;
      _dayExpanded = false;
      _localeExpanded = !_localeExpanded;
    });
  }

  void _closeLocalePanel() {
    if (!_localeExpanded) return;
    setState(() => _localeExpanded = false);
  }

  void _selectLocale(UnifiedShowcaseLocale locale) {
    final currentDraft = _draftController.text.trim();
    if (currentDraft == englishUnifiedShowcaseStrings.defaultDraftText ||
        currentDraft == arabicUnifiedShowcaseStrings.defaultDraftText) {
      _draftController.text = locale == UnifiedShowcaseLocale.arabic
          ? arabicUnifiedShowcaseStrings.defaultDraftText
          : englishUnifiedShowcaseStrings.defaultDraftText;
    }

    setState(() {
      _locale = locale;
      _localeExpanded = false;
      _searchExpanded = false;
      _filterExpanded = false;
      _dayExpanded = false;
    });
  }

  Future<void> _closeComposer() async {
    _draftFocusNode.unfocus();
    await _composerController.collapse();
  }

  Future<void> _openComposer() async {
    _closeTransientPanels();
    _draftFocusNode.unfocus();
    await _composerController.expand();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _composerController,
      builder: (context, _) {
        final strings = _strings;
        final localeExpandedWidth = MediaQuery.sizeOf(context).width < 400
            ? 188.0
            : 208.0;

        return Directionality(
          key: const Key('unified_showcase_directionality'),
          textDirection: _pageTextDirection,
          child: Scaffold(
            backgroundColor: const Color(0xFFF4F7FB),
            appBar: AppBar(
              backgroundColor: const Color(0xFFF4F7FB),
              surfaceTintColor: Colors.transparent,
              title: Text(strings.appBarTitle),
            ),
            body: SafeArea(
              top: false,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: CustomScrollView(
                      key: const Key('unified_showcase_page'),
                      slivers: [
                        SliverPadding(
                          padding: const EdgeInsets.fromLTRB(16, 84, 16, 140),
                          sliver: SliverList.list(
                            children: [
                              UnifiedShowcaseHeaderSection(
                                textDirection: _pageTextDirection,
                                isArabic: _isArabic,
                                strings: strings,
                                searchExpanded: _searchExpanded,
                                filterExpanded: _filterExpanded,
                                filterPreset: _filterPreset,
                                filterLabel: _filterLabel,
                                filterSummary: _filterSummary,
                                onSearchToggle: _toggleSearchPanel,
                                onSearchClose: _closeSearchPanel,
                                onFilterToggle: _toggleFilterPanel,
                                onFilterClose: _closeFilterPanel,
                                onFilterPresetSelected: _selectFilterPreset,
                              ),
                              const SizedBox(height: 20),
                              UnifiedShowcaseScheduleSection(
                                textDirection: _pageTextDirection,
                                isArabic: _isArabic,
                                strings: strings,
                                dayExpanded: _dayExpanded,
                                onDayToggle: _toggleDayDetail,
                                onDayClose: _closeDayDetail,
                              ),
                              const SizedBox(height: 20),
                              UnifiedShowcaseActivitySection(strings: strings),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (_localeExpanded)
                    UnifiedShowcaseSectionBackdrop(
                      key: const Key('unified_showcase_locale_backdrop'),
                      onTap: _closeLocalePanel,
                      color: const Color(0x120F172A),
                    ),
                  if (_composerController.isExpanded)
                    UnifiedShowcaseSectionBackdrop(
                      key: const Key(
                        'unified_showcase_bottom_composer_backdrop',
                      ),
                      onTap: _closeComposer,
                      color: const Color(0x120F766E),
                    ),
                  Positioned.directional(
                    textDirection: _pageTextDirection,
                    top: 12,
                    end: 16,
                    width: localeExpandedWidth,
                    height: 228,
                    child: UnifiedShowcaseLocaleSurface(
                      isExpanded: _localeExpanded,
                      isArabic: _isArabic,
                      strings: strings,
                      onToggle: _toggleLocalePanel,
                      onSelectEnglish: () =>
                          _selectLocale(UnifiedShowcaseLocale.english),
                      onSelectArabic: () =>
                          _selectLocale(UnifiedShowcaseLocale.arabic),
                      expandedWidth: localeExpandedWidth,
                    ),
                  ),
                  Positioned(
                    left: 16,
                    right: 16,
                    bottom: 16,
                    child: UnifiedShowcaseComposerDock(
                      controller: _composerController,
                      draftController: _draftController,
                      draftFocusNode: _draftFocusNode,
                      strings: strings,
                      onExpand: _openComposer,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
