import Orion
import UIKit

private func showHighQualityPopUp() {
    PopUpHelper.showPopUp(
        message: "high_audio_quality_popup".localized,
        buttonText: "OK".uiKitLocalized
    )
}

class ListRowInteractionListenerViewHook: ClassHook<UIView> {
    typealias Group = ModernPremiumPatchingGroup
    static let targetName = "_TtC15Settings_ECMKit30ListRowInteractionListenerView"

    func performAction() {
        guard
            let accessibilityLabel = target.subviews.first?.accessibilityLabel,
            accessibilityLabel.hasSuffix("Premium")
        else {
            orig.performAction()
            return
        }
        
        showHighQualityPopUp()
    }
}

class StreamQualitySettingsSectionHook: ClassHook<NSObject> {
    typealias Group = LegacyPremiumPatchingGroup
    static let targetName = "StreamQualitySettingsSection"

    func shouldResetSelection() -> Bool {
        showHighQualityPopUp()
        return true
    }
}

class ContentOffliningUIHelperImplementationHook: ClassHook<NSObject> {
    typealias Group = BasePremiumPatchingGroup
    static let targetName = "Offline_ContentOffliningUIImpl.ContentOffliningUIHelperImplementation"
    
    func downloadToggledWithCurrentAvailability(
        _ availability: NSInteger,
        addAction: NSObject,
        removeAction: NSObject,
        pageIdentifier: NSString,
        pageURI: NSURL
    ) {
        let isPlaylist = Dynamic.convert(pageURI, to: SPTURL.self)
            .isPlaylistURL()
            
        PopUpHelper.showPopUp(
            message: "playlist_downloading_popup".localized,
            buttonText: "OK".uiKitLocalized,
            secondButtonText: isPlaylist
                ? "download_local_playlist".localized
                : nil,
            onSecondaryClick: isPlaylist
                ? {
                    self.orig.downloadToggledWithCurrentAvailability(
                        availability,
                        addAction: addAction,
                        removeAction: removeAction,
                        pageIdentifier: pageIdentifier,
                        pageURI: pageURI
                    )
                }
                : nil
        )
    }
}
