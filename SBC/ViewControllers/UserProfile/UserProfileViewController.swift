import UIKit

class UserProfileViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func loggedOutAction(_ sender: UIBarButtonItem) {
        UserDefaults.standard.isLoggedIn = false
        KeyChainServiceWrapper.standard.appAuthToken = nil
        KeyChainServiceWrapper.standard.authToken = nil
        RootViewControllerRouter.setLoginNavAsRootVC(animated: false)
    }
    
}
