//
//  ManageWalletViewModel.swift
//  SBC
//

import Foundation
import UIKit
import LocalAuthentication

protocol ManageWalletDataPassingDelegate: AnyObject {
    func cardDetailsSuccessHandler(card: Card)
    func cardDetailListSuccessHandler()
    func unmaskCardDetailSuccessHandler(unmaskCardDetail: UnmaskCardDetail)
    func cardCVVDetailSuccessHandler(cardCVVDetail: CardCVVDetail)
    func customerDetailsSuccessHandler()
    func cardImagesSuccessHandler()
    func failureHandler(message: String)
}

enum ManageWalletOptions: Int {
    case personalInfo
    case changedPin
    case biomatricOption
    case termsAndCondition
}

class ManageWalletViewModel: BaseViewModel {
    
    var titles: Titles = Titles()
    var images = Images()
    let ManageWalletCellSpacing = CGFloat(12.0)
    let ManageWalletCellPeekWidth = CGFloat(10.0)
    let ManageWalletMaximumItemsToScroll = CGFloat(1.0)
    let ManageWalletNumberOfItemsToShow = CGFloat(1.0)
    var underLineColor = UIColor.themeNeonBlue
    let buttonAttributes: [NSAttributedString.Key: Any] = [
        .font: UIFont.mediumFontWithSize(size: 12),
        .foregroundColor: UIColor.themeDarkBlue,
        .underlineStyle: NSUnderlineStyle.thick.rawValue,
        .underlineColor: UIColor.themeNeonBlue]
    
    var isCardVisible = false
    var unmaskCardDetailDict: [String: UnmaskCardDetail] = [:]
    var cardDetailsDict: [String: Card] = [:]
    var cardCVVDetailDict: [String: CardCVVDetail] = [:]
    weak var delegate: ManageWalletDataPassingDelegate?
    var customerManager = CustomerManager(dataStore: APIStore.instance)
    let walletManager = WalletManager(dataStore: APIStore.instance)
    var customerDetails: Customer?
    var cardDetailList: CardDetailList?
    var cardImageURLs: CardImageURLs = [:]
    
    var biometrciType: LAContext.BiometricType {
        return LAContext().biometricType
    }
    //------------------------------------------------------------------
    
    func updateBiometricStatus(sender: UISwitch, viewController: UIViewController) {
        
        if sender.isOn {
            sender.isOn = false
            if UserDefaults.standard.isWalletBiometricEnabled {
                sender.isOn = true
                return
            }
            LAContext.authenticationWithBiometric(fallbackTitle: localizedStringForKey(key: "biometrics_reason"), viewController: viewController, completion: { result in
                DispatchQueue.main.async {
                    if result {
                        UserDefaults.standard.isWalletBiometricEnabled = true
                        sender.isOn = true
                        
                    } else {
                        CommonAlertHandler.showErrorResponseAlert(for: localizedStringForKey(key: "biometrics_auth_failure_msg"))
                        sender.isOn = false
                    }
                }
            })
        } else {
            sender.isOn = false
            UserDefaults.standard.isWalletBiometricEnabled = false
        }
    }
    
    struct Titles {
        let show = localizedStringForKey(key: "SHOW")
        let hide = localizedStringForKey(key: "HIDE")
        let update = localizedStringForKey(key: "UPDATE")
        let termsAndCondition = localizedStringForKey(key: "TERMS_AND_CONDITIONS")
        let changePin = localizedStringForKey(key: "CHANGE_PIN")
        let enableFaceID = localizedStringForKey(key: "ENABLE_FACE_ID")
        let enableTouchID = localizedStringForKey(key: "ENABLE_TOUCH_ID")
        let navigationTitle = localizedStringForKey(key: "MANAGE_WALLET")
        let cardNumberCopyMessage = localizedStringForKey(key: "CARD_NUMBER_SUCCESSFULLY_COPIED")
        let successTitle = localizedStringForKey(key: "SUCCESS") 
    }
    
    //------------------------------------------------------------------
    
    struct Images {
        let changePin = "changePin"
        let enableFaceID = "faceID"
        let enableTouchID = "touchID"
    }
    
    //------------------------------------------------------------------
    
    func numberOfManageOptions() -> Int {
        if biometrciType == .none {
            return 3
        }
        return 4
    }
    
    func hideCardDetails(cardNumber: String?) -> String? {
        guard let number = cardNumber else {
            return nil
        }
        let lastFourDigit = number.suffix(4)
        return "••••  ••••  ••••  \(lastFourDigit)"
    }
    
    func setButtonTitleWithUnderline(title: String) -> NSMutableAttributedString {
        let attributeString = NSMutableAttributedString(string: title,
                                                        attributes: buttonAttributes)
        return attributeString
    }
    
    func getBiometricOptionDetails() -> (String, String) // 1.optionName 2.image
    {
        if biometrciType == .faceID {
            return (titles.enableFaceID, images.enableFaceID)
        } else if biometrciType == .touchID {
            return (titles.enableTouchID, images.enableTouchID)
        }
        return ("", "")
    }
    
    func getManageWalletDetails() {
        getCustomerDetails()
    }
    
    func getCustomerDetails() {
        CommonUtil.sharedInstance.showLoader()
        customerManager.getCustomerDetails(customerHashId: CommonUtil.customerHashID) { (result: Result<Customer, APIError>) in
            CommonUtil.sharedInstance.removeLoader()
            switch result {
            case .success(let response):
                self.customerDetails = response
                self.delegate?.customerDetailsSuccessHandler()
            case .failure( let error):
                self.delegate?.failureHandler(message: error.localizedDescription)
            }
        }
    }
    
    func getCardDetailList() {
        CommonUtil.sharedInstance.showLoader()
        customerManager.getCardDetailList { (result: Result<CardDetailList, APIError>) in
            CommonUtil.sharedInstance.removeLoader()
            switch result {
            case .success(let response):
                self.cardDetailList = response
                if response.cards.count > 0 {
                    self.delegate?.cardDetailListSuccessHandler()
                } else {
                    self.callAddCardAPI()
                }
            case .failure( let error):
                self.delegate?.failureHandler(message: error.localizedDescription)
            }
        }
    }
    
    func getCardDetails(cardHashId: String) {
        if let cardDetails = cardDetailsDict[cardHashId] {
            self.delegate?.cardDetailsSuccessHandler(card: cardDetails)
            return
        }
        CommonUtil.sharedInstance.showLoader()
        customerManager.getCardDetails(cardHashId: cardHashId) { (result: Result<Card, APIError>) in
            CommonUtil.sharedInstance.removeLoader()
            switch result {
            case .success(let response):
                self.cardDetailsDict[cardHashId] = response
                self.delegate?.cardDetailsSuccessHandler(card: response)
            case .failure( let error):
                self.delegate?.failureHandler(message: error.localizedDescription)
            }
        }
    }
    
    func showCardDetails(cardHashId: String) {
        getUnmaskCardDetail(cardHashId: cardHashId) { () in
            self.getCardCVVDetail(cardHashId: cardHashId)
        }
        
    }
    
    func getUnmaskCardDetail(cardHashId: String, completion: @escaping () -> Void) {
        if let unamskCard = unmaskCardDetailDict[cardHashId], let _ = cardCVVDetailDict[cardHashId] {
            self.delegate?.unmaskCardDetailSuccessHandler(unmaskCardDetail: unamskCard)
            return
        }
        CommonUtil.sharedInstance.showLoader()
        customerManager.getUnmaskCardDetail(cardHashId: cardHashId) { (result: Result<UnmaskCardDetail, APIError>) in
            CommonUtil.sharedInstance.removeLoader()
            switch result {
            case .success(let response):
                self.unmaskCardDetailDict[cardHashId] = response
                completion()
            case .failure( let error):
                self.delegate?.failureHandler(message: error.localizedDescription)
            }
        }
    }
    
    func getCardCVVDetail(cardHashId: String) {
        if let cardCVV = cardCVVDetailDict[cardHashId] {
            self.delegate?.cardCVVDetailSuccessHandler(cardCVVDetail: cardCVV)
            return
        }
        CommonUtil.sharedInstance.showLoader()
        customerManager.getCardCVVdetails(cardHashId: cardHashId) { (result: Result<CardCVVDetail, APIError>) in
            CommonUtil.sharedInstance.removeLoader()
            switch result {
            case .success(let response):
                self.cardCVVDetailDict[cardHashId] = response
                self.delegate?.cardCVVDetailSuccessHandler(cardCVVDetail: response)
            case .failure( let error):
                self.delegate?.failureHandler(message: error.localizedDescription)
            }
        }
    }
    private func callAddCardAPI() {
        CommonUtil.sharedInstance.showLoader()
        walletManager.performAddCard { result  in
            CommonUtil.sharedInstance.removeLoader()
            switch result {
            case .success:
                self.getCardDetailList()
            case .failure( let error):
                self.delegate?.failureHandler(message: error.localizedDescription)
            }
        }
    }
    
    func getCardImageURLs() {
        CommonUtil.sharedInstance.showLoader()
        customerManager.getCardImageURLs { (result: Result<CardImageURLs, APIError>) in
            CommonUtil.sharedInstance.removeLoader()
            switch result {
            case .success(let response):
                self.cardImageURLs = response
                self.delegate?.cardImagesSuccessHandler()
            case .failure( let error):
                self.delegate?.failureHandler(message: error.localizedDescription)
            }
        }
    }
}
