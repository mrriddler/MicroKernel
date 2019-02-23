//      __  ____                 __ __                     __
//     /  |/  (_)_____________  / //_/__  _________  ___  / /
//    / /|_/ / / ___/ ___/ __ \/ ,< / _ \/ ___/ __ \/ _ \/ /
//   / /  / / / /__/ /  / /_/ / /| /  __/ /  / / / /  __/ /
//  /_/  /_/_/\___/_/   \____/_/ |_\___/_/  /_/ /_/\___/_/
//

import UIKit

/// Summary: The centralized point of control and coordination for MicroApplication,
/// MicroApplicationContext, MainApplication, MainApplicationContext.

/// Discussion: Driver simulate application switchover as a stack.
/// Dring switchover, Driver would manage application and context lifetime.
/// Driver construct ControlBlock to keep tracking status and entity of
/// application and context.

internal class MicroKernelDriver {
    
    internal static let shared = MicroKernelDriver()
    
    fileprivate var applicationTable: [String: MicroApplication.Type] = [:]
    
    fileprivate var mainCB: MainApplicationControlBlock?
    
    fileprivate var applicationStack: [MicroApplicationControlBlock] = []
    
    fileprivate var aspects: [MicroKernelDriverAspect] = []
    
    /// Find Dependency in order, current scope first global scope again.
    ///
    /// - Parameter registerType: dependency prototype type
    /// - Returns: dependency entity
    internal class func findDependency<RegisterType>(registerType: RegisterType.Type) -> Dependency? {
        if let microApplicationCB = shared.applicationStack.last {
            return microApplicationCB.applicationContext().findDependency(registerType: registerType)
        }
        
        if let mainCB = shared.mainCB {
            return mainCB.mainContext().findDependency(registerType: registerType)
        }
        
        return nil
    }
    
    /// Launch a MicroApplication, and handover control to this MicroApplication.
    ///
    /// - Parameters:
    ///   - appId: MicroApplication appId
    ///   - launchOptions: launch options
    internal class func launchApplication(appId: String,
                                         launchOptions: [MicroApplicationLaunchOptionsKey: Any]?) {
        guard let applicationType = shared.applicationTable[appId] else {
            return
        }
        
        let applicaionCB: MicroApplicationControlBlock = MicroApplicationControlBlock(applicationType: applicationType, launchOptions: launchOptions, mainContext: shared.mainCB?.mainContext() as! MainApplicationContextEntity)
        
        switchContextPush(applicationCB: applicaionCB, launchingOptions: launchOptions)
    }
    
    /// Terminate a series of MicroApplication until first application with given appId
    /// occurs and terminated.
    ///
    /// - Parameter appId: MicroApplication appId
    internal class func terminateToApplication(appId: String) {
        _ = switchContextPop(appId: appId)
    }
    
    /// Boot MainApplication, MainApplication initialization handover to main function.
    ///
    /// - Parameter mainApplication: mainApplication
    internal class func boot(_ mainApplication: MainApplication) {
        shared.mainCB = MainApplicationControlBlock(application: mainApplication)
        shared.mainCB?.application.boot()
        shared.mainCB?.injectDependency()
        
        shared.aspects.forEach({ $0.boot() })
    }
    
    /// Access MainApplication.
    ///
    /// - Returns: MainApplication
    internal class func mainApplication() -> MainApplication? {
        return shared.mainCB?.application
    }
    
    /// Access MainApplicationContext.
    ///
    /// - Returns: MainApplicationContext
    internal class func mainApplicationContext() -> MainApplicationContext? {
        return shared.mainCB?.mainContext()
    }
    
    /// Access current MicroApplication.
    ///
    /// - Returns: MicroApplication
    internal class func currentApplication() -> MicroApplication? {
        return shared.applicationStack.last?.application
    }
    
    /// Access current MicroApplicationContext.
    ///
    /// - Returns: MicroApplicationContext
    internal class func currentApplicationContext() -> MicroApplicationContext? {
        return shared.applicationStack.last?.applicationContext()
    }
    
    /// Register MicroApplication.
    ///
    /// - Parameter applicationType: MicroApplication type
    internal class func registerMicroApplication(_ applicationType: MicroApplication.Type) {
        shared.applicationTable[applicationType.appId()] = applicationType
    }
    
    /// Verify that it is possibe to launch a MicroApplication by given appId.
    ///
    /// - Parameter appId: MicroApplication AppId
    /// - Returns: result flag
    internal class func canLaunchMicroApplication(_ appId: String) -> Bool {
        if shared.applicationTable[appId] != nil {
            return true
        }
        
        return false
    }
    
    /// Register Driver Aspect.
    ///
    /// - Parameter aspect: MicroKernelDriverAspect
    internal class func registerAspect(aspect: MicroKernelDriverAspect) {
        shared.aspects.append(aspect)
    }
    
    fileprivate class func switchContextPush(applicationCB: MicroApplicationControlBlock,
                                             launchingOptions launchOptions: [MicroApplicationLaunchOptionsKey: Any]?) {
        let topApplication: MicroApplicationControlBlock? = shared.applicationStack.last
        
        shared.applicationStack.append(applicationCB)
        
        shared.aspects.forEach({ $0.applicationWillStartLaunching(applicationCB.application, launchOptions: launchOptions) })
        
        applicationCB.application.applicationWillStartLaunching(applicationCB.application, launchOptions: launchOptions)
        
        topApplication?.application.applicationWillResignActive(topApplication!.application)
        
        shared.aspects.forEach({ $0.applicationDidFinishLaunching(applicationCB.application) })
        
        applicationCB.application.applicationDidFinishLaunching(applicationCB.application)
        
        topApplication?.application.applicationDidResignActive(topApplication!.application)
    }
    
    fileprivate class func switchContextPop(appId: String) -> MicroApplicationControlBlock? {
        guard shared.applicationStack.contains(where: { $0.appId == appId }) else {
            return nil
        }
        
        var slowCursor: Int = shared.applicationStack.count - 1
        var fastCursor: Int = slowCursor - 1
        
        var isActive: Bool = true
        
        while slowCursor >= 0 && shared.applicationStack[slowCursor].appId != appId {
            terminateApplication(idx: slowCursor, isActive: isActive)
            isActive = false
            
            slowCursor = fastCursor
            fastCursor -= 1
        }
        
        terminateApplication(idx: slowCursor, isActive: isActive)
        
        if slowCursor < 1 {
            return nil
        }
        
        let resumeApplication: MicroApplicationControlBlock = shared.applicationStack[slowCursor - 1]
        resumeApplication.application.applicationWillBecomeActive(resumeApplication.application)
        resumeApplication.application.applicationDidBecomeActive(resumeApplication.application)
        
        return resumeApplication
    }
    
    fileprivate class func topApplicationCB(appId: String) -> MicroApplicationControlBlock? {
        var cursor = shared.applicationStack.count - 1
        while cursor >= 0 {
            let testApplicationCB: MicroApplicationControlBlock = shared.applicationStack[cursor]
            
            if testApplicationCB.appId == appId {
                return testApplicationCB
            }
            
            cursor = cursor - 1
        }
        
        return nil
    }
    
    fileprivate class func terminateApplication(idx: Int, isActive: Bool) {
        let terminateApplication: MicroApplication = shared.applicationStack[idx].application
        
        if !isActive {
            terminateApplication.applicationWillBecomeActive(terminateApplication)
            
            terminateApplication.applicationDidBecomeActive(terminateApplication)
        }
        
        shared.aspects.forEach({ $0.applicationWillTerminate(terminateApplication) })
        
        terminateApplication.applicationWillTerminate(terminateApplication)
        
        shared.aspects.forEach({ $0.applicationDidTerminate(terminateApplication) })
        
        terminateApplication.applicationDidTerminate(terminateApplication)
        
        unregisterApplicationEventSubscriber(applicationCB: shared.applicationStack[idx])
        
        shared.applicationStack.remove(at: idx)
    }
}

extension MicroKernelDriver {
    
    internal class func registerEventSubscriber(appId: String, subscriber: String) {
        if let applicationCB: MicroApplicationControlBlock = topApplicationCB(appId: appId) {
            applicationCB.registerSubscriber(subscriber: subscriber)
        }
    }
    
    fileprivate class func unregisterApplicationEventSubscriber(applicationCB: MicroApplicationControlBlock) {
        applicationCB.applicationEventSubscriber().forEach({ applicationCB.application.unregister(subscriber: $0) })
    }
}

extension MicroKernelDriver {
    
    internal class func resignActive() {
        guard let application = MicroKernelDriver.currentApplication() else {
            return
        }
        
        application.applicationWillResignActive(application)
        application.applicationDidResignActive(application)
    }
    
    internal class func becomeActive() {
        guard let application = MicroKernelDriver.currentApplication() else {
            return
        }
        
        application.applicationWillBecomeActive(application)
        application.applicationDidBecomeActive(application)
    }
}
