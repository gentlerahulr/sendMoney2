import Foundation

class BaseManager {
    var dataStore: DataProviderProtocol
    
    init(dataStore: DataProviderProtocol) {
        self.dataStore = dataStore
    }
}
