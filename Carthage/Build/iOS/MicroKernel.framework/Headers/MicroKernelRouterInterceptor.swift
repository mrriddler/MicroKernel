//      __  ____                 __ __                     __
//     /  |/  (_)_____________  / //_/__  _________  ___  / /
//    / /|_/ / / ___/ ___/ __ \/ ,< / _ \/ ___/ __ \/ _ \/ /
//   / /  / / / /__/ /  / /_/ / /| /  __/ /  / / / /  __/ /
//  /_/  /_/_/\___/_/   \____/_/ |_\___/_/  /_/ /_/\___/_/
//

import Foundation

/// Summary: The Router would take input param construct MicroKernelRouterParam and
/// navigating switchover MicroApplication base on that. The Interceptor is open for
/// custom process.

public protocol MicroKernelRouterInterceptor {
    
    /// Custom process previous level input param.
    ///
    /// - Parameter param: previous level param
    /// - Returns: next level param
    func intercept(param: MicroKernelRouterParam) -> MicroKernelRouterParam
    
    /// Custom verify input param legality.
    ///
    /// - Parameter param:
    /// - Returns: result flag
    func canOpenURL(param: MicroKernelRouterParam) -> Bool
}
