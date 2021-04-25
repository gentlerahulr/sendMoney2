import Foundation

protocol DataProviderProtocol {
    var userService: UserServiceProtocol { get }
    var walletService: WalletServiceProtocol { get }
    var moneyThorService: MoneyThorServiceProtocol { get }
    var playlistService: PlaylistServiceProtocol { get }
    var customerService: CustomerServiceProtocol { get }
    var recommendationsService: RecommendationsServiceProtocol { get }
    var topUpService: TopUpServiceProtocol { get }
    var withdrawService: WithdrawServiceProtocol { get }
    var searchService: SearchServiceProtocol { get }
}
