//      __  ____                 __ __                     __
//     /  |/  (_)_____________  / //_/__  _________  ___  / /
//    / /|_/ / / ___/ ___/ __ \/ ,< / _ \/ ___/ __ \/ _ \/ /
//   / /  / / / /__/ /  / /_/ / /| /  __/ /  / / / /  __/ /
//  /_/  /_/_/\___/_/   \____/_/ |_\___/_/  /_/ /_/\___/_/
//

import UIKit

open class MicroKernelNavigationController: UINavigationController, UINavigationControllerDelegate {
    
    private var popIfNeededVC: UIViewController?
    
    override open func pushViewController(_ viewController: UIViewController, animated: Bool) {
        super.pushViewController(viewController, animated: animated)
        NavigationDriverAspect.shared.push(viewController)
    }
    
    override open func popViewController(animated: Bool) -> UIViewController? {
        guard let res = super.popViewController(animated: animated) else {
            return nil
        }
        
        self.popIfNeededVC = res
        
        return res
    }
    
    override open func popToViewController(_ viewController: UIViewController, animated: Bool) -> [UIViewController]? {
        guard let res = super.popToViewController(viewController, animated: animated) else {
            return nil
        }
        
        res.forEach({ NavigationDriverAspect.shared.pop($0) })
        
        return res
    }
    
    override open func popToRootViewController(animated: Bool) -> [UIViewController]? {
        guard let res = super.popToRootViewController(animated: animated) else {
            return nil
        }
        
        NavigationDriverAspect.shared.popToRootViewController(res)
        
        return res
    }
    
    override open func setViewControllers(_ viewControllers: [UIViewController], animated: Bool) {
        var popedVC: [UIViewController] = self.viewControllers
        popedVC = popedVC.filter({ !viewControllers.contains($0) })
        super.setViewControllers(viewControllers, animated: animated)
        NavigationDriverAspect.shared.setViewControllers(popedVC)
    }
    
    override open func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        NavigationDriverAspect.shared.dismiss(self.collectPresentingViewController(viewController: self))

        super.dismiss(animated: flag, completion: {
            if let completion = completion {
                completion()
            }
        })
    }
    
    open func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        
        if let popIfNeededVC = self.popIfNeededVC {
            if !self.viewControllers.contains(popIfNeededVC) {
                NavigationDriverAspect.shared.pop(popIfNeededVC)
            }
            self.popIfNeededVC = nil
        }
    }
}
