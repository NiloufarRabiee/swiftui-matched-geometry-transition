/// Layout values used by the SwiftUI gallery.
///
/// Values are normalized at initialization to avoid invalid geometry,
/// negative spacing, and invisible or excessively opaque scrims.
public struct TransitionMetrics: Equatable {
    public let minimumCardWidth: Double
    public let spacing: Double
    public let maximumDetailWidth: Double
    public let backdropOpacity: Double

    public init(
        minimumCardWidth: Double = 190,
        spacing: Double = 16,
        maximumDetailWidth: Double = 640,
        backdropOpacity: Double = 0.42
    ) {
        self.minimumCardWidth = Self.normalized(
            minimumCardWidth, lower: 120, upper: 1000, fallback: 190
        )
        self.spacing = Self.normalized(
            spacing, lower: 0, upper: 80, fallback: 16
        )
        self.maximumDetailWidth = Self.normalized(
            maximumDetailWidth, lower: 280, upper: 1200, fallback: 640
        )
        self.backdropOpacity = Self.normalized(
            backdropOpacity, lower: 0, upper: 0.85, fallback: 0.42
        )
    }

    private static func normalized(
        _ value: Double,
        lower: Double,
        upper: Double,
        fallback: Double
    ) -> Double {
        guard value.isFinite else { return fallback }
        return min(max(value, lower), upper)
    }
}
