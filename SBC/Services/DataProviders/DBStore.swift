import Foundation

class DBStore: DataProviderProtocol {

    static let instance = DBStore()
    private let dbService: DatabaseServiceProtocol
    
    private init() {
        self.dbService = CoreDataStack.sharedInstance
    }
    
    var userService: UserServiceProtocol {
        UserDBService(dbService: dbService)
    }
    
    var walletService: WalletServiceProtocol {
        fatalError("wallet service for DB not implemented.")
    }

    var moneyThorService: MoneyThorServiceProtocol {
        fatalError("MoneyThor service for DB not implemented.")
    }
    
    var playlistService: PlaylistServiceProtocol {
        fatalError("Playlist service for DB not implemented.")
    }
    
    var customerService: CustomerServiceProtocol {
        fatalError("Customer service for DB not implemented.")
    }
    
    var recommendationsService: RecommendationsServiceProtocol {
        fatalError("Customer service for DB not implemented.")
    }
    
    var topUpService: TopUpServiceProtocol {
        fatalError("Customer service for DB not implemented.")
    }
 
    var withdrawService: WithdrawServiceProtocol {
        fatalError("Customer service for DB not implemented.")
    }
    
    var searchService: SearchServiceProtocol {
        fatalError("Search service for DB not implemented.")
    }
}
