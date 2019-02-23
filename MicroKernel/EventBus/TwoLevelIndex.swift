//      __  ____                 __ __                     __
//     /  |/  (_)_____________  / //_/__  _________  ___  / /
//    / /|_/ / / ___/ ___/ __ \/ ,< / _ \/ ___/ __ \/ _ \/ /
//   / /  / / / /__/ /  / /_/ / /| /  __/ /  / / / /  __/ /
//  /_/  /_/_/\___/_/   \____/_/ |_\___/_/  /_/ /_/\___/_/
//

import Foundation

internal protocol TwoLevelIndex: class {
    
    var index: [String: [String: [String]]] { get set }
    
    func insert(_ firstLevelKey: String, _ secondLevelKey: String, _ value: String)
    
    func value(_ firstLevelKey: String) -> [String: [String]]?
    
    func value(_ firstLevelKey: String, _ secondLevelKey: String) -> [String]?
    
    func value(_ firstLevelKey: String, _ secondLevelKey: String, _ value: String) -> String?
    
    func removeValue(_ firstLevelKey: String)
    
    func removeValue(_ firstLevelKey: String, _ secondLevelKey: String)
    
    func removeValue(_ firstLevelKey: String, _ secondLevelKey: String, _ value: String)
}

extension TwoLevelIndex {
    
    func insert(_ firstLevelKey: String, _ secondLevelKey: String, _ value: String) {
        
        var valueSet: [String] = [value]
        
        if let firstLevel: [String: [String]] = index[firstLevelKey] {
            if let secondLevel: [String] = firstLevel[secondLevelKey] {
                valueSet = secondLevel
                if !valueSet.contains(value) {
                    valueSet.append(value)
                }
                
                var newFirstLevel = firstLevel
                newFirstLevel[secondLevelKey] = valueSet
                index[firstLevelKey] = newFirstLevel
            } else {
                var newFirstLevel = firstLevel
                newFirstLevel[secondLevelKey] = valueSet
                index[firstLevelKey] = newFirstLevel
            }
        } else {
            index[firstLevelKey] = [secondLevelKey: valueSet]
        }
    }
    
    func value(_ firstLevelKey: String) -> [String: [String]]? {
        return index[firstLevelKey]
    }
    
    func value(_ firstLevelKey: String, _ secondLevelKey: String) -> [String]? {
        return index[firstLevelKey]?[secondLevelKey]
    }
    
    func value(_ firstLevelKey: String, _ secondLevelKey: String, _ value: String) -> String? {
        guard let exist = index[firstLevelKey]?[secondLevelKey]?.contains(value) else {
            return nil
        }
        
        if exist {
            return value
        }
        
        return nil
    }
    
    func removeValue(_ firstLevelKey: String) {
        guard value(firstLevelKey) != nil else {
            return
        }
        
        index.removeValue(forKey: firstLevelKey)
    }
    
    func removeValue(_ firstLevelKey: String, _ secondLevelKey: String) {
        guard value(firstLevelKey, secondLevelKey) != nil else {
            return
        }
        
        var newFirstLevel: [String: [String]] = index[firstLevelKey]!
        newFirstLevel.removeValue(forKey: secondLevelKey)
        
        if newFirstLevel.count > 0 {
            index[firstLevelKey] = newFirstLevel
        } else {
            removeValue(firstLevelKey)
        }
    }
    
    func removeValue(_ firstLevelKey: String, _ secondLevelKey: String, _ value: String) {
        guard self.value(firstLevelKey, secondLevelKey, value) != nil else {
            return
        }

        var newValue: [String] = index[firstLevelKey]![secondLevelKey]!
        newValue.remove(at: newValue.firstIndex(of: value)!)
        
        if newValue.count > 0 {
            index[firstLevelKey]![secondLevelKey]! = newValue
        } else {
            removeValue(firstLevelKey, secondLevelKey)
        }
    }
}
