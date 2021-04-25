import Foundation

protocol DashBoardViewModelProtocol {
    var delegate: DashBoardDataPassingDelegate? { get set }
    func updateWalletBalance()
    func callGetWalletStatus()
    func getCustomerWalletBalance()
    func getCustomerData(customerHasId: String)
    var walletRegisterStatusResponse: WalletRegisterStatusResponse? { get set }
}

enum DashBoardTransactionsResult {
    case transactions([DashBoardTransactionSection])
    case placeholder(String)
}

protocol DashBoardDataPassingDelegate: class {
    func updateLoadingStatus(isLoading: Bool)
    func showWalletBalance(amount: Double, currency: String)
    func failureWithError(message: String)
    func succesWalletStatus(response: WalletRegisterStatusResponse)
    func getCustomerDataSucces(response: Customer)
    func getCustomerDataFailure(message: String)
    func topUpSucces(response: TopUpRequestResponse)
    func topUpFailure(message: String)
    func getWalletBalanceSucces(response: WalletBalanceResponseArray)
    
}

class DashBoardViewModel: BaseViewModel {
    let moneyThorManager: MoneyThorManager
    var walletManager = WalletManager(dataStore: APIStore.instance)
 
    init(moneyThorManager: MoneyThorManager = MoneyThorManager(dataStore: APIStore.instance)) {
        self.moneyThorManager = moneyThorManager
    }
    private weak var _delegate: DashBoardDataPassingDelegate?
    private var _walletRegisterStatusResponse: WalletRegisterStatusResponse?
}

struct DashBoardTransactionSection {
    let date: Date
    var transactions: [DashBoardTransaction]
}

extension DashBoardTransactionSection {
    var totalAmount: Double {
        transactions.reduce(0.0) { $0 + $1.amount }
    }
}

struct DashBoardTransaction {
    let transactionDescription: String?
    let amount: Double
    let currency: String
    let tags: [String]
    let notes: String?
}

extension DashBoardViewModel: DashBoardViewModelProtocol {
 
    var delegate: DashBoardDataPassingDelegate? {
        get { _delegate }
        set { _delegate = newValue }
    }
    
    var walletRegisterStatusResponse: WalletRegisterStatusResponse? {
        get { _walletRegisterStatusResponse }
        set { _walletRegisterStatusResponse = newValue }
    }

    func updateWalletBalance() {
        // TODO: Implement actual wallet balance fetch 
        delegate?.showWalletBalance(amount: 0.0, currency: "SGD")
    }

    func callGetWalletStatus() {
        delegate?.updateLoadingStatus(isLoading: true)
        walletManager.performGetwAlletStatus(completion: { [weak self] result in
            self?.delegate?.updateLoadingStatus(isLoading: false)
            switch result {
            case .success(let walletData):
                CommonUtil.userEmail = walletData.email ?? ""
                CommonUtil.userMobile = walletData.mobile ?? ""
                CommonUtil.customerHashID = walletData.customerHashId ?? ""
                CommonUtil.walletHashID = walletData.walletHashId ?? ""
                CommonUtil.countryCode = walletData.countryCode ?? Config.DEFAULT_COUNTRY_CODE
                self?.walletRegisterStatusResponse = walletData
                self?.delegate?.succesWalletStatus(response: walletData)
            case .failure( let error):
                self?.delegate?.failureWithError(message: error.localizedDescription)
            }
        })
    }

    func getCustomerData(customerHasId: String) {
        delegate?.updateLoadingStatus(isLoading: true)
        walletManager.performGetCustomerData(customerHashID: customerHasId, completion: { [self] result in
            self.delegate?.updateLoadingStatus(isLoading: false)
            switch result {
            case .success(let respose):
                self.delegate?.getCustomerDataSucces(response: respose)
            case .failure( let error):
                self.delegate?.getCustomerDataFailure(message: error.localizedDescription)
            }
        })
    }
    
    func getCustomerWalletBalance() {
        walletManager.performGetWalletBalance(completion: { [self] result in
            switch result {
            case .success(let respose):
                self.delegate?.getWalletBalanceSucces(response: respose)
            case .failure( let error):
                self.delegate?.failureWithError(message: error.localizedDescription)
            }
        })
    }
}
