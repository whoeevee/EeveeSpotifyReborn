import Orion
import UIKit

private var shouldOverrideLocalTrackURI = false

class SPTPlayerTrackHook: ClassHook<NSObject> {
    typealias Group = BaseLyricsGroup
    static let targetName = EeveeSpotify.hookTarget == .latest
        ? "SPTPlayerTrackImplementation"
        : "SPTPlayerTrack"

    func metadata() -> [String: String] {
        var meta = orig.metadata()
        meta["has_lyrics"] = "true"
        return meta
    }
    
    func URI() -> NSURL? {
        let uri = orig.URI()
        
        guard shouldOverrideLocalTrackURI,
              let absoluteString = uri?.absoluteString,
              absoluteString.hasPrefix("spotify:local:") else {
            return uri
        }
        
        return NSURL(string: "spotify:track:")!
    }
}

class LyricsScrollProviderHook: ClassHook<NSObject> {
    typealias Group = BaseLyricsGroup
    static var targetName = HookTargetNameHelper.lyricsScrollProvider
    
    func isEnabledForTrack(_ track: SPTPlayerTrack) -> Bool {
        return true
    }
}

class NPVScrollViewControllerHook: ClassHook<NSObject> {
    typealias Group = ModernLyricsGroup
    static var targetName = "NowPlaying_ScrollImpl.NPVScrollViewController"

    func viewWillAppear(_ animated: Bool) {
        shouldOverrideLocalTrackURI = true
        orig.viewWillAppear(animated)
    }
    
    func viewWillDisappear(_ animated: Bool) {
        shouldOverrideLocalTrackURI = false
        orig.viewWillDisappear(animated)
    }
}

class NowPlayingScrollViewControllerHook: ClassHook<NSObject> {
    typealias Group = LegacyLyricsGroup
    static var targetName = "NowPlaying_ScrollImpl.NowPlayingScrollViewController"
    
    func nowPlayingScrollViewModelWithDidLoadComponentsFor(
        _ track: SPTPlayerTrack,
        withDifferentProviders: Bool,
        scrollEnabledValueChanged: Bool
    ) -> NowPlayingScrollViewController {
        let controller = orig.nowPlayingScrollViewModelWithDidLoadComponentsFor(
            track,
            withDifferentProviders: withDifferentProviders,
            scrollEnabledValueChanged: scrollEnabledValueChanged
        )
        
        if !scrollEnabledValueChanged {
            controller.scrollEnabled = true
            controller.nowPlayingScrollViewModelDidChangeScrollEnabledValue()
        }
        
        return controller
    }
}
