//
//  PlacesViewModel.swift
//  SBC
//

import Foundation

protocol PlacesDataDelegate: AnyObject {
    func failureWithError(message: String)
    func didReceiveData()
}

enum PlaceMode: Equatable {
    
    case allPlaces
    case cuisine(Cuisine)
    case nearby
    
    static func == (lhs: PlaceMode, rhs: PlaceMode) -> Bool {
        switch (lhs, rhs) {
        case (let .cuisine(lhsCuisine), let .cuisine(rhsCuisine)):
            return lhsCuisine.id == rhsCuisine.id
        case (.allPlaces, .allPlaces), (.nearby, .nearby):
            return true
        default:
            return false
        }
    }
}

class PlacesViewModel: BaseViewModel {
    
    private let searchManager = SearchManager(dataStore: APIStore.instance)
    
    weak var delegate: PlacesDataDelegate?
    var placeMode: PlaceMode
    var venuesSearchResults: [SearchResult]?
    var sortItems = [SortItem]() {
        didSet {
            fetchDataFromAPI()
        }
    }
    var selectedSortItem: SortItem? {
        sortItems.filter { $0.isSelected}.first
    }
    var title: String {
        switch placeMode {
        case .allPlaces, .nearby:
            return "ALL_PLACES".localized(bundle: Bundle.main)
        case .cuisine(let cuisine):
            return cuisine.name ?? ""
        }
    }
    
    init(placeMode: PlaceMode) {
        self.placeMode = placeMode
        super.init()
        initSortItems(placeMode: placeMode)
    }
    
    private func initSortItems(placeMode: PlaceMode) {
        
        if placeMode == .nearby {
            sortItems.append(SortItem(identifier: "relevance", title: "RELEVANCE".localized(bundle: Bundle.main), isSelected: false, apiKey: "-relevance"))
            sortItems.append(SortItem(identifier: "rating", title: "RATING".localized(bundle: Bundle.main), isSelected: false, apiKey: "-rating"))
            sortItems.append(SortItem(identifier: "distance", title: "DISTANCE".localized(bundle: Bundle.main), isSelected: true, apiKey: "+distance"))
            sortItems.append(SortItem(identifier: "priceDesc", title: "PRICE_DESC".localized(bundle: Bundle.main), isSelected: false, apiKey: "-price"))
            sortItems.append(SortItem(identifier: "priceAsc", title: "PRICE_ASC".localized(bundle: Bundle.main), isSelected: false, apiKey: "+price"))
        } else {
            sortItems.append(SortItem(identifier: "relevance", title: "RELEVANCE".localized(bundle: Bundle.main), isSelected: true, apiKey: "-relevance"))
            sortItems.append(SortItem(identifier: "rating", title: "RATING".localized(bundle: Bundle.main), isSelected: false, apiKey: "-rating"))
            sortItems.append(SortItem(identifier: "distance", title: "DISTANCE".localized(bundle: Bundle.main), isSelected: false, apiKey: "+distance"))
            sortItems.append(SortItem(identifier: "priceDesc", title: "PRICE_DESC".localized(bundle: Bundle.main), isSelected: false, apiKey: "-price"))
            sortItems.append(SortItem(identifier: "priceAsc", title: "PRICE_ASC".localized(bundle: Bundle.main), isSelected: false, apiKey: "+price"))
        }
    }
    
    private func fetchDataFromAPI() {
        switch placeMode {
        case .allPlaces:
            callSearchAPI()
        case .nearby:
            //might need users location - not defined so far
            callSearchAPI()
        case .cuisine(let cuisine):
            callSearchAPI(cuisine: cuisine)
        }
    }
    
    private func callSearchAPI(cuisine: Cuisine? = nil) {
        let searchRequest = SearchRequest(limit: 20, pageToken: nil, term: nil, type: "venue", cuisine: cuisine?.id ?? nil, sort: selectedSortItem?.apiKey)
        searchManager.searchForResults(request: searchRequest) { (result) in
            switch result {
            case .success(let searchResults):
                self.venuesSearchResults = searchResults.data.filter { $0.type == "venue"}
                self.delegate?.didReceiveData()
            case .failure(let error):
                self.delegate?.failureWithError(message: error.localizedDescription)
                self.loadMockData()
                self.delegate?.didReceiveData()
            }
        }
    }
    
    private func loadMockData() {
        let decoder = JSONDecoder()
        do {
            let path = Bundle.main.path(forResource: "SearchResult", ofType: "json")
            let jsonData = try Data(contentsOf: URL(fileURLWithPath: path!))
            let searchResults = try decoder.decode(SearchResults.self, from: jsonData)
            self.venuesSearchResults = searchResults.data.filter { $0.type == "venue"}
        } catch let decodingError as DecodingError {
            NSLog(decodingError.errorDescription ?? "ERROR")
        } catch {
            NSLog("Error converting Json")
        }
    }
    
}
