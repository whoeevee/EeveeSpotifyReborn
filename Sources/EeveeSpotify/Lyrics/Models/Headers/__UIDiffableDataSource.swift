import UIKit

@objc protocol __UIDiffableDataSource {
    func itemIdentifiers() -> NSArray
    func deleteItemsWithIdentifiers(_ identifiers: NSArray)
}
