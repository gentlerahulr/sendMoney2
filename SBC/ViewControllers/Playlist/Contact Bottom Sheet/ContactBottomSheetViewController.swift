import UIKit

class ContactBottomSheetViewController: UIViewController {
    
    @IBOutlet private weak var contentView: UIView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var phoneNumberStackView: UIStackView!
    @IBOutlet private weak var phoneButton: UIButton!
    @IBOutlet private weak var phoneNumberLabel: UILabel!
    @IBOutlet private weak var bookingButton: UIButton!
    @IBOutlet private weak var facebookView: UIView!
    @IBOutlet private weak var instagramView: UIView!
    @IBOutlet private weak var websiteView: UIView!
    @IBOutlet private weak var contentViewBottomConstraint: NSLayoutConstraint!
    var venue: Venue?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    private func setupView() {
        contentView.layer.cornerRadius = 15
        contentView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        titleLabel.setLabelConfig(lblConfig: LabelConfig.getBoldLabelConfig(text: localizedStringForKey(key: "contactsheet_title"), fontSize: 16, textAlignment: .center))
        
        if let venue = venue {
            if let phoneNumber = venue.phoneNumber {
                phoneNumberLabel.setLabelConfig(lblConfig: LabelConfig.getRegularLabelConfig(text: phoneNumber, fontSize: 13))
                phoneButton.backgroundColor = UIColor.themeNeonBlue
                phoneNumberStackView.isHidden = false
            } else {
                phoneNumberStackView.isHidden = true
            }
            
            facebookView.isHidden = venue.facebookUrl == nil
            facebookView.layer.borderWidth = 2
            facebookView.layer.borderColor = UIColor.themeDarkBlueTint3.cgColor
            instagramView.isHidden = venue.instagramUrl == nil
            instagramView.layer.borderWidth = 2
            instagramView.layer.borderColor = UIColor.themeDarkBlueTint3.cgColor
            websiteView.isHidden = venue.websiteUrl == nil
            websiteView.layer.borderWidth = 2
            websiteView.layer.borderColor = UIColor.themeDarkBlueTint3.cgColor
            bookingButton.isHidden = venue.bookingUrl == nil
            bookingButton.setButtonConfig(btnConfig: ButtonConfig.getBoldButtonConfig(titleText: localizedStringForKey(key: "contactsheet_booking"), fontSize: 16, textColor: UIColor.themeDarkBlue, backgroundColor: UIColor.themeNeonBlue, cornerRadius: 8))
            bookingButton.borderColor = UIColor.themeNeonBlue
            
        }
    }
    
    @IBAction func closeAction(_ sender: Any) {
        dismissSheet()
    }
    
    private func dismissSheet() {
        if let parent = parent as? BottomSheetViewController {
            parent.dismissViewController()
        }
    }
    
    @IBAction func callAction(_ sender: Any) {
        if let number = venue?.phoneNumber, let url = URL(string: "tel://\(number.removingWhitespaces())") {
            UIApplication.shared.open(url, options: [:]) { _ in
                self.dismissSheet()
            }
        }
    }
    @IBAction func copyNumberAction(_ sender: Any) {
        let pasteboard = UIPasteboard.general
        pasteboard.string = venue?.phoneNumber
        AlertViewAdapter.shared.showBottomMessageWithDismiss("Number copied", details: nil, state: .success)
        dismissSheet()
    }
    @IBAction func openFacebookAction(_ sender: Any) {
        if let facebookUrl = venue?.facebookUrl, let url = URL(string: facebookUrl) {
            UIApplication.shared.open(url, options: [:]) { _ in
                self.dismissSheet()
            }
        }
    }
    @IBAction func openInstagramAction(_ sender: Any) {
        if let instagramUrl = venue?.instagramUrl, let url = URL(string: instagramUrl) {
            UIApplication.shared.open(url, options: [:]) { _ in
                self.dismissSheet()
            }
        }
    }
    @IBAction func openWebsiteAction(_ sender: Any) {
        if let websiteUrl = venue?.websiteUrl, let url = URL(string: websiteUrl) {
            UIApplication.shared.open(url, options: [:]) { _ in
                self.dismissSheet()
            }
        }
    }
    @IBAction func openBookingAction(_ sender: Any) {
        if let bookingUrl = venue?.bookingUrl, let url = URL(string: bookingUrl) {
            UIApplication.shared.open(url, options: [:]) { _ in
                self.dismissSheet()
            }
        }
    }
}
