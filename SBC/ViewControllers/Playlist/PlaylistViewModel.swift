import Foundation

protocol PlaylistDetailsDataDelegate: AnyObject {
    func failureWithError(message: String)
    func didReceiveData(playlistResponse: Playlist)
    func didReceiveData(venuesResponse: Venues)
    func didDeletePlaylist(error: APIError?)
    func didDeleteVenue(venue: Venue, error: APIError?)
    func didToggleLikePlaylist(error: APIError?)
    func didToggleLikeVenue(indexPath: IndexPath, error: APIError?)
}

extension PlaylistDetailsDataDelegate {
    func didReceiveData(venuesResponse: Venues) {}
    func didDeletePlaylist(error: APIError?) {}
    func didDeleteVenue(venue: Venue, error: APIError?) {}
    func didToggleLikePlaylist(error: APIError?) {}
    func didToggleLikeVenue(indexPath: IndexPath, error: APIError?) {}
}

protocol PlaylistViewModelProtocol {
    var delegate: PlaylistDetailsDataDelegate? { get set }
    func callPlaylistDetailsAPI()
}

class PlaylistViewModel: PlaylistViewModelProtocol {
    
    weak var delegate: PlaylistDetailsDataDelegate?
    var playlistResponse: Playlist?
    let playlistManager = PlaylistManager(dataStore: APIStore.instance)
    let playlistId: String?
    var playlist: Playlist?
    var venues: Venues?
    var isLikedVenues: Bool = false
    var isMyPlaylist: Bool = false
    
    func callPlaylistDetailsAPI() {
        if let playlistId = playlistId {
            let playlistRequest = PlaylistDetailsRequest(id: playlistId)
            playlistManager.getPlaylistDetails(request: playlistRequest, completion: { result in
                switch result {
                case .success(let playlistData):
                    self.playlistResponse = playlistData
                    self.venues = playlistData.venues
                    if let creator = playlistData.creator {
                        self.isMyPlaylist = creator.id == KeyChainServiceWrapper.standard.userHashId
                    }
                    self.delegate?.didReceiveData(playlistResponse: playlistData)
                case .failure( let error):
                    self.delegate?.failureWithError(message: error.localizedDescription)
                    
                }
            })
        }
    }
    
    func callLikedVenuesAPI() {
        let venuesRequest = VenuesRequest()
        playlistManager.getVenues(request: venuesRequest, completion: { result in
            switch result {
            case .success(let venuesData):
                self.venues = venuesData
                self.delegate?.didReceiveData(venuesResponse: venuesData)
            case .failure(let error):
                self.delegate?.failureWithError(message: error.localizedDescription)
            }
        })
    }
    
    func deletePlaylistAPI() {
        if let playlist = playlist {
            let deleteRequest = DeletePlaylistRequest(id: playlist.id)
            playlistManager.deletePlaylist(request: deleteRequest) { result in
                switch result {
                case .success:
                    self.delegate?.didDeletePlaylist(error: nil)
                case .failure(let error):
                    self.delegate?.didDeletePlaylist(error: error)
                }
            }
        }
    }
    
    func likePlaylistAPI() {
        if let playlist = playlist {
            let likeRequest = ToggleLikePlaylistRequest(id: playlist.id)
            playlistManager.toggleLikePlaylistDetails(request: likeRequest) { result in
                switch result {
                case .success:
                    self.delegate?.didToggleLikePlaylist(error: nil)
                case .failure(let error):
                    self.delegate?.didToggleLikePlaylist(error: error)
                }
            }
        }
    }
    
    func likeVenue(indexPath: IndexPath) {
        if let venue = venues?.data[indexPath.row] {
            let likeRequest = ToggleLikeVenueRequest(id: venue.id)
            playlistManager.toggleLikeVenue(request: likeRequest) { result in
                switch result {
                case .success:
                    self.delegate?.didToggleLikeVenue(indexPath: indexPath, error: nil)
                case .failure(let error):
                    self.delegate?.didToggleLikeVenue(indexPath: indexPath, error: error)
                }
            }
        }
    }
    
    func deleteVenueFromPlaylistAPI(venue: Venue) {
        if let playlist = playlist {
            let deleteRequest = DeleteVenueFromPlaylistRequest()
            playlistManager.deleteVenueFromPlaylist(request: deleteRequest, playlistId: playlist.id, venueId: venue.id) { result in
                switch result {
                case .success:
                    self.delegate?.didDeleteVenue(venue: venue, error: nil)
                case .failure(let error):
                    self.delegate?.didDeleteVenue(venue: venue, error: error)
                }
            }
        }
    }
    
    init(playlist: Playlist) {
        self.playlist = playlist
        self.playlistId = playlist.id
        self.playlistResponse = playlist
        self.venues = playlist.venues
        if let creator = playlist.creator {
            self.isMyPlaylist = creator.id == KeyChainServiceWrapper.standard.userHashId
        }
    }
    
    init(playlistId: String) {
        self.playlistId = playlistId
        callPlaylistDetailsAPI()
    }
    init(forLikeVenues: Bool) {
        self.isLikedVenues = forLikeVenues
        self.playlistId = nil
        callLikedVenuesAPI()
    }
    
    // MARK: - UI Config
    var lblCreatedByConfig: LabelConfig? = LabelConfig.getRegularLabelConfig(text: Text.lblCreatedBytext, fontSize: 13, textColor: .themeDarkBlueTint1)
    var lblPlacesConfig: LabelConfig? = LabelConfig.getRegularLabelConfig(text: Text.lblPlacestext, fontSize: 13, textColor: .themeDarkBlueTint1, textAlignment: .center)
    var btnAddDescriptionConfig: ButtonConfig? = ButtonConfig.getBackgroundButtonConfig(titleText: Text.btnAddDescriptiontext, fontSize: 13, textColor: .themeDarkBlue, backgroundColor: .themeNeonBlue, cornerRadius: 10)
    
    struct Text {
        static let btnAddDescriptiontext = localizedStringForKey(key: "playlist_btn_addDescription")
        static let lblCreatedBytext = localizedStringForKey(key: "playlist_label_createdBy")
        static let lblPlacestext = localizedStringForKey(key: "playlist_label_places")
    }
}
