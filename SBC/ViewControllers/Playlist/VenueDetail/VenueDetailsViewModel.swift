import Foundation

protocol VenueDataDelegate: AnyObject {
    func failureWithError(message: String)
    func didReceiveData(venueResponse: Venue)
    func didToggleLikeVenue(error: APIError?, indexPath: IndexPath?)
    func didToggleLikePlaylist(error: APIError?, indexPath: IndexPath?)
}
class VenueDetailsViewModel: BaseViewModel {
    weak var delegate: VenueDataDelegate?
    let playlistManager = PlaylistManager(dataStore: APIStore.instance)
   
    var venue: Venue?
    var sortedReviews = [Review]()
    let venueId: String
    
    init(venueId: String) {
        self.venueId = venueId
    }
    
    func getVenue(id: String) {
        let venueRequest = VenueRequest(id: id)
        playlistManager.getVenue(request: venueRequest, completion: { result in
            switch result {
            case .success(let venueData):
                self.venue = venueData
                self.sortReviews()
                self.delegate?.didReceiveData(venueResponse: venueData)
            case .failure(let error):
                self.delegate?.failureWithError(message: error.localizedDescription)
            }
        })
    }
    
    private func sortReviews() {
        sortedReviews.removeAll()
        guard var reviews = venue?.reviews?.data else {return}
        reviews.sort { (lhs, rhs) -> Bool in
            return lhs.rating > rhs.rating
        }
        sortedReviews = reviews
    }
    
    func likeVenue(indexPath: IndexPath?) {
        var likedId = venueId
        if let indexPath = indexPath, let similarVenues = venue?.similarVenues {
            likedId = similarVenues.data[indexPath.row].id
        }
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
    
    func likePlaylist(indexPath: IndexPath?) {
        if let indexPath = indexPath, let featuredList = venue?.featuredPlaylists, let playlistId = featuredList.data?[indexPath.row].id {
            
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
}
