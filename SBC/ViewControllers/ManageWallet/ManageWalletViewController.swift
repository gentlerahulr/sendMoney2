//
//  ManageWalletViewController.swift
//  SBC

import UIKit
import MSPeekCollectionViewDelegateImplementation

class ManageWalletViewController: BaseViewController {
    
    @IBOutlet weak var CardCollectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionViewTop: NSLayoutConstraint!
    var behavior: MSCollectionViewPeekingBehavior!
    var viewModel = ManageWalletViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        viewModel.delegate = self
        viewModel.getCardImageURLs()
        viewModel.getCardDetailList()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.getCustomerDetails()
        self.tabBarController?.tabBar.isHidden = false
    }
    
    override func leftButtonAction(button: UIButton) {
        self.navigationController?.popToRootViewController(animated: true)
    }
}

// MARK: - Setup Methods
extension ManageWalletViewController {
    func setupView() {
        let nib = UINib(nibName: "CardCollectionViewCell", bundle: nil)
        CardCollectionView.register(nib, forCellWithReuseIdentifier: "cell")
        tableView.tableFooterView = UIView(frame: .zero)
        behavior = MSCollectionViewPeekingBehavior(cellSpacing: viewModel.ManageWalletCellSpacing,
                                                   cellPeekWidth: viewModel.ManageWalletCellPeekWidth,
                                                   maximumItemsToScroll: Int(viewModel.ManageWalletMaximumItemsToScroll),
                                                   numberOfItemsToShow: Int(viewModel.ManageWalletNumberOfItemsToShow),
                                                   scrollDirection: .horizontal)
        CardCollectionView.configureForPeekingBehavior(behavior: behavior)
        CardCollectionView.reloadData()
        setUpHeader()
    }
    func setUpHeader() {
        showScreenTitleWithLeftBarButton(screenTitle: localizedStringForKey(key: "manage.wallet.screen.title"),
                                         leftButtonImage: ImageConstants.IMG_BACK_WHITE,
                                         screenTitleColor: colorConfig.dark_navigation_header_text_color, headerBGColor: .themeDarkBlue)
        UIDevice.current.hasNotch ? (collectionViewTop.constant = 124) : (collectionViewTop.constant = 104)
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}

// MARK: - Action Methods
extension ManageWalletViewController {
    
    var currentCardHashId: String {
        guard let cardList = viewModel.cardDetailList, behavior.currentIndex <= (cardList.cards.count - 1)  else {
            return ""
        }
        return cardList.cards[behavior.currentIndex].cardHashId
    }
    @objc func showHideButtonPressed() {
        if viewModel.isCardVisible {
            viewModel.isCardVisible = false
            viewModel.getCardDetails(cardHashId: currentCardHashId)
        } else {
            viewModel.isCardVisible = true
            viewModel.showCardDetails(cardHashId: currentCardHashId)
        }
        
    }
    
    @objc func updateMobileNoButtonPressed() {
        navigateToUpdateMobile()
    }
    
    @objc func copyButtonPressed() {
        copied(content: viewModel.unmaskCardDetailDict[currentCardHashId]?.unMaskedCardNumber ?? "")
        AlertViewAdapter.shared.show(viewModel.titles.cardNumberCopyMessage, state: .success)
    }
    
    @objc func biometricSwitchPressed(_ sender: UISwitch) {
        viewModel.updateBiometricStatus(sender: sender, viewController: self)
    }
    
    func navigateToUpdateMobile() {
        let model = AcceptMobileNumberModel(title: K.EMPTY, desc: localizedStringForKey(key: "Update.mobile.desc"), buttonText: localizedStringForKey(key: "button.title.Next"), endPoint: .updateMobileNo)
       let vc = AcceptMobileNumberViewController.instantiateFromStoryboard(storyboardName: StoryboardName.WalletFlow, storyboardId: StoryboardId.AcceptMobileNumberViewController)
       vc.viewModel.acceptMobileNumberModel = model
        self.tabBarController?.tabBar.isHidden = true
       self.navigationController?.pushViewController(vc, animated: true)
   }
    
    func navigateToUpdatePin() {
        let vc = CurrentPinViewController.instantiateFromStoryboard(storyboardName: StoryboardName.CurrentPin, storyboardId: StoryboardId.CurrentPinViewController)
        vc.viewModel?.mobileOTPType = .updatePin
        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    private func navigateToTnCVC() {
        let vc = TNCForWalletViewController.instantiateFromStoryboard(storyboardName: StoryboardName.TnC, storyboardId: StoryboardId.TNCForWalletViewController)
        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - Custom Methods
extension ManageWalletViewController {
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        behavior.scrollViewWillEndDragging(scrollView, withVelocity: velocity, targetContentOffset: targetContentOffset)
    }
}

// MARK: - CollectionView Delegate and Datasource Methods
extension ManageWalletViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.cardDetailList?.cards.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? CardCollectionViewCell {
            cell.showAndHideButton.addTarget(self, action: #selector(showHideButtonPressed), for: .touchUpInside)
            cell.copyButton.addTarget(self, action: #selector(copyButtonPressed), for: .touchUpInside)
            let card = viewModel.cardDetailList?.cards[indexPath.item]
            let cardHashId: String = card?.cardHashId ?? ""
            let cardCVVDetails = viewModel.cardCVVDetailDict[cardHashId]
            cell.userNameLabel.text = card?.firstAndLastName
            if viewModel.isCardVisible {
                cell.copyButton.isHidden = false
                cell.cardSubDetailContainerView.isHidden = false
                cell.showAndHideButton.setAttributedTitle(viewModel.setButtonTitleWithUnderline(title: viewModel.titles.hide), for: .normal)
                cell.cardNumberLabel.text = viewModel.unmaskCardDetailDict[cardHashId]?.unMaskedCardNumber.grouping(every: 4, with: " ")
                cell.cvvNumberLabel.text =  cardCVVDetails?.formattedCVV
                cell.expiryDateLabel.text = cardCVVDetails?.formattedExpiry
            } else {
                cell.copyButton.isHidden = true
                cell.cardSubDetailContainerView.isHidden = true
                cell.showAndHideButton.setAttributedTitle(viewModel.setButtonTitleWithUnderline(title: viewModel.titles.show), for: .normal)
                cell.cardNumberLabel.text = viewModel.hideCardDetails(cardNumber: card?.maskedCardNumber)
            }
            
            if let plasticId = card?.plasticId, let cardBackgroundImageURL = viewModel.cardImageURLs[plasticId] {
                cell.cardBackgroundImageView.downloaded(from: cardBackgroundImageURL, contentMode: .scaleAspectFill)
            }

            return cell
        }
        return UICollectionViewCell()
    }
    
}

// MARK: - TableView Delegate and Datasource Methods
extension ManageWalletViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfManageOptions()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("ManageWalletOptionsTableViewCell", owner: self, options: nil)?.first as! ManageWalletOptionsTableViewCell
        let cellPersonalInfo =  Bundle.main.loadNibNamed("ManageWalletPersonalInfoCell", owner: self, options: nil)?.first as! ManageWalletPersonalInfoCell
        let cells = ManageWalletOptions.init(rawValue: indexPath.row)
        switch cells {
        case .personalInfo:
            cellPersonalInfo.updateMobileNoButton.setAttributedTitle(viewModel.setButtonTitleWithUnderline(title: viewModel.titles.update), for: .normal)
            cellPersonalInfo.updateMobileNoButton.addTarget(self, action: #selector(updateMobileNoButtonPressed), for: .touchUpInside)
            cellPersonalInfo.registerAddressLabel.text = viewModel.customerDetails?.fullBillingAddress
            cellPersonalInfo.mobileNumberLabel.text = viewModel.customerDetails?.formattedMobileNumber
            return cellPersonalInfo
        case .changedPin:
            cell.switchButton.isHidden = true
            cell.disclosureIconImageView.isHidden = false
            cell.optionNameLabel.text = viewModel.titles.changePin
            cell.optionImageView.image = UIImage(named: viewModel.images.changePin)
            return cell
        case .biomatricOption:
            if viewModel.biometrciType == .none {
               fallthrough
            }
            let optionDetails = viewModel.getBiometricOptionDetails()
            cell.optionNameLabel.text = optionDetails.0
            cell.optionImageView.image = UIImage(named: optionDetails.1)
            cell.switchButton.addTarget(self, action: #selector(biometricSwitchPressed(_:)), for: .touchUpInside)
            cell.switchButton.isOn = UserDefaults.standard.isWalletBiometricEnabled
            return cell
        case .termsAndCondition:
            let tncCell =  Bundle.main.loadNibNamed("ManageWalletTnCCell", owner: self, options: nil)?.first as! ManageWalletTnCCell
            return tncCell
        case .none:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cells = ManageWalletOptions.init(rawValue: indexPath.row)
        switch cells {
        case .personalInfo:
            debugPrint("No Actoion")
        case .changedPin:
           navigateToUpdatePin()
        case .biomatricOption:
            if viewModel.biometrciType == .none {
               fallthrough
            }
            debugPrint("No Action")
        case .termsAndCondition:
            navigateToTnCVC()
        case .none:
            print("")
        }
    }
    
}

extension ManageWalletViewController: ManageWalletDataPassingDelegate {
    func cardDetailListSuccessHandler() {
        self.CardCollectionView.reloadData()
    }
    
    func unmaskCardDetailSuccessHandler(unmaskCardDetail: UnmaskCardDetail) {
        self.CardCollectionView.reloadData()
    }
    
    func cardDetailsSuccessHandler(card: Card) {
        self.CardCollectionView.reloadData()
    }
    
    func customerDetailsSuccessHandler() {
        self.tableView.reloadRows(at: [IndexPath(row: ManageWalletOptions.personalInfo.rawValue, section: 0)], with: .automatic)
    }
    
    func failureHandler(message: String) {
        CommonAlertHandler.showErrorResponseAlert(for: message)
    }
    
    func cardCVVDetailSuccessHandler(cardCVVDetail: CardCVVDetail) {
        self.CardCollectionView.reloadData()
    }
    
    func cardImagesSuccessHandler() {
        
    }

}
