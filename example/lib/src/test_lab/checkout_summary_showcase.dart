// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:spring_surface/spring_surface.dart';

import 'showcase_models.dart';
import 'showcase_shell.dart';
import 'showcase_shared_widgets.dart';

enum _PaymentMethod { mada, applePay, card }

class CheckoutSummaryScenario extends StatefulWidget {
  const CheckoutSummaryScenario({
    super.key,
    this.displayMode = ScenarioDisplayMode.compact,
    this.keyPrefix = 'checkout_summary',
  });

  final ScenarioDisplayMode displayMode;
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

    return BottomDockScenarioShell(
      keyPrefix: widget.keyPrefix,
      displayMode: widget.displayMode,
      isExpanded: isExpanded,
      onToggle: toggle,
      onClose: close,
      accent: accent,
      gradient: const LinearGradient(
        colors: [Color(0xFFFFFBF6), Color(0xFFFFF4EC)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ),
      title: 'سلة المشتريات',
      badgeLabel: '3 عناصر',
      surfaceConfig: const SpringSurfaceConfig(),
      collapsedHeight: 60,
      expandedHeightCompact: 248,
      expandedHeightFeatured: 264,
      surfaceHostHeightCompact: 286,
      surfaceHostHeightFeatured: 302,
      backgroundBuilder: (context) {
        return Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Row(
                children: [
                  const Icon(Icons.location_on_outlined, color: accent),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'التوصيل إلى المنزل',
                          style: Theme.of(context).textTheme.titleSmall
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
        );
      },
      collapsedChild: CheckoutDockBar(
        total: total,
        accent: accent,
        methodLabel: methodLabel,
      ),
      expandedChild: _CheckoutSummaryPanel(
        onToggle: toggle,
        subtotal: subtotal,
        discount: discount,
        delivery: delivery,
        total: total,
        methodDescription: methodDescription,
      ),
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
