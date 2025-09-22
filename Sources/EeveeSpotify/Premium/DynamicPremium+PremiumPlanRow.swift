import Foundation

func getPremiumPlanBadge() throws -> Data {
    let badge = YourPremiumBadge.with {
        $0.name = "Eevee"
        $0.version = 2
        $0.colorCode = "#FFD2D7"
    }
    
    return try badge.serializedData()
}

func getPremiumPlanRowData(originalPremiumPlanRow: PremiumPlanRow) throws -> Data {
    var premiumPlanRow = originalPremiumPlanRow
    
    premiumPlanRow.planName = "EeveeSpotify"
    premiumPlanRow.planIdentifier = "Eevee"
    premiumPlanRow.colorCode = "#FFD2D7"
    
    return try premiumPlanRow.serializedData()
}

func getPlanOverviewData() throws -> Data {
    let plan = SpotifyPlan.with {
        $0.notice = SpotifyPlan.Notice.with {
            $0.message = "payment_notice".localized
            $0.status = 2 // 0 - trial, 1 - prepaid, 2 - subsсription
        }
        $0.subscription = SpotifyPlan.SubscriptionInfo.with {
            $0.planVariant = 2
            $0.planName = "EeveeSpotify"
            $0.planCategory = "Eevee"
            $0.colorCode = "#FFD2D7"
            $0.features = [
                SpotifyPlan.Feature.with {
                    $0.color = "#1ED760"
                    $0.description_p = "ad_free_music_listening".localized
                    $0.icon = SpotifyPlan.IconType.check
                },
                SpotifyPlan.Feature.with {
                    $0.color = "#1ED760"
                    $0.description_p = "play_songs_in_any_order".localized
                    $0.icon = SpotifyPlan.IconType.check
                },
                SpotifyPlan.Feature.with {
                    $0.color = "#1ED760"
                    $0.description_p = "organize_listening_queue".localized
                    $0.icon = SpotifyPlan.IconType.check
                }
            ]
        }
    }
    
    return try plan.serializedData()
}
