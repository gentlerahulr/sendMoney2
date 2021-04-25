import Foundation

protocol DependencyGraphProtocol {
    var moneyThorManager: MoneyThorManager { get }
}

extension DependencyGraphProtocol {
    func inject() {
        ServiceLocator.shared.register(moneyThorManager)
    }
}

struct DependencyGraph: DependencyGraphProtocol {
    let moneyThorManager: MoneyThorManager

    static let standard: DependencyGraphProtocol = DependencyGraph(
        moneyThorManager: MoneyThorManager(dataStore: APIStore.instance)
    )
}
