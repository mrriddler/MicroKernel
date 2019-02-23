//      __  ____                 __ __                     __
//     /  |/  (_)_____________  / //_/__  _________  ___  / /
//    / /|_/ / / ___/ ___/ __ \/ ,< / _ \/ ___/ __ \/ _ \/ /
//   / /  / / / /__/ /  / /_/ / /| /  __/ /  / / / /  __/ /
//  /_/  /_/_/\___/_/   \____/_/ |_\___/_/  /_/ /_/\___/_/
//

import Foundation

/// Summary: The Router input param union data structure.

public struct MicroKernelRouterParam {
    
    public let url: URL
    
    public let scheme: String?
    
    public var options: [MicroApplicationLaunchOptionsKey: Any]?
    
    public init(url: URL, options: [MicroApplicationLaunchOptionsKey: Any]?) {
        self.url = url
        self.scheme = url.scheme
        self.options = options
    }
}
