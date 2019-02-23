//      __  ____                 __ __                     __
//     /  |/  (_)_____________  / //_/__  _________  ___  / /
//    / /|_/ / / ___/ ___/ __ \/ ,< / _ \/ ___/ __ \/ _ \/ /
//   / /  / / / /__/ /  / /_/ / /| /  __/ /  / / / /  __/ /
//  /_/  /_/_/\___/_/   \____/_/ |_\___/_/  /_/ /_/\___/_/
//

import Foundation

internal class SubscribeEventIndex: TwoLevelIndex {
    
    internal var index: [String : [String : [String]]] = [:]
    
    internal func register(subscriber: AnyObject, eventName: String, expectType: String) {
        insert(ObjectStringConvertor.convertObjectToString(subscriber), eventName, expectType)
    }
    
    internal func register(subscriber: String, eventName: String, expectType: String) {
        insert(subscriber, eventName, expectType)
    }
    
    internal func event(subscriber: AnyObject) -> [String: [String]]? {
        return value(ObjectStringConvertor.convertObjectToString(subscriber))
    }
    
    internal func event(subscriber: String) -> [String: [String]]? {
        return value(subscriber)
    }
    
    internal func expectTypeSet(subscriber: AnyObject, eventName: String) -> [String]? {
        return value(ObjectStringConvertor.convertObjectToString(subscriber), eventName)
    }
    
    internal func expectTypeSet(subscriber: String, eventName: String) -> [String]? {
        return value(subscriber, eventName)
    }
    
    internal func expectType(subscriber: AnyObject, eventName: String, expectType: String) -> String? {
        return value(ObjectStringConvertor.convertObjectToString(subscriber), eventName, expectType)
    }
    
    internal func expectType(subscriber: String, eventName: String, expectType: String) -> String? {
        return value(subscriber, eventName, expectType)
    }

    internal func unregister(subscriber: AnyObject) {
        removeValue(ObjectStringConvertor.convertObjectToString(subscriber))
    }
    
    internal func unregister(subscriber: String) {
        removeValue(subscriber)
    }
    
    internal func unregister(subscriber: AnyObject, eventName: String) {
        removeValue(ObjectStringConvertor.convertObjectToString(subscriber), eventName)
    }
    
    internal func unregister(subscriber: String, eventName: String) {
        removeValue(subscriber, eventName)
    }
    
    internal func unregister(subscriber: AnyObject, eventName: String, expectType: String) {
        removeValue(ObjectStringConvertor.convertObjectToString(subscriber), eventName, expectType)
    }
    
    internal func unregister(subscriber: String, eventName: String, expectType: String) {
        removeValue(subscriber, eventName, expectType)
    }
}
