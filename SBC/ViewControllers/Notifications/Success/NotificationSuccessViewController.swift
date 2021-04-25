import UIKit

class NotificationSuccessViewController: BaseViewController {
    
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var buttonSuccess: UIButton!
    
    var viewModel: NotificationSuccessVieweModelProtocol?
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func setupViewModel() {
        viewModel =  NotificationSuccessViewModel()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    private func setupUI() {
        labelTitle.setLabelConfig(lblConfig: viewModel?.labelTitleConfig)
        buttonSuccess.setButtonConfig(btnConfig: viewModel?.buttonSuccessConfig)
    }
    
    @IBAction func buttonSuccessAction(_ sender: UIButton) {
        handleNavigation(buttonText: buttonSuccess.titleLabel?.text ?? "")
    }
    //Navigation
    private func handleNavigation(buttonText: String) {
        if buttonText == "Log in" {
            RootViewControllerRouter.setLoginNavAsRootVC(animated: false)
        } else if buttonText == localizedStringForKey(key: "button.title.go_to_wallet")  || buttonText == localizedStringForKey(key: "button.title.back_to_wallet") {
            self.navigationController?.popToRootViewController(animated: true)
        }
    }
    
}
