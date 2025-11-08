import Orion

extension NowPlayingScrollViewController {
    private var nowPlayingScrollViewModel: NSObject {
        get {
            Ivars<NSObject>(self).scrollViewModel
        }
    }
    
    var scrollEnabled: Bool {
        get {
            Ivars<Bool>(nowPlayingScrollViewModel).scrollEnabled
        }
        set {
            Ivars<Bool>(nowPlayingScrollViewModel).scrollEnabled = newValue
        }
    }
    
    var loadedTrack: SPTPlayerTrack {
        get {
            Ivars<SPTPlayerTrack>(nowPlayingScrollViewModel).loadedTrack
        }
    }
    
    var dataSource: NowPlayingScrollDataSourceImplementation {
        get {
            Ivars<NowPlayingScrollDataSourceImplementation>(nowPlayingScrollViewModel).dataSource
        }
    }
}
