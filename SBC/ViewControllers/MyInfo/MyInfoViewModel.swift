import UIKit

protocol MyInfoDataPassingDelegate: AnyObject {
    func performMinimalCoustmerSuccess(response: MinimalCustomerDataResponse)
    func performMinimalCoustmerfailure(message: String)

}

protocol MyInfoViewModelProtocol {
    var delegate: MyInfoDataPassingDelegate? { get set }
    var redirectUrl: String? { get set }
    var errorMessage: String? { get set }
    var labelDescConfig: LabelConfig? { get }
    var minimalCustomerDataRequest: MinimalCustomerDataRequest { get }
    func callAddCoustomerWithMinimalData(request: MinimalCustomerDataRequest)
}

class MyInfoViewModel: MyInfoViewModelProtocol {
    
    let walletManager = WalletManager(dataStore: APIStore.instance)
    weak var delegate: MyInfoDataPassingDelegate?
    var minimalCustomerDataRequest: MinimalCustomerDataRequest {
        return MinimalCustomerDataRequest(email: CommonUtil.userEmail, countryCode: Config.countryDict[CommonUtil.countryCode], mobile: CommonUtil.userMobile, customerHashId: CommonUtil.customerHashID, walletHashId: CommonUtil.walletHashID)
    }
    var errorMessage: String?
    var redirectUrl: String?
    var labelDescConfig: LabelConfig? {
        return LabelConfig.getRegularLabelConfig(text: localizedStringForKey(key: "myinfo.login.desc"), lineSpacing: 2.5, textAlignment: .center, numberOfLines: 0)
    }
    
    func callAddCoustomerWithMinimalData(request: MinimalCustomerDataRequest) {
        CommonUtil.sharedInstance.showLoader()
        walletManager.performAddCustomerWithMinimalCustomerData(request: request, completion: { result in
            CommonUtil.sharedInstance.removeLoader()
            switch result {
            case .success(let response):
                self.delegate?.performMinimalCoustmerSuccess(response: response)
            case .failure( let error):
                self.delegate?.performMinimalCoustmerfailure(message: error.localizedDescription)
            }
        })
    }
}
