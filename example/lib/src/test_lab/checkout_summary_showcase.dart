// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:spring_surface/spring_surface.dart';
import 'showcase_models.dart';
import 'showcase_shell.dart';
import 'showcase_shared_widgets.dart';

enum _PaymentMethod { mada, applePay, card }

class CheckoutSummaryDetailExperience extends StatefulWidget {
  const CheckoutSummaryDetailExperience();

  @override
  State<CheckoutSummaryDetailExperience> createState() =>
      CheckoutSummaryDetailExperienceState();
}

class CheckoutSummaryDetailExperienceState
    extends State<CheckoutSummaryDetailExperience> {
  final _sceneKey = GlobalKey<CheckoutSummaryScenarioState>();

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
      child: CheckoutSummaryScenario(
        key: _sceneKey,
        presentation: ScenarioPresentation.detail,
        keyPrefix: 'checkout_summary_detail',
      ),
    );
  }
}

class CheckoutSummaryScenario extends StatefulWidget {
  const CheckoutSummaryScenario({
    super.key,
    this.presentation = ScenarioPresentation.compact,
    this.keyPrefix = 'checkout_summary',
  });

  final ScenarioPresentation presentation;
  final String keyPrefix;

  @override
  State<CheckoutSummaryScenario> createState() =>
      CheckoutSummaryScenarioState();
}

class CheckoutSummaryScenarioState
    extends ExpandableSceneState<CheckoutSummaryScenario> {
  @override
  Widget build(BuildContext context) {
    const accent = Color(0xFFEA580C);
    const currentPaymentMethod = _PaymentMethod.mada;

    late final String subtotal;
    late final String discount;
    late final String delivery;
    late final String total;
    late final String methodLabel;
    late final String methodDescription;

    switch (currentPaymentMethod) {
      case _PaymentMethod.mada:
        subtotal = '132 ر.س';
        discount = '-8 ر.س';
        delivery = '12 ر.س';
        total = '136 ر.س';
        methodLabel = 'مدى';
        methodDescription = 'بطاقة مدى •••• 8841';
      case _PaymentMethod.applePay:
        subtotal = '132 ر.س';
        discount = '-10 ر.س';
        delivery = '12 ر.س';
        total = '134 ر.س';
        methodLabel = 'Apple Pay';
        methodDescription = 'Apple Pay جاهز على هذا الجهاز';
      case _PaymentMethod.card:
        subtotal = '132 ر.س';
        discount = '-6 ر.س';
        delivery = '12 ر.س';
        total = '138 ر.س';
        methodLabel = 'بطاقة';
        methodDescription = 'بطاقة ائتمانية •••• 1930';
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final surfaceWidth = constraints.maxWidth - 32;

        return DecoratedBox(
          key: Key('${widget.keyPrefix}_canvas'),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFFFFBF6), Color(0xFFFFF4EC)],
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
                              'سلة المشتريات',
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(fontWeight: FontWeight.w800),
                            ),
                          ),
                          const ShowcaseBadge(label: '3 عناصر'),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.location_on_outlined,
                              color: accent,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'التوصيل إلى المنزل',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleSmall
                                        ?.copyWith(fontWeight: FontWeight.w800),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'حي الروضة، شارع الأمير سلطان',
                                    style: Theme.of(context).textTheme.bodySmall
                                        ?.copyWith(color: Colors.black54),
                                  ),
                                ],
                              ),
                            ),
                            const Icon(Icons.chevron_left_rounded),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Expanded(
                        child: Column(
                          children: [
                            CartLine(
                              title: 'سماعة لاسلكية',
                              subtitle: 'لون رمادي',
                              amount: '79 ر.س',
                            ),
                            SizedBox(height: 10),
                            CartLine(
                              title: 'غلاف حماية',
                              subtitle: 'مقاس كامل',
                              amount: '18 ر.س',
                            ),
                            SizedBox(height: 10),
                            CartLine(
                              title: 'شاحن سريع',
                              subtitle: 'منفذ Type-C',
                              amount: '35 ر.س',
                            ),
                            Spacer(),
                            SizedBox(height: 68),
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
                left: 16,
                right: 16,
                bottom: 16,
                height: widget.presentation.isDetail ? 302 : 286,
                child: SpringSurface(
                  isExpanded: isExpanded,
                  origin: SpringSurfaceOrigin.bottom,
                  config: const SpringSurfaceConfig(),
                  collapsedSize: Size(surfaceWidth, 60),
                  expandedSize: Size(
                    surfaceWidth,
                    widget.presentation.isDetail ? 264 : 248,
                  ),
                  collapsedDecoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: accent.withAlpha(34)),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x12000000),
                        blurRadius: 22,
                        offset: Offset(0, 12),
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
                        blurRadius: 28,
                        offset: Offset(0, 14),
                      ),
                    ],
                  ),
                  collapsedChild: GestureDetector(
                    key: Key('${widget.keyPrefix}_toggle'),
                    behavior: HitTestBehavior.opaque,
                    onTap: toggle,
                    child: CheckoutDockBar(
                      total: total,
                      accent: accent,
                      methodLabel: methodLabel,
                    ),
                  ),
                  expandedChild: _CheckoutSummaryPanel(
                    onToggle: toggle,
                    subtotal: subtotal,
                    discount: discount,
                    delivery: delivery,
                    total: total,
                    methodDescription: methodDescription,
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

class _CheckoutSummaryPanel extends StatelessWidget {
  const _CheckoutSummaryPanel({
    required this.onToggle,
    required this.subtotal,
    required this.discount,
    required this.delivery,
    required this.total,
    required this.methodDescription,
  });

  final VoidCallback onToggle;
  final String subtotal;
  final String discount;
  final String delivery;
  final String total;
  final String methodDescription;

  @override
  Widget build(BuildContext context) {
    return SurfaceScrollableContent(
      children: [
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: onToggle,
          child: const PanelHeaderButton(
            label: 'ملخص الدفع',
            icon: Icons.receipt_long_outlined,
            accent: Color(0xFFEA580C),
          ),
        ),
        const SizedBox(height: 12),
        InfoRow(label: 'المجموع الفرعي', value: subtotal),
        const SizedBox(height: 8),
        InfoRow(label: 'خصم القسيمة', value: discount),
        const SizedBox(height: 8),
        InfoRow(label: 'رسوم التوصيل', value: delivery),
        const SizedBox(height: 8),
        InfoRow(label: 'الإجمالي', value: total),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFFFFF3EA),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              const Icon(Icons.credit_card_rounded, color: Color(0xFFEA580C)),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  methodDescription,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w800),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
