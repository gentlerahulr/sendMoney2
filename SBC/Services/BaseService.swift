import Foundation

//This class act as base class for all NetwokService classes.
class BaseNetworkService {
    
    let networkService: NetworkAPIServiceProtocol
    
    init(networkService: NetworkAPIServiceProtocol) {
        self.networkService = networkService
    }
}

//This class act as base class for all DatabaseService classes.
class BaseDBService {
    
    var dbService: DatabaseServiceProtocol

    init(dbService: DatabaseServiceProtocol) {
        self.dbService = dbService
    }
}
