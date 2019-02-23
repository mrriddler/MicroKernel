//      __  ____                 __ __                     __
//     /  |/  (_)_____________  / //_/__  _________  ___  / /
//    / /|_/ / / ___/ ___/ __ \/ ,< / _ \/ ___/ __ \/ _ \/ /
//   / /  / / / /__/ /  / /_/ / /| /  __/ /  / / / /  __/ /
//  /_/  /_/_/\___/_/   \____/_/ |_\___/_/  /_/ /_/\___/_/
//

import Foundation

internal protocol BunchKeyIndex: class {
    
    typealias IndexEntry = ([ObjectIdentifier], String)
    
    var entry: [IndexEntry] { get set }
    
    func appendKey(_ key: ObjectIdentifier)
    
    func appendBunchKey(_ keys: [ObjectIdentifier])
    
    func appendValue(_ value: String)
    
    func removeValue(_ value: String) -> [String]?
    
    func removeKey(_ key: ObjectIdentifier) -> [String]?
    
    func removeBunchKey(_ keys: [ObjectIdentifier]) -> [String]?
    
    func removeKeyPartition(_ key: ObjectIdentifier) -> [String]?
    
    func removeBunchKeyPartition(_ keys: [ObjectIdentifier]) -> [String]?
}

extension BunchKeyIndex {
    
    func remove() -> [String]? {
        guard let idx = entry.firstIndex(where: { $0.0.count == 0 }) else {
            return nil
        }
        
        let res = entry[idx..<entry.count].map({ $0.1 })
        
        entry = Array(entry.prefix(idx))

        return res
    }
    
    func appendKey(_ key: ObjectIdentifier) {
        guard var last = entry.last else {
            return
        }
        
        last.0.append(key)
        entry.removeLast()
        entry.append(last)
    }
    
    func appendBunchKey(_ keys: [ObjectIdentifier]) {
        guard var last = entry.last else {
            return
        }
        
        last.0.append(contentsOf: keys)
        entry.removeLast()
        entry.append(last)
    }
    
    func appendValue(_ value: String) {
        entry.append(([], value))
    }
    
    func removeValue(_ value: String) -> [String]? {
        guard let idx = entry.lastIndex(where: { $0.1 == value }) else {
            return nil
        }
        
        let res = entry[idx..<entry.count].map({ $0.1 })
        
        entry = Array(entry.prefix(idx))
        return res
    }
    
    func removeKey(_ key: ObjectIdentifier) -> [String]? {
        entry = entry.map({ (testKeys, value) -> ([ObjectIdentifier], String) in
            let filterKeys = testKeys.filter({ $0 != key })
            return (filterKeys, value)
        })
        
        return remove()
    }
    
    func removeBunchKey(_ keys: [ObjectIdentifier]) -> [String]? {
        entry = entry.map({ (testKeys, value) -> ([ObjectIdentifier], String) in
            let filterKeys = testKeys.filter({ !keys.contains($0) })
            return (filterKeys, value)
        })
        
        return remove()
    }
    
    func removeKeyPartition(_ key: ObjectIdentifier) -> [String]? {
        entry = entry.map({ (testKeys, value) -> ([ObjectIdentifier], String) in
            var filterKeys: [ObjectIdentifier] = testKeys
            if let partitionIdx: Int = testKeys.lastIndex(of: key) {
                filterKeys = Array(testKeys.prefix(partitionIdx))
            }
            return (filterKeys, value)
        })
        
        return remove()
    }
    
    func removeBunchKeyPartition(_ keys: [ObjectIdentifier]) -> [String]? {
        entry = entry.map({ (testKeys, value) -> ([ObjectIdentifier], String) in
            var filterKeys: [ObjectIdentifier] = testKeys

            let intersectionIdx: [Int] = Set(testKeys).intersection(keys).map({ keys.firstIndex(of: $0)! })
            
            if let partitionIdx: Int = intersectionIdx.min() {
                filterKeys = Array(testKeys.prefix(partitionIdx))
            }
            return (filterKeys, value)
        })
        
        return remove()
    }
}

