//      __  ____                 __ __                     __
//     /  |/  (_)_____________  / //_/__  _________  ___  / /
//    / /|_/ / / ___/ ___/ __ \/ ,< / _ \/ ___/ __ \/ _ \/ /
//   / /  / / / /__/ /  / /_/ / /| /  __/ /  / / / /  __/ /
//  /_/  /_/_/\___/_/   \____/_/ |_\___/_/  /_/ /_/\___/_/
//

import UIKit

internal class NavigationDriverAspect: MicroKernelDriverAspect {
    
    internal static let shared = NavigationDriverAspect()
        
    fileprivate let index = NavigationApplicationIndex()
    
    internal func boot() {
        NotificationCenter.default.addObserver(NavigationDriverAspect.shared, selector: #selector(willEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
        
        NotificationCenter.default.addObserver(NavigationDriverAspect.shared, selector: #selector(willResignActive), name: UIApplication.willResignActiveNotification, object: nil)
    }
    
    internal func applicationWillStartLaunching(_ application: MicroApplication,
                                                launchOptions: [MicroApplicationLaunchOptionsKey: Any]?) {
        index.launchApplication(application)
    }
    
    internal func applicationDidFinishLaunching(_ application: MicroApplication) {}
    
    internal func applicationWillTerminate(_ application: MicroApplication) {}
    
    internal func applicationDidTerminate(_ application: MicroApplication) {
        index.terminateApplication(application)
    }
    
    internal func push(_ viewControllerToPush: UIViewController) {
        index.pushViewController(viewControllerToPush)
    }
    
    internal func pop(_ viewControllerToPop: UIViewController) {
        if let toBeTerminated = index.popViewController(viewControllerToPop) {
            toBeTerminated.forEach({ MicroKernelDriver.terminateToApplication(appId: $0) })
        }
    }
    
    internal func popToRootViewController(_ viewControllers: [UIViewController]) {
        if let toBeTerminated = index.popViewControllers(viewControllers) {
            toBeTerminated.forEach({ MicroKernelDriver.terminateToApplication(appId:$0) })
        }
    }
    
    internal func setViewControllers(_ viewControllers: [UIViewController]) {
        if let toBeTerminated = index.popViewControllers(viewControllers) {
            toBeTerminated.forEach({ MicroKernelDriver.terminateToApplication(appId: $0) })
        }
    }
    
    internal func present(_ viewControllerToPresent: UIViewController) {
        index.presentViewController(viewControllerToPresent)
    }
    
    internal func dismiss(_ viewControllerToDismiss: [UIViewController]) {
        if let toBeTerminated = index.dismissViewControllers(viewControllerToDismiss) {
            toBeTerminated.forEach({ MicroKernelDriver.terminateToApplication(appId: $0) })
        }
    }
    
    @objc internal func willEnterForeground() {
        MicroKernelDriver.becomeActive()
    }

    @objc internal func willResignActive() {
        MicroKernelDriver.resignActive()
    }
}
