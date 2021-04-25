import Foundation

typealias PlaylistsCompletionHandler = (_ result: Result<Playlists, APIError>) -> Void
typealias PlaylistDetailsCompletionHandler = (_ result: Result<Playlist, APIError>) -> Void
typealias MyLikesCompletionHandler = (_ result: Result<MyLikes, APIError>) -> Void
typealias VenuesCompletionHandler = (_ result: Result<Venues, APIError>) -> Void
typealias VenueCompletionHandler = (_ result: Result<Venue, APIError>) -> Void
typealias DeletePlaylistCompletionHandler = (_ result: Result<EmptyResponse, APIError>) -> Void
typealias UpdateVenueCompletionHandler = (_ result: Result<Venue, APIError>) -> Void
typealias UpdatePlaylistCompletionHandler = (_ result: Result<EmptyResponse, APIError>) -> Void
typealias ToggleLikePlaylistCompletionHandler = (_ result: Result<ToggleLikePlaylistResponse, APIError>) -> Void
typealias ToggleLikeVenueCompletionHandler = (_ result: Result<ToggleLikeVenueResponse, APIError>) -> Void

class PlaylistManager: BaseManager {
    func getPlaylistList(request: PlaylistsRequest, completion: @escaping PlaylistsCompletionHandler) {
        self.dataStore.playlistService.getPlaylists(request: request) { (result: Result<Playlists, APIError>) in
            switch result {
            case .success(let model):
                DispatchQueue.main.async {
                    completion(.success(model))
                }
            case .failure( let error):
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
    
    func getPlaylistDetails(request: PlaylistDetailsRequest, completion: @escaping PlaylistDetailsCompletionHandler) {
        self.dataStore.playlistService.getPlaylistDetails(request: request) { (result: Result<Playlist, APIError>) in
            switch result {
            case .success(let model):
                DispatchQueue.main.async {
                    completion(.success(model))
                }
            case .failure( let error):
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
    
    func getMyLikes(request: MyLikesRequest, completion: @escaping MyLikesCompletionHandler) {
        self.dataStore.playlistService.getMyLikes(request: request) { (result: Result<MyLikes, APIError>) in
            switch result {
            case .success(let model):
                DispatchQueue.main.async {
                    completion(.success(model))
                }
            case .failure( let error):
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
    
    func createPlaylist(request: CreatePlaylistRequest, completion: @escaping PlaylistDetailsCompletionHandler) {
        self.dataStore.playlistService.createPlaylist(request: request) { (result: Result<Playlist, APIError>) in
            switch result {
            case .success(let model):
                DispatchQueue.main.async {
                    completion(.success(model))
                }
            case .failure( let error):
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
    
    func toggleLikePlaylistDetails(request: ToggleLikePlaylistRequest, completion: @escaping ToggleLikePlaylistCompletionHandler) {
        self.dataStore.playlistService.toggleLikePlaylistDetails(request: request) { (result: Result<ToggleLikePlaylistResponse, APIError>) in
            switch result {
            case .success(let model):
                DispatchQueue.main.async {
                    completion(.success(model))
                }
            case .failure( let error):
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
    
    func editPlaylist(request: PlaylistEditRequest, playlistId: String, completion: @escaping PlaylistDetailsCompletionHandler) {
        self.dataStore.playlistService.editPlaylist(request: request, playlistId: playlistId) { (result: Result<Playlist, APIError>) in
            switch result {
            case .success(let model):
                DispatchQueue.main.async {
                    completion(.success(model))
                }
            case .failure( let error):
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
    
    func addVenueToPlaylist(request: AddVenueToPlaylistRequest, playlistId: String, completion: @escaping UpdatePlaylistCompletionHandler) {
        self.dataStore.playlistService.addVenueToPlaylist(request: request, playlistId: playlistId) { (result: Result<EmptyResponse, APIError>) in
            switch result {
            case .success(let model):
                DispatchQueue.main.async {
                    completion(.success(model))
                }
            case .failure( let error):
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
    
    func deleteVenueFromPlaylist(request: DeleteVenueFromPlaylistRequest, playlistId: String, venueId: String, completion: @escaping UpdatePlaylistCompletionHandler) {
        self.dataStore.playlistService.deleteVenueFromPlaylist(request: request, playlistId: playlistId, venueId: venueId) { (result: Result<EmptyResponse, APIError>) in
            switch result {
            case .success(let model):
                DispatchQueue.main.async {
                    completion(.success(model))
                }
            case .failure( let error):
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
    
    func deletePlaylist(request: DeletePlaylistRequest, completion: @escaping DeletePlaylistCompletionHandler) {
        self.dataStore.playlistService.deletePlaylist(request: request) { (result: Result<EmptyResponse, APIError>) in
            switch result {
            case .success(let model):
                DispatchQueue.main.async {
                    completion(.success(model))
                }
            case .failure( let error):
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
    
    func getVenues(request: VenuesRequest, completion: @escaping VenuesCompletionHandler) {
        self.dataStore.playlistService.getVenues(request: request) { (result: Result<Venues, APIError>) in
            switch result {
            case .success(let model):
                DispatchQueue.main.async {
                    completion(.success(model))
                }
            case .failure( let error):
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
    
    func getVenue(request: VenueRequest, completion: @escaping VenueCompletionHandler) {
        self.dataStore.playlistService.getVenue(request: request) { (result: Result<Venue, APIError>) in
            switch result {
            case .success(let model):
                DispatchQueue.main.async {
                    completion(.success(model))
                }
            case .failure( let error):
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
    
    func updateVenue(request: UpdateVenueRequest, playlistId: String, venueId: String, completion: @escaping UpdateVenueCompletionHandler) {
        self.dataStore.playlistService.updateVenue(request: request, playlistId: playlistId, venueId: venueId) { (result: Result<Venue, APIError>) in
            switch result {
            case .success(let model):
                DispatchQueue.main.async {
                    completion(.success(model))
                }
            case .failure( let error):
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
    
    func toggleLikeVenue(request: ToggleLikeVenueRequest, completion: @escaping ToggleLikeVenueCompletionHandler) {
        self.dataStore.playlistService.toggleLikeVenue(request: request) { (result: Result<ToggleLikeVenueResponse, APIError>) in
            switch result {
            case .success(let model):
                DispatchQueue.main.async {
                    completion(.success(model))
                }
            case .failure( let error):
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
}
