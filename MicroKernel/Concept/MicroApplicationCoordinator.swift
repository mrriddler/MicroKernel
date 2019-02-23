//      __  ____                 __ __                     __
//     /  |/  (_)_____________  / //_/__  _________  ___  / /
//    / /|_/ / / ___/ ___/ __ \/ ,< / _ \/ ___/ __ \/ _ \/ /
//   / /  / / / /__/ /  / /_/ / /| /  __/ /  / / / /  __/ /
//  /_/  /_/_/\___/_/   \____/_/ |_\___/_/  /_/ /_/\___/_/
//

import Foundation

/// Summary: The generic protocol represent MicroApplicationCoordinator concept.

public protocol MicroApplicationCoordinator: Dependency {
    
    /// Invoke a Cross Module Procedure Call
    ///
    /// - Parameters:
    ///   - request: call parameter
    ///   - handler: call result
    func call<RequestType, ResponseType>(request: RequestType,
                                         handler: @escaping ((ResponseType?) -> Void))
}

public extension MicroApplicationCoordinator {
    
    /// Deafult void implementation
    ///
    /// - Parameters:
    ///   - request: call parameter
    ///   - handler: call result
    func call<RequestType, ResponseType>(request: RequestType,
                                         handler: @escaping ((ResponseType?) -> Void)) {}
}

/// Summary: Convenient interface for application coordinator to adopted
/// EventBus.

/// Discussion: EventBus extension is for MicroApplication cross module access
/// mechanisms.

/// Usage Note: Subscriber should only survive in application, subscriber
/// would be unregister before application terminate.
public extension MicroApplicationCoordinator {
    
    /// Register as a subscriber, wait for event with no expect event type.
    ///
    /// - Parameters:
    ///   - subscriber: subscriber object
    ///   - eventName: event Id
    ///   - handler: event arrival call back
    public func register(subscriber: AnyObject,
                         eventName: String,
                         handler: @escaping (() -> Void)) {
        MicroKernel.currentApplication()?.register(subscriber: subscriber, eventName: eventName, handler: handler)
    }
    
    /// Register as a subscriber, wait for event with no expect event type.
    ///
    /// - Parameters:
    ///   - subscriber: stringify subscriber Id
    ///   - eventName: event Id
    ///   - handler: event arrival call back
    public func register(subscriber: String,
                         eventName: String,
                         handler: @escaping (() -> Void)) {
        MicroKernel.currentApplication()?.register(subscriber: subscriber, eventName: eventName, handler: handler)
    }
    
    /// Register as a subscriber, wait for event with certain expect event type.
    ///
    /// - Parameters:
    ///   - subscriber: subscriber object
    ///   - eventName: event Id
    ///   - expectType: expect event type
    ///   - handler: event arrival call back
    public func register<ExpectType>(subscriber: AnyObject,
                                     eventName: String,
                                     expectType: ExpectType.Type,
                                     handler: @escaping ((ExpectType?) -> Void)) {
        MicroKernel.currentApplication()?.register(subscriber: subscriber,
                             eventName: eventName,
                             expectType: expectType,
                             handler: handler)
    }
    
    /// Register as a subscriber, wait for event with certain expect event type.
    ///
    /// - Parameters:
    ///   - subscriber: stringify subscriber Id
    ///   - eventName: event Id
    ///   - expectType: expect event type
    ///   - handler: event arrival call back
    public func register<ExpectType>(subscriber: String,
                                     eventName: String,
                                     expectType: ExpectType.Type,
                                     handler: @escaping ((ExpectType?) -> Void)) {
        MicroKernel.currentApplication()?.register(subscriber: subscriber,
                             eventName: eventName,
                             expectType: expectType,
                             handler: handler)
    }
    
    /// Unregister as a subscriber, for all event.
    ///
    /// - Parameters:
    ///   - subscriber: subscriber object
    public func unregister(subscriber: AnyObject) {
        MicroKernel.currentApplication()?.unregister(subscriber: subscriber)
    }
    
    /// Unregister as a subscriber, for all event.
    ///
    /// - Parameters:
    ///   - subscriber: stringify subscriber Id
    public func unregister(subscriber: String) {
        MicroKernel.currentApplication()?.unregister(subscriber: subscriber)
    }
    
    /// Unregister as a subscriber, for exactly event with all expect type.
    ///
    /// - Parameters:
    ///   - subscriber: subscriber object
    ///   - eventName: event Id
    public func unregister(subscriber: AnyObject, eventName: String) {
        MicroKernel.currentApplication()?.unregister(subscriber: subscriber, eventName: eventName)
    }
    
    /// Unregister as a subscriber, for exactly event with all expect type.
    ///
    /// - Parameters:
    ///   - subscriber: stringify subscriber Id
    ///   - eventName: event Id
    public func unregister(subscriber: String, eventName: String) {
        MicroKernel.currentApplication()?.unregister(subscriber: subscriber, eventName: eventName)
    }
    
    /// Unregister as a subscriber, for exactly event with no expect type.
    ///
    /// - Parameters:
    ///   - subscriber: subscriber object
    ///   - eventName: event Id
    public func unregisterNoExpect(subscriber: AnyObject, eventName: String) {
        MicroKernel.currentApplication()?.unregisterNoExpect(subscriber: subscriber, eventName: eventName)
    }
    
    /// Unregister as a subscriber, for exactly event with no expect type.
    ///
    /// - Parameters:
    ///   - subscriber: stringify subscriber Id
    ///   - eventName: event Id
    public func unregisterNoExpect(subscriber: String, eventName: String) {
        MicroKernel.currentApplication()?.unregisterNoExpect(subscriber: subscriber, eventName: eventName)
    }
    
    /// Unregister as a subscriber, for exactly event with certain expect type.
    ///
    /// - Parameters:
    ///   - subscriber: subscriber object
    ///   - eventName: event Id
    ///   - expectType: expect event type
    public func unregister<ExpectType>(subscriber: AnyObject,
                                       eventName: String,
                                       expectType: ExpectType.Type) {
        MicroKernel.currentApplication()?.unregister(subscriber: subscriber,
                               eventName: eventName,
                               expectType: expectType)
    }
    
    /// Unregister as a subscriber, for exactly event with certain expect type.
    ///
    /// - Parameters:
    ///   - subscriber: stringify subscriber Id
    ///   - eventName: event Id
    ///   - expectType: expect event type
    public func unregister<ExpectType>(subscriber: String,
                                       eventName: String,
                                       expectType: ExpectType.Type) {
        MicroKernel.currentApplication()?.unregister(subscriber: subscriber,
                               eventName: eventName,
                               expectType: expectType)
    }
}


