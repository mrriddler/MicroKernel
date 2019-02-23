//      __  ____                 __ __                     __
//     /  |/  (_)_____________  / //_/__  _________  ___  / /
//    / /|_/ / / ___/ ___/ __ \/ ,< / _ \/ ___/ __ \/ _ \/ /
//   / /  / / / /__/ /  / /_/ / /| /  __/ /  / / / /  __/ /
//  /_/  /_/_/\___/_/   \____/_/ |_\___/_/  /_/ /_/\___/_/
//

import Foundation

/// Summary: The generic protocol represent MicroApplicationContext in architecture.

/// Discussion: MicroApplicationContext provide launch options and dependency container
/// in MicroApplication scope. Every MicroApplication paired with a MicroApplicationContext.

/// Implmentating Notes: Do not instantiation yourself.
public protocol MicroApplicationContext {
    
    /// Launch options for paired MicroApplication, immutable.
    var launchOptions: [MicroApplicationLaunchOptionsKey: Any]? { get }
    
    /// Inject Dependency to MicroApplication from MainApplication
    ///
    /// - Parameter registerType: dependency prototype type
    func injectDependency<RegisterType>(registerType: RegisterType.Type)
    
    /// Inject Dependency to MicroApplication
    ///
    /// - Parameter registerType: dependency prototype type
    /// - Parameter resloveType: dependency entity type
    func injectDependency<RegisterType, ResloveType: Dependency>(registerType: RegisterType.Type,
                                                                 resloveType: ResloveType.Type)
    
    /// Find Dependency in MicroApplication scope
    ///
    /// - Parameter registerType: dependency prototype type
    /// - Returns: dependency entity
    func findDependency<RegisterType>(registerType: RegisterType.Type) -> Dependency?
}
