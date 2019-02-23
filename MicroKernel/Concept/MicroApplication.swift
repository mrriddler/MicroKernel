//      __  ____                 __ __                     __
//     /  |/  (_)_____________  / //_/__  _________  ___  / /
//    / /|_/ / / ___/ ___/ __ \/ ,< / _ \/ ___/ __ \/ _ \/ /
//   / /  / / / /__/ /  / /_/ / /| /  __/ /  / / / /  __/ /
//  /_/  /_/_/\___/_/   \____/_/ |_\___/_/  /_/ /_/\___/_/
//

import Foundation

/// Summary: The generic protocol represent MicroApplication in architecture.

/// Discussion: An app has one or many application, application constantly switch
/// throughout user usage. With switchover is application's entire lifetime, Driver
/// would manage it and call API to notify application. API looks a lot like system
/// UIApplication for a better unity.

/// Implmentating Notes: Do not instantiation yourself. Register implementation to
/// MicroKernl.
public protocol MicroApplication: Initable {
    
    /// Application unique Id.
    ///
    /// - Returns: Id of the Application
    static func appId() -> String
    
    
    /// Dependency Injection for application, called after instantiation.
    ///
    /// - Parameters:
    ///   - context: context for application scope
    /// - Returns: context for application scope
    func applicationInjectDependency(context: MicroApplicationContext) -> MicroApplicationContext
    
    /// Application will start launching.
    ///
    /// - Parameters:
    ///   - application: application instance
    ///   - launchOptions: launching options
    func applicationWillStartLaunching(_ application: MicroApplication,
                                       launchOptions: [MicroApplicationLaunchOptionsKey: Any]?)
    
    /// Application did finish launching.
    ///
    /// - Parameter application: application instance
    func applicationDidFinishLaunching(_ application: MicroApplication)
    
    /// Application will lose focus, i.e entering background.
    ///
    /// - Parameter application: application instance
    func applicationWillResignActive(_ application: MicroApplication)
    
    /// Application did lose focus, i.e entered background.
    ///
    /// - Parameter application: application instance
    func applicationDidResignActive(_ application: MicroApplication)
    
    /// Application will get focus, i.e entering foreground.
    ///
    /// - Parameter application: application instance
    func applicationWillBecomeActive(_ application: MicroApplication)
    
    /// Application did get focus, i.e entered foreground
    ///
    /// - Parameter application: application instance
    func applicationDidBecomeActive(_ application: MicroApplication)
    
    /// Application will terminate.
    ///
    /// - Parameter application: application instance
    func applicationWillTerminate(_ application: MicroApplication)
    
    /// Application did terminate.
    ///
    /// - Parameter application: application instance
    func applicationDidTerminate(_ application: MicroApplication)
}

/// Summary: Convenient interface for application to adopted EventBus.

/// Discussion: EventBus extension is for MicroApplication internal
/// communication mechanisms.

/// Usage Note: Subscriber should only survive in application, subscriber
/// would be unregister before application terminate.
public extension MicroApplication {
    
    /// Register as a subscriber, wait for event with no expect event type.
    ///
    /// - Parameters:
    ///   - subscriber: subscriber object
    ///   - eventName: event Id
    ///   - handler: event arrival call back
    public func register(subscriber: AnyObject,
                         eventName: String,
                         handler: @escaping (() -> Void)) {
        MicroKernel.register(subscriber: subscriber, eventName: eventName, handler: handler)
        MicroKernelDriver.registerEventSubscriber(appId: type(of: self).appId(), subscriber: ObjectStringConvertor.convertObjectToString(subscriber))
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
        MicroKernel.register(subscriber: subscriber, eventName: eventName, handler: handler)
        MicroKernelDriver.registerEventSubscriber(appId: type(of: self).appId(), subscriber: subscriber)
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
        MicroKernel.register(subscriber: subscriber,
                             eventName: eventName,
                             expectType: expectType,
                             handler: handler)
        MicroKernelDriver.registerEventSubscriber(appId: type(of: self).appId(), subscriber: ObjectStringConvertor.convertObjectToString(subscriber))
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
        MicroKernel.register(subscriber: subscriber,
                             eventName: eventName,
                             expectType: expectType,
                             handler: handler)
        MicroKernelDriver.registerEventSubscriber(appId: type(of: self).appId(), subscriber: subscriber)
    }
    
    /// Unregister as a subscriber, for all event.
    ///
    /// - Parameters:
    ///   - subscriber: subscriber object
    public func unregister(subscriber: AnyObject) {
        MicroKernel.unregister(subscriber: subscriber)
    }
    
    /// Unregister as a subscriber, for all event.
    ///
    /// - Parameters:
    ///   - subscriber: stringify subscriber Id
    public func unregister(subscriber: String) {
        MicroKernel.unregister(subscriber: subscriber)
    }
    
    /// Unregister as a subscriber, for exactly event with all expect type.
    ///
    /// - Parameters:
    ///   - subscriber: subscriber object
    ///   - eventName: event Id
    public func unregister(subscriber: AnyObject, eventName: String) {
        MicroKernel.unregister(subscriber: subscriber, eventName: eventName)
    }
    
    /// Unregister as a subscriber, for exactly event with all expect type.
    ///
    /// - Parameters:
    ///   - subscriber: stringify subscriber Id
    ///   - eventName: event Id
    public func unregister(subscriber: String, eventName: String) {
        MicroKernel.unregister(subscriber: subscriber, eventName: eventName)
    }
    
    /// Unregister as a subscriber, for exactly event with no expect type.
    ///
    /// - Parameters:
    ///   - subscriber: subscriber object
    ///   - eventName: event Id
    public func unregisterNoExpect(subscriber: AnyObject, eventName: String) {
        MicroKernel.unregisterNoExpect(subscriber: subscriber, eventName: eventName)
    }
    
    /// Unregister as a subscriber, for exactly event with no expect type.
    ///
    /// - Parameters:
    ///   - subscriber: stringify subscriber Id
    ///   - eventName: event Id
    public func unregisterNoExpect(subscriber: String, eventName: String) {
        MicroKernel.unregisterNoExpect(subscriber: subscriber, eventName: eventName)
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
        MicroKernel.unregister(subscriber: subscriber,
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
        MicroKernel.unregister(subscriber: subscriber,
                               eventName: eventName,
                               expectType: expectType)
    }
    
    /// Post as a publisher, with no expect event type.
    ///
    /// - Parameters:
    ///   - eventName: event Id
    public func post(eventName: String) {
        MicroKernel.post(eventName: eventName)
    }
    
    /// Post as a publisher, with certain expect event type.
    ///
    /// - Parameters:
    ///   - eventName: event Id
    ///   - expectType: expect event type
    ///   - event: event subject
    public func post<EventType>(eventName: String,
                                eventType: EventType.Type,
                                event: EventType) {
        MicroKernel.post(eventName: eventName,
                         eventType: eventType,
                         event: event)
    }
}

/// Summary: Options for launch application.
public struct MicroApplicationLaunchOptionsKey : Hashable, Equatable, RawRepresentable {
    
    public var rawValue: String
    
    public init(rawValue: String) {
        self.rawValue = rawValue
    }
}
