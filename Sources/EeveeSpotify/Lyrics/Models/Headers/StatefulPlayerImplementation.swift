import Foundation

@objc protocol StatefulPlayerImplementation {
    func currentTrack() -> SPTPlayerTrack?
}
