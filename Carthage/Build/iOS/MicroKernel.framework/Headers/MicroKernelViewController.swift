//      __  ____                 __ __                     __
//     /  |/  (_)_____________  / //_/__  _________  ___  / /
//    / /|_/ / / ___/ ___/ __ \/ ,< / _ \/ ___/ __ \/ _ \/ /
//   / /  / / / /__/ /  / /_/ / /| /  __/ /  / / / /  __/ /
//  /_/  /_/_/\___/_/   \____/_/ |_\___/_/  /_/ /_/\___/_/
//

import UIKit

open class MicroKernelViewController: UIViewController {
    
    override open func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)? = nil) {
        NavigationDriverAspect.shared.present(viewControllerToPresent)
        super.present(viewControllerToPresent, animated: flag, completion: completion)
    }
    
    override open func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        NavigationDriverAspect.shared.dismiss(self.collectPresentingViewController(viewController: self))

        super.dismiss(animated: flag, completion: {
            if let completion = completion {
                completion()
            }
        })
    }
}

extension UIViewController {
    
    /// case 1: presenting - *vc*
    /// case 2: presenting - *nav* - vc - vc
    /// case 3: presenting - nav - vc - *vc*
    /// case 4: presenting - *nav* - vc - vc - nav - vc - vc
    /// case 5: presenting - nav - vc - *vc* - nav - vc - vc
    internal func collectPresentingViewController(viewController: UIViewController) -> [UIViewController] {
        
        var res: [UIViewController] = []
        
        if let nav = viewController as? UINavigationController {
            res.append(contentsOf: collectPresentingViewControllerFrom(navigationController: nav))
        } else if viewController.presentingViewController != nil {
            if let nav = viewController.navigationController {
                res.append(contentsOf: collectPresentingViewControllerFrom(navigationController: nav))
            } else {
                res.append(viewController)
            }
        }
        
        return res
    }
    
    internal func collectPresentingViewControllerFrom(navigationController: UINavigationController) -> [UIViewController] {
        
        var res: [UIViewController] = []
        
        navigationController.viewControllers.forEach { vc in
            if let nav = vc as? UINavigationController {
                res.append(contentsOf: collectPresentingViewControllerFrom(navigationController: nav))
            } else {
                res.append(vc)
            }
        }
        
        return res
    }
}
