#if canImport(SwiftUI)
import SwiftUI

/// A stable identity for an element shared between the collapsed and expanded card.
public struct MatchedElementKey<ID: Hashable>: Hashable {
    public let itemID: ID
    public let role: String

    public init(itemID: ID, role: String) {
        self.itemID = itemID
        self.role = role
    }
}

/// Context passed to both renderers to match individual elements.
///
/// Use the same role (such as "artwork" or "title") in the card and detail
/// views. The gallery manages source ownership to prevent competing sources.
public struct MatchedGeometryContext<ID: Hashable> {
    public let itemID: ID
    public let namespace: Namespace.ID
    public let isSource: Bool

    public init(itemID: ID, namespace: Namespace.ID, isSource: Bool) {
        self.itemID = itemID
        self.namespace = namespace
        self.isSource = isSource
    }

    public func key(_ role: String) -> MatchedElementKey<ID> {
        MatchedElementKey(itemID: itemID, role: role)
    }
}

/// A responsive, reusable card-to-detail presentation using matched geometry.
///
/// The card and expanded view remain in the same SwiftUI hierarchy, which is
/// required for shared-element matching. The gallery owns selection, dismissal,
/// the dimmed backdrop, and the reduced-motion behavior.
public struct MatchedGeometryGallery<
    Item: Identifiable,
    Card: View,
    Detail: View
>: View {
    private let items: [Item]
    private let metrics: TransitionMetrics
    private let cardContent: (Item, MatchedGeometryContext<Item.ID>) -> Card
    private let detailContent:
        (Item, MatchedGeometryContext<Item.ID>, @escaping () -> Void) -> Detail

    @Namespace private var namespace
    @State private var selection = CardSelectionState<Item.ID>()
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    public init(
        items: [Item],
        metrics: TransitionMetrics = .init(),
        @ViewBuilder card: @escaping (Item, MatchedGeometryContext<Item.ID>) -> Card,
        @ViewBuilder detail: @escaping (
            Item, MatchedGeometryContext<Item.ID>, @escaping () -> Void
        ) -> Detail
    ) {
        self.items = items
        self.metrics = metrics
        self.cardContent = card
        self.detailContent = detail
    }

    public var body: some View {
        ZStack {
            ScrollView {
                LazyVGrid(columns: columns, spacing: CGFloat(metrics.spacing)) {
                    ForEach(items) { item in
                        Button {
                            expand(item.id)
                        } label: {
                            cardContent(item, context(for: item.id, isSource: selection.selectedID != item.id))
                                .matchedGeometryEffect(
                                    id: MatchedElementKey(itemID: item.id, role: "surface"),
                                    in: namespace,
                                    isSource: selection.selectedID != item.id
                                )
                        }
                        .buttonStyle(.plain)
                        .opacity(selection.selectedID == item.id ? 0 : 1)
                        .accessibilityHint("Open details")
                    }
                }
                .padding(CGFloat(metrics.spacing))
            }
            .allowsHitTesting(selection.selectedID == nil)
            .accessibilityHidden(selection.selectedID != nil)

            if let item = selectedItem {
                Color.black
                    .opacity(metrics.backdropOpacity)
                    .ignoresSafeArea()
                    .onTapGesture(perform: dismiss)
                    .transition(.opacity)
                    .zIndex(1)

                ScrollView {
                    detailContent(item, context(for: item.id, isSource: true), dismiss)
                        .frame(maxWidth: CGFloat(metrics.maximumDetailWidth))
                        .matchedGeometryEffect(
                            id: MatchedElementKey(itemID: item.id, role: "surface"),
                            in: namespace,
                            isSource: true
                        )
                        .frame(maxWidth: .infinity)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 28)
                }
                .transition(.opacity)
                .zIndex(2)
                .accessibilityIdentifier("matched-geometry-detail")
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onChange(of: items.map(\.id)) { availableIDs in
            selection.reconcile(availableIDs: availableIDs)
        }
    }

    private var columns: [GridItem] {
        [
            GridItem(
                .adaptive(minimum: CGFloat(metrics.minimumCardWidth)),
                spacing: CGFloat(metrics.spacing)
            )
        ]
    }

    private var selectedItem: Item? {
        guard let selectedID = selection.selectedID else { return nil }
        return items.first { $0.id == selectedID }
    }

    private func context(
        for id: Item.ID,
        isSource: Bool
    ) -> MatchedGeometryContext<Item.ID> {
        MatchedGeometryContext(
            itemID: id,
            namespace: namespace,
            isSource: isSource
        )
    }

    private var transitionAnimation: Animation? {
        reduceMotion ? nil : .spring(response: 0.42, dampingFraction: 0.86)
    }

    private func expand(_ id: Item.ID) {
        withAnimation(transitionAnimation) {
            selection.open(id)
        }
    }

    private func dismiss() {
        withAnimation(transitionAnimation) {
            selection.close()
        }
    }
}
#endif
