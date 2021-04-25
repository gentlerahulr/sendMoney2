import Foundation
import Security

protocol DatabaseServiceProtocol {
    
}

//ToDo: Implement Coredata functionality
class CoreDataStack: DatabaseServiceProtocol {
	static let sharedInstance = CoreDataStack()
	
    private init() {
    }
}
