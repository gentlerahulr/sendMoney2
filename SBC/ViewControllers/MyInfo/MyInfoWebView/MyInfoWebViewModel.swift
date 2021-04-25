import Foundation

protocol MyInfoWebViewDataPassingDelegate: AnyObject {
    func failureWithError(message: String)
    func getCustomerDataSucces(response: Customer)
}

protocol MyInfoWebViewModelProtocol {
    var delegate: MyInfoWebViewDataPassingDelegate? { get set }
    var redirectURL: String? { get set }
    func getCustomerDetails(customerHasId: String)
}

class MyInfoWebViewModel: MyInfoWebViewModelProtocol {
    weak var delegate: MyInfoWebViewDataPassingDelegate?
    var redirectURL: String?
    let walletManager = WalletManager(dataStore: APIStore.instance)
    
    func getCustomerDetails(customerHasId: String) {
        CommonUtil.sharedInstance.showLoader()
        walletManager.performGetCustomerData(customerHashID: customerHasId, completion: { [weak self] result in
            CommonUtil.sharedInstance.removeLoader()
            switch result {
            case .success(let respose):
                self?.delegate?.getCustomerDataSucces(response: respose)
            case .failure( let error):
                self?.delegate?.failureWithError(message: error.localizedDescription)
            }
        })
    }
    
}
