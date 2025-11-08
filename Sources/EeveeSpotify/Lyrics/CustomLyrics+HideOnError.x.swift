import Orion
import UIKit

class ErrorViewControllerHook: ClassHook<UIViewController> {
    typealias Group = BaseLyricsGroup
    
    static var targetName: String {
        switch EeveeSpotify.hookTarget {
        case .lastAvailableiOS14: return "Lyrics_CoreImpl.ErrorViewController"
        default: return "Lyrics_NPVCommunicatorImpl.ErrorViewController"
        }
    }
    
    func loadView() {
        orig.loadView()
        
        guard UserDefaults.lyricsOptions.hideOnError else {
            return
        }
        
        if let controller = nowPlayingScrollViewController {
            controller.dataSource.activeProviders.removeAll {
                NSStringFromClass(type(of: $0)) == HookTargetNameHelper.lyricsScrollProvider
            }
            
            controller.collectionView().reloadData()
        }
        else if let controller = npvScrollViewController, let dataSource = scrollDataSource {
            let lyricsProviderIndex = dataSource.activeProviders.firstIndex {
                NSStringFromClass(type(of: $0)) == HookTargetNameHelper.lyricsScrollProvider
            }
            
            let collectionView = controller.collectionView()
            let dataSource = Ivars<__UIDiffableDataSource>(collectionView.dataSource!)._impl
            
            let itemIdentifiers = dataSource.itemIdentifiers()
            let lyricsProviderItemIdentifier = itemIdentifiers[lyricsProviderIndex!]
            
            dataSource.deleteItemsWithIdentifiers([lyricsProviderItemIdentifier])
        }
    }
}
