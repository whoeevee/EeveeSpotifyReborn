import Orion

extension NowPlayingScrollDataSourceImplementation {
    var activeProviders: Array<NSObject> {
        get {
            Ivars<Array<NSObject>>(self).activeProviders
        }
        set {
            Ivars<Array<NSObject>>(self).activeProviders = newValue
        }
    }
}
