import XCTest
@testable import MatchedGeometryTransition

final class CardSelectionStateTests: XCTestCase {
    func testInitialSelectionIsEmpty() {
        XCTAssertNil(CardSelectionState<Int>().selectedID)
    }

    func testExplicitInitialSelection() {
        XCTAssertEqual(CardSelectionState(selectedID: "a").selectedID, "a")
    }

    func testOpenSelectsIdentifier() {
        var selection = CardSelectionState<Int>()
        XCTAssertTrue(selection.open(3))
        XCTAssertEqual(selection.selectedID, 3)
    }

    func testOpenIsIdempotentForSameIdentifier() {
        var selection = CardSelectionState<Int>()
        selection.open(3)
        XCTAssertFalse(selection.open(3))
        XCTAssertEqual(selection.selectedID, 3)
    }

    func testOpeningAnotherCardReplacesSelection() {
        var selection = CardSelectionState<Int>()
        selection.open(3)
        XCTAssertTrue(selection.open(5))
        XCTAssertEqual(selection.selectedID, 5)
    }

    func testCloseClearsSelection() {
        var selection = CardSelectionState(selectedID: "one")
        XCTAssertTrue(selection.close())
        XCTAssertNil(selection.selectedID)
    }

    func testClosingAnEmptySelectionIsNoOp() {
        var selection = CardSelectionState<Int>()
        XCTAssertFalse(selection.close())
    }

    func testReconcilePreservesSelectedItem() {
        var selection = CardSelectionState(selectedID: "b")
        XCTAssertFalse(selection.reconcile(availableIDs: ["a", "b", "c"]))
        XCTAssertEqual(selection.selectedID, "b")
    }

    func testReconcileClosesWhenItemDisappears() {
        var selection = CardSelectionState(selectedID: "b")
        XCTAssertTrue(selection.reconcile(availableIDs: ["a", "c"]))
        XCTAssertNil(selection.selectedID)
    }

    func testReconcileClosesWhenListBecomesEmpty() {
        var selection = CardSelectionState(selectedID: 8)
        XCTAssertTrue(selection.reconcile(availableIDs: []))
        XCTAssertNil(selection.selectedID)
    }

    func testReorderingDoesNotChangeSelectedIdentity() {
        var selection = CardSelectionState(selectedID: 8)
        XCTAssertFalse(selection.reconcile(availableIDs: [9, 8, 7]))
        XCTAssertEqual(selection.selectedID, 8)
    }

    func testDuplicateIDsInReconcileDoNotCauseDismissal() {
        var selection = CardSelectionState(selectedID: 8)
        XCTAssertFalse(selection.reconcile(availableIDs: [8, 8]))
    }

    func testReconcileWhenAlreadyClosedIsNoOp() {
        var selection = CardSelectionState<String>()
        XCTAssertFalse(selection.reconcile(availableIDs: []))
    }

    func testCanReopenAfterRemovedItem() {
        var selection = CardSelectionState(selectedID: "old")
        selection.reconcile(availableIDs: ["new"])
        XCTAssertTrue(selection.open("new"))
        XCTAssertEqual(selection.selectedID, "new")
    }

    func testSelectionEquality() {
        var first = CardSelectionState<Int>()
        var second = CardSelectionState<Int>()
        XCTAssertEqual(first, second)
        first.open(1)
        XCTAssertNotEqual(first, second)
        second.open(1)
        XCTAssertEqual(first, second)
    }
}
