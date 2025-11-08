import Orion

class SPTFreeTierArtistHubRemoteURLResolverHook: ClassHook<NSObject> {
    typealias Group = BasePremiumPatchingGroup
    static let targetName = "SPTFreeTierArtistHubRemoteURLResolver"
    
    func initWithViewURI(
        _ uri: NSURL,
        onDemandSet: Any,
        onDemandTrialService: Any,
        trackRowsEnabled: Bool,
        productState: NSObject
    ) -> Target {
        return orig.initWithViewURI(
            uri,
            onDemandSet: onDemandSet,
            onDemandTrialService: onDemandTrialService,
            trackRowsEnabled: true,
            productState: productState
        )
    }
}
