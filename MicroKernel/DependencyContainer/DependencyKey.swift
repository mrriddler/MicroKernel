//      __  ____                 __ __                     __
//     /  |/  (_)_____________  / //_/__  _________  ___  / /
//    / /|_/ / / ___/ ___/ __ \/ ,< / _ \/ ___/ __ \/ _ \/ /
//   / /  / / / /__/ /  / /_/ / /| /  __/ /  / / / /  __/ /
//  /_/  /_/_/\___/_/   \____/_/ |_\___/_/  /_/ /_/\___/_/
//

import Foundation

internal struct DependencyKey {
    
    internal let registerType: Any.Type
    
    internal init(_ registerType: Any.Type) {
        self.registerType = registerType
    }
    
    static func == (lhs: DependencyKey, rhs: DependencyKey) -> Bool {
        return "\(lhs.registerType)" == "\(rhs.registerType)"
    }
}

extension DependencyKey: Hashable {
    
    var hashValue: Int {
        return "\(registerType)".hashValue
    }
}
