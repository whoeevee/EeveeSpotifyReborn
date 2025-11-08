import Orion
import EeveeSpotifyC
import UIKit

func exitApplication() {
    UIControl().sendAction(#selector(URLSessionTask.suspend), to: UIApplication.shared, for: nil)
    Timer.scheduledTimer(withTimeInterval: 0.2, repeats: false) { _ in
        exit(EXIT_SUCCESS)
    }
}

struct BasePremiumPatchingGroup: HookGroup { }

struct LegacyPremiumPatchingGroup: HookGroup { }
struct ModernPremiumPatchingGroup: HookGroup { }

func activatePremiumPatchingGroup() {
    BasePremiumPatchingGroup().activate()
    
    if EeveeSpotify.hookTarget == .lastAvailableiOS14 {
        LegacyPremiumPatchingGroup().activate()
    }
    else {
        ModernPremiumPatchingGroup().activate()
    }
}

struct EeveeSpotify: Tweak {
    static let version = "6.2"
    
    static var hookTarget: VersionHookTarget {
        let version = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String
        
        switch version {
        case "9.0.48":
            return .lastAvailableiOS15
        case "8.9.8":
            return .lastAvailableiOS14
        default:
            return .latest
        }
    }
    
    init() {
        if UserDefaults.experimentsOptions.showInstagramDestination {
            InstgramDestinationGroup().activate()
        }
        
        if UserDefaults.darkPopUps {
            DarkPopUps().activate()
        }
        
        if UserDefaults.patchType.isPatching {
            activatePremiumPatchingGroup()
        }
        
        if UserDefaults.lyricsSource.isReplacingLyrics {
            BaseLyricsGroup().activate()
            
            if EeveeSpotify.hookTarget == .latest {
                ModernLyricsGroup().activate()
            }
            else {
                LegacyLyricsGroup().activate()
            }
        }
    }
}
