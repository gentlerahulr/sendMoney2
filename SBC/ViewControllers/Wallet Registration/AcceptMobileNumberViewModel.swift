//
//  WalletRegistartionViewModel.swift
//  SBC
//

import Foundation
import UIKit

protocol AcceptMobileNumberViewModelDelegate: class {
    func FailureWithError(message: String)
    func Success()
}

struct AcceptMobileNumberModel {
    let title: String
    let desc: String
    let buttonText: String
    let endPoint: MobileOTPType
}

enum AcceptMobileNumberCells: Int {
    case cellTittle
    case cellMobileNo
    case cellProceddBtn
}

class AcceptMobileNumberViewModel: BaseViewModel {
    
    override init() {}
    
    private func getCells() -> [AcceptMobileNumberCells] {
        var cell = [AcceptMobileNumberCells]()
        cell.append(.cellTittle)
        cell.append(.cellMobileNo)
        cell.append(.cellProceddBtn)
        return cell
    }
    
    var validationStateMobile = ValidationState.valid
    var acceptMobileNumberModel: AcceptMobileNumberModel?
    weak var delegate: AcceptMobileNumberViewModelDelegate?
    var arrayOfCells = [AcceptMobileNumberCells]()
    let walletManager = WalletManager(dataStore: APIStore.instance)
    
    public func getCells() {
        self.arrayOfCells.removeAll()
        self.arrayOfCells = getCells()
    }
    var mobileNumber: String = ""
    
    // MARK: - Validations
    public func validateMobileNumber(isWantToUpdateUI: Bool) -> ValidationState {
        
        if arrayOfCells.contains(.cellMobileNo) {
            if mobileNumber.count < 0 { return .inValid(localizedStringForKey(key: "MSG_EMPTY_Mobile")) }
            if mobileNumber.isPhoneNumber { return .valid} else {return .inValid(localizedStringForKey(key: "MOBILE_NO_NOTVALID"))}
        }
        return .valid
    }
    
    // MARK: Call APi's
    
    func callGenerateMobileOTPAPI(request: OTPGenerationRequest) {
        CommonUtil.sharedInstance.showLoader()
        walletManager.performOTPgenerationForMobile(for: acceptMobileNumberModel?.endPoint ?? MobileOTPType.registerWallet, request: request, completion: {result in
            CommonUtil.sharedInstance.removeLoader()
            switch result {
            case .success:
                self.delegate?.Success()
            case .failure( let error):
                self.delegate?.FailureWithError(message: error.localizedDescription)
                
            }
        })
    }
}
