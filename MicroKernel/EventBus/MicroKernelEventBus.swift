//      __  ____                 __ __                     __
//     /  |/  (_)_____________  / //_/__  _________  ___  / /
//    / /|_/ / / ___/ ___/ __ \/ ,< / _ \/ ___/ __ \/ _ \/ /
//   / /  / / / /__/ /  / /_/ / /| /  __/ /  / / / /  __/ /
//  /_/  /_/_/\___/_/   \____/_/ |_\___/_/  /_/ /_/\___/_/
//

import Foundation

/// Summary: Event Bus is a Event Driven cross module access mechanisms.

/// Discussion: It could be adopted by three manner:
///             1. Register as a subscriber, wait for event, with expect event
///                subject or not.
///             2. Unregister as a subscriber, quickly unregister all event or
///                unregister exactly event.
///             3. Post a event as a publisher, with event subject or not.

/// Event Bus hold subsciber's handler closure, and construct index to
/// speed up lookup operation.

internal class MicroKernelEventBus {
    
    internal static let `default` = MicroKernelEventBus()
    
    fileprivate let subscriberEventIndex = SubscribeEventIndex()
    
    fileprivate let eventSubscriberIndex = EventSubscriberIndex()
    
    fileprivate var handlerTable: [String: Any] = [:]
    
    /// Register as a subscriber, wait for event with no expect event type.
    ///
    /// - Parameters:
    ///   - subscriber: subscriber object
    ///   - eventName: event Id
    ///   - handler: event arrival call back
    internal func register(subscriber: AnyObject,
                           eventName: String,
                           handler: @escaping (() -> Void)) {
        
        let handlerId: String = MicroKernelEventBus.join(subscriber: ObjectStringConvertor.convertObjectToString(subscriber), eventName: eventName, expectType: MicroKernelEventBus.voidPlaceHolder())
        register(handlerId: handlerId, subscriber: subscriber, eventName: eventName, expectType: MicroKernelEventBus.voidPlaceHolder(), handler: handler)
    }
    
    /// Register as a subscriber, wait for event with no expect event type.
    ///
    /// - Parameters:
    ///   - subscriber: stringify subscriber Id
    ///   - eventName: event Id
    ///   - handler: event arrival call back
    internal func register(subscriber: String,
                           eventName: String,
                           handler: @escaping (() -> Void)) {
        
        let handlerId: String = MicroKernelEventBus.join(subscriber: subscriber, eventName: eventName, expectType: MicroKernelEventBus.voidPlaceHolder())
        register(handlerId: handlerId, subscriber: subscriber, eventName: eventName, expectType: MicroKernelEventBus.voidPlaceHolder(), handler: handler)
    }
    
    /// Register as a subscriber, wait for event with certain expect event type.
    ///
    /// - Parameters:
    ///   - subscriber: subscriber object
    ///   - eventName: event Id
    ///   - expectType: expect event type
    ///   - handler: event arrival call back
    internal func register<ExpectType>(subscriber: AnyObject,
                                       eventName: String,
                                       expectType: ExpectType.Type,
                                       handler: @escaping ((ExpectType?) -> Void)) {
        
        let expectTypeStringify: String = "\(expectType)"
        let handlerId: String = MicroKernelEventBus.join(subscriber: ObjectStringConvertor.convertObjectToString(subscriber), eventName: eventName, expectType: expectTypeStringify)
        register(handlerId: handlerId, subscriber: subscriber, eventName: eventName, expectType: expectTypeStringify, handler: handler)

    }
    
    /// Register as a subscriber, wait for event with certain expect event type.
    ///
    /// - Parameters:
    ///   - subscriber: stringify subscriber Id
    ///   - eventName: event Id
    ///   - expectType: expect event type
    ///   - handler: event arrival call back
    internal func register<ExpectType>(subscriber: String,
                                       eventName: String,
                                       expectType: ExpectType.Type,
                                       handler: @escaping ((ExpectType?) -> Void)) {
        
        let expectTypeStringify: String = "\(expectType)"
        let handlerId: String = MicroKernelEventBus.join(subscriber: subscriber, eventName: eventName, expectType: expectTypeStringify)
        register(handlerId: handlerId, subscriber: subscriber, eventName: eventName, expectType: expectTypeStringify, handler: handler)
    }
    
    /// Unregister as a subscriber, for all event.
    ///
    /// - Parameters:
    ///   - subscriber: subscriber object
    internal func unregister(subscriber: AnyObject) {
        guard let events = subscriberEventIndex.event(subscriber: subscriber) else {
            return
        }
        
        events.forEach { (eventName, expectTypeSet) in
            eventSubscriberIndex.unregister(eventName: eventName, subscriber: subscriber)
            
            expectTypeSet.forEach({ removeHandler(subscriber: subscriber, eventName: eventName, expectType: $0) })
        }
        
        subscriberEventIndex.unregister(subscriber: subscriber)
    }
    
    /// Unregister as a subscriber, for all event.
    ///
    /// - Parameters:
    ///   - subscriber: stringify subscriber Id
    internal func unregister(subscriber: String) {
        guard let events = subscriberEventIndex.event(subscriber: subscriber) else {
            return
        }
        
        events.forEach { (eventName, expectTypeSet) in
            eventSubscriberIndex.unregister(eventName: eventName, subscriber: subscriber)
            
            expectTypeSet.forEach({ removeHandler(subscriber: subscriber, eventName: eventName, expectType: $0) })
        }
        
        subscriberEventIndex.unregister(subscriber: subscriber)
    }
    
    /// Unregister as a subscriber, for exactly event with all expect type.
    ///
    /// - Parameters:
    ///   - subscriber: subscriber object
    ///   - eventName: event Id
    internal func unregister(subscriber: AnyObject, eventName: String) {
        guard let expectTypeSet = subscriberEventIndex.expectTypeSet(subscriber: subscriber, eventName: eventName) else {
            return
        }
        
        expectTypeSet.forEach({ removeHandler(subscriber: subscriber, eventName: eventName, expectType: $0) })

        subscriberEventIndex.unregister(subscriber: subscriber, eventName: eventName)
        eventSubscriberIndex.unregister(eventName: eventName, subscriber: subscriber)
    }
    
    /// Unregister as a subscriber, for exactly event with all expect type.
    ///
    /// - Parameters:
    ///   - subscriber: stringify subscriber Id
    ///   - eventName: event Id
    internal func unregister(subscriber: String, eventName: String) {
        guard let expectTypeSet = subscriberEventIndex.expectTypeSet(subscriber: subscriber, eventName: eventName) else {
            return
        }
        
        expectTypeSet.forEach({ removeHandler(subscriber: subscriber, eventName: eventName, expectType: $0) })
        
        subscriberEventIndex.unregister(subscriber: subscriber, eventName: eventName)
        eventSubscriberIndex.unregister(eventName: eventName, subscriber: subscriber)
    }
    
    /// Unregister as a subscriber, for exactly event with no expect type.
    ///
    /// - Parameters:
    ///   - subscriber: subscriber object
    ///   - eventName: event Id
    internal func unregisterNoExpect(subscriber: AnyObject, eventName: String) {
        removeHandler(subscriber: subscriber, eventName: eventName, expectType: MicroKernelEventBus.voidPlaceHolder())
        
        subscriberEventIndex.unregister(subscriber: subscriber, eventName: eventName, expectType: MicroKernelEventBus.voidPlaceHolder())
        eventSubscriberIndex.unregister(eventName: eventName, subscriber: subscriber, expectType: MicroKernelEventBus.voidPlaceHolder())
    }
    
    /// Unregister as a subscriber, for exactly event with no expect type.
    ///
    /// - Parameters:
    ///   - subscriber: stringify subscriber Id
    ///   - eventName: event Id
    internal func unregisterNoExpect(subscriber: String, eventName: String) {
        removeHandler(subscriber: subscriber, eventName: eventName, expectType: MicroKernelEventBus.voidPlaceHolder())
        
        subscriberEventIndex.unregister(subscriber: subscriber, eventName: eventName, expectType: MicroKernelEventBus.voidPlaceHolder())
        eventSubscriberIndex.unregister(eventName: eventName, subscriber: subscriber, expectType: MicroKernelEventBus.voidPlaceHolder())
    }
    
    /// Unregister as a subscriber, for exactly event with certain expect type.
    ///
    /// - Parameters:
    ///   - subscriber: subscriber object
    ///   - eventName: event Id
    ///   - expectType: expect event type
    internal func unregister<ExpectType>(subscriber: AnyObject,
                                         eventName: String,
                                         expectType: ExpectType.Type) {
        let expectTypeStringify: String = "\(expectType)"
        
        removeHandler(subscriber: subscriber, eventName: eventName, expectType: expectTypeStringify)
        
        subscriberEventIndex.unregister(subscriber: subscriber, eventName: eventName, expectType: expectTypeStringify)
        eventSubscriberIndex.unregister(eventName: eventName, subscriber: subscriber, expectType: expectTypeStringify)
    }
    
    /// Unregister as a subscriber, for exactly event with certain expect type.
    ///
    /// - Parameters:
    ///   - subscriber: stringify subscriber Id
    ///   - eventName: event Id
    ///   - expectType: expect event type
    internal func unregister<ExpectType>(subscriber: String,
                                         eventName: String,
                                         expectType: ExpectType.Type) {
        let expectTypeStringify: String = "\(expectType)"
        
        removeHandler(subscriber: subscriber, eventName: eventName, expectType: expectTypeStringify)
        
        subscriberEventIndex.unregister(subscriber: subscriber, eventName: eventName, expectType: expectTypeStringify)
        eventSubscriberIndex.unregister(eventName: eventName, subscriber: subscriber, expectType: expectTypeStringify)
    }
    
    /// Post as a publisher, with no expect event type.
    ///
    /// - Parameters:
    ///   - eventName: event Id
    internal func post(eventName: String) {
        guard let subscribers = eventSubscriberIndex.subscriber(eventName: eventName) else {
            return
        }
        
        var handlerIds: [String] = []
        subscribers.forEach { (subscriber, eventTypeSet) in
            if eventTypeSet.contains(MicroKernelEventBus.voidPlaceHolder()) {
                handlerIds.append(MicroKernelEventBus.join(subscriber: subscriber, eventName: eventName, expectType: MicroKernelEventBus.voidPlaceHolder()))
            }
        }
        
        handlerIds.forEach({ dispatchHandler(handlerId: $0) })
    }
    
    /// Post as a publisher, with certain expect event type.
    ///
    /// - Parameters:
    ///   - eventName: event Id
    ///   - expectType: expect event type
    ///   - event: event subject
    internal func post<EventType>(eventName: String,
                                  eventType: EventType.Type,
                                  event: EventType) {
        guard let subscribers = eventSubscriberIndex.subscriber(eventName: eventName) else {
            return
        }
        
        let eventTypeStringify: String = "\(eventType)"
        
        var handlerIds: [String] = []
        subscribers.forEach { (subscriber, eventTypeSet) in
            if eventTypeSet.contains(eventTypeStringify) {
                handlerIds.append(MicroKernelEventBus.join(subscriber: subscriber, eventName: eventName, expectType: eventTypeStringify))
            }
        }
        
        handlerIds.forEach({ dispatchHandler(handlerId: $0, eventType: eventType, event: event) })
    }
    
    fileprivate func register(handlerId: String,
                              subscriber: AnyObject,
                              eventName: String,
                              expectType: String,
                              handler: Any) {
        handlerTable[handlerId] = handler
        
        subscriberEventIndex.register(subscriber: subscriber, eventName: eventName, expectType: expectType)
        eventSubscriberIndex.register(eventName: eventName, subscriber: subscriber, expectType: expectType)
    }
    
    fileprivate func register(handlerId: String,
                              subscriber: String,
                              eventName: String,
                              expectType: String,
                              handler: Any) {
        handlerTable[handlerId] = handler
        
        subscriberEventIndex.register(subscriber: subscriber, eventName: eventName, expectType: expectType)
        eventSubscriberIndex.register(eventName: eventName, subscriber: subscriber, expectType: expectType)
    }
    
    fileprivate func dispatchHandler(handlerId: String) {
        guard let handler = handlerTable[handlerId] else {
            return
        }
        
        switch handler {
        case let castHandler as () -> Void:
            castHandler()
        default:
            break
        }
    }

    fileprivate func dispatchHandler<EventType>(handlerId: String,
                                                eventType: EventType.Type,
                                                event: EventType) {
        guard let handler = handlerTable[handlerId] else {
            return
        }
        
        switch handler {
        case let castHandler as (EventType?) -> Void:
            castHandler(event)
        default:
            break
        }
    }
    
    fileprivate func removeHandler(subscriber: AnyObject, eventName: String, expectType: String) {
        let handlerId = MicroKernelEventBus.join(subscriber: ObjectStringConvertor.convertObjectToString(subscriber), eventName: eventName, expectType: expectType)
        handlerTable.removeValue(forKey: handlerId)
    }
    
    fileprivate func removeHandler(subscriber: String, eventName: String, expectType: String) {
        let handlerId = MicroKernelEventBus.join(subscriber: subscriber, eventName: eventName, expectType: expectType)
        handlerTable.removeValue(forKey: handlerId)
    }
    
    fileprivate class func join(subscriber: String, eventName: String, expectType: String) -> String {
        return "\(subscriber)_\(eventName)_\(expectType)"
    }
    
    fileprivate class func voidPlaceHolder() -> String {
        return "VoidPlaceHolder"
    }
}
