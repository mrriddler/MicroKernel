//      __  ____                 __ __                     __
//     /  |/  (_)_____________  / //_/__  _________  ___  / /
//    / /|_/ / / ___/ ___/ __ \/ ,< / _ \/ ___/ __ \/ _ \/ /
//   / /  / / / /__/ /  / /_/ / /| /  __/ /  / / / /  __/ /
//  /_/  /_/_/\___/_/   \____/_/ |_\___/_/  /_/ /_/\___/_/
//

import Foundation

internal protocol DependencyEntryProtocol {
    
    func instance() -> Dependency
    
    func type() -> Dependency.Type
}

internal class DependencyEntry: DependencyEntryProtocol {
    
    internal var storage: Dependency?
    
    internal let resloveType: Dependency.Type
    
    internal init(_ resloveType: Dependency.Type) {
        self.resloveType = resloveType
    }
    
    internal func instance() -> Dependency {
        if let instance = storage {
            return instance
        }
        
        var instance: Dependency
        
        if resloveType.isSingleton() {
            instance = resloveType.singleton()
            storage = instance
        } else {
            instance = resloveType.init()
        }
        
        return instance
    }
    
    internal func type() -> Dependency.Type {
        return resloveType
    }
}
