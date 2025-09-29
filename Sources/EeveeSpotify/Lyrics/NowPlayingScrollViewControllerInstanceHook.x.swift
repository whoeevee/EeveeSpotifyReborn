import Orion
import UIKit

var nowPlayingScrollViewController: NowPlayingScrollViewController?

class NowPlayingScrollViewControllerInstanceHook: ClassHook<UIViewController> {
    typealias Group = LyricsGroup
    static let targetName = "NowPlaying_ScrollImpl.NowPlayingScrollViewController"
    
    func nowPlayingScrollViewModelWithDidMoveToRelativeTrack(
        _ track: SPTPlayerTrack,
        withDifferentProviders: Bool,
        scrollEnabledValueChanged: Bool
    ) -> NowPlayingScrollViewController {
        nowPlayingScrollViewController = orig.nowPlayingScrollViewModelWithDidMoveToRelativeTrack(
            track,
            withDifferentProviders: withDifferentProviders,
            scrollEnabledValueChanged: scrollEnabledValueChanged
        )
        
        return nowPlayingScrollViewController!
    }
}

class NowPlayingScrollPrivateServiceImplementationHook: ClassHook<NSObject> {
    typealias Group = LyricsGroup
    static let targetName = "NowPlaying_ScrollImpl.NowPlayingScrollPrivateServiceImplementation"
    
    func provideScrollViewControllerWithDependencies(_ dependencies: NSObject) -> UIViewController {
        // spotify introduced some "nova scroll" with different controllers and logic
        // hope they don't remove backward compatibility, i don't want to rewrite ts 😭🙏
        
        if EeveeSpotify.hookTarget != .lastAvailableiOS14 {
            Ivars<Bool>(target).$__lazy_storage_$_isNovaScrollEnabled = false
        }
        
        return orig.provideScrollViewControllerWithDependencies(dependencies)
    }
}
