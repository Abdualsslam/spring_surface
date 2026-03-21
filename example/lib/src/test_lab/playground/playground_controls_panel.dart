import 'package:flutter/material.dart';
import 'package:spring_surface/spring_surface.dart';

import 'playground_models.dart';

class PlaygroundControlsPanel extends StatelessWidget {
  const PlaygroundControlsPanel({
    super.key,
    required this.collapsedWidth,
    required this.collapsedHeight,
    required this.expandedWidth,
    required this.expandedHeight,
    required this.overshootClamp,
    required this.expandDurationMs,
    required this.collapseDurationMs,
    required this.reboundProfile,
    required this.anchor,
    required this.placement,
    required this.onCollapsedWidth,
    required this.onCollapsedHeight,
    required this.onOvershootClamp,
    required this.onExpandedWidth,
    required this.onExpandedHeight,
    required this.onExpandDuration,
    required this.onCollapseDuration,
    required this.onReboundProfile,
    required this.onAnchor,
    required this.onPlacement,
    required this.onPreset,
  });

  final double collapsedWidth;
  final double collapsedHeight;
  final double expandedWidth;
  final double expandedHeight;
  final double overshootClamp;
  final int expandDurationMs;
  final int collapseDurationMs;
  final SpringSurfaceReboundProfile reboundProfile;
  final SpringSurfaceAnchor anchor;
  final PlaygroundPlacement placement;
  final ValueChanged<double> onCollapsedWidth;
  final ValueChanged<double> onCollapsedHeight;
  final ValueChanged<double> onOvershootClamp;
  final ValueChanged<double> onExpandedWidth;
  final ValueChanged<double> onExpandedHeight;
  final ValueChanged<int> onExpandDuration;
  final ValueChanged<int> onCollapseDuration;
  final ValueChanged<SpringSurfaceReboundProfile> onReboundProfile;
  final ValueChanged<SpringSurfaceAnchor> onAnchor;
  final ValueChanged<PlaygroundPlacement> onPlacement;
  final ValueChanged<SpringSurfaceConfig> onPreset;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 320,
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: Color(0x10000000),
            blurRadius: 20,
            offset: Offset(0, -4),
          ),
        ],
      ),
      child: SingleChildScrollView(
        primary: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Wrap(
              spacing: 8,
              runSpacing: 8,
              alignment: WrapAlignment.center,
              children: [
                PlaygroundPresetChip(
                  label: 'gentle',
                  onTap: () => onPreset(const SpringSurfaceConfig.gentle()),
                ),
                PlaygroundPresetChip(
                  label: 'default',
                  onTap: () => onPreset(const SpringSurfaceConfig()),
                ),
                PlaygroundPresetChip(
                  label: 'bouncy',
                  onTap: () => onPreset(const SpringSurfaceConfig.bouncy()),
                ),
                PlaygroundPresetChip(
                  key: const Key('playground_preset_natural'),
                  label: 'natural',
                  onTap: () => onPreset(const SpringSurfaceConfig.natural()),
                ),
                PlaygroundPresetChip(
                  label: 'snappy',
                  onTap: () => onPreset(const SpringSurfaceConfig.snappy()),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const PlaygroundSectionLabel(title: 'Controls from SpringSurface'),
            PlaygroundSliderRow(
              label: 'overshoot',
              value: overshootClamp,
              min: 1.0,
              max: 1.12,
              digits: 2,
              onChanged: onOvershootClamp,
              infoKey: const Key('playground_info_overshoot'),
              description: playgroundOvershootDescriptionText,
            ),
            PlaygroundSliderRow(
              label: 'expanded width',
              value: expandedWidth,
              min: 260,
              max: 420,
              digits: 0,
              onChanged: onExpandedWidth,
              sliderKey: const Key('playground_expanded_width_slider'),
              valueKey: const Key('playground_expanded_width_value'),
              infoKey: const Key('playground_info_width'),
              description: playgroundExpandedWidthDescriptionText,
            ),
            PlaygroundSliderRow(
              label: 'expanded height',
              value: expandedHeight,
              min: 220,
              max: 520,
              digits: 0,
              onChanged: onExpandedHeight,
              sliderKey: const Key('playground_expanded_height_slider'),
              valueKey: const Key('playground_expanded_height_value'),
              infoKey: const Key('playground_info_height'),
              description: playgroundExpandedHeightDescriptionText,
            ),
            PlaygroundSliderRow(
              label: 'expand',
              value: expandDurationMs.toDouble(),
              min: 200,
              max: 1000,
              digits: 0,
              unit: 'ms',
              onChanged: (value) => onExpandDuration(value.round()),
              infoKey: const Key('playground_info_expand'),
              description: playgroundExpandDescriptionText,
            ),
            PlaygroundSliderRow(
              label: 'collapse',
              value: collapseDurationMs.toDouble(),
              min: 200,
              max: 1000,
              digits: 0,
              unit: 'ms',
              onChanged: (value) => onCollapseDuration(value.round()),
              infoKey: const Key('playground_info_collapse'),
              description: playgroundCollapseDescriptionText,
            ),
            const PlaygroundSectionHeader(
              title: 'rebound',
              infoKey: Key('playground_info_rebound'),
              description: playgroundReboundDescriptionText,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                PlaygroundReboundProfileChip(
                  key: const Key('playground_rebound_simultaneous'),
                  label: 'simultaneous',
                  value: SpringSurfaceReboundProfile.simultaneous,
                  current: reboundProfile,
                  onTap: onReboundProfile,
                ),
                PlaygroundReboundProfileChip(
                  key: const Key('playground_rebound_sequential'),
                  label: 'sequential',
                  value: SpringSurfaceReboundProfile.sequentialCrossAxis,
                  current: reboundProfile,
                  onTap: onReboundProfile,
                ),
              ],
            ),
            const PlaygroundSectionHeader(
              title: 'anchor',
              infoKey: Key('playground_info_anchor'),
              description: playgroundAnchorDescriptionText,
            ),
            Column(
              children: playgroundAnchorGrid
                  .map(
                    (row) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: row
                            .map(
                              (value) => PlaygroundAnchorChip(
                                key: Key('playground_anchor_${value.name}'),
                                label: playgroundAnchorLabel(value),
                                value: value,
                                current: anchor,
                                onTap: onAnchor,
                              ),
                            )
                            .toList(),
                      ),
                    ),
                  )
                  .toList(),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Text(
                playgroundAnchorFootnoteText,
                style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 14),
            const PlaygroundSectionLabel(title: 'Local Playground Controls'),
            PlaygroundSliderRow(
              label: 'button width',
              value: collapsedWidth,
              min: 180,
              max: 320,
              digits: 0,
              onChanged: onCollapsedWidth,
              infoKey: const Key('playground_info_button_width'),
              description: playgroundButtonWidthDescriptionText,
            ),
            PlaygroundSliderRow(
              label: 'button height',
              value: collapsedHeight,
              min: 44,
              max: 90,
              digits: 0,
              onChanged: onCollapsedHeight,
              infoKey: const Key('playground_info_button_height'),
              description: playgroundButtonHeightDescriptionText,
            ),
            const PlaygroundSectionHeader(
              title: 'placement',
              infoKey: Key('playground_info_placement'),
              description: playgroundPlacementDescriptionText,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                PlaygroundPlacementChip(
                  key: const Key('playground_placement_top'),
                  label: 'top',
                  value: PlaygroundPlacement.top,
                  current: placement,
                  onTap: onPlacement,
                ),
                PlaygroundPlacementChip(
                  key: const Key('playground_placement_center'),
                  label: 'center',
                  value: PlaygroundPlacement.center,
                  current: placement,
                  onTap: onPlacement,
                ),
                PlaygroundPlacementChip(
                  key: const Key('playground_placement_bottom'),
                  label: 'bottom',
                  value: PlaygroundPlacement.bottom,
                  current: placement,
                  onTap: onPlacement,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class PlaygroundSectionLabel extends StatelessWidget {
  const PlaygroundSectionLabel({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 10, 0, 6),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                color: Color(0xFF4F46E5),
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(child: Divider()),
        ],
      ),
    );
  }
}

class PlaygroundSectionHeader extends StatelessWidget {
  const PlaygroundSectionHeader({
    super.key,
    required this.title,
    required this.infoKey,
    required this.description,
  });

  final String title;
  final Key infoKey;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          const Expanded(child: Divider()),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
                ),
                const SizedBox(width: 6),
                PlaygroundInfoButton(
                  buttonKey: infoKey,
                  title: title,
                  description: description,
                ),
              ],
            ),
          ),
          const Expanded(child: Divider()),
        ],
      ),
    );
  }
}

class PlaygroundPresetChip extends StatelessWidget {
  const PlaygroundPresetChip({
    super.key,
    required this.label,
    required this.onTap,
  });

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          color: const Color(0xFFF0F0F8),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Color(0xFF4F46E5),
          ),
        ),
      ),
    );
  }
}

class PlaygroundReboundProfileChip extends StatelessWidget {
  const PlaygroundReboundProfileChip({
    super.key,
    required this.label,
    required this.value,
    required this.current,
    required this.onTap,
  });

  final String label;
  final SpringSurfaceReboundProfile value;
  final SpringSurfaceReboundProfile current;
  final ValueChanged<SpringSurfaceReboundProfile> onTap;

  @override
  Widget build(BuildContext context) {
    final selected = value == current;
    return GestureDetector(
      onTap: () => onTap(value),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFF4F46E5) : const Color(0xFFF0F0F8),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: selected ? Colors.white : const Color(0xFF4F46E5),
          ),
        ),
      ),
    );
  }
}

class PlaygroundPlacementChip extends StatelessWidget {
  const PlaygroundPlacementChip({
    super.key,
    required this.label,
    required this.value,
    required this.current,
    required this.onTap,
  });

  final String label;
  final PlaygroundPlacement value;
  final PlaygroundPlacement current;
  final ValueChanged<PlaygroundPlacement> onTap;

  @override
  Widget build(BuildContext context) {
    final selected = value == current;
    return GestureDetector(
      onTap: () => onTap(value),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFF4F46E5) : const Color(0xFFF0F0F8),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: selected ? Colors.white : const Color(0xFF4F46E5),
          ),
        ),
      ),
    );
  }
}

class PlaygroundAnchorChip extends StatelessWidget {
  const PlaygroundAnchorChip({
    super.key,
    required this.label,
    required this.value,
    required this.current,
    required this.onTap,
  });

  final String label;
  final SpringSurfaceAnchor value;
  final SpringSurfaceAnchor current;
  final ValueChanged<SpringSurfaceAnchor> onTap;

  @override
  Widget build(BuildContext context) {
    final selected = value == current;
    return GestureDetector(
      onTap: () => onTap(value),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFF4F46E5) : const Color(0xFFF0F0F8),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: selected ? Colors.white : const Color(0xFF4F46E5),
          ),
        ),
      ),
    );
  }
}

class PlaygroundSliderRow extends StatelessWidget {
  const PlaygroundSliderRow({
    super.key,
    required this.label,
    required this.value,
    required this.min,
    required this.max,
    required this.digits,
    required this.onChanged,
    required this.description,
    this.sliderKey,
    this.valueKey,
    this.infoKey,
    this.unit = '',
  });

  final String label;
  final double value;
  final double min;
  final double max;
  final int digits;
  final ValueChanged<double> onChanged;
  final String description;
  final Key? sliderKey;
  final Key? valueKey;
  final Key? infoKey;
  final String unit;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 128,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 11, color: Colors.grey),
                ),
              ),
              const SizedBox(width: 6),
              PlaygroundInfoButton(
                buttonKey: infoKey,
                title: label,
                description: description,
              ),
            ],
          ),
        ),
        Expanded(
          child: SliderTheme(
            data: SliderTheme.of(context).copyWith(
              trackHeight: 2,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 7),
              overlayShape: const RoundSliderOverlayShape(overlayRadius: 14),
              activeTrackColor: const Color(0xFF4F46E5),
              thumbColor: const Color(0xFF4F46E5),
              inactiveTrackColor: const Color(0xFFE0E0E8),
              overlayColor: const Color(0x1A4F46E5),
            ),
            child: Slider(
              key: sliderKey,
              value: value.clamp(min, max),
              min: min,
              max: max,
              onChanged: onChanged,
            ),
          ),
        ),
        SizedBox(
          width: 52,
          child: Text(
            key: valueKey,
            '${value.toStringAsFixed(digits)}$unit',
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: Color(0xFF4F46E5),
            ),
            textAlign: TextAlign.end,
          ),
        ),
      ],
    );
  }
}

class PlaygroundInfoButton extends StatelessWidget {
  const PlaygroundInfoButton({
    super.key,
    required this.title,
    required this.description,
    this.buttonKey,
  });

  final String title;
  final String description;
  final Key? buttonKey;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      key: buttonKey,
      behavior: HitTestBehavior.opaque,
      onTap: () => _showInfoDialog(context),
      child: Container(
        width: 18,
        height: 18,
        decoration: BoxDecoration(
          color: const Color(0xFFF0F0F8),
          shape: BoxShape.circle,
          border: Border.all(color: const Color(0x334F46E5)),
        ),
        child: const Center(
          child: Text(
            'i',
            style: TextStyle(
              color: Color(0xFF4F46E5),
              fontSize: 11,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _showInfoDialog(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (context) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
            title: Text(title),
            content: Text(description),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text(playgroundCloseDialogText),
              ),
            ],
          ),
        );
      },
    );
  }
}
