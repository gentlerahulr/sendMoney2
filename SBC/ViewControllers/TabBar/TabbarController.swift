import UIKit

class TabbarController: UITabBarController {
    
    fileprivate lazy var defaultTabBarHeight = { tabBar.frame.size.height }()
    var selectedTabBarIndex = 0
    var previousSelectedTabBarIndex = 0
    ///Code In this class is in testing
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.tabBarSetUp()
        self.selectedIndex = selectedTabBarIndex
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        configureTabBarAsPerScreen()
    }
    
    /// This function is used to configure tabbar to screen size
    func configureTabBarAsPerScreen() {
        ///Device Without Notch
        configureIconForTabBar()
       // configureTabBarHeight()
    }
    
    func configureTabBarHeight() {
        let newTabBarHeight = defaultTabBarHeight
        var newFrame = tabBar.frame
        newFrame.size.height = newTabBarHeight
        newFrame.origin.y = view.frame.size.height - newTabBarHeight
        tabBar.frame = newFrame
    }
    
    func configureIconForTabBar() {
        ///Use this function for Image Size and top/bottom padding
        for tabBarItem in tabBar.items! {
            tabBarItem.imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
    }
}
extension TabbarController: UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if selectedTabBarIndex == tabBarController.selectedIndex {
            return
        }
        selectedTabBarIndex  = tabBarController.selectedIndex
        if let navigationVC = viewController as? UINavigationController, !navigationVC.viewControllers.isEmpty, let dashboardVC = navigationVC.viewControllers [0] as? DashBoardViewController {
            navigationVC.popViewController(animated: false)
            dashboardVC.shouldCallGetWalletStatusAPI = true
            return
        }
        previousSelectedTabBarIndex = tabBarController.selectedIndex
    }
}
