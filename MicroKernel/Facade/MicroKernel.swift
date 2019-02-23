//      __  ____                 __ __                     __
//     /  |/  (_)_____________  / //_/__  _________  ___  / /
//    / /|_/ / / ___/ ___/ __ \/ ,< / _ \/ ___/ __ \/ _ \/ /
//   / /  / / / /__/ /  / /_/ / /| /  __/ /  / / / /  __/ /
//  /_/  /_/_/\___/_/   \____/_/ |_\___/_/  /_/ /_/\___/_/
//

import Foundation

/// Summary: The interface point of MicroKernel, this class serve as a Facade.

public class MicroKernel {
    
    /// Find Dependency in order, current scope first global scope again.
    ///
    /// - Parameter registerType: dependency prototype type
    /// - Returns: dependency entity
    public class func findDependency<RegisterType>(registerType: RegisterType.Type) -> Dependency? {
        return MicroKernelDriver.findDependency(registerType: registerType)
    }
    
    /// Access MainApplication.
    ///
    /// - Returns: MainApplication
    public class func mainApplication() -> MainApplication? {
        return MicroKernelDriver.mainApplication()
    }
    
    /// Access MainApplicationContext.
    ///
    /// - Returns: MainApplicationContext
    internal class func mainApplicationContext() -> MainApplicationContext? {
        return MicroKernelDriver.mainApplicationContext()
    }
    
    /// Access current MicroApplication.
    ///
    /// - Returns: MicroApplication
    public class func currentApplication() -> MicroApplication? {
        return MicroKernelDriver.currentApplication()
    }
    
    /// Access current MicroApplicationContext.
    ///
    /// - Returns: MicroApplicationContext
    internal class func currentApplicationContext() -> MicroApplicationContext? {
        return MicroKernelDriver.currentApplicationContext()
    }
}

public extension MicroKernel {
    
    /// Launch a MicroApplication, and handover control to this MicroApplication.
    ///
    /// - Parameters:
    ///   - appId: MicroApplication appId
    ///   - launchOptions: launch options
    public class func launchApplication(appId: String, launchOptions: [MicroApplicationLaunchOptionsKey: Any]?) {
        MicroKernelDriver.launchApplication(appId: appId, launchOptions: launchOptions)
    }
    
    /// Terminate a series of MicroApplication until first application with given appId.
    /// occurs and terminated.
    ///
    /// - Parameter appId: MicroApplication appId
    public class func terminateToApplication(appId: String) {
        MicroKernelDriver.terminateToApplication(appId: appId)
    }
    
    /// Verify that it is possibe to launch a MicroApplication by given appId.
    ///
    /// - Parameter appId: MicroApplication AppId
    /// - Returns: result flag
    public class func canLaunchMicroApplication(_ appId: String) -> Bool {
        return MicroKernelDriver.canLaunchMicroApplication(appId)
    }
    
    /// Boot MainApplication, MainApplication initialization handover to main function.
    ///
    /// - Parameter mainApplication: mainApplication
    public class func boot(_ platformMainApplication: PlatformMainApplication) {
        MicroKernelRouter.shared.registerInterceptor(interceptor: ApplicationRouterInterceptor())
        
        MicroKernelDriver.registerAspect(aspect: NavigationDriverAspect.shared)
        
        MicroKernelDriver.boot(platformMainApplication)
    }
}

public extension MicroKernel {
    
    /// Register MicroApplication.
    ///
    /// - Parameter applicationType: MicroApplication type
    public class func registerMicroApplication(_ applicationType: MicroApplication.Type) {
        MicroKernelDriver.registerMicroApplication(applicationType)
    }
    
    /// Register Driver Aspect
    ///
    /// - Parameter aspect: MicroKernelDriverAspect
    internal class func registerAspect(aspect: MicroKernelDriverAspect) {
        MicroKernelDriver.registerAspect(aspect: aspect)
    }
    
    /// Register Router Interceptor
    ///
    /// - Parameter interceptor: MicroKernelRouterInterceptor
    public class func registerInterceptor(interceptor: MicroKernelRouterInterceptor) {
        MicroKernelRouter.shared.registerInterceptor(interceptor: interceptor)
    }
}

public extension MicroKernel {
    
    /// Launch a MicroApplication by URL, verify first, API looks a lot like system
    /// UIApplication for a better unity.
    ///
    /// - Parameters:
    ///   - url: url's sheme as appId
    ///   - options: launch options
    ///   - completionHandler: launch completion call back
    public class func open(url: URL,
                           options: [MicroApplicationLaunchOptionsKey: Any]?,
                           completionHandler: ((Bool) -> Void)?) {
        MicroKernelRouter.shared.open(url: url, options: options, completionHandler: completionHandler)
    }

    /// Verify that the URL is possible to launch MicroApplication. API looks a lot
    /// like system UIApplication for a better unity.
    ///
    /// - Parameters:
    ///   - url: url's sheme as appId
    ///   - options: launch options
    /// - Returns: result flag
    public class func canOpenURL(url: URL,
                                 options: [MicroApplicationLaunchOptionsKey: Any]?) -> Bool {
        return MicroKernelRouter.shared.canOpenURL(url: url, options:options)
    }
}

public extension MicroKernel {
    
    /// Register as a subscriber, wait for event with no expect event type.
    ///
    /// - Parameters:
    ///   - subscriber: subscriber object
    ///   - eventName: event Id
    ///   - handler: event arrival call back
    public class func register(subscriber: AnyObject,
                               eventName: String,
                               handler: @escaping (() -> Void)) {
        MicroKernelEventBus.default.register(subscriber: subscriber, eventName: eventName, handler: handler)
    }
    
    /// Register as a subscriber, wait for event with no expect event type.
    ///
    /// - Parameters:
    ///   - subscriber: stringify subscriber Id
    ///   - eventName: event Id
    ///   - handler: event arrival call back
    public class func register(subscriber: String,
                               eventName: String,
                               handler: @escaping (() -> Void)) {
        MicroKernelEventBus.default.register(subscriber: subscriber, eventName: eventName, handler: handler)
    }
    
    /// Register as a subscriber, wait for event with certain expect event type.
    ///
    /// - Parameters:
    ///   - subscriber: subscriber object
    ///   - eventName: event Id
    ///   - expectType: expect event type
    ///   - handler: event arrival call back
    public class func register<ExpectType>(subscriber: AnyObject,
                                           eventName: String,
                                           expectType: ExpectType.Type,
                                           handler: @escaping ((ExpectType?) -> Void)) {
        MicroKernelEventBus.default.register(subscriber: subscriber,
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
    public class func register<ExpectType>(subscriber: String,
                                           eventName: String,
                                           expectType: ExpectType.Type,
                                           handler: @escaping ((ExpectType?) -> Void)) {
        MicroKernelEventBus.default.register(subscriber: subscriber,
                                             eventName: eventName,
                                             expectType: expectType,
                                             handler: handler)
    }
    
    /// Unregister as a subscriber, for all event.
    ///
    /// - Parameters:
    ///   - subscriber: subscriber object
    public class func unregister(subscriber: AnyObject) {
        MicroKernelEventBus.default.unregister(subscriber: subscriber)
    }
    
    /// Unregister as a subscriber, for all event.
    ///
    /// - Parameters:
    ///   - subscriber: stringify subscriber Id
    public class func unregister(subscriber: String) {
        MicroKernelEventBus.default.unregister(subscriber: subscriber)
    }
    
    /// Unregister as a subscriber, for exactly event with all expect type.
    ///
    /// - Parameters:
    ///   - subscriber: subscriber object
    ///   - eventName: event Id
    public class func unregister(subscriber: AnyObject, eventName: String) {
        MicroKernelEventBus.default.unregister(subscriber: subscriber, eventName: eventName)
    }
    
    /// Unregister as a subscriber, for exactly event with all expect type.
    ///
    /// - Parameters:
    ///   - subscriber: stringify subscriber Id
    ///   - eventName: event Id
    public class func unregister(subscriber: String, eventName: String) {
        MicroKernelEventBus.default.unregister(subscriber: subscriber, eventName: eventName)
    }
    
    /// Unregister as a subscriber, for exactly event with no expect type.
    ///
    /// - Parameters:
    ///   - subscriber: subscriber object
    ///   - eventName: event Id
    public class func unregisterNoExpect(subscriber: AnyObject, eventName: String) {
        MicroKernelEventBus.default.unregisterNoExpect(subscriber: subscriber, eventName: eventName)
    }
    
    /// Unregister as a subscriber, for exactly event with no expect type.
    ///
    /// - Parameters:
    ///   - subscriber: stringify subscriber Id
    ///   - eventName: event Id
    public class func unregisterNoExpect(subscriber: String, eventName: String) {
        MicroKernelEventBus.default.unregisterNoExpect(subscriber: subscriber, eventName: eventName)
    }
    
    /// Unregister as a subscriber, for exactly event with certain expect type.
    ///
    /// - Parameters:
    ///   - subscriber: subscriber object
    ///   - eventName: event Id
    ///   - expectType: expect event type
    public class func unregister<ExpectType>(subscriber: AnyObject,
                                             eventName: String,
                                             expectType: ExpectType.Type) {
        MicroKernelEventBus.default.unregister(subscriber: subscriber,
                                               eventName: eventName,
                                               expectType: expectType)
    }
    
    /// Unregister as a subscriber, for exactly event with certain expect type.
    ///
    /// - Parameters:
    ///   - subscriber: stringify subscriber Id
    ///   - eventName: event Id
    ///   - expectType: expect event type
    public class func unregister<ExpectType>(subscriber: String,
                                             eventName: String,
                                             expectType: ExpectType.Type) {
        MicroKernelEventBus.default.unregister(subscriber: subscriber,
                                               eventName: eventName,
                                               expectType: expectType)
    }
    
    /// Post as a publisher, with no expect event type.
    ///
    /// - Parameters:
    ///   - eventName: event Id
    public class func post(eventName: String) {
        MicroKernelEventBus.default.post(eventName: eventName)
    }
    
    /// Post as a publisher, with certain expect event type.
    ///
    /// - Parameters:
    ///   - eventName: event Id
    ///   - expectType: expect event type
    ///   - event: event subject
    public class func post<EventType>(eventName: String,
                                      eventType: EventType.Type,
                                      event: EventType) {
        MicroKernelEventBus.default.post(eventName: eventName,
                                         eventType: eventType,
                                         event: event)
    }
}
