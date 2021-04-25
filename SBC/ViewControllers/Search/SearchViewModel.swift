import Foundation

protocol SearchDelegate: AnyObject {
    func didLoadSuggestedSearches()
    func didReceiveData()
    func failureWithError()
}

enum SearchSegment: String {
    case all = "all"
    case places = "venue"
    case lists = "playlist"
}

class SearchViewModel: BaseViewModel {
    let searchManager = SearchManager(dataStore: APIStore.instance)
    var suggestedList: Trendings?
    weak var delegate: SearchDelegate?
    var globalResult: SearchResults?
    var placesResult: SearchResults?
    var listsResult: SearchResults?
    var globalSearchResults: [SearchResult]?
    var placesSearchResults: [SearchResult]?
    var listsSearchResults: [SearchResult]?
    var sortItems = [SortItem]()
    var selectedSortItem: SortItem? {
        sortItems.filter { $0.isSelected}.first
    }
    var trendingSearch: String?
    override init() {
        super.init()
        initSortItems()
    }
    
    private func initSortItems() {
        sortItems.append(SortItem(identifier: "relevance", title: "RELEVANCE".localized(bundle: Bundle.main), isSelected: true, apiKey: "-relevance"))
        sortItems.append(SortItem(identifier: "likes", title: "LIKES".localized(bundle: Bundle.main), isSelected: false, apiKey: "-likes"))
    }
    
    func loadSuggestedList() {
        let trendingRequest = SuggestedRequest()
        searchManager.getSuggested(request: trendingRequest, completion: { result in
            switch result {
            case .success(let suggestedData):
                self.suggestedList = suggestedData
                self.delegate?.didLoadSuggestedSearches()
            case .failure( _):
                self.suggestedList = Trendings(data: ["search term", "search term", "search term", "search term", "search term", "search term"])
                self.delegate?.didLoadSuggestedSearches()
            //self.delegate?.failureWithError()
            }
        })
    }
    
    var recentSearches: [String] {
        return UserDefaults.standard.recentSearches
    }
    
    func addSearchToRecent(text: String) {
        UserDefaults.standard.addSearchToRecent(text: text)
    }
    
    func removeSearchAt(index: Int) {
        UserDefaults.standard.removeSearchAt(index: index)
    }
    
    func callSearchAPI(term: String, type: Int) {
        let searchType =  getSearchSegment(segment: type)
        let searchRequest = SearchRequest(limit: 20, pageToken: getNextToken(segment: type), term: nil, type: searchType.rawValue, cuisine: nil, sort: selectedSortItem?.apiKey)
        searchManager.searchForResults(request: searchRequest) { (result) in
            switch result {
            case .success(let searchResults):
                switch searchType {
                case .all:
                    self.globalSearchResults = self.save(newResult: searchResults.data, inSearchResult: self.globalSearchResults)
                    self.globalResult = searchResults
                case .lists:
                    self.listsSearchResults = self.save(newResult: searchResults.data, inSearchResult: self.listsSearchResults)
                    self.listsResult = searchResults
                case .places:
                    self.placesSearchResults = self.save(newResult: searchResults.data, inSearchResult: self.placesSearchResults)
                    self.placesResult = searchResults
                }
                self.delegate?.didReceiveData()
            case .failure(let error):
                self.delegate?.failureWithError()
                self.loadMockData(type: searchType)
                self.delegate?.didReceiveData()
            }
        }
    }
    
    private func save(newResult: [SearchResult]?, inSearchResult: [SearchResult]?) -> [SearchResult]? {
        if var searchResult = inSearchResult, let newResult = newResult {
            searchResult.append(contentsOf: newResult)
            return searchResult
        }
        return newResult
    }
    
    func getSearchSegment(segment: Int) -> SearchSegment {
        switch segment {
        case 0:
            return .all
        case 1:
            return .places
        default:
            return .lists
        }
    }
    
    func getCurrentList(segment: Int) -> [SearchResult]? {
        switch segment {
        case 0:
            return globalSearchResults
        case 1:
            return placesSearchResults
        default:
            return listsSearchResults
        }
    }
    
    func getNextToken(segment: Int) -> String? {
        switch segment {
        case 0:
            return globalResult?.nextPageToken
        case 1:
            return placesResult?.nextPageToken
        default:
            return listsResult?.nextPageToken
        }
    }
    
    func resetSearch() {
        globalSearchResults = []
        placesSearchResults = []
        listsSearchResults = []
    }
    
    private func loadMockData(type: SearchSegment) {
        let decoder = JSONDecoder()
        do {
            let path = Bundle.main.path(forResource: "SearchResult", ofType: "json")
            let jsonData = try Data(contentsOf: URL(fileURLWithPath: path!))
            let searchResults = try decoder.decode(SearchResults.self, from: jsonData)
            switch type {
            case .all:
                self.globalSearchResults = self.save(newResult: searchResults.data, inSearchResult: self.globalSearchResults)
                self.globalResult = searchResults
                
            case .lists:
                self.listsSearchResults = searchResults.data.filter { $0.type == "playlist"}
                self.listsSearchResults = self.save(newResult: searchResults.data.filter { $0.type == "playlist"}, inSearchResult: self.listsSearchResults)
                self.listsResult = searchResults
            case .places:
                self.placesSearchResults = self.save(newResult: searchResults.data.filter { $0.type == "venue"}, inSearchResult: self.placesSearchResults)
                self.placesResult = searchResults
            }
        } catch let decodingError as DecodingError {
            NSLog(decodingError.errorDescription ?? "ERROR")
        } catch {
            NSLog("Error converting Json")
        }
    }
}
