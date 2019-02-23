//      __  ____                 __ __                     __
//     /  |/  (_)_____________  / //_/__  _________  ___  / /
//    / /|_/ / / ___/ ___/ __ \/ ,< / _ \/ ___/ __ \/ _ \/ /
//   / /  / / / /__/ /  / /_/ / /| /  __/ /  / / / /  __/ /
//  /_/  /_/_/\___/_/   \____/_/ |_\___/_/  /_/ /_/\___/_/
//

import Foundation

/// Summary: The Key-Value style Dependency Type and Dependency Instance Container.

internal protocol DependencyContainer: class {
    
    var container: [DependencyKey: DependencyEntryProtocol] { get set }

    func insert(registerType: Any.Type, resloveType: Dependency.Type)

    func findInstance(registerType: Any.Type) -> Dependency?

    func findType(registerType: Any.Type) -> Dependency.Type?
}

extension DependencyContainer {

    func insert(registerType: Any.Type, resloveType: Dependency.Type) {
        let key: DependencyKey = DependencyKey(registerType)
        let entry: DependencyEntryProtocol = DependencyEntry(resloveType)
        
        container[key] = entry
    }

    func findInstance(registerType: Any.Type) -> Dependency? {
        guard let entry = container[DependencyKey(registerType)] else {
            return nil
        }
        
        return entry.instance()
    }
    
    func findType(registerType: Any.Type) -> Dependency.Type? {
        guard let entry = container[DependencyKey(registerType)] else {
            return nil
        }
        
        return entry.type()
    }
}
