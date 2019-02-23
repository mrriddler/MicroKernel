//      __  ____                 __ __                     __
//     /  |/  (_)_____________  / //_/__  _________  ___  / /
//    / /|_/ / / ___/ ___/ __ \/ ,< / _ \/ ___/ __ \/ _ \/ /
//   / /  / / / /__/ /  / /_/ / /| /  __/ /  / / / /  __/ /
//  /_/  /_/_/\___/_/   \____/_/ |_\___/_/  /_/ /_/\___/_/
//

import Foundation

internal class MicroApplicationContextEntity: MicroApplicationContext, DependencyContainer {

    fileprivate let mainContext: MainApplicationContextEntity
    
    fileprivate let privateLaunchOptions: [MicroApplicationLaunchOptionsKey: Any]?
    
    internal var launchOptions: [MicroApplicationLaunchOptionsKey: Any]? {
        get {
            return privateLaunchOptions
        }
    }
    
    internal init(launchOptions: [MicroApplicationLaunchOptionsKey: Any]?,
                  mainContext: MainApplicationContextEntity) {
        self.privateLaunchOptions = launchOptions
        self.mainContext = mainContext
    }

    internal var container: [DependencyKey: DependencyEntryProtocol] = [:]
    
    internal func injectDependency<RegisterType>(registerType: RegisterType.Type) {
        guard let resloveType: Dependency.Type = mainContext.findDependencyType(registerType: registerType) else {
            return
        }
        
        insert(registerType: registerType, resloveType: resloveType)
    }
    
    func injectDependency<RegisterType, ResloveType: Dependency>(registerType: RegisterType.Type,
                                                                 resloveType: ResloveType.Type) {
        insert(registerType: registerType, resloveType: resloveType)
    }
    
    internal func findDependency<RegisterType>(registerType: RegisterType.Type) -> Dependency? {
        return findInstance(registerType: registerType)
    }
}
