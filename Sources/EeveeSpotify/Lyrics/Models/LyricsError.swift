import Foundation

enum LyricsError: Error, CustomStringConvertible {
    case noCurrentTrack
    case trackMismatch
    case musixmatchRestricted
    case invalidMusixmatchToken
    case decodingError
    case noSuchSong
    case unknownError
    case invalidSource
    
    // swift 5.8 compatible
    var description: String {
        switch self {
        case .noSuchSong:
            return "no_such_song".localized
        case .musixmatchRestricted:
            return "musixmatch_restricted".localized
        case .invalidMusixmatchToken:
            return "invalid_musixmatch_token".localized
        case .decodingError:
            return "decoding_error".localized
        case .unknownError:
            return "unknown_error".localized
        default:
            return ""
        }
    }
}
