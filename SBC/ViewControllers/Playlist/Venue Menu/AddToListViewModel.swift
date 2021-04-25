import Foundation

protocol PlaylistsDataDelegate: AnyObject {
    func didReceiveData(playlistResponse: Playlists)
    func failureWithError(message: String)
    func didAddVenue(venue: Venue, toPlaylist: Playlist)
    func closeWithFailure(error: APIError)
}

protocol AddToListViewModelProtocol {
    func callPlaylistsAPI()
    func addVenueToPlaylistAPI(playlist: Playlist)
    var playlists: Playlists? { get set }
    var venue: Venue { get set }
}

class AddToListViewModel: AddToListViewModelProtocol {
    let playlistManager = PlaylistManager(dataStore: APIStore.instance)
    var playlists: Playlists?
    var venue: Venue
    weak var delegate: PlaylistsDataDelegate?
    
    init(venue: Venue) {
        self.venue = venue
    }
    
    func callPlaylistsAPI() {
        let playlistRequest = PlaylistsRequest(limit: nil, user: nil, pageToken: nil, venueId: venue.id, liked: nil)
        playlistManager.getPlaylistList(request: playlistRequest, completion: { result in
            switch result {
            case .success(let playlistsData):
                self.playlists = playlistsData
                self.sortList()
                self.delegate?.didReceiveData(playlistResponse: playlistsData)
            case .failure( let error):
                self.delegate?.failureWithError(message: error.localizedDescription)
            }
        })
    }
    
    func addVenueToPlaylistAPI(playlist: Playlist) {
        let addRequest = AddVenueToPlaylistRequest(venueId: venue.id)
        playlistManager.addVenueToPlaylist(request: addRequest, playlistId: playlist.id, completion: { result in
            switch result {
            case .success:
                self.delegate?.didAddVenue(venue: self.venue, toPlaylist: playlist)
            case .failure( let error):
                self.delegate?.closeWithFailure(error: error)
            }
        })
    }
    
    private func sortList() {
        if let playlists = playlists, let data = playlists.data {
            let playlistsWithoutVenue = data.filter { (a) -> Bool in
                return a.venues != nil && !a.venues!.data.contains(venue)
            }.sorted { (a, b) -> Bool in
                return a.title!.lowercased() < b.title!.lowercased()
            }
            let playlistsWithVenue = data.filter { (a) -> Bool in
                return a.venues != nil && a.venues!.data.contains(venue)
            }.sorted { (a, b) -> Bool in
                return a.title!.lowercased() < b.title!.lowercased()
            }
            
            let playlistsEmpty = data.filter { (a) -> Bool in
                return a.venues == nil
            }.sorted { (a, b) -> Bool in
                return a.title!.lowercased() < b.title!.lowercased()
            }
        
            self.playlists?.data = playlistsWithoutVenue + playlistsEmpty + playlistsWithVenue
        }
    }
}
