//      __  ____                 __ __                     __
//     /  |/  (_)_____________  / //_/__  _________  ___  / /
//    / /|_/ / / ___/ ___/ __ \/ ,< / _ \/ ___/ __ \/ _ \/ /
//   / /  / / / /__/ /  / /_/ / /| /  __/ /  / / / /  __/ /
//  /_/  /_/_/\___/_/   \____/_/ |_\___/_/  /_/ /_/\___/_/
//

import Foundation

internal struct ApplicationRouterInterceptor: MicroKernelRouterInterceptor {
    
    internal func intercept(param: MicroKernelRouterParam) -> MicroKernelRouterParam {
        return param
    }
    
    internal func canOpenURL(param: MicroKernelRouterParam) -> Bool {
        guard let appId: String = param.scheme else {
            return false
        }
        
        return MicroKernel.canLaunchMicroApplication(appId)
    }
}
