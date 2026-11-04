/// A small, testable selection state machine for an expanding card gallery.
///
/// The selected identifier is independent of array position so that filtering,
/// sorting, and inserting cards do not accidentally open a different item.
public struct CardSelectionState<ID: Hashable>: Equatable {
    public private(set) var selectedID: ID?

    public init(selectedID: ID? = nil) {
        self.selectedID = selectedID
    }

    /// Opens a card. Returns false when it is already selected.
    @discardableResult
    public mutating func open(_ id: ID) -> Bool {
        guard selectedID != id else { return false }
        selectedID = id
        return true
    }

    /// Closes the expanded card. Returns false when already closed.
    @discardableResult
    public mutating func close() -> Bool {
        guard selectedID != nil else { return false }
        selectedID = nil
        return true
    }

    /// Closes the detail if its item has disappeared from the collection.
    @discardableResult
    public mutating func reconcile(availableIDs: [ID]) -> Bool {
        guard let selectedID, !availableIDs.contains(selectedID) else {
            return false
        }
        self.selectedID = nil
        return true
    }
}
