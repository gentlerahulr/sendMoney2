import Foundation

struct MyInfoDetailsModel {
    let dob: String?
    let name: String?
    let address: String?
}

protocol MyInfoDetailsDataPassingDelegate: AnyObject {
    func failureWithError(message: String)
    func success()
}

protocol MyInfoDetailsViewModelProtocol {
    var delegate: MyInfoDetailsDataPassingDelegate? { get set }
    var dataModel: MyInfoDetailsModel? { get set }
    var customerDetails: Customer? { get set }
    func callUpdateWalletStatus(request: UpdateWalletRegisteredRequest)
    
}

class MyInfoDetailsViewModel: MyInfoDetailsViewModelProtocol {
    
    weak var delegate: MyInfoDetailsDataPassingDelegate?
    var dataModel: MyInfoDetailsModel?
    var customerDetails: Customer?
    let walletManager = WalletManager(dataStore: APIStore.instance)
    
    func callUpdateWalletStatus(request: UpdateWalletRegisteredRequest) {
        CommonUtil.sharedInstance.showLoader()
        walletManager.performUpdateWalletStatus(request: request, completion: { result  in
            CommonUtil.sharedInstance.removeLoader()
            switch result {
            case .success:
                self.callAddCardAPI()
                self.delegate?.success()
            case .failure( let error):
                self.delegate?.failureWithError(message: error.localizedDescription)
            }
        })
    }
    
    private func callAddCardAPI() {
        CommonUtil.sharedInstance.showLoader()
        walletManager.performAddCard { result  in
            CommonUtil.sharedInstance.removeLoader()
            switch result {
            case .success:
                debugPrint("Added Card")
            case .failure( let error):
                self.delegate?.failureWithError(message: error.localizedDescription)
            }
        }
    }
}
