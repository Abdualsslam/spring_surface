part of '../spring_surface_test_lab_page.dart';

class _PageHero extends StatelessWidget {
  const _PageHero();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0F172A), Color(0xFF1D3557)],
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
              'سبعة مشاهد واقعية قابلة للتصوير مباشرة.',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'الصفحة تعرض أمثلة واقعية قصيرة، ويمكن فتح كل مثال في صفحة مستقلة أوسع مع تحكمات تخص السيناريو نفسه.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.white.withAlpha(215),
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ScenarioSection extends StatelessWidget {
  const _ScenarioSection({required this.definition});

  final _ShowcaseScenarioDefinition definition;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
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
            Row(
              children: [
                Expanded(
                  child: Text(
                    definition.title,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                OutlinedButton.icon(
                  key: definition.detailButtonKey,
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => _SpringSurfaceScenarioDetailPage(
                          definition: definition,
                        ),
                      ),
                    );
                  },
                  icon: const Icon(Icons.open_in_new_rounded, size: 18),
                  label: const Text('تجربة في صفحة'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              definition.description,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.black54,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 18),
            _PreviewFrame(child: definition.compactPreviewBuilder()),
          ],
        ),
      ),
    );
  }
}

class _SpringSurfaceScenarioDetailPage extends StatelessWidget {
  const _SpringSurfaceScenarioDetailPage({required this.definition});

  final _ShowcaseScenarioDefinition definition;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.transparent,
          title: Text(definition.title),
        ),
        body: SafeArea(
          child: KeyedSubtree(
            key: definition.detailPageKey,
            child: definition.detailExperienceBuilder(),
          ),
        ),
      ),
    );
  }
}

class _PreviewFrame extends StatelessWidget {
  const _PreviewFrame({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 520,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: const Color(0xFF0F172A),
          borderRadius: BorderRadius.circular(34),
          boxShadow: const [
            BoxShadow(
              color: Color(0x24000000),
              blurRadius: 32,
              offset: Offset(0, 18),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}

class _ScenarioBackdrop extends StatelessWidget {
  const _ScenarioBackdrop({required this.backdropKey, required this.onTap});

  final Key backdropKey;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: GestureDetector(
        key: backdropKey,
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: ColoredBox(color: Colors.black.withAlpha(14)),
      ),
    );
  }
}

abstract class _ExpandableSceneState<T extends StatefulWidget>
    extends State<T> {
  bool isExpanded = false;

  void setExpanded(bool value) {
    if (isExpanded == value) {
      return;
    }
    setState(() => isExpanded = value);
  }

  void open() => setExpanded(true);

  void toggle() => setExpanded(!isExpanded);

  void close() => setExpanded(false);
}

Widget _buildOrdersFilterCompactPreview() => const _OrdersFilterScenario();
Widget _buildSearchSuggestionsCompactPreview() =>
    const _SearchSuggestionsScenario();
Widget _buildTicketActionsCompactPreview() => const _TicketActionsScenario();
Widget _buildBookingSlotCompactPreview() => const _BookingSlotScenario();
Widget _buildSettingsInlineCompactPreview() => const _SettingsInlineScenario();
Widget _buildMessageComposerCompactPreview() =>
    const _MessageComposerScenario();
Widget _buildCheckoutSummaryCompactPreview() =>
    const _CheckoutSummaryScenario();

Widget _buildOrdersFilterDetailExperience() =>
    const _OrdersFilterDetailExperience();
Widget _buildSearchSuggestionsDetailExperience() =>
    const _SearchSuggestionsDetailExperience();
Widget _buildTicketActionsDetailExperience() =>
    const _TicketActionsDetailExperience();
Widget _buildBookingSlotDetailExperience() =>
    const _BookingSlotDetailExperience();
Widget _buildSettingsInlineDetailExperience() =>
    const _SettingsInlineDetailExperience();
Widget _buildMessageComposerDetailExperience() =>
    const _MessageComposerDetailExperience();
Widget _buildCheckoutSummaryDetailExperience() =>
    const _CheckoutSummaryDetailExperience();
