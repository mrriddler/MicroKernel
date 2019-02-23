//      __  ____                 __ __                     __
//     /  |/  (_)_____________  / //_/__  _________  ___  / /
//    / /|_/ / / ___/ ___/ __ \/ ,< / _ \/ ___/ __ \/ _ \/ /
//   / /  / / / /__/ /  / /_/ / /| /  __/ /  / / / /  __/ /
//  /_/  /_/_/\___/_/   \____/_/ |_\___/_/  /_/ /_/\___/_/
//

import Foundation

/// Summary: The centralized point of navigating switchover MicroApplication through URL.

/// Discussion: The Router parse URL, take scheme as appId to launch MicroApplication.
/// During this process, mutiple Level Interceptor would be adopted to interfere.

internal class MicroKernelRouter {
    
    internal static let shared = MicroKernelRouter()
    
    internal var interceptors: [MicroKernelRouterInterceptor] = []
    
    /// Launch a MicroApplication by URL, verify first, API looks a lot like system
    /// UIApplication for a better unity.
    ///
    /// - Parameters:
    ///   - url: url's sheme as appId
    ///   - options: launch options
    ///   - completionHandler: launch completion call back
    internal func open(url: URL,
                       options: [MicroApplicationLaunchOptionsKey: Any]?,
                       completionHandler: ((Bool) -> Void)?) {
        let param: MicroKernelRouterParam = constructParam(url: url, options: options)
        
        guard canOpenURL(param: param) else {
            if let completionHandler = completionHandler {
                completionHandler(false)
            }
            return
        }
        
        guard let appId: String = param.scheme else {
            if let completionHandler = completionHandler {
                completionHandler(false)
            }
            return
        }
        
        MicroKernel.launchApplication(appId: appId, launchOptions: param.options)
        
        if let completionHandler = completionHandler {
            completionHandler(true)
        }
    }
    
    /// Verify that the URL is possible to Launch MicroApplication. API looks a lot
    /// like system UIApplication for a better unity.
    ///
    /// - Parameters:
    ///   - url: url's sheme as appId
    ///   - options: launch options
    /// - Returns: result flag
    internal func canOpenURL(url: URL,
                             options: [MicroApplicationLaunchOptionsKey: Any]?) -> Bool {
        return canOpenURL(param: constructParam(url: url, options: options))
    }
    
    /// Register Router Interceptor
    ///
    /// - Parameter interceptor: MicroKernelRouterInterceptor
    internal func registerInterceptor(interceptor: MicroKernelRouterInterceptor) {
        interceptors.append(interceptor)
    }
    
    fileprivate func canOpenURL(param: MicroKernelRouterParam) -> Bool {
        var res: Bool = true
        
        res = !interceptors.contains(where: { !$0.canOpenURL(param: param) })
        
        return res
    }
    
    fileprivate func constructParam(url: URL,
                                    options: [MicroApplicationLaunchOptionsKey: Any]?) -> MicroKernelRouterParam {
        var param: MicroKernelRouterParam = MicroKernelRouterParam(url: url, options: options)
        interceptors.forEach({ param = $0.intercept(param: param) })
        return param
    }
}
