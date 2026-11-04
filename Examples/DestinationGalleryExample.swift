import SwiftUI
import MatchedGeometryTransition

private struct Destination: Identifiable {
    let id: Int
    let title: String
    let subtitle: String
    let symbol: String
    let color: Color
    let description: String
}

struct DestinationGalleryExample: View {
    private let destinations: [Destination] = [
        Destination(
            id: 1,
            title: "Mountains",
            subtitle: "A quiet weekend",
            symbol: "mountain.2.fill",
            color: .indigo,
            description: "Explore trails, lakes, and mountain villages."
        ),
        Destination(
            id: 2,
            title: "Coast",
            subtitle: "A day by the sea",
            symbol: "water.waves",
            color: .teal,
            description: "Enjoy the coast, walk along the shore, and discover local cafés."
        ),
        Destination(
            id: 3,
            title: "City",
            subtitle: "Architecture and culture",
            symbol: "building.2.fill",
            color: .orange,
            description: "Visit museums, studios, and small independent shops."
        )
    ]

    var body: some View {
        MatchedGeometryGallery(
            items: destinations,
            metrics: TransitionMetrics(minimumCardWidth: 170, spacing: 14)
        ) { destination, context in
            VStack(alignment: .leading, spacing: 10) {
                artwork(destination, context: context, height: 120)

                Text(destination.title)
                    .font(.headline)
                    .matchedGeometryEffect(
                        id: context.key("title"),
                        in: context.namespace,
                        isSource: context.isSource
                    )

                Text(destination.subtitle)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            .padding(12)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 20))
        } detail: { destination, context, dismiss in
            VStack(alignment: .leading, spacing: 18) {
                HStack {
                    Text("Explore")
                        .font(.subheadline.weight(.medium))
                        .foregroundStyle(.secondary)

                    Spacer()

                    Button(action: dismiss) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.title2)
                    }
                    .accessibilityLabel("Close details")
                }

                artwork(destination, context: context, height: 260)

                Text(destination.title)
                    .font(.largeTitle.bold())
                    .matchedGeometryEffect(
                        id: context.key("title"),
                        in: context.namespace,
                        isSource: context.isSource
                    )

                Text(destination.description)
                    .font(.body)
            }
            .padding(20)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 24))
        }
    }

    private func artwork(
        _ destination: Destination,
        context: MatchedGeometryContext<Int>,
        height: CGFloat
    ) -> some View {
        RoundedRectangle(cornerRadius: 16)
            .fill(destination.color.gradient)
            .frame(height: height)
            .overlay {
                Image(systemName: destination.symbol)
                    .font(.system(size: height > 200 ? 64 : 40))
                    .foregroundStyle(.white)
            }
            .matchedGeometryEffect(
                id: context.key("artwork"),
                in: context.namespace,
                isSource: context.isSource
            )
            .accessibilityHidden(true)
    }
}
