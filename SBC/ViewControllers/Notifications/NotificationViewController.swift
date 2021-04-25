import UIKit

class NotificationViewController: BaseViewController {
    
    @IBOutlet weak var imageViewNotification: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDesc: UILabel!
    @IBOutlet weak var lblContact: UILabel!
    @IBOutlet weak var btnNotificationHandler: UIButton!
    @IBOutlet weak var backgroundView: UIView?
    
    var viewModel: NotificationViewModelProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupUI()
    }
    
    @IBAction func btnNotificationAction(_ sender: UIButton) {
        let buttonText = viewModel?.btnNotificationHandlerConfig.titleText
        if   buttonText == localizedStringForKey(key: "button.title.back_to_home") || buttonText == localizedStringForKey(key: "wallet_success_btn") {
            RootViewControllerRouter.setDashboardAsRootVC(animated: false)
        } else if buttonText == localizedStringForKey(key: "button.title.back_to_wallet") {
            self.navigationController?.popToRootViewController(animated: true)
        } else if buttonText == localizedStringForKey(key: "button.title.topUP") {
            for controller in self.navigationController!.viewControllers as Array {
                if controller.isKind(of: TopUpAmountViewController.self) {
                    self.navigationController?.popToViewController(controller, animated: true)
                    break
                }
            }
           
        } else if buttonText == localizedStringForKey(key: "button.title.withdraw") {
            for controller in self.navigationController!.viewControllers as Array {
                if controller.isKind(of: WithdrawAmountViewController.self) {
                    self.navigationController?.popToViewController(controller, animated: true)
                    break
                }
            }
        } else {
            navigateToOTPHandlerVC()
        }
    }
    
    func setupUI() {
        imageViewNotification.image = UIImage(named: viewModel?.dataModel?.imageName ?? "")
        lblTitle.setLabelConfig(lblConfig: viewModel?.lblTitleConfig)
        lblDesc.setLabelConfig(lblConfig: viewModel?.lblDescConfig)
        lblContact.setLabelConfig(lblConfig: viewModel?.lblContactConfig)
        if let colorString = viewModel?.dataModel?.backgroundColor {
            backgroundView?.drawCustomRect(fillColor: UIColor.getUIColorFromHexCode(colorCode: colorString, alpha: 1))
            
            self.view.backgroundColor = UIColor.white
        }
        btnNotificationHandler.setButtonConfig(btnConfig: viewModel?.btnNotificationHandlerConfig)
    }
    
    override func setupViewModel() {
        viewModel = NotificationViewModel()
        viewModel?.delegate = self
    }
    
    private func navigateToOTPHandlerVC() {
        let vc = OTPHandlingViewController.instantiateFromStoryboard(storyboardName: StoryboardName.Verification, storyboardId: StoryboardId.OTPHandlingViewController)
        let model = OTPModel(title: K.Verify_Email_Title, desc: K.Verify_Email_Desc, contactInfo: lblContact.text, resendTitle: K.Verify_Email_Resend_Title)
        vc.viewModel?.model = model
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension NotificationViewController: NotificationDataPassingDelegate {
    
}
