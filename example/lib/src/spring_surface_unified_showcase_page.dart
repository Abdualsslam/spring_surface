import 'package:flutter/material.dart';
import 'package:spring_surface/spring_surface.dart';

import 'test_lab/showcase_shared_widgets.dart';

class SpringSurfaceUnifiedShowcasePage extends StatelessWidget {
  const SpringSurfaceUnifiedShowcasePage({super.key});

  static const routeName = '/unified-showcase';

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFFF3F5FB),
        appBar: AppBar(
          backgroundColor: const Color(0xFFF3F5FB),
          surfaceTintColor: Colors.transparent,
          title: const Text('Spring Surface Unified Showcase'),
        ),
        body: ListView(
          key: const Key('unified_showcase_page'),
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
          children: const [
            _ShowcaseHero(),
            SizedBox(height: 18),
            _ZoneSection(
              zoneKey: Key('unified_showcase_top_zone'),
              title: 'Top Zone',
              description:
                  'عناصر علوية متنوعة تعرض التمدد من أعلى اليسار والوسط واليمين داخل شريط عمليات مكتظ بالبيانات.',
              child: _UnifiedTopZone(),
            ),
            SizedBox(height: 18),
            _ZoneSection(
              zoneKey: Key('unified_showcase_middle_zone'),
              title: 'Middle Zone',
              description:
                  'لوحة وسطى مليئة بالبطاقات والمواعيد؛ اليوم نفسه يتمدد من المنتصف مع بطاقتين جانبيتين لاتجاهات التمدد الأفقية.',
              child: _UnifiedMiddleZone(),
            ),
            SizedBox(height: 18),
            _ZoneSection(
              zoneKey: Key('unified_showcase_bottom_zone'),
              title: 'Bottom Zone',
              description:
                  'جزء سفلي غني بالمحادثات مع مؤلف رسائل مثبت يتمدد من أسفل المنتصف مثل أمثلة الدردشة.',
              child: _UnifiedBottomZone(),
            ),
          ],
        ),
      ),
    );
  }
}

class _ShowcaseHero extends StatelessWidget {
  const _ShowcaseHero();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0F172A), Color(0xFF1E3A5F)],
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
              'صفحة واحدة لتجربة جميع اتجاهات التمدد ببيانات كثيرة وواضحة.',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'الواجهة تجمع عناصر علوية ووسطية وسفلية داخل شاشة واحدة، وتستعمل anchors متعددة مع dynamicHeight في الأماكن المناسبة.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.white.withAlpha(220),
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ZoneSection extends StatelessWidget {
  const _ZoneSection({
    required this.zoneKey,
    required this.title,
    required this.description,
    required this.child,
  });

  final Key zoneKey;
  final String title;
  final String description;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      key: zoneKey,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: const [
          BoxShadow(
            color: Color(0x12000000),
            blurRadius: 28,
            offset: Offset(0, 14),
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
            child,
          ],
        ),
      ),
    );
  }
}

enum _TopSurfacePanel { status, search, filter }

class _UnifiedTopZone extends StatefulWidget {
  const _UnifiedTopZone();

  @override
  State<_UnifiedTopZone> createState() => _UnifiedTopZoneState();
}

class _UnifiedMiddleZone extends StatefulWidget {
  const _UnifiedMiddleZone();

  @override
  State<_UnifiedMiddleZone> createState() => _UnifiedMiddleZoneState();
}

class _UnifiedBottomZone extends StatefulWidget {
  const _UnifiedBottomZone();

  @override
  State<_UnifiedBottomZone> createState() => _UnifiedBottomZoneState();
}

enum _TopFilterPreset { urgent, today, review }

class _UnifiedTopZoneState extends State<_UnifiedTopZone> {
  _TopSurfacePanel? _activePanel;
  _TopFilterPreset _filterPreset = _TopFilterPreset.urgent;

  String get _filterLabel {
    switch (_filterPreset) {
      case _TopFilterPreset.urgent:
        return 'Urgent';
      case _TopFilterPreset.today:
        return 'Due today';
      case _TopFilterPreset.review:
        return 'Needs review';
    }
  }

  void _togglePanel(_TopSurfacePanel panel) {
    setState(() {
      _activePanel = _activePanel == panel ? null : panel;
    });
  }

  void _closePanel() {
    if (_activePanel == null) {
      return;
    }
    setState(() => _activePanel = null);
  }

  void _selectPreset(_TopFilterPreset preset) {
    setState(() {
      _filterPreset = preset;
      _activePanel = _TopSurfacePanel.filter;
    });
  }

  @override
  Widget build(BuildContext context) {
    const topLeftAccent = Color(0xFF0F766E);
    const topCenterAccent = Color(0xFF2563EB);
    const topRightAccent = Color(0xFF7C3AED);

    return SizedBox(
      height: 360,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFF8FAFF), Color(0xFFEFF5FF)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          borderRadius: BorderRadius.circular(26),
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final centerWidth = constraints.maxWidth
                .clamp(0.0, 360.0)
                .toDouble();

            return Stack(
              children: [
                Positioned.fill(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 112, 16, 16),
                    child: SingleChildScrollView(
                      primary: false,
                      child: Column(
                        children: [
                          Row(
                            children: const [
                              Expanded(
                                child: MetricTile(
                                  label: 'Open cases',
                                  value: '28',
                                  tint: Color(0xFFE8F2FF),
                                ),
                              ),
                              SizedBox(width: 10),
                              Expanded(
                                child: MetricTile(
                                  label: 'Escalations',
                                  value: '4',
                                  tint: Color(0xFFFFEFE4),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          const OrderCard(
                            title: 'Quarterly compliance pack',
                            subtitle: 'Finance desk · Due 18:30',
                            amount: '12 docs',
                            status: 'Pending',
                            tint: Color(0xFFE2E8F0),
                          ),
                          const SizedBox(height: 10),
                          const MessageListTile(
                            title: 'Client approval loop',
                            subtitle: 'Waiting on signature and tax note',
                            time: '9m',
                            tint: Color(0xFFDBEAFE),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                if (_activePanel == _TopSurfacePanel.status)
                  _ZoneBackdrop(
                    backdropKey: const Key(
                      'unified_showcase_top_status_backdrop',
                    ),
                    color: topLeftAccent.withAlpha(16),
                    onTap: _closePanel,
                  ),
                if (_activePanel == _TopSurfacePanel.search)
                  _ZoneBackdrop(
                    backdropKey: const Key(
                      'unified_showcase_top_search_backdrop',
                    ),
                    color: topCenterAccent.withAlpha(16),
                    onTap: _closePanel,
                  ),
                if (_activePanel == _TopSurfacePanel.filter)
                  _ZoneBackdrop(
                    backdropKey: const Key(
                      'unified_showcase_top_filter_backdrop',
                    ),
                    color: topRightAccent.withAlpha(16),
                    onTap: _closePanel,
                  ),
                Positioned(
                  top: 14,
                  left: 12,
                  width: 210,
                  height: 216,
                  child: SpringSurface(
                    isExpanded: _activePanel == _TopSurfacePanel.status,
                    anchor: SpringSurfaceAnchor.topLeft,
                    expandedSizing: SpringSurfaceExpandedSizing.dynamicHeight,
                    maxExpandedHeight: 204,
                    config: const SpringSurfaceConfig.gentle(),
                    collapsedSize: const Size(138, 44),
                    expandedSize: const Size(210, 180),
                    collapsedDecoration: _collapsedDecoration(topLeftAccent),
                    expandedDecoration: _expandedDecoration(topLeftAccent),
                    collapsedChild: GestureDetector(
                      key: const Key('unified_showcase_top_status_toggle'),
                      behavior: HitTestBehavior.opaque,
                      onTap: () => _togglePanel(_TopSurfacePanel.status),
                      child: const FilterChipButton(
                        label: '3 alerts',
                        accent: topLeftAccent,
                      ),
                    ),
                    expandedChild: _TopStatusPanel(
                      onClose: _closePanel,
                      accent: topLeftAccent,
                    ),
                  ),
                ),
                Positioned(
                  top: 10,
                  left: (constraints.maxWidth - centerWidth) / 2,
                  width: centerWidth,
                  height: 248,
                  child: SpringSurface(
                    isExpanded: _activePanel == _TopSurfacePanel.search,
                    anchor: SpringSurfaceAnchor.topCenter,
                    expandedSizing: SpringSurfaceExpandedSizing.dynamicHeight,
                    maxExpandedHeight: 232,
                    config: const SpringSurfaceConfig(),
                    collapsedSize: const Size(236, 46),
                    expandedSize: Size(centerWidth, 214),
                    collapsedDecoration: _collapsedDecoration(topCenterAccent),
                    expandedDecoration: _expandedDecoration(topCenterAccent),
                    collapsedChild: GestureDetector(
                      key: const Key('unified_showcase_top_search_toggle'),
                      behavior: HitTestBehavior.opaque,
                      onTap: () => _togglePanel(_TopSurfacePanel.search),
                      child: const SearchFieldTrigger(
                        text: 'Search schedule, client, or file',
                        accent: topCenterAccent,
                      ),
                    ),
                    expandedChild: _TopSearchPanel(
                      onClose: _closePanel,
                      accent: topCenterAccent,
                    ),
                  ),
                ),
                Positioned(
                  top: 14,
                  right: 12,
                  width: 226,
                  height: 210,
                  child: SpringSurface(
                    isExpanded: _activePanel == _TopSurfacePanel.filter,
                    anchor: SpringSurfaceAnchor.topRight,
                    expandedSizing: SpringSurfaceExpandedSizing.dynamicHeight,
                    maxExpandedHeight: 198,
                    config: const SpringSurfaceConfig.gentle(),
                    collapsedSize: const Size(148, 42),
                    expandedSize: const Size(226, 176),
                    collapsedDecoration: _collapsedDecoration(topRightAccent),
                    expandedDecoration: _expandedDecoration(topRightAccent),
                    collapsedChild: GestureDetector(
                      key: const Key('unified_showcase_top_filter_toggle'),
                      behavior: HitTestBehavior.opaque,
                      onTap: () => _togglePanel(_TopSurfacePanel.filter),
                      child: FilterChipButton(
                        label: 'Filter · $_filterLabel',
                        accent: topRightAccent,
                      ),
                    ),
                    expandedChild: _TopFilterPanel(
                      selectedPreset: _filterPreset,
                      onClose: _closePanel,
                      onPresetSelected: _selectPreset,
                      accent: topRightAccent,
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

enum _MiddleSurfacePanel { queue, day, availability }

class _UnifiedMiddleZoneState extends State<_UnifiedMiddleZone> {
  _MiddleSurfacePanel? _activePanel;

  void _togglePanel(_MiddleSurfacePanel panel) {
    setState(() {
      _activePanel = _activePanel == panel ? null : panel;
    });
  }

  void _closePanel() {
    if (_activePanel == null) {
      return;
    }
    setState(() => _activePanel = null);
  }

  @override
  Widget build(BuildContext context) {
    const leftAccent = Color(0xFF0F766E);
    const centerAccent = Color(0xFFD97706);
    const rightAccent = Color(0xFF2563EB);
    const outerPadding = 16.0;
    const boardPadding = 14.0;
    const badgeRowHeight = 40.0;
    const badgeGap = 14.0;
    const dayRowHeight = 40.0;
    const dayRowGap = 14.0;
    const gridSpacing = 10.0;
    const queueExpandedSize = Size(214, 182);
    const dayExpandedSize = Size(216, 208);
    const availabilityExpandedSize = Size(214, 184);

    return SizedBox(
      height: 480,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFFFFBF5), Color(0xFFFFF5EA)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          borderRadius: BorderRadius.circular(26),
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final boardTop = outerPadding + badgeRowHeight + badgeGap;
            final boardWidth = constraints.maxWidth - (outerPadding * 2);
            final boardHeight = constraints.maxHeight - boardTop - outerPadding;
            final boardInnerWidth = boardWidth - (boardPadding * 2);
            final gridLeft = outerPadding + boardPadding;
            final gridTop = boardTop + boardPadding + dayRowHeight + dayRowGap;
            final gridHeight =
                boardHeight - (boardPadding * 2) - dayRowHeight - dayRowGap;
            final cellWidth = (boardInnerWidth - (gridSpacing * 2)) / 3;
            final cellHeight = (gridHeight - (gridSpacing * 2)) / 3;
            final collapsedCellSize = Size(cellWidth, cellHeight);

            Offset cellTopLeft(int row, int column) {
              return Offset(
                gridLeft + (column * (cellWidth + gridSpacing)),
                gridTop + (row * (cellHeight + gridSpacing)),
              );
            }

            Rect anchoredHostRect({
              required Offset collapsedTopLeft,
              required Size collapsedSize,
              required Size expandedSize,
              required SpringSurfaceAnchor anchor,
            }) {
              late final double left;
              late final double top;

              switch (anchor) {
                case SpringSurfaceAnchor.centerLeft:
                  left = collapsedTopLeft.dx;
                  top =
                      collapsedTopLeft.dy -
                      ((expandedSize.height - collapsedSize.height) / 2);
                case SpringSurfaceAnchor.center:
                  left =
                      collapsedTopLeft.dx -
                      ((expandedSize.width - collapsedSize.width) / 2);
                  top =
                      collapsedTopLeft.dy -
                      ((expandedSize.height - collapsedSize.height) / 2);
                case SpringSurfaceAnchor.centerRight:
                  left =
                      collapsedTopLeft.dx -
                      (expandedSize.width - collapsedSize.width);
                  top =
                      collapsedTopLeft.dy -
                      ((expandedSize.height - collapsedSize.height) / 2);
                default:
                  left = collapsedTopLeft.dx;
                  top = collapsedTopLeft.dy;
              }

              return Rect.fromLTWH(
                left,
                top,
                expandedSize.width,
                expandedSize.height,
              );
            }

            final queueHostRect = anchoredHostRect(
              collapsedTopLeft: cellTopLeft(0, 0),
              collapsedSize: collapsedCellSize,
              expandedSize: queueExpandedSize,
              anchor: SpringSurfaceAnchor.centerLeft,
            );
            final dayHostRect = anchoredHostRect(
              collapsedTopLeft: cellTopLeft(1, 1),
              collapsedSize: collapsedCellSize,
              expandedSize: dayExpandedSize,
              anchor: SpringSurfaceAnchor.center,
            );
            final availabilityHostRect = anchoredHostRect(
              collapsedTopLeft: cellTopLeft(0, 2),
              collapsedSize: collapsedCellSize,
              expandedSize: availabilityExpandedSize,
              anchor: SpringSurfaceAnchor.centerRight,
            );

            return Stack(
              children: [
                Positioned(
                  top: outerPadding,
                  left: outerPadding,
                  right: outerPadding,
                  child: const SizedBox(
                    height: badgeRowHeight,
                    child: Row(
                      children: [
                        Expanded(child: ShowcaseBadge(label: 'Clinic board')),
                        SizedBox(width: 8),
                        Expanded(
                          child: ShowcaseBadge(label: '9 slots unassigned'),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: boardTop,
                  left: outerPadding,
                  width: boardWidth,
                  height: boardHeight,
                  child: Container(
                    padding: const EdgeInsets.all(boardPadding),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Column(
                      children: [
                        const SizedBox(
                          height: dayRowHeight,
                          child: Row(
                            children: [
                              Expanded(
                                child: DayChip(label: 'Mon', active: false),
                              ),
                              SizedBox(width: 8),
                              Expanded(
                                child: DayChip(label: 'Tue', active: false),
                              ),
                              SizedBox(width: 8),
                              Expanded(
                                child: DayChip(label: 'Wed', active: true),
                              ),
                              SizedBox(width: 8),
                              Expanded(
                                child: DayChip(label: 'Thu', active: false),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: dayRowGap),
                        Expanded(
                          child: GridView.count(
                            physics: const NeverScrollableScrollPhysics(),
                            crossAxisCount: 3,
                            crossAxisSpacing: gridSpacing,
                            mainAxisSpacing: gridSpacing,
                            children: const [
                              CalendarSlotGhost(
                                time: '8:00',
                                detail: 'Check-in',
                              ),
                              CalendarSlotGhost(
                                time: '8:30',
                                detail: 'Available',
                              ),
                              CalendarSlotGhost(time: '9:00', detail: 'Remote'),
                              CalendarSlotGhost(
                                time: '9:30',
                                detail: 'Lab prep',
                              ),
                              CalendarSlotGhost(
                                time: '10:00',
                                detail: 'Follow-up',
                                highlight: true,
                              ),
                              CalendarSlotGhost(
                                time: '10:30',
                                detail: 'Available',
                              ),
                              CalendarSlotGhost(
                                time: '11:00',
                                detail: 'Waiting',
                              ),
                              CalendarSlotGhost(
                                time: '11:30',
                                detail: 'Confirmed',
                              ),
                              CalendarSlotGhost(
                                time: '12:00',
                                detail: 'Available',
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                if (_activePanel == _MiddleSurfacePanel.queue)
                  _ZoneBackdrop(
                    backdropKey: const Key(
                      'unified_showcase_middle_queue_backdrop',
                    ),
                    color: leftAccent.withAlpha(16),
                    onTap: _closePanel,
                  ),
                if (_activePanel == _MiddleSurfacePanel.day)
                  _ZoneBackdrop(
                    backdropKey: const Key(
                      'unified_showcase_middle_day_backdrop',
                    ),
                    color: centerAccent.withAlpha(16),
                    onTap: _closePanel,
                  ),
                if (_activePanel == _MiddleSurfacePanel.availability)
                  _ZoneBackdrop(
                    backdropKey: const Key(
                      'unified_showcase_middle_availability_backdrop',
                    ),
                    color: rightAccent.withAlpha(16),
                    onTap: _closePanel,
                  ),
                Positioned(
                  top: queueHostRect.top,
                  left: queueHostRect.left,
                  width: queueHostRect.width,
                  height: queueHostRect.height,
                  child: SpringSurface(
                    isExpanded: _activePanel == _MiddleSurfacePanel.queue,
                    anchor: SpringSurfaceAnchor.centerLeft,
                    config: const SpringSurfaceConfig.gentle(),
                    collapsedSize: collapsedCellSize,
                    expandedSize: queueExpandedSize,
                    collapsedDecoration: _calendarCellDecoration(
                      accent: leftAccent,
                      tint: const Color(0xFFE8FBF5),
                    ),
                    expandedDecoration: _expandedDecoration(leftAccent),
                    collapsedChild: GestureDetector(
                      key: const Key('unified_showcase_middle_queue_toggle'),
                      behavior: HitTestBehavior.opaque,
                      onTap: () => _togglePanel(_MiddleSurfacePanel.queue),
                      child: const _MetricSurfaceButton(
                        title: 'Queue',
                        value: '12',
                        subtitle: 'waiting',
                        accent: leftAccent,
                        highlight: false,
                      ),
                    ),
                    expandedChild: _QueueDetailPanel(
                      onClose: _closePanel,
                      accent: leftAccent,
                    ),
                  ),
                ),
                Positioned(
                  top: dayHostRect.top,
                  left: dayHostRect.left,
                  width: dayHostRect.width,
                  height: dayHostRect.height,
                  child: SpringSurface(
                    isExpanded: _activePanel == _MiddleSurfacePanel.day,
                    anchor: SpringSurfaceAnchor.center,
                    expandedSizing: SpringSurfaceExpandedSizing.dynamicHeight,
                    maxExpandedHeight: 236,
                    config: const SpringSurfaceConfig.bouncy(),
                    collapsedSize: collapsedCellSize,
                    expandedSize: dayExpandedSize,
                    collapsedDecoration: _calendarCellDecoration(
                      accent: centerAccent,
                      tint: const Color(0xFFFFF1E0),
                    ),
                    expandedDecoration: _expandedDecoration(centerAccent),
                    collapsedChild: GestureDetector(
                      key: const Key('unified_showcase_middle_day_toggle'),
                      behavior: HitTestBehavior.opaque,
                      onTap: () => _togglePanel(_MiddleSurfacePanel.day),
                      child: const _DaySurfaceButton(
                        dayLabel: 'Wed',
                        dateLabel: '20 Mar',
                        accent: centerAccent,
                        highlight: true,
                      ),
                    ),
                    expandedChild: _DayDetailPanel(
                      onClose: _closePanel,
                      accent: centerAccent,
                    ),
                  ),
                ),
                Positioned(
                  top: availabilityHostRect.top,
                  left: availabilityHostRect.left,
                  width: availabilityHostRect.width,
                  height: availabilityHostRect.height,
                  child: SpringSurface(
                    isExpanded:
                        _activePanel == _MiddleSurfacePanel.availability,
                    anchor: SpringSurfaceAnchor.centerRight,
                    config: const SpringSurfaceConfig(),
                    collapsedSize: collapsedCellSize,
                    expandedSize: availabilityExpandedSize,
                    collapsedDecoration: _calendarCellDecoration(
                      accent: rightAccent,
                      tint: const Color(0xFFEAF3FF),
                    ),
                    expandedDecoration: _expandedDecoration(rightAccent),
                    collapsedChild: GestureDetector(
                      key: const Key(
                        'unified_showcase_middle_availability_toggle',
                      ),
                      behavior: HitTestBehavior.opaque,
                      onTap: () =>
                          _togglePanel(_MiddleSurfacePanel.availability),
                      child: const _MetricSurfaceButton(
                        title: 'Dr. Lena',
                        value: '6',
                        subtitle: 'open slots',
                        accent: rightAccent,
                        highlight: false,
                      ),
                    ),
                    expandedChild: _AvailabilityDetailPanel(
                      onClose: _closePanel,
                      accent: rightAccent,
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _UnifiedBottomZoneState extends State<_UnifiedBottomZone> {
  bool _isExpanded = false;

  void _toggleComposer() {
    setState(() => _isExpanded = !_isExpanded);
  }

  void _closeComposer() {
    if (!_isExpanded) {
      return;
    }
    setState(() => _isExpanded = false);
  }

  @override
  Widget build(BuildContext context) {
    const bottomAccent = Color(0xFF0F766E);

    return SizedBox(
      height: 420,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFF3FBF8), Color(0xFFE8F7F0)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          borderRadius: BorderRadius.circular(26),
        ),
        child: Stack(
          children: [
            Positioned.fill(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 86),
                child: SingleChildScrollView(
                  primary: false,
                  child: Column(
                    children: const [
                      MessageListTile(
                        title: 'Care coordinator',
                        subtitle:
                            'We can move the follow-up to 10:30 if needed.',
                        time: 'Now',
                        tint: Color(0xFFD1FAE5),
                      ),
                      SizedBox(height: 10),
                      ChatBubble(
                        text:
                            'Move it to 10:30 and attach the previous summary for the doctor.',
                        mine: false,
                      ),
                      SizedBox(height: 10),
                      ChatBubble(
                        text:
                            'Done. I also added the lab note and the payment link.',
                        mine: true,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            if (_isExpanded)
              _ZoneBackdrop(
                backdropKey: const Key(
                  'unified_showcase_bottom_composer_backdrop',
                ),
                color: bottomAccent.withAlpha(16),
                onTap: _closeComposer,
              ),
            Positioned(
              left: 16,
              right: 16,
              bottom: 16,
              height: 240,
              child: SpringSurface(
                isExpanded: _isExpanded,
                anchor: SpringSurfaceAnchor.bottomCenter,
                expandedSizing: SpringSurfaceExpandedSizing.dynamicHeight,
                maxExpandedHeight: 224,
                config: const SpringSurfaceConfig.bouncy(),
                collapsedSize: const Size(320, 56),
                expandedSize: const Size(320, 194),
                collapsedDecoration: _collapsedDecoration(bottomAccent),
                expandedDecoration: _expandedDecoration(bottomAccent),
                collapsedChild: GestureDetector(
                  key: const Key('unified_showcase_bottom_composer_toggle'),
                  behavior: HitTestBehavior.opaque,
                  onTap: _toggleComposer,
                  child: const ComposerBar(
                    placeholder: 'Reply, attach, or start a task',
                    accent: bottomAccent,
                  ),
                ),
                expandedChild: _BottomComposerPanel(
                  onClose: _closeComposer,
                  accent: bottomAccent,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ZoneBackdrop extends StatelessWidget {
  const _ZoneBackdrop({
    required this.backdropKey,
    required this.color,
    required this.onTap,
  });

  final Key backdropKey;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: GestureDetector(
        key: backdropKey,
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: ColoredBox(color: color),
      ),
    );
  }
}

class _TopStatusPanel extends StatelessWidget {
  const _TopStatusPanel({required this.onClose, required this.accent});

  final VoidCallback onClose;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return SurfaceScrollableContent(
      children: [
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: onClose,
          child: PanelHeaderButton(
            label: 'Escalation summary',
            icon: Icons.notifications_active_outlined,
            accent: accent,
          ),
        ),
        const SizedBox(height: 12),
        const InfoRow(label: 'Critical', value: '1 client waiting'),
        const SizedBox(height: 8),
        const InfoRow(label: 'Review queue', value: '2 contracts blocked'),
        const SizedBox(height: 8),
        const InfoRow(label: 'Staffing', value: 'Late handoff at 17:00'),
      ],
    );
  }
}

class _TopSearchPanel extends StatelessWidget {
  const _TopSearchPanel({required this.onClose, required this.accent});

  final VoidCallback onClose;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return SurfaceScrollableContent(
      children: [
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: onClose,
          child: PanelHeaderButton(
            label: 'Search workspace',
            icon: Icons.search_rounded,
            accent: accent,
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          key: const Key('unified_showcase_top_search_query_field'),
          decoration: InputDecoration(
            hintText: 'Type a patient, file, shift, or note',
            prefixIcon: const Icon(Icons.search_rounded),
            filled: true,
            fillColor: const Color(0xFFF8FAFC),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: const [
            ChoicePill(label: 'Clients', selected: true),
            ChoicePill(label: 'Files'),
            ChoicePill(label: 'Messages'),
          ],
        ),
        const SizedBox(height: 12),
        const InfoRow(label: 'Nora follow-up', value: '10:30 slot + lab note'),
        const SizedBox(height: 8),
        const InfoRow(label: 'INV-203', value: 'Pending finance approval'),
      ],
    );
  }
}

class _TopFilterPanel extends StatelessWidget {
  const _TopFilterPanel({
    required this.selectedPreset,
    required this.onClose,
    required this.onPresetSelected,
    required this.accent,
  });

  final _TopFilterPreset selectedPreset;
  final VoidCallback onClose;
  final ValueChanged<_TopFilterPreset> onPresetSelected;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return SurfaceScrollableContent(
      children: [
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: onClose,
          child: PanelHeaderButton(
            label: 'Quick filters',
            icon: Icons.tune_rounded,
            accent: accent,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _PresetChipButton(
              label: 'Urgent',
              selected: selectedPreset == _TopFilterPreset.urgent,
              accent: accent,
              onTap: () => onPresetSelected(_TopFilterPreset.urgent),
            ),
            _PresetChipButton(
              label: 'Due today',
              selected: selectedPreset == _TopFilterPreset.today,
              accent: accent,
              onTap: () => onPresetSelected(_TopFilterPreset.today),
            ),
            _PresetChipButton(
              label: 'Needs review',
              selected: selectedPreset == _TopFilterPreset.review,
              accent: accent,
              onTap: () => onPresetSelected(_TopFilterPreset.review),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFFF8FAFC),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(
            _topFilterSummary(selectedPreset),
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

class _QueueDetailPanel extends StatelessWidget {
  const _QueueDetailPanel({required this.onClose, required this.accent});

  final VoidCallback onClose;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return SurfaceScrollableContent(
      children: [
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: onClose,
          child: PanelHeaderButton(
            label: 'Waiting queue',
            icon: Icons.people_alt_outlined,
            accent: accent,
          ),
        ),
        const SizedBox(height: 12),
        const InfoRow(label: 'Walk-ins', value: '4 patients'),
        const SizedBox(height: 8),
        const InfoRow(label: 'Pending lab', value: '3 samples'),
        const SizedBox(height: 8),
        const InfoRow(label: 'Needs triage', value: '2 cases'),
      ],
    );
  }
}

class _DayDetailPanel extends StatelessWidget {
  const _DayDetailPanel({required this.onClose, required this.accent});

  final VoidCallback onClose;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return SurfaceScrollableContent(
      children: [
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: onClose,
          child: PanelHeaderButton(
            label: 'Wednesday details',
            icon: Icons.calendar_month_outlined,
            accent: accent,
          ),
        ),
        const SizedBox(height: 12),
        const InfoRow(label: '09:30', value: 'Remote follow-up · 20m'),
        const SizedBox(height: 8),
        const InfoRow(label: '10:00', value: 'In-person consult · Nora'),
        const SizedBox(height: 8),
        const InfoRow(label: '11:30', value: 'Team huddle · 15m'),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFFFFF4E8),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(
            'Today has one overbooked pocket between 10:00 and 11:00, so the expanded panel highlights the day tile itself without shifting the whole board.',
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

class _AvailabilityDetailPanel extends StatelessWidget {
  const _AvailabilityDetailPanel({required this.onClose, required this.accent});

  final VoidCallback onClose;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return SurfaceScrollableContent(
      children: [
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: onClose,
          child: PanelHeaderButton(
            label: 'Provider availability',
            icon: Icons.medical_services_outlined,
            accent: accent,
          ),
        ),
        const SizedBox(height: 12),
        const InfoRow(label: 'Dr. Lena', value: '6 open slots'),
        const SizedBox(height: 8),
        const InfoRow(label: 'Remote block', value: '13:00 - 15:00'),
        const SizedBox(height: 8),
        const InfoRow(label: 'Assistant prep', value: '2 rooms staged'),
      ],
    );
  }
}

class _BottomComposerPanel extends StatelessWidget {
  const _BottomComposerPanel({required this.onClose, required this.accent});

  final VoidCallback onClose;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return SurfaceScrollableContent(
      children: [
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: onClose,
          child: PanelHeaderButton(
            label: 'Compose next step',
            icon: Icons.chat_bubble_outline_rounded,
            accent: accent,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: const [
            Expanded(
              child: ActionTile(
                title: 'Attach file',
                subtitle: 'Send summary and lab PDF',
                icon: Icons.attach_file_rounded,
                tint: Color(0xFFD1FAE5),
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: ActionTile(
                title: 'Create task',
                subtitle: 'Follow up on payment and consent',
                icon: Icons.task_alt_rounded,
                tint: Color(0xFFDCFCE7),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        const InfoRow(label: 'Channel', value: 'Care team thread'),
        const SizedBox(height: 8),
        const InfoRow(label: 'Draft', value: 'Ready to send'),
      ],
    );
  }
}

class _PresetChipButton extends StatelessWidget {
  const _PresetChipButton({
    required this.label,
    required this.selected,
    required this.accent,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final Color accent;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: ChoicePill(label: label, selected: selected, accent: accent),
    );
  }
}

class _MetricSurfaceButton extends StatelessWidget {
  const _MetricSurfaceButton({
    required this.title,
    required this.value,
    required this.subtitle,
    required this.accent,
    required this.highlight,
  });

  final String title;
  final String value;
  final String subtitle;
  final Color accent;
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: highlight ? accent : Colors.black54,
              fontWeight: FontWeight.w700,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: Theme.of(
              context,
            ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w800),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: Colors.black54),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class _DaySurfaceButton extends StatelessWidget {
  const _DaySurfaceButton({
    required this.dayLabel,
    required this.dateLabel,
    required this.accent,
    required this.highlight,
  });

  final String dayLabel;
  final String dateLabel;
  final Color accent;
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Icon(Icons.event_available_rounded, color: accent, size: 16),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  dayLabel,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: highlight ? accent : Colors.black54,
                    fontWeight: FontWeight.w700,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            dateLabel,
            style: Theme.of(
              context,
            ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w800),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            'Tap for details',
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: Colors.black54),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

BoxDecoration _collapsedDecoration(Color accent) {
  return BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(22),
    border: Border.all(color: accent.withAlpha(38)),
    boxShadow: [
      BoxShadow(
        color: accent.withAlpha(24),
        blurRadius: 18,
        offset: const Offset(0, 10),
      ),
    ],
  );
}

BoxDecoration _calendarCellDecoration({
  required Color accent,
  required Color tint,
}) {
  return BoxDecoration(
    color: tint,
    borderRadius: BorderRadius.circular(18),
    border: Border.all(color: accent.withAlpha(18)),
    boxShadow: const [
      BoxShadow(color: Color(0x0F000000), blurRadius: 12, offset: Offset(0, 6)),
    ],
  );
}

BoxDecoration _expandedDecoration(Color accent) {
  return BoxDecoration(
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
  );
}

String _topFilterSummary(_TopFilterPreset preset) {
  switch (preset) {
    case _TopFilterPreset.urgent:
      return 'Focus the page on escalations, time-sensitive approvals, and messages that need a human handoff before the end of the shift.';
    case _TopFilterPreset.today:
      return 'Keep only items scheduled for today in view: appointments, payment reminders, and client replies that change the calendar.';
    case _TopFilterPreset.review:
      return 'Group records that still need review notes, attachments, or a supervisor checkpoint before they can move forward.';
  }
}
