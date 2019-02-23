//      __  ____                 __ __                     __
//     /  |/  (_)_____________  / //_/__  _________  ___  / /
//    / /|_/ / / ___/ ___/ __ \/ ,< / _ \/ ___/ __ \/ _ \/ /
//   / /  / / / /__/ /  / /_/ / /| /  __/ /  / / / /  __/ /
//  /_/  /_/_/\___/_/   \____/_/ |_\___/_/  /_/ /_/\___/_/
//

import Foundation

internal class MicroApplicationControlBlock {
    
    internal let appId: String
    
    internal let application: MicroApplication
    
    fileprivate var context: MicroApplicationContext
    
    fileprivate var eventSubscriber: [String] = []
    
    init(applicationType: MicroApplication.Type,
         launchOptions: [MicroApplicationLaunchOptionsKey: Any]?,
         mainContext: MainApplicationContextEntity) {
        application = applicationType.init()
        
        appId = applicationType.appId()
        
        context = MicroApplicationContextEntity(launchOptions: launchOptions, mainContext: mainContext)
        
        _ = injectDependency()
    }
    
    internal func injectDependency() -> MicroApplicationContext {
        context = application.applicationInjectDependency(context: context)
        
        return context
    }
    
    internal func applicationContext() -> MicroApplicationContext {
        return context
    }
    
    internal func registerSubscriber(subscriber: String) {
        if !eventSubscriber.contains(subscriber) {
            eventSubscriber.append(subscriber)
        }
    }
    
    internal func unregisterSubscriber(subscriber: String) {
        if let idx = eventSubscriber.firstIndex(of: subscriber) {
            eventSubscriber.remove(at: idx)
        }
    }
    
    internal func applicationEventSubscriber() -> [String] {
        return eventSubscriber
    }
}
