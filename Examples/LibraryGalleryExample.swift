import SwiftUI
import MatchedGeometryTransition

private struct LibraryEntry: Identifiable {
    let id: Int
    let title: String
    let category: String
    let symbol: String
    var favorite: Bool
}

struct LibraryGalleryExample: View {
    @State private var entries: [LibraryEntry] = [
        LibraryEntry(id: 101, title: "Grid systems", category: "Design", symbol: "square.grid.2x2", favorite: true),
        LibraryEntry(id: 205, title: "Motion principles", category: "Animation", symbol: "circle.dotted", favorite: false),
        LibraryEntry(id: 309, title: "Color studies", category: "Design", symbol: "paintpalette", favorite: true)
    ]

    @State private var showFavoritesOnly = false

    private var visibleEntries: [LibraryEntry] {
        showFavoritesOnly ? entries.filter(\.favorite) : entries
    }

    var body: some View {
        VStack(spacing: 0) {
            Toggle("Favorites only", isOn: $showFavoritesOnly)
                .padding()

            MatchedGeometryGallery(items: visibleEntries) { entry, context in
                VStack(spacing: 12) {
                    Image(systemName: entry.symbol)
                        .font(.system(size: 40))
                        .frame(height: 90)
                        .matchedGeometryEffect(
                            id: context.key("icon"),
                            in: context.namespace,
                            isSource: context.isSource
                        )

                    Text(entry.title)
                        .font(.headline)
                        .matchedGeometryEffect(
                            id: context.key("title"),
                            in: context.namespace,
                            isSource: context.isSource
                        )
                }
                .frame(maxWidth: .infinity)
                .padding(16)
                .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 18))
            } detail: { entry, context, dismiss in
                VStack(alignment: .leading, spacing: 20) {
                    HStack {
                        Text(entry.category)
                            .foregroundStyle(.secondary)

                        Spacer()

                        Button("Close", action: dismiss)
                    }

                    Image(systemName: entry.symbol)
                        .font(.system(size: 76))
                        .frame(maxWidth: .infinity)
                        .matchedGeometryEffect(
                            id: context.key("icon"),
                            in: context.namespace,
                            isSource: context.isSource
                        )

                    Text(entry.title)
                        .font(.largeTitle.bold())
                        .matchedGeometryEffect(
                            id: context.key("title"),
                            in: context.namespace,
                            isSource: context.isSource
                        )

                    Button("Remove from library", role: .destructive) {
                        entries.removeAll { $0.id == entry.id }
                        dismiss()
                    }
                }
                .padding(24)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 24))
            }
        }
    }
}
