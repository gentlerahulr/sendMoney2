import UIKit

class RootViewControllerRouter {
    
    class func setLoginNavAsRootVC(animated: Bool) {
        let navigation = UINavigationController.instantiateFromStoryboard(
            storyboardName: StoryboardName.Login,
            storyboardId: StoryboardId.LoginNavViewController)
        setRootNavVC(navigationVC: navigation, animated: animated)
    }
    
    class func setHomeNavAsRootVC(animated: Bool) {
        let navigation = UINavigationController.instantiateFromStoryboard(
            storyboardName: StoryboardName.Main,
            storyboardId: StoryboardId.HomeNavViewController)
        setRootNavVC(navigationVC: navigation, animated: true)
    }
    
    class func popToManageWallettVC(animated: Bool, navigationController: UINavigationController?) {
        guard let navigationVC = navigationController else { return }
        for vc in navigationVC.viewControllers {
            if vc is ManageWalletViewController {
                navigationVC.popToViewController(vc, animated: true)
            }
        }
    }
    
    class func setDashboardAsRootVC(animated: Bool) {
        setTabbarAsRootVC(animated: true, initialVCIndex: 3)
    }
    
    class func setTabbarAsRootVC(animated: Bool, initialVCIndex: Int = 0) {
        let storyboard = UIStoryboard(name: StoryboardName.TabBar, bundle: nil)
        let initialViewController = storyboard.instantiateViewController(withIdentifier: StoryboardName.TabBar) as? TabbarController
        initialViewController?.selectedTabBarIndex = initialVCIndex
        initialViewController?.previousSelectedTabBarIndex = initialVCIndex
        let window = getWindow()
        window?.rootViewController = initialViewController
        window?.makeKeyAndVisible()
    }
    
    class func getWindow() -> UIWindow? {
        if #available(iOS 13.0, *) {
            let scene = UIApplication.shared.connectedScenes.first
            let sd: SceneDelegate? = (scene?.delegate as? SceneDelegate)
            guard let window = sd?.window else {
                debugPrint("Unable to get SceneDelegate window object")
                return nil
            }
            return window
        } else {
            let appDelegate = UIApplication.shared.delegate as? AppDelegate
            guard let window =  appDelegate?.window else {
                debugPrint("Unable to get Appdelaegate window object")
                return nil
            }
            return window
        }
    }
    
    class func getRootViewController() -> UIViewController? {
        guard let window = getWindow() else {
            return nil
        }
        if window.rootViewController is UINavigationController {
            guard let nVC = window.rootViewController as? UINavigationController else {
                return nil
            }
            return nVC.viewControllers.last
        }
        return window.rootViewController
    }
    
    private class func setRootNavVC(navigationVC: UINavigationController, animated: Bool) {
        guard let window = getWindow() else {
            debugPrint("Unable to get SceneDelegate window object")
            return
        }
        if animated {
            UIView.transition(with: window, duration: 0.5, options: .transitionFlipFromLeft, animations: {
                window.rootViewController = navigationVC
            }, completion: nil)
            
        } else {
            window.rootViewController = navigationVC
        }
    }
    private class func setRootVC(navigationVC: UIViewController, animated: Bool) {
        guard let window = getWindow() else {
            debugPrint("Unable to get SceneDelegate window object")
            return
        }
        if animated {
            UIView.transition(with: window, duration: 0.5, options: .transitionFlipFromLeft, animations: {
                window.rootViewController = navigationVC
            }, completion: nil)
            
        } else {
            window.rootViewController = navigationVC
        }
    }
}
