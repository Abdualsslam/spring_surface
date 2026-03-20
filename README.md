# spring_surface

`spring_surface` is a Flutter widget for building realistic expand/collapse surfaces with a liquid spring feel.

It is designed for inline actions, drawers, search affordances, composer bars, and other UI pieces that should feel like one surface stretching into another, not a modal abruptly appearing on top.

## Features

- Declarative API with `isExpanded`
- Controller-based API with `SpringSurfaceController`
- Configurable spring tuning via `SpringSurfaceConfig`
- Support for `top`, `center`, and `bottom` expansion origins
- Fixed and measured dynamic expanded sizing
- Runnable example app under [`example/`](example)

## Installation

```yaml
dependencies:
  spring_surface: ^0.1.0
```

## Usage

```dart
import 'package:flutter/material.dart';
import 'package:spring_surface/spring_surface.dart';

class DemoCard extends StatefulWidget {
  const DemoCard({super.key});

  @override
  State<DemoCard> createState() => _DemoCardState();
}

class _DemoCardState extends State<DemoCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => setState(() => _isExpanded = !_isExpanded),
      child: SpringSurface(
        isExpanded: _isExpanded,
        origin: SpringSurfaceOrigin.bottom,
        config: const SpringSurfaceConfig.gentle(),
        collapsedSize: const Size(220, 52),
        expandedSize: const Size(320, 320),
        expandedSizing: SpringSurfaceExpandedSizing.dynamicHeight,
        collapsedChild: const Center(child: Text('Open')),
        expandedChild: const Padding(
          padding: EdgeInsets.all(16),
          child: Text('Expanded content'),
        ),
      ),
    );
  }
}
```

## Controller API

```dart
late final SpringSurfaceController controller;

@override
void initState() {
  super.initState();
  controller = SpringSurfaceController(
    vsync: this,
    config: const SpringSurfaceConfig.snappy(),
  );
}

@override
void dispose() {
  controller.dispose();
  super.dispose();
}
```

Then use:

```dart
SpringSurface.controlled(
  controller: controller,
  collapsedSize: const Size(220, 52),
  expandedSize: const Size(320, 320),
  collapsedChild: const Text('Compose'),
  expandedChild: const Text('Composer panel'),
)
```

## Example app

The runnable showcase lives in [`example/`](example). It contains the playground plus several realistic scenarios that import the package exactly as an external consumer would.
