//      __  ____                 __ __                     __
//     /  |/  (_)_____________  / //_/__  _________  ___  / /
//    / /|_/ / / ___/ ___/ __ \/ ,< / _ \/ ___/ __ \/ _ \/ /
//   / /  / / / /__/ /  / /_/ / /| /  __/ /  / / / /  __/ /
//  /_/  /_/_/\___/_/   \____/_/ |_\___/_/  /_/ /_/\___/_/
//

import Foundation

/// Summary: The external aspect programming of the MicroKernelDriver control and coordination.

public protocol MicroKernelDriverAspect {
    
    /// Boot action
    func boot()
    
    /// Will start launch action.
    ///
    /// - Parameters:
    ///   - application: launch application
    ///   - launchOptions: launch options
    func applicationWillStartLaunching(_ application: MicroApplication,
                                       launchOptions: [MicroApplicationLaunchOptionsKey: Any]?)
    
    /// Did finish launch action.
    ///
    /// - Parameter application: launch application
    func applicationDidFinishLaunching(_ application: MicroApplication)
    
    /// Will terminate action.
    ///
    /// - Parameter application: launch application
    func applicationWillTerminate(_ application: MicroApplication)
    
    /// Did terminate action.
    ///
    /// - Parameter application: launch application
    func applicationDidTerminate(_ application: MicroApplication)
}
