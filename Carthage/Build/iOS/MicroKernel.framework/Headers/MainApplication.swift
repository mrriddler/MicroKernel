//      __  ____                 __ __                     __
//     /  |/  (_)_____________  / //_/__  _________  ___  / /
//    / /|_/ / / ___/ ___/ __ \/ ,< / _ \/ ___/ __ \/ _ \/ /
//   / /  / / / /__/ /  / /_/ / /| /  __/ /  / / / /  __/ /
//  /_/  /_/_/\___/_/   \____/_/ |_\___/_/  /_/ /_/\___/_/
//

import Foundation

/// Summary: The generic protocol represent MainApplication in architecture.

/// Discussion: An app has exactly one instance of MainApplication. for
/// MainApplication sole purpose is register and config and interfacing external channels.

/// Implmentating Notes: Do not instantiation yourself. Register implementation to
/// MicroKernl.
public protocol MainApplication {
    
    /// Boot MainApplication, do not call yourself, override do stuff.
    func boot()
    
    /// Inject Dependency to MainApplication.
    ///
    /// - Parameter mainContext: main dependency container before injected
    /// - Returns: main dependency container after injected
    func applicationInjectDependency(_ mainContext: MainApplicationContext) -> MainApplicationContext
}
