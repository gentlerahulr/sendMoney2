import Foundation

class APIStore: DataProviderProtocol {
    static let instance = APIStore()
    private var networkService: NetworkAPIServiceProtocol
    
    private init() {
        networkService = AlamofireNetworkServiceWrapper.sharedInstance
    }
    
    var userService: UserServiceProtocol {
        return UserNWService(networkService: networkService)
    }
    
    var walletService: WalletServiceProtocol {
        return WalletNWService(networkService: networkService)
    }

    var moneyThorService: MoneyThorServiceProtocol {
        return MoneyThorNWService(networkService: networkService)
    }
    
    var playlistService: PlaylistServiceProtocol {
        return PlaylistNWService(networkService: networkService)
    }
    
    var customerService: CustomerServiceProtocol {
        return CustomerNWService(networkService: networkService)
    }
    
    var recommendationsService: RecommendationsServiceProtocol {
        return RecommendationsNWService(networkService: networkService)
    }
    
    var topUpService: TopUpServiceProtocol {
        return TopUpNWService(networkService: networkService)
    }
    
    var withdrawService: WithdrawServiceProtocol {
       return WithdrawNWService(networkService: networkService)
    }
    
    var searchService: SearchServiceProtocol {
        return SearchNWService(networkService: networkService)
    }
}
