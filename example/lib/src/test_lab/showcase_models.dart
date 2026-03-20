import 'package:flutter/widgets.dart';

enum ScenarioPresentation { compact, detail }

extension ScenarioPresentationX on ScenarioPresentation {
  bool get isDetail => this == ScenarioPresentation.detail;
}

class ShowcaseScenarioDefinition {
  const ShowcaseScenarioDefinition({
    required this.id,
    required this.title,
    required this.description,
    required this.detailSummary,
    required this.compactPreviewBuilder,
    required this.detailExperienceBuilder,
  });

  final String id;
  final String title;
  final String description;
  final String detailSummary;
  final Widget Function() compactPreviewBuilder;
  final Widget Function() detailExperienceBuilder;

  Key get detailButtonKey => Key('${id}_detail_button');
  Key get detailPageKey => Key('${id}_detail_page');
}

