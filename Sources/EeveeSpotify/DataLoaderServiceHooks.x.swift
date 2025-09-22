import Foundation
import Orion

class SPTDataLoaderServiceHook: ClassHook<NSObject>, SpotifySessionDelegate {
    static let targetName = "SPTDataLoaderService"
    
    // orion:new
    func shouldModify(_ url: URL) -> Bool {
        let shouldPatchPremium = PremiumPatchingGroup.isActive
        let shouldReplaceLyrics = LyricsGroup.isActive
        
        return (shouldReplaceLyrics && url.isLyrics)
            || (shouldPatchPremium && (url.isCustomize || url.isPremiumPlanRow || url.isPremiumBadge || url.isPlanOverview))
    }
    
    // orion:new
    func respondWithCustomData(_ data: Data, task: URLSessionDataTask, session: URLSession) {
        orig.URLSession(session, dataTask: task, didReceiveData: data)
        orig.URLSession(session, task: task, didCompleteWithError: nil)
    }
    
    func URLSession(
        _ session: URLSession,
        task: URLSessionDataTask,
        didCompleteWithError error: Error?
    ) {
        guard let url = task.currentRequest?.url else {
            return
        }
        
        guard error == nil, shouldModify(url) else {
            orig.URLSession(session, task: task, didCompleteWithError: error)
            return
        }
        
        do {
            if let buffer = URLSessionHelper.shared.obtainData(for: url) {
                if url.isLyrics {
                    respondWithCustomData(
                        try getLyricsDataForCurrentTrack(
                            originalLyrics: try? Lyrics(serializedBytes: buffer)
                        ),
                        task: task,
                        session: session
                    )
                    
                    return
                }
                
                if url.isPremiumPlanRow {
                    respondWithCustomData(
                        try getPremiumPlanRowData(
                            originalPremiumPlanRow: try PremiumPlanRow(serializedBytes: buffer)
                        ),
                        task: task,
                        session: session
                    )
                    
                    return
                }
                
                if url.isPremiumBadge {
                    respondWithCustomData(try getPremiumPlanBadge(), task: task, session: session)
                    return
                }
                
                var customizeMessage = try CustomizeMessage(serializedBytes: buffer)
                modifyRemoteConfiguration(&customizeMessage.response)
                
                respondWithCustomData(try customizeMessage.serializedData(), task: task, session: session)
                return
            }
            
            if url.isPlanOverview {
                do {
                    orig.URLSession(session, dataTask: task, didReceiveData: try getPlanOverviewData())
                    orig.URLSession(session, task: task, didCompleteWithError: nil)
                }
                catch {
                    orig.URLSession(session, task: task, didCompleteWithError: error)
                }

                return
            }
        }
        catch {
            orig.URLSession(session, task: task, didCompleteWithError: error)
        }
        
        orig.URLSession(session, task: task, didCompleteWithError: error)
    }

    func URLSession(
        _ session: URLSession,
        dataTask task: URLSessionDataTask,
        didReceiveResponse response: HTTPURLResponse,
        completionHandler handler: @escaping (URLSession.ResponseDisposition) -> Void
    ) {
        guard
            let url = task.currentRequest?.url,
            url.isLyrics,
            response.statusCode != 200
        else {
            orig.URLSession(session, dataTask: task, didReceiveResponse: response, completionHandler: handler)
            return
        }

        do {
            let data = try getLyricsDataForCurrentTrack()
            let okResponse = HTTPURLResponse(url: url, statusCode: 200, httpVersion: "2.0", headerFields: [:])!
            
            orig.URLSession(session, dataTask: task, didReceiveResponse: okResponse, completionHandler: handler)
            respondWithCustomData(data, task: task, session: session)
        } catch {
            orig.URLSession(session, task: task, didCompleteWithError: error)
        }
    }

    func URLSession(
        _ session: URLSession,
        dataTask task: URLSessionDataTask,
        didReceiveData data: Data
    ) {
        guard let url = task.currentRequest?.url else {
            return
        }

        if shouldModify(url) {
            URLSessionHelper.shared.setOrAppend(data, for: url)
            return
        }

        orig.URLSession(session, dataTask: task, didReceiveData: data)
    }
}
