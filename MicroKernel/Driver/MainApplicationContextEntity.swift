//      __  ____                 __ __                     __
//     /  |/  (_)_____________  / //_/__  _________  ___  / /
//    / /|_/ / / ___/ ___/ __ \/ ,< / _ \/ ___/ __ \/ _ \/ /
//   / /  / / / /__/ /  / /_/ / /| /  __/ /  / / / /  __/ /
//  /_/  /_/_/\___/_/   \____/_/ |_\___/_/  /_/ /_/\___/_/
//

import Foundation

internal class MainApplicationContextEntity: MainApplicationContext, DependencyContainer {
    
    internal var container: [DependencyKey: DependencyEntryProtocol] = [:]
    
    internal func injectDependency<RegisterType, ResloveType: Dependency>(registerType: RegisterType.Type,
                                                                          resloveType: ResloveType.Type) {
        insert(registerType: registerType, resloveType: resloveType)
    }
            
    internal func findDependency<RegisterType>(registerType: RegisterType.Type) -> Dependency? {
        return findInstance(registerType: registerType)
    }
    
    internal func findDependencyType<RegisterType>(registerType: RegisterType.Type) -> Dependency.Type? {
        return findType(registerType: registerType)
    }
}
