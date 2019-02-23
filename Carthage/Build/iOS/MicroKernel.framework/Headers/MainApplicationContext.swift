//      __  ____                 __ __                     __
//     /  |/  (_)_____________  / //_/__  _________  ___  / /
//    / /|_/ / / ___/ ___/ __ \/ ,< / _ \/ ___/ __ \/ _ \/ /
//   / /  / / / /__/ /  / /_/ / /| /  __/ /  / / / /  __/ /
//  /_/  /_/_/\___/_/   \____/_/ |_\___/_/  /_/ /_/\___/_/
//

import Foundation

/// Summary: The generic protocol represent MainApplicationContext in architecture.

/// Discussion: MainApplicationContext provide dependency container in global scope.
/// An app has exactly one instance of MainApplicationContext.

/// Implmentating Notes: Do not instantiation yourself.
public protocol MainApplicationContext {
    
    /// Inject Dependency to MainApplication
    ///
    /// - Parameter registerType: dependency prototype type
    /// - Parameter resloveType: dependency entity type
    func injectDependency<RegisterType, ResloveType: Dependency>(registerType: RegisterType.Type,
                                                                 resloveType: ResloveType.Type)
    
    /// Find Dependency in global scope
    ///
    /// - Parameter registerType: dependency prototype type
    /// - Returns: dependency entity
    func findDependency<RegisterType>(registerType: RegisterType.Type) -> Dependency?
}
