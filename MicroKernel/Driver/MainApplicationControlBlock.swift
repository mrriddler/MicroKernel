//      __  ____                 __ __                     __
//     /  |/  (_)_____________  / //_/__  _________  ___  / /
//    / /|_/ / / ___/ ___/ __ \/ ,< / _ \/ ___/ __ \/ _ \/ /
//   / /  / / / /__/ /  / /_/ / /| /  __/ /  / / / /  __/ /
//  /_/  /_/_/\___/_/   \____/_/ |_\___/_/  /_/ /_/\___/_/
//

import Foundation

internal class MainApplicationControlBlock {
    
    internal let application: MainApplication
    
    fileprivate var context: MainApplicationContext

    init(application: MainApplication) {
        self.application = application
        context = MainApplicationContextEntity()
    }
    
    internal func injectDependency() {
        context = application.applicationInjectDependency(context)
    }
    
    internal func mainContext() -> MainApplicationContext {
        return context
    }
}
