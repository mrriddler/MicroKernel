//      __  ____                 __ __                     __
//     /  |/  (_)_____________  / //_/__  _________  ___  / /
//    / /|_/ / / ___/ ___/ __ \/ ,< / _ \/ ___/ __ \/ _ \/ /
//   / /  / / / /__/ /  / /_/ / /| /  __/ /  / / / /  __/ /
//  /_/  /_/_/\___/_/   \____/_/ |_\___/_/  /_/ /_/\___/_/
//

import UIKit

/// Summary: The MainApplication of the platform, conform UIApplicationDelegate,
/// serve as a AppDelegate.

open class PlatformMainApplication: UIResponder, UIApplicationDelegate, MainApplication {
    
    open func boot() {}
    
    open func applicationInjectDependency(_ mainContext: MainApplicationContext) -> MainApplicationContext {
        return mainContext
    }
}
