import 'package:flutter/material.dart';
import 'package:spring_surface/spring_surface.dart';

import 'playground_models.dart';

class PlaygroundSurfacePreview extends StatelessWidget {
  const PlaygroundSurfacePreview({
    super.key,
    required this.isExpanded,
    required this.anchor,
    required this.config,
    required this.collapsedSize,
    required this.expandedSize,
    required this.surfaceHostWidth,
    required this.surfaceHostHeight,
    required this.hostLeft,
    required this.hostTop,
    required this.onToggle,
  });

  final bool isExpanded;
  final SpringSurfaceAnchor anchor;
  final SpringSurfaceConfig config;
  final Size collapsedSize;
  final Size expandedSize;
  final double surfaceHostWidth;
  final double surfaceHostHeight;
  final double hostLeft;
  final double hostTop;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Positioned(
          left: hostLeft,
          top: hostTop,
          width: surfaceHostWidth,
          height: surfaceHostHeight,
          child: GestureDetector(
            key: const Key('playground_surface_toggle'),
            behavior: HitTestBehavior.opaque,
            onTap: onToggle,
            child: SizedBox(
              key: const Key('playground_surface_host'),
              width: surfaceHostWidth,
              height: surfaceHostHeight,
              child: SpringSurface(
                isExpanded: isExpanded,
                anchor: anchor,
                config: config,
                collapsedSize: collapsedSize,
                expandedSize: expandedSize,
                collapsedBorderRadius: const BorderRadius.all(
                  Radius.circular(32),
                ),
                expandedBorderRadius: const BorderRadius.all(
                  Radius.circular(22),
                ),
                collapsedDecoration: BoxDecoration(
                  color: const Color(0xFF4F46E5),
                  borderRadius: BorderRadius.circular(32),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x224F46E5),
                      blurRadius: 22,
                      offset: Offset(0, 12),
                    ),
                  ],
                ),
                expandedDecoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(22),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x16000000),
                      blurRadius: 26,
                      offset: Offset(0, 14),
                    ),
                  ],
                ),
                collapsedChild: const Center(
                  child: Text(
                    key: Key('playground_collapsed_label'),
                    playgroundCollapsedLabelText,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                expandedChild: const SingleChildScrollView(
                  primary: false,
                  child: PlaygroundExpandedContent(),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class PlaygroundExpandedContent extends StatelessWidget {
  const PlaygroundExpandedContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 8),
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Container(
            height: 90,
            decoration: BoxDecoration(
              color: const Color(0xFFF0F0F8),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Center(
              child: Text(
                key: Key('playground_expanded_heading'),
                playgroundExpandedHeadingText,
                style: TextStyle(
                  color: Color(0xFF4F46E5),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          _placeholder(52),
          const SizedBox(height: 8),
          _placeholder(52),
          const SizedBox(height: 16),
          Container(
            height: 52,
            decoration: BoxDecoration(
              color: const Color(0xFF4F46E5),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Center(
              child: Text(
                playgroundConfirmPaymentText,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _placeholder(double height) => Container(
    height: height,
    decoration: BoxDecoration(
      color: Colors.grey.shade100,
      borderRadius: BorderRadius.circular(12),
    ),
  );
}
