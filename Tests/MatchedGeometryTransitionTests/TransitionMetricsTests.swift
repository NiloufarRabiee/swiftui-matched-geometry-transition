import XCTest
@testable import MatchedGeometryTransition

final class TransitionMetricsTests: XCTestCase {
    func testDefaults() {
        let metrics = TransitionMetrics()
        XCTAssertEqual(metrics.minimumCardWidth, 190)
        XCTAssertEqual(metrics.spacing, 16)
        XCTAssertEqual(metrics.maximumDetailWidth, 640)
        XCTAssertEqual(metrics.backdropOpacity, 0.42)
    }

    func testCustomValues() {
        let metrics = TransitionMetrics(
            minimumCardWidth: 210,
            spacing: 12,
            maximumDetailWidth: 720,
            backdropOpacity: 0.6
        )
        XCTAssertEqual(metrics.minimumCardWidth, 210)
        XCTAssertEqual(metrics.spacing, 12)
        XCTAssertEqual(metrics.maximumDetailWidth, 720)
        XCTAssertEqual(metrics.backdropOpacity, 0.6)
    }

    func testNegativeInputsClampToMinimum() {
        let metrics = TransitionMetrics(
            minimumCardWidth: -10,
            spacing: -30,
            maximumDetailWidth: -1,
            backdropOpacity: -0.5
        )
        XCTAssertEqual(metrics.minimumCardWidth, 120)
        XCTAssertEqual(metrics.spacing, 0)
        XCTAssertEqual(metrics.maximumDetailWidth, 280)
        XCTAssertEqual(metrics.backdropOpacity, 0)
    }

    func testExcessiveInputsClampToMaximum() {
        let metrics = TransitionMetrics(
            minimumCardWidth: 10000,
            spacing: 10000,
            maximumDetailWidth: 10000,
            backdropOpacity: 10
        )
        XCTAssertEqual(metrics.minimumCardWidth, 1000)
        XCTAssertEqual(metrics.spacing, 80)
        XCTAssertEqual(metrics.maximumDetailWidth, 1200)
        XCTAssertEqual(metrics.backdropOpacity, 0.85)
    }

    func testNonFiniteValuesUseDefaults() {
        let metrics = TransitionMetrics(
            minimumCardWidth: .infinity,
            spacing: .nan,
            maximumDetailWidth: -.infinity,
            backdropOpacity: .nan
        )
        XCTAssertEqual(metrics, TransitionMetrics())
    }

    func testZeroSpacingIsAllowed() {
        XCTAssertEqual(TransitionMetrics(spacing: 0).spacing, 0)
    }

    func testTransparentBackdropIsAllowed() {
        XCTAssertEqual(TransitionMetrics(backdropOpacity: 0).backdropOpacity, 0)
    }

    func testMetricsEquatability() {
        XCTAssertEqual(TransitionMetrics(), TransitionMetrics())
        XCTAssertNotEqual(TransitionMetrics(), TransitionMetrics(spacing: 22))
    }
}
