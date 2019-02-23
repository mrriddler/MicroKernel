//      __  ____                 __ __                     __
//     /  |/  (_)_____________  / //_/__  _________  ___  / /
//    / /|_/ / / ___/ ___/ __ \/ ,< / _ \/ ___/ __ \/ _ \/ /
//   / /  / / / /__/ /  / /_/ / /| /  __/ /  / / / /  __/ /
//  /_/  /_/_/\___/_/   \____/_/ |_\___/_/  /_/ /_/\___/_/
//

import Foundation

/// Summary: The generic protocol represent Dependency concept.

public protocol Dependency: Initable {
    
    /// Check Dependency is a singleton.
    ///
    /// - Returns: singleton flag
    static func isSingleton() -> Bool
    
    /// Dependency Singleton instance
    ///
    /// - Returns: singleton instance
    static func singleton() -> Self
}
