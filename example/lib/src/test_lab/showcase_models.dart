import 'package:flutter/widgets.dart';

enum ScenarioDisplayMode { compact, featured }

extension ScenarioDisplayModeX on ScenarioDisplayMode {
  bool get isFeatured => this == ScenarioDisplayMode.featured;
}

enum FamilyLayoutStyle { featuredSwitcher, stackedCards }

typedef ShowcaseVariantBuilder =
    Widget Function({
      required String keyPrefix,
      required ScenarioDisplayMode displayMode,
    });

class ShowcaseVariantDefinition {
  const ShowcaseVariantDefinition({
    required this.id,
    required this.title,
    required this.description,
    required this.builder,
  });

  final String id;
  final String title;
  final String description;
  final ShowcaseVariantBuilder builder;
}

class ShowcaseFamilyDefinition {
  const ShowcaseFamilyDefinition({
    required this.id,
    required this.title,
    required this.description,
    required this.layoutStyle,
    required this.variants,
  }) : assert(
         variants.length > 0,
         'A family must contain at least one variant.',
       );

  final String id;
  final String title;
  final String description;
  final FamilyLayoutStyle layoutStyle;
  final List<ShowcaseVariantDefinition> variants;
}
