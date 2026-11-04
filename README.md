# MatchedGeometryTransition

A reusable SwiftUI card-to-detail transition with **shared-element animations**, a responsive grid, accessible dismissal, and reduced-motion support.

![Swift](https://img.shields.io/badge/Swift-5.9%2B-orange)
![iOS](https://img.shields.io/badge/iOS-16%2B-blue)
![macOS](https://img.shields.io/badge/macOS-13%2B-blue)
[![MIT License](https://img.shields.io/badge/License-MIT-green)](LICENSE)

**Author:** Niloufar Rabiee

## What you will learn

- Animate between two layouts using `@Namespace` and `matchedGeometryEffect`.
- Give shared elements stable identities across collapsed and expanded states.
- Control `isSource` so that only one matching view owns the source geometry.
- Keep both layouts in the same view hierarchy.
- Handle selection, dismissal, filtering, and removed items safely.
- Respect the system's Reduce Motion accessibility setting.

## Features

- Generic `MatchedGeometryGallery<Item, Card, Detail>` with custom content.
- Adaptive grid that works across compact and wide layouts.
- Shared element identifiers for titles, images, and other regions.
- Spring-based expand/collapse animations and dimmed background.
- Backdrop-tap dismissal and an explicit close callback.
- Reduced-motion behavior without a forced animation.
- Identity-based selection that survives sorting and closes when an item disappears.
- Configurable card width, spacing, detail width, and backdrop opacity.
- Dependency-free Swift Package Manager library.

## Requirements

Swift 5.9 or newer, **iOS 16+** or **macOS 13+**, Xcode with Swift Package Manager support.

## Installation

In Xcode, select **File > Add Package Dependencies...** and enter:

```text
https://github.com/NiloufarRabiee/swiftui-matched-geometry-transition
```

Add the `MatchedGeometryTransition` library product to your app target.

## Quick start

```swift
import SwiftUI
import MatchedGeometryTransition

struct Note: Identifiable {
    let id: Int
    let title: String
    let summary: String
}

struct NotesGallery: View {
    private let notes = [
        Note(id: 1, title: "Ideas", summary: "A collection of sketches"),
        Note(id: 2, title: "Plans", summary: "Next steps for the project")
    ]

    var body: some View {
        MatchedGeometryGallery(items: notes) { note, context in
            Text(note.title)
                .font(.headline)
                .matchedGeometryEffect(
                    id: context.key("title"),
                    in: context.namespace,
                    isSource: context.isSource
                )
                .padding(24)
                .frame(maxWidth: .infinity)
                .background(.regularMaterial)
        } detail: { note, context, dismiss in
            VStack(alignment: .leading, spacing: 20) {
                Button("Close", action: dismiss)

                Text(note.title)
                    .font(.largeTitle.bold())
                    .matchedGeometryEffect(
                        id: context.key("title"),
                        in: context.namespace,
                        isSource: context.isSource
                    )

                Text(note.summary)
            }
            .padding(24)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(.regularMaterial)
        }
    }
}
```

**Important:** Use the same role name (for example, `"title"`) in both closures. The context supplies the correct namespace and source ownership. The outer card-to-detail surface is matched automatically.

## Configuration

```swift
let metrics = TransitionMetrics(
    minimumCardWidth: 200,
    spacing: 12,
    maximumDetailWidth: 680,
    backdropOpacity: 0.48
)

MatchedGeometryGallery(items: items, metrics: metrics) { item, context in
    // Collapsed card content
} detail: { item, context, dismiss in
    // Expanded card content and a close control
}
```

| Setting | Default | Range |
| --- | ---: | --- |
| `minimumCardWidth` | 190 | 120...1000 points |
| `spacing` | 16 | 0...80 points |
| `maximumDetailWidth` | 640 | 280...1200 points |
| `backdropOpacity` | 0.42 | 0...0.85 |

Non-finite numbers revert to the corresponding default.

## How matching works

The collapsed and expanded views are rendered by one `MatchedGeometryGallery`, sharing an internal `@Namespace`. The gallery matches each card's outer surface with the expanded surface using a stable item identifier.

For interior elements, attach `matchedGeometryEffect` to corresponding views in both closures using `context.key("artwork")`, `context.key("title")`, or another role. The context controls the `isSource` value so that the visible view supplies the source geometry while the paired view participates in the transition.

The selected card remains in the grid at zero opacity to preserve its original layout position while detail content is presented above it. When detail is dismissed, the transition can return to that position.

## Accessibility and interaction

The entire collapsed card is a standard `Button` and supports VoiceOver activation. The detail closure receives a `dismiss` callback; **include a clearly labeled close button**, so dismissal is available without tapping the dimmed background. While the detail is shown, background cards are removed from accessibility and hit-testing.

With **Reduce Motion** enabled, the gallery updates selection without spring animation. Shared element identities remain stable.

## Examples

- [DestinationGalleryExample.swift](Examples/DestinationGalleryExample.swift): colored artwork, title matching, adaptive cards, and a close control.
- [LibraryGalleryExample.swift](Examples/LibraryGalleryExample.swift): filtering and deleting items while preserving identity.

The example files contain SwiftUI views intended to be copied into an app target. They are not separate executable app bundles.

## Testing

```bash
swift build
swift test
```

The unit tests cover selection changes, idempotent operations, removal reconciliation, reordering, and metric validation. CI also builds the SwiftUI implementation on macOS.

## Limitations

- Shared-element animations require both views to be in the same SwiftUI hierarchy. This component does not push a new `NavigationStack` destination.
- One card is expanded at a time.
- The detail area scrolls independently and is intended for in-place presentation.
- When authoring custom content, keep role names stable and do not reuse the same role for two different elements in one card.

## Project files

- `Sources/MatchedGeometryTransition/`: reusable component, shared-element context, layout metrics, selection state.
- `Tests/MatchedGeometryTransitionTests/`: deterministic unit tests.
- `Examples/`: two consumer-facing usage examples.

## License

MIT © 2026 **Niloufar Rabiee**. See [LICENSE](LICENSE).
