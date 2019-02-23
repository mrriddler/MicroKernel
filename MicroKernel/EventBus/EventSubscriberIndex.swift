//      __  ____                 __ __                     __
//     /  |/  (_)_____________  / //_/__  _________  ___  / /
//    / /|_/ / / ___/ ___/ __ \/ ,< / _ \/ ___/ __ \/ _ \/ /
//   / /  / / / /__/ /  / /_/ / /| /  __/ /  / / / /  __/ /
//  /_/  /_/_/\___/_/   \____/_/ |_\___/_/  /_/ /_/\___/_/
//

import Foundation

class EventSubscriberIndex: TwoLevelIndex {
    
    internal var index: [String : [String : [String]]] = [:]
    
    internal func register(eventName: String, subscriber: AnyObject, expectType: String) {
        insert(eventName, ObjectStringConvertor.convertObjectToString(subscriber), expectType)
    }
    
    internal func register(eventName: String, subscriber: String, expectType: String) {
        insert(eventName, subscriber, expectType)
    }
    
    internal func subscriber(eventName: String) -> [String: [String]]? {
        return value(eventName)
    }
    
    internal func expectTypeSet(eventName: String, subscriber: AnyObject) -> [String]? {
        return value(eventName, ObjectStringConvertor.convertObjectToString(subscriber))
    }
    
    internal func expectTypeSet(eventName: String, subscriber: String) -> [String]? {
        return value(eventName, subscriber)
    }
    
    internal func expectType(eventName: String, subscriber: AnyObject, expectType: String) -> String? {
        return value(eventName, ObjectStringConvertor.convertObjectToString(subscriber), expectType)
    }
    
    internal func expectType(eventName: String, subscriber: String, expectType: String) -> String? {
        return value(eventName, subscriber, expectType)
    }
    
    internal func unregister(eventName: String) {
        removeValue(eventName)
    }
    
    internal func unregister(eventName: String, subscriber: AnyObject) {
        removeValue(eventName, ObjectStringConvertor.convertObjectToString(subscriber))
    }
    
    internal func unregister(eventName: String, subscriber: String) {
        removeValue(eventName, subscriber)
    }
    
    internal func unregister(eventName: String, subscriber: AnyObject, expectType: String) {
        removeValue(eventName, ObjectStringConvertor.convertObjectToString(subscriber), expectType)
    }
    
    internal func unregister(eventName: String, subscriber: String, expectType: String) {
        removeValue(eventName, subscriber, expectType)
    }
}
