# elastic_sheet

`elastic_sheet` is a Flutter widget for building realistic expand/collapse surfaces with a liquid spring feel.

It is designed for inline actions, drawers, search affordances, composer bars, and other UI pieces that should feel like one surface stretching into another, not a modal abruptly appearing on top.

## Features

- Declarative API with `isExpanded`
- Controller-based API with `SpringSurfaceController`
- Configurable spring tuning via `SpringSurfaceConfig`
- Optional rebound profiles, including a sequential cross-axis stretch
- 9-point anchors for fixed-size expansion, from `topLeft` to `bottomRight`
- Content states for `ready`, `pending`, and `unavailable`
- Legacy `top`, `center`, and `bottom` origins still supported
- Fixed and measured dynamic expanded sizing
- Runnable example app under [`example/`](example)

## Installation

```yaml
dependencies:
  elastic_sheet: ^0.1.0
```

## Usage

```dart
import 'package:flutter/material.dart';
import 'package:elastic_sheet/elastic_sheet.dart';

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
        anchor: SpringSurfaceAnchor.bottomCenter,
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
  anchor: SpringSurfaceAnchor.centerRight,
  collapsedSize: const Size(220, 52),
  expandedSize: const Size(320, 320),
  collapsedChild: const Text('Compose'),
  expandedChild: const Text('Composer panel'),
)
```

You can also opt into a more natural late-stage rebound:

```dart
const config = SpringSurfaceConfig.natural();
```

## Partial Triggers

`SpringSurface.controlled` injects `SpringSurfaceActions` around its collapsed
and expanded content. That lets any descendant open, close, toggle, or pulse
the surface without turning the whole `collapsedChild` into one large button.

```dart
SpringSurface.controlled(
  controller: controller,
  anchor: SpringSurfaceAnchor.bottomCenter,
  collapsedSize: const Size(320, 56),
  expandedSize: const Size(320, 220),
  collapsedChild: Builder(
    builder: (context) => Row(
      children: [
        Expanded(child: TextField(controller: draftController)),
        IconButton(
          onPressed: () {
            FocusManager.instance.primaryFocus?.unfocus();
            SpringSurfaceActions.of(context).expand();
          },
          icon: const Icon(Icons.add_rounded),
        ),
      ],
    ),
  ),
  expandedChild: const Text('Composer actions'),
)
```

## Anchors

Use `anchor` to keep a specific edge or corner fixed while the surface grows:

```dart
SpringSurface(
  isExpanded: _open,
  anchor: SpringSurfaceAnchor.topRight,
  collapsedSize: const Size(180, 48),
  expandedSize: const Size(320, 280),
  collapsedChild: const Text('Filters'),
  expandedChild: const Text('Expanded content'),
)
```

For `SpringSurfaceExpandedSizing.dynamicHeight`, the horizontal part of the
anchor is ignored so `topLeft` and `topRight` both behave like `topCenter`,
and the same applies to the `center` and `bottom` rows.

## Content States

Use `contentState` when a collapsed surface does not always have expanded data.

```dart
SpringSurface(
  isExpanded: false,
  contentState: SpringSurfaceContentState.pending,
  collapsedSize: const Size(180, 48),
  collapsedChild: const Text('Waiting for slot data'),
  onPendingTap: _reloadSlots,
)
```

- `ready`: normal expand/collapse behavior. `expandedSize` and `expandedChild` are required.
- `pending`: no expanded content yet. The surface stays collapsed and plays a subtle pulse on tap.
- `unavailable`: visible but disabled. No pulse and no expansion.

## Example app

The runnable showcase lives in [`example/`](example). It contains the playground plus several realistic scenarios that import the package exactly as an external consumer would.
