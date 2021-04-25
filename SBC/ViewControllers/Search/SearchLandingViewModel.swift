import Foundation

protocol SearchLandingDelegate: AnyObject {
    func didReceiveData()
    func failureWithError()
}

class SearchLandingViewModel: BaseViewModel {
    let searchManager = SearchManager(dataStore: APIStore.instance)
    var trendingList: Trendings?
    var cuisineList: [Cuisine]?
    weak var delegate: SearchLandingDelegate?
    
    func loadData() {
        trendingList = CoreDataManager.shared().fetchTrendings()
        cuisineList = CoreDataManager.shared().fetchCuisines()
    }
}
