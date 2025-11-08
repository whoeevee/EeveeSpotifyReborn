import UIKit
import Orion

class UITableViewHook: ClassHook<UITableView> {
    typealias Group = BaseLyricsGroup
    
    func scrollToRowAtIndexPath(
        _ indexPath: NSIndexPath,
        atScrollPosition scrollPosition: UITableView.ScrollPosition,
        animated: Bool
    ) {
        if target.numberOfRows(inSection: indexPath.section) == 0 {
            return
        }
        
        orig.scrollToRowAtIndexPath(
            indexPath,
            atScrollPosition: scrollPosition,
            animated: animated
        )
    }
}
