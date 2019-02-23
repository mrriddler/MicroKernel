//      __  ____                 __ __                     __
//     /  |/  (_)_____________  / //_/__  _________  ___  / /
//    / /|_/ / / ___/ ___/ __ \/ ,< / _ \/ ___/ __ \/ _ \/ /
//   / /  / / / /__/ /  / /_/ / /| /  __/ /  / / / /  __/ /
//  /_/  /_/_/\___/_/   \____/_/ |_\___/_/  /_/ /_/\___/_/
//

import UIKit

internal class NavigationApplicationIndex: BunchKeyIndex {
    
    internal var entry: [NavigationApplicationIndex.IndexEntry] = []
    
    internal func launchApplication(_ application: MicroApplication) {
        appendValue(type(of: application).appId())
    }
    
    internal func terminateApplication(_ application: MicroApplication) {
        _ = removeValue(type(of: application).appId())
    }
    
    internal func pushViewController(_ viewController: UIViewController) {
        appendKey(ObjectIdentifier(viewController))
    }
    
    internal func popViewController(_ viewController: UIViewController) -> [String]? {
        return removeKey(ObjectIdentifier(viewController))
    }
    
    internal func popViewControllers(_ viewControllers: [UIViewController]) -> [String]? {
        return removeBunchKey(viewControllers.map({ ObjectIdentifier($0) }))
    }
    
    internal func presentViewController(_ viewController: UIViewController) {
        appendKey(ObjectIdentifier(viewController))
    }
    
    internal func dismissViewController(_ viewController: UIViewController) -> [String]? {
        return removeKeyPartition(ObjectIdentifier(viewController))
    }
    
    internal func dismissViewControllers(_ viewControllers: [UIViewController]) -> [String]? {
        return removeBunchKeyPartition(viewControllers.map({ ObjectIdentifier($0) }))
    }
}
