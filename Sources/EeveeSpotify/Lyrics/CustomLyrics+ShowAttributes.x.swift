import Orion
import UIKit

class LyricsOnlyViewControllerHook: ClassHook<UIViewController> {
    typealias Group = BaseLyricsGroup
    
    static var targetName: String {
        switch EeveeSpotify.hookTarget {
        case .lastAvailableiOS14: return "Lyrics_CoreImpl.LyricsOnlyViewController"
        default: return "Lyrics_NPVCommunicatorImpl.LyricsOnlyViewController"
        }
    }

    func viewDidLoad() {
        orig.viewDidLoad()
        
        guard
            let lyricsHeaderViewController = target.parent?.children.first
        else {
            return
        }
        
        guard let lyricsLabel = WindowHelper.shared.findFirstSubview(
            "SPTEncoreLabel",
            in: lyricsHeaderViewController.view
        ) else {
            return
        }
    
        let encoreLabel = Dynamic.convert(lyricsLabel, to: SPTEncoreLabel.self)
        
        var text = [
            encoreLabel.text().firstObject
        ]
        
        let attributes = Dynamic.SPTEncoreAttributes
            .alloc(interface: SPTEncoreAttributes.self)
            .`init`({ attributes in
                attributes.setForegroundColor(.white.withAlphaComponent(0.5))
            })
        
        let typeStyle = type(
            of: Dynamic[
                dynamicMember: EeveeSpotify.hookTarget == .lastAvailableiOS14
                    ? "SPTEncoreTypeStyle"
                    : "SPTEncoreTextStyle"
            ].alloc(interface: SPTEncoreTypeStyle.self)
        ).bodyMediumBold()
        
        //
        
        if UserDefaults.lyricsOptions.showFallbackReasons,
            let description = lyricsState.fallbackError?.description
        {
            let attributedString = Dynamic.SPTEncoreAttributedString.alloc(
                interface: SPTEncoreAttributedString.self
            )
            
            text.append(
                EeveeSpotify.hookTarget == .lastAvailableiOS14
                    ? attributedString.initWithString(
                        "\n\("fallback_attribute".localized): \(description)",
                        typeStyle: typeStyle,
                        attributes: attributes
                    )
                    : attributedString.initWithString(
                        "\n\("fallback_attribute".localized): \(description)",
                        textStyle: typeStyle,
                        attributes: attributes
                    )
            )
        }
        
        if lyricsState.wasRomanized {
            let attributedString = Dynamic.SPTEncoreAttributedString.alloc(
                interface: SPTEncoreAttributedString.self
            )
            
            text.append(
                EeveeSpotify.hookTarget == .lastAvailableiOS14
                    ? attributedString.initWithString(
                        "\n\("romanized_attribute".localized)",
                        typeStyle: typeStyle,
                        attributes: attributes
                    )
                    : attributedString.initWithString(
                        "\n\("romanized_attribute".localized)",
                        textStyle: typeStyle,
                        attributes: attributes
                    )
            )
        }
        
        if EeveeSpotify.hookTarget == .lastAvailableiOS14 {
            encoreLabel.setNumberOfLines(text.count)
        }

        encoreLabel.setText(text as NSArray)
    }
}
