//
//  LandingViewModel.swift
//  SBC
//

import Foundation

protocol LandingDataDelegate: AnyObject {
    func didReceiveData(recommendationsResponse: RecommendationsResponse)
    func didReceiveData(recommendationsResponse: RecommendationsResponse, indexPath: IndexPath, type: RecommendationsType, isForTableView: Bool)
    func didReceiveData(venue: Venue, forMenu: Bool)
    func failureWithError(message: String)
    func didToggleLikePlaylist(error: APIError?, indexPath: IndexPath?)
    func didToggleLikeVenue(error: APIError?, indexPath: IndexPath?)
}

class LandingViewModel: BaseViewModel {
    
    var recommendations: RecommendationsResponse?
    private let recommendationsManager = RecommendationsManager(dataStore: APIStore.instance)
    private let playlistManager = PlaylistManager(dataStore: APIStore.instance)
    weak var delegate: LandingDataDelegate?
    private let searchManager = SearchManager(dataStore: APIStore.instance)
    
    func callRecommendationsAPI(isForTableView: Bool? = nil, indexPath: IndexPath? = nil, type: RecommendationsType? = nil) {
        let recommendationsRequest = RecommendationsRequest(limit: 7, user: KeyChainServiceWrapper.standard.userHashId, pageToken: nil, venueId: nil)
        recommendationsManager.getRecommendations(request: recommendationsRequest, completion: { result in
            switch result {
            case .success(let recommendationsResponse):
                self.recommendations = recommendationsResponse
                if let indexPath = indexPath, let type = type, let isForTableView = isForTableView {
                    self.delegate?.didReceiveData(recommendationsResponse: recommendationsResponse,
                                                  indexPath: indexPath, type: type, isForTableView: isForTableView)
                } else {
                    self.delegate?.didReceiveData(recommendationsResponse: recommendationsResponse)
                }
            case .failure( let error):
                self.delegate?.failureWithError(message: error.localizedDescription)
            }
        })
    }
    
    func likePlaylist(indexPath: IndexPath?) {
        if let indexPath = indexPath, let playlistId = recommendations?.data[indexPath.section].recommendations[indexPath.row].id {
            let likeRequest = ToggleLikePlaylistRequest(id: playlistId)
            playlistManager.toggleLikePlaylistDetails(request: likeRequest) { result in
                switch result {
                case .success:
                    self.delegate?.didToggleLikePlaylist(error: nil, indexPath: indexPath)
                case .failure(let error):
                    self.delegate?.didToggleLikePlaylist(error: error, indexPath: indexPath)
                }
            }
        }
    }
    
    func likeVenue(indexPath: IndexPath?) {
        if let indexPath = indexPath, let likedId = recommendations?.data[indexPath.section].recommendations[indexPath.row].id {
            
            let likeRequest = ToggleLikeVenueRequest(id: likedId)
            playlistManager.toggleLikeVenue(request: likeRequest) { result in
                switch result {
                case .success:
                    self.delegate?.didToggleLikeVenue(error: nil, indexPath: indexPath)
                case .failure(let error):
                    self.delegate?.didToggleLikeVenue(error: error, indexPath: indexPath)
                }
            }
        }
    }
    
    func fetchVenue(id: String, forMenu: Bool = false) {
        let venueRequest = VenueRequest(id: id)
        playlistManager.getVenue(request: venueRequest, completion: { result in
            switch result {
            case .success(let venue):
                self.delegate?.didReceiveData(venue: venue, forMenu: forMenu)
            case .failure(let error):
                self.delegate?.failureWithError(message: error.localizedDescription)
            }
        })
    }
    
    //------------------------------------------------------------------
    // MARK: Search data fetching
    //------------------------------------------------------------------
    
    var trendingList: Trendings?
    var cuisineList: Cuisines?
    func loadSearchData() {
        if UserDefaults.standard.needsUpdatingCuisines {
            loadTrendingList()
            loadCuisineList()
        }
    }
    
    private func loadTrendingList() {
        let trendingRequest = TrendingRequest()
        searchManager.getTrendings(request: trendingRequest, completion: { result in
            switch result {
            case .success(let trendingData):
                self.trendingList = trendingData
                if let trendings = self.trendingList {
                    CoreDataManager.shared().saveTrendingSearchObject(object: trendings)
                }
            case .failure( _):
                self.trendingList = Trendings(data: ["search term", "search term", "search term", "search term", "search term", "search term"])
                if let trendings = self.trendingList {
                    CoreDataManager.shared().saveTrendingSearchObject(object: trendings)
                }
            }
        })
    }
    
    private func loadCuisineList() {
        let cuisinesRequest = CuisinesRequest(featured: false, limit: 10, pageToken: nil)
        searchManager.getCuisines(request: cuisinesRequest, completion: { result in
            switch result {
            case .success(let cuisineData):
                self.cuisineList = cuisineData
                if let cuisines = self.cuisineList {
                    CoreDataManager.shared().saveCuisines(object: cuisines)
                    UserDefaults.standard.updateLastDateCuisinesUpdated()
                }
            case .failure( _):
                self.cuisineList = Cuisines(data: [Cuisine(name: "Thai", imageUrl: "https://www.englishclub.com/images/vocabulary/food/thai/thai-food-930.jpg", id: "", isLiked: false), Cuisine(name: "French", imageUrl: "https://i0.wp.com/www.bestfranceforever.com/wp-content/uploads/2018/01/1170x658_ratatouille.jpg?resize=624%2C513&ssl=1", id: "", isLiked: false), Cuisine(name: "Italian", imageUrl: "https://travelfoodatlas.com/wp-content/uploads/2018/02/italian-food.jpg", id: "", isLiked: false), Cuisine(name: "Mexican", imageUrl: "https://hips.hearstapps.com/del.h-cdn.co/assets/17/41/1507827432-beef-taco-boats-delish-1.jpg", id: "", isLiked: false), Cuisine(name: "Burgers", imageUrl: "https://www.just-eat.ie/CmsAssets/media/Images/Cuisines/Editorial-981x363/Burgers/92282.jpg?h=363&w=981&bid=9728a8075cbf450ca1d932e285a51e3f&hash=95F9F2508ADEDAF13FD657D8741B4BA4", id: "", isLiked: false), Cuisine(name: "Japanese", imageUrl: "https://www.melangemagazine.biz/wp-content/uploads/2018/02/01-78-678x381.jpg", id: "", isLiked: false)], limit: 10, count: 6, nextPageToken: "")
                if let cuisines = self.cuisineList {
                    CoreDataManager.shared().saveCuisines(object: cuisines)
                    UserDefaults.standard.updateLastDateCuisinesUpdated() //TODO: Remove when API ready
                }
            }
        })
    }
}
