extension SPTPlayerTrack {
    var trackIdentifier: String {
        self.URI().spt_trackIdentifier()
    }
}
