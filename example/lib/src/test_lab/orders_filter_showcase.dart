// ignore_for_file: use_key_in_widget_constructors

import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:spring_surface/spring_surface.dart';
import 'showcase_models.dart';
import 'showcase_shell.dart';
import 'showcase_shared_widgets.dart';

enum _OrdersFilterPreset { today, urgent, prepaid }

const _ordersFilterAccent = Color(0xFF2563EB);
const _ordersFilterDetailSurfaceHeight = 220.0;
const _ordersFilterExpandedPanelHeight = 194.0;

class _OrdersFilterOrder {
  const _OrdersFilterOrder({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.amount,
    required this.status,
    required this.eta,
    required this.priority,
    required this.note,
    required this.tint,
  });

  final String id;
  final String title;
  final String subtitle;
  final String amount;
  final String status;
  final String eta;
  final String priority;
  final String note;
  final Color tint;
}

class _OrdersFilterPresetData {
  const _OrdersFilterPresetData({
    required this.label,
    required this.badgeLabel,
    required this.branchValue,
    required this.statusValue,
    required this.primaryValue,
    required this.secondaryValue,
    required this.summaryTitle,
    required this.summaryDetail,
    required this.orders,
  });

  final String label;
  final String badgeLabel;
  final String branchValue;
  final String statusValue;
  final String primaryValue;
  final String secondaryValue;
  final String summaryTitle;
  final String summaryDetail;
  final List<_OrdersFilterOrder> orders;
}

const _ordersFilterPresetData = <_OrdersFilterPreset, _OrdersFilterPresetData>{
  _OrdersFilterPreset.today: _OrdersFilterPresetData(
    label: 'اليوم',
    badgeLabel: '18 طلباً',
    branchValue: 'وردية الصباح',
    statusValue: 'عرض طلبات اليوم قبل 2:00 م',
    primaryValue: '12',
    secondaryValue: '4',
    summaryTitle: 'نافذة التسليم الحالية',
    summaryDetail:
        'ركّز على الطلبات القريبة من التسليم قبل انتقال السائقين إلى الجولة التالية.',
    orders: [
      _OrdersFilterOrder(
        id: 'ahmad_salem',
        title: 'طلب أحمد سالم',
        subtitle: 'وجبتان عائليتان',
        amount: '42 ر.س',
        status: 'قيد التحضير',
        eta: '12 دقيقة',
        priority: 'اعتيادي',
        note: 'ابدأ التغليف بعد تأكيد العصير البارد مع المطبخ.',
        tint: Color(0xFFE0EEFF),
      ),
      _OrdersFilterOrder(
        id: 'noura_mazin',
        title: 'طلب نورة مازن',
        subtitle: 'توصيل خلال 20 دقيقة',
        amount: '28 ر.س',
        status: 'بانتظار السائق',
        eta: '20 دقيقة',
        priority: 'تسليم قريب',
        note: 'أبق الطلب في نقطة الاستلام الأمامية لأن السائق في الطريق.',
        tint: Color(0xFFFFF1D6),
      ),
      _OrdersFilterOrder(
        id: 'yasmin_hotel',
        title: 'طلب فندق الياسمين',
        subtitle: 'إفطار غرفة 402',
        amount: '86 ر.س',
        status: 'جاهز للتسليم',
        eta: '8 دقائق',
        priority: 'فندقي',
        note: 'نسّق مع الاستقبال قبل خروج الطلب من المطبخ.',
        tint: Color(0xFFDFF7F1),
      ),
    ],
  ),
  _OrdersFilterPreset.urgent: _OrdersFilterPresetData(
    label: 'مستعجل',
    badgeLabel: '7 طلبات مستعجلة',
    branchValue: 'مسار الأولوية',
    statusValue: 'إبراز الطلبات الحرجة أولاً',
    primaryValue: '5',
    secondaryValue: '2',
    summaryTitle: 'نافذة الاستجابة السريعة',
    summaryDetail:
        'هذه المجموعة تحتاج تدخلًا قبل أن تتجاوز وقت التسليم المستهدف خلال الوردية.',
    orders: [
      _OrdersFilterOrder(
        id: 'city_hospital',
        title: 'طلب مستشفى المدينة',
        subtitle: 'تسليم فوري قبل 10 دقائق',
        amount: '96 ر.س',
        status: 'عاجل جداً',
        eta: '10 دقائق',
        priority: 'أولوية قصوى',
        note:
            'أرسل الطلب مباشرة إلى محطة التغليف السريع مع إشعار السائق المناوب.',
        tint: Color(0xFFFFF1D6),
      ),
      _OrdersFilterOrder(
        id: 'madar_office',
        title: 'طلب مكتب المدار',
        subtitle: 'سائق قريب من الاستلام',
        amount: '58 ر.س',
        status: 'جاهز للتسليم',
        eta: '13 دقيقة',
        priority: 'جاهز للخروج',
        note: 'ثبّت الفاتورة أعلى الكيس وأعط السائق أولوية عند الوصول.',
        tint: Color(0xFFE0EEFF),
      ),
      _OrdersFilterOrder(
        id: 'blue_tower',
        title: 'طلب برج الأزرق',
        subtitle: 'يتطلب مكالمة قبل الوصول',
        amount: '74 ر.س',
        status: 'بانتظار التأكيد',
        eta: '18 دقيقة',
        priority: 'اتصال مسبق',
        note: 'اتصل بالحارس قبل 5 دقائق لتسريع عملية الاستلام.',
        tint: Color(0xFFDFF7F1),
      ),
    ],
  ),
  _OrdersFilterPreset.prepaid: _OrdersFilterPresetData(
    label: 'الدفع المسبق',
    badgeLabel: '9 طلبات مدفوعة',
    branchValue: 'الدفع الإلكتروني',
    statusValue: 'مطابقة الطلبات المسددة فقط',
    primaryValue: '6',
    secondaryValue: '3',
    summaryTitle: 'مطابقة المدفوعات',
    summaryDetail:
        'راجع الطلبات التي اكتمل سدادها لتقليل وقت نقطة الدفع وتحريكها أسرع للتغليف.',
    orders: [
      _OrdersFilterOrder(
        id: 'madar_company',
        title: 'طلب شركة المدار',
        subtitle: 'بطاقة شركة - تم السداد',
        amount: '128 ر.س',
        status: 'مدفوع مسبقاً',
        eta: '15 دقيقة',
        priority: 'بدون تحصيل',
        note: 'تجاوز خطوة الدفع واذهب مباشرة إلى التغليف وتسليم الإيصال.',
        tint: Color(0xFFE0EEFF),
      ),
      _OrdersFilterOrder(
        id: 'fatima_khaled',
        title: 'طلب فاطمة خالد',
        subtitle: 'دفع عبر Apple Pay',
        amount: '34 ر.س',
        status: 'بانتظار التحضير',
        eta: '22 دقيقة',
        priority: 'Apple Pay',
        note: 'لا حاجة لتأكيد التحصيل، فقط راجع الإضافات قبل الإغلاق.',
        tint: Color(0xFFFFF1D6),
      ),
      _OrdersFilterOrder(
        id: 'rawan_studio',
        title: 'طلب استوديو روان',
        subtitle: 'فاتورة إلكترونية مطلوبة',
        amount: '67 ر.س',
        status: 'جاهز للطباعة',
        eta: '9 دقائق',
        priority: 'فاتورة مطلوبة',
        note: 'أرسل نسخة PDF مباشرة بعد إغلاق الطلب.',
        tint: Color(0xFFDFF7F1),
      ),
    ],
  ),
};

class OrdersFilterDetailExperience extends StatefulWidget {
  const OrdersFilterDetailExperience();

  @override
  State<OrdersFilterDetailExperience> createState() =>
      OrdersFilterDetailExperienceState();
}

class OrdersFilterDetailExperienceState
    extends State<OrdersFilterDetailExperience> {
  final _sceneKey = GlobalKey<OrdersFilterScenarioState>();

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
      child: OrdersFilterScenario(
        key: _sceneKey,
        presentation: ScenarioPresentation.detail,
        keyPrefix: 'orders_filter_detail',
      ),
    );
  }
}

class OrdersFilterScenario extends StatefulWidget {
  const OrdersFilterScenario({
    super.key,
    this.presentation = ScenarioPresentation.compact,
    this.keyPrefix = 'orders_filter',
  });

  final ScenarioPresentation presentation;
  final String keyPrefix;

  @override
  State<OrdersFilterScenario> createState() => OrdersFilterScenarioState();
}

class OrdersFilterScenarioState
    extends ExpandableSceneState<OrdersFilterScenario> {
  late _OrdersFilterPreset _selectedPreset;
  late String _selectedOrderId;

  bool get _isInteractive => widget.presentation.isDetail;

  @override
  void initState() {
    super.initState();
    _selectedPreset = _OrdersFilterPreset.today;
    _selectedOrderId =
        _ordersFilterPresetData[_selectedPreset]!.orders.first.id;
  }

  _OrdersFilterPresetData get _activePresetData =>
      _ordersFilterPresetData[_isInteractive
          ? _selectedPreset
          : _OrdersFilterPreset.today]!;

  _OrdersFilterOrder get _selectedOrder {
    final orders = _activePresetData.orders;
    return orders.firstWhere(
      (order) => order.id == _selectedOrderId,
      orElse: () => orders.first,
    );
  }

  void _selectPreset(_OrdersFilterPreset preset) {
    if (!_isInteractive || preset == _selectedPreset) {
      return;
    }

    setState(() {
      _selectedPreset = preset;
      _selectedOrderId = _ordersFilterPresetData[preset]!.orders.first.id;
    });

    if (!isExpanded) {
      open();
    }
  }

  void _selectOrder(String orderId) {
    if (!_isInteractive || orderId == _selectedOrderId) {
      return;
    }

    setState(() => _selectedOrderId = orderId);

    if (!isExpanded) {
      open();
    }
  }

  @override
  Widget build(BuildContext context) {
    final presetData = _activePresetData;
    final selectedOrder = _selectedOrder;

    return LayoutBuilder(
      builder: (context, constraints) {
        return widget.presentation.isDetail
            ? _buildDetailScene(context, constraints, presetData, selectedOrder)
            : _buildCompactScene(
                context,
                constraints,
                _ordersFilterPresetData[_OrdersFilterPreset.today]!,
              );
      },
    );
  }

  Widget _buildDetailScene(
    BuildContext context,
    BoxConstraints constraints,
    _OrdersFilterPresetData presetData,
    _OrdersFilterOrder selectedOrder,
  ) {
    const gap = 12.0;
    final maxExpandedWidth = math.max(168.0, constraints.maxWidth - 152);
    final expandedSurfaceWidth = math.min(320.0, maxExpandedWidth);
    final collapsedChipWidth = math.min(214.0, expandedSurfaceWidth);

    return DecoratedBox(
      key: Key('${widget.keyPrefix}_canvas'),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFFAFCFF), Color(0xFFF2F6FE)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'لوحة العمليات',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                ShowcaseBadge(label: presetData.badgeLabel),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              key: Key('${widget.keyPrefix}_controls_zone'),
              height: _ordersFilterDetailSurfaceHeight,
              child: Stack(
                children: [
                  Positioned.fill(
                    right: expandedSurfaceWidth + gap,
                    child: Column(
                      children: [
                        _OrdersSearchShell(
                          fieldKey: Key('${widget.keyPrefix}_search_field'),
                        ),
                        const SizedBox(height: 12),
                        Expanded(
                          child: _OrdersInsightCard(
                            title: presetData.summaryTitle,
                            subtitle: presetData.summaryDetail,
                            routeValue: presetData.branchValue,
                            etaValue: selectedOrder.eta,
                            priorityValue: selectedOrder.priority,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (isExpanded)
                    Positioned.fill(
                      right: expandedSurfaceWidth + gap,
                      child: GestureDetector(
                        key: Key('${widget.keyPrefix}_backdrop'),
                        behavior: HitTestBehavior.opaque,
                        onTap: close,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            color: _ordersFilterAccent.withAlpha(9),
                            borderRadius: BorderRadius.circular(28),
                          ),
                        ),
                      ),
                    ),
                  Positioned(
                    top: 0,
                    right: 0,
                    width: expandedSurfaceWidth,
                    height: _ordersFilterDetailSurfaceHeight,
                    child: SizedBox(
                      key: Key('${widget.keyPrefix}_surface_host'),
                      child: SpringSurface(
                        isExpanded: isExpanded,
                        origin: SpringSurfaceOrigin.top,
                        config: const SpringSurfaceConfig.gentle(),
                        collapsedSize: Size(expandedSurfaceWidth, 54),
                        expandedSize: Size(
                          expandedSurfaceWidth,
                          _ordersFilterExpandedPanelHeight,
                        ),
                        collapsedDecoration: const BoxDecoration(
                          color: Colors.transparent,
                        ),
                        expandedDecoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(
                            color: _ordersFilterAccent.withAlpha(34),
                          ),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x120F172A),
                              blurRadius: 24,
                              offset: Offset(0, 12),
                            ),
                          ],
                        ),
                        collapsedChild: GestureDetector(
                          key: Key('${widget.keyPrefix}_toggle'),
                          behavior: HitTestBehavior.opaque,
                          onTap: toggle,
                          child: SizedBox.expand(
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Container(
                                width: collapsedChipWidth,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(18),
                                  border: Border.all(
                                    color: _ordersFilterAccent.withAlpha(30),
                                  ),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Color(0x102563EB),
                                      blurRadius: 16,
                                      offset: Offset(0, 8),
                                    ),
                                  ],
                                ),
                                child: FilterChipButton(
                                  label: 'الفلاتر · ${presetData.label}',
                                  accent: _ordersFilterAccent,
                                ),
                              ),
                            ),
                          ),
                        ),
                        expandedChild: _OrdersFilterPanel(
                          keyPrefix: widget.keyPrefix,
                          onToggle: toggle,
                          preset: _selectedPreset,
                          branchValue: presetData.branchValue,
                          statusValue: presetData.statusValue,
                          selectedOrder: selectedOrder,
                          onPresetSelected: _selectPreset,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Row(
              key: Key('${widget.keyPrefix}_metrics_row'),
              children: [
                Expanded(
                  child: KeyedSubtree(
                    key: Key('${widget.keyPrefix}_metric_primary'),
                    child: MetricTile(
                      label: 'مكتملة',
                      value: presetData.primaryValue,
                      tint: const Color(0xFFE4EEFD),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: KeyedSubtree(
                    key: Key('${widget.keyPrefix}_metric_secondary'),
                    child: MetricTile(
                      label: 'تحتاج متابعة',
                      value: presetData.secondaryValue,
                      tint: const Color(0xFFFFF3DD),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Expanded(
              child: ListView.separated(
                key: Key('${widget.keyPrefix}_orders_list'),
                primary: false,
                itemCount: presetData.orders.length,
                separatorBuilder: (_, _) => const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  final order = presetData.orders[index];
                  return _SelectableOrderCard(
                    cardKey: Key('${widget.keyPrefix}_order_${order.id}'),
                    order: order,
                    selected: order.id == selectedOrder.id,
                    onTap: () => _selectOrder(order.id),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCompactScene(
    BuildContext context,
    BoxConstraints constraints,
    _OrdersFilterPresetData presetData,
  ) {
    final compactOrders = presetData.orders.take(2).toList();
    final expandedWidth = math.min(constraints.maxWidth - 32, 284.0);
    const collapsedWidth = 112.0;
    const surfaceHeight = 212.0;
    const expandedHeight = 188.0;

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
                      ShowcaseBadge(label: presetData.badgeLabel),
                    ],
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 42,
                    child: Row(
                      children: [
                        const SizedBox(width: collapsedWidth),
                        const SizedBox(width: 10),
                        const Expanded(
                          child: GhostSearchField(
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
                      children: _OrdersFilterPreset.values
                          .map(
                            (preset) => _OrdersPresetChip(
                              label: _ordersFilterPresetData[preset]!.label,
                              selected: preset == _OrdersFilterPreset.today,
                            ),
                          )
                          .toList(),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Expanded(
                        child: MetricTile(
                          label: 'مكتملة',
                          value: presetData.primaryValue,
                          tint: const Color(0xFFE0EEFF),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: MetricTile(
                          label: 'تحتاج متابعة',
                          value: presetData.secondaryValue,
                          tint: const Color(0xFFFFF1D6),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Expanded(
                    child: ListView.separated(
                      primary: false,
                      itemCount: compactOrders.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 10),
                      itemBuilder: (context, index) {
                        final order = compactOrders[index];
                        return OrderCard(
                          title: order.title,
                          subtitle: order.subtitle,
                          amount: order.amount,
                          status: order.status,
                          tint: order.tint,
                        );
                      },
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
            top: 70,
            right: 16,
            width: expandedWidth,
            height: surfaceHeight,
            child: SpringSurface(
              isExpanded: isExpanded,
              origin: SpringSurfaceOrigin.top,
              config: const SpringSurfaceConfig.snappy(),
              collapsedSize: const Size(collapsedWidth, 42),
              expandedSize: const Size(284, expandedHeight),
              collapsedDecoration: BoxDecoration(
                color: Colors.white.withAlpha(246),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: _ordersFilterAccent.withAlpha(35)),
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
                border: Border.all(color: _ordersFilterAccent.withAlpha(35)),
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
                child: const FilterChipButton(
                  label: 'الفلاتر',
                  accent: _ordersFilterAccent,
                ),
              ),
              expandedChild: _OrdersFilterPanel(
                keyPrefix: widget.keyPrefix,
                onToggle: toggle,
                preset: _OrdersFilterPreset.today,
                branchValue: presetData.branchValue,
                statusValue: presetData.statusValue,
                selectedOrder: presetData.orders.first,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _OrdersFilterPanel extends StatelessWidget {
  const _OrdersFilterPanel({
    required this.keyPrefix,
    required this.onToggle,
    required this.preset,
    required this.branchValue,
    required this.statusValue,
    required this.selectedOrder,
    this.onPresetSelected,
  });

  final String keyPrefix;
  final VoidCallback onToggle;
  final _OrdersFilterPreset preset;
  final String branchValue;
  final String statusValue;
  final _OrdersFilterOrder selectedOrder;
  final ValueChanged<_OrdersFilterPreset>? onPresetSelected;

  bool get _interactive => onPresetSelected != null;

  @override
  Widget build(BuildContext context) {
    return SurfaceScrollableContent(
      children: [
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: onToggle,
          child: const PanelHeaderButton(
            label: 'الفلاتر',
            icon: Icons.tune_rounded,
            accent: _ordersFilterAccent,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'اختر ما يجب أن يظهر أولاً للفريق خلال هذه الوردية مع تحديث الطلب المحدد مباشرة.',
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(color: Colors.black54, height: 1.45),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _OrdersFilterPreset.values
              .map(
                (value) => _OrdersPresetChip(
                  chipKey: Key('${keyPrefix}_panel_preset_${value.name}'),
                  label: _ordersFilterPresetData[value]!.label,
                  selected: value == preset,
                  onTap: _interactive ? () => onPresetSelected!(value) : null,
                ),
              )
              .toList(),
        ),
        const SizedBox(height: 12),
        InfoRow(label: 'المسار', value: branchValue),
        const SizedBox(height: 8),
        InfoRow(label: 'الوضع الحالي', value: statusValue),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFFF6F9FF),
            borderRadius: BorderRadius.circular(18),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'الطلب المحدد',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: _ordersFilterAccent,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                key: Key('${keyPrefix}_selected_order_title'),
                selectedOrder.title,
                style: Theme.of(
                  context,
                ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 4),
              Text(
                key: Key('${keyPrefix}_selected_order_note'),
                selectedOrder.note,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.black54,
                  height: 1.45,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: _OrdersMiniInfo(
                      label: 'ETA',
                      value: selectedOrder.eta,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _OrdersMiniInfo(
                      label: 'الأولوية',
                      value: selectedOrder.priority,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _OrdersSearchShell extends StatelessWidget {
  const _OrdersSearchShell({required this.fieldKey});

  final Key fieldKey;

  @override
  Widget build(BuildContext context) {
    return Container(
      key: fieldKey,
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFDCE6F5)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0F0F172A),
            blurRadius: 14,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: const Color(0xFFEAF1FF),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.search_rounded,
              color: _ordersFilterAccent,
              size: 18,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'ابحث برقم الطلب أو اسم العميل',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: Colors.black45),
            ),
          ),
          const SizedBox(width: 10),
          Text(
            'بحث سريع',
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: _ordersFilterAccent,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _OrdersInsightCard extends StatelessWidget {
  const _OrdersInsightCard({
    required this.title,
    required this.subtitle,
    required this.routeValue,
    required this.etaValue,
    required this.priorityValue,
  });

  final String title;
  final String subtitle;
  final String routeValue;
  final String etaValue;
  final String priorityValue;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFDCE6F5)),
      ),
      child: SingleChildScrollView(
        primary: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(
                context,
              ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 6),
            Text(
              subtitle,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.black54,
                height: 1.45,
              ),
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: _OrdersMiniInfo(label: 'المسار', value: routeValue),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _OrdersMiniInfo(label: 'ETA', value: etaValue),
                ),
              ],
            ),
            const SizedBox(height: 8),
            _OrdersMiniInfo(label: 'الأولوية', value: priorityValue),
          ],
        ),
      ),
    );
  }
}

class _OrdersMiniInfo extends StatelessWidget {
  const _OrdersMiniInfo({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFF6F9FF),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: Theme.of(
              context,
            ).textTheme.labelMedium?.copyWith(color: Colors.black45),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w800),
          ),
        ],
      ),
    );
  }
}

class _OrdersPresetChip extends StatelessWidget {
  const _OrdersPresetChip({
    required this.label,
    this.selected = false,
    this.onTap,
    this.chipKey,
  });

  final String label;
  final bool selected;
  final VoidCallback? onTap;
  final Key? chipKey;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      key: chipKey,
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: selected
              ? _ordersFilterAccent.withAlpha(16)
              : Colors.white.withAlpha(onTap == null ? 150 : 255),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: selected
                ? _ordersFilterAccent.withAlpha(44)
                : const Color(0xFFDCE6F5),
          ),
        ),
        child: Text(
          label,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
            color: selected ? _ordersFilterAccent : Colors.black87,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

class _SelectableOrderCard extends StatelessWidget {
  const _SelectableOrderCard({
    required this.cardKey,
    required this.order,
    required this.selected,
    required this.onTap,
  });

  final Key cardKey;
  final _OrdersFilterOrder order;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      key: cardKey,
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: selected
                ? _ordersFilterAccent.withAlpha(70)
                : const Color(0xFFE5EBF5),
            width: selected ? 1.4 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: selected
                  ? const Color(0x142563EB)
                  : const Color(0x0A0F172A),
              blurRadius: selected ? 22 : 14,
              offset: Offset(0, selected ? 12 : 8),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: order.tint,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                selected
                    ? Icons.receipt_long_rounded
                    : Icons.receipt_long_outlined,
                color: Colors.black87,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    order.title,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    order.subtitle,
                    style: Theme.of(
                      context,
                    ).textTheme.bodySmall?.copyWith(color: Colors.black54),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        order.eta,
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: _ordersFilterAccent,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        order.priority,
                        style: Theme.of(
                          context,
                        ).textTheme.bodySmall?.copyWith(color: Colors.black45),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  order.amount,
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 4),
                Text(
                  order.status,
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: Colors.black54),
                ),
                if (selected) ...[
                  const SizedBox(height: 8),
                  Text(
                    'محدد الآن',
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: _ordersFilterAccent,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
