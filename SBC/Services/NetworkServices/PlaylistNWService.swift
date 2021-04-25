import UIKit

class PlaylistNWService: BaseNetworkService, PlaylistServiceProtocol {
    
    func getPlaylists(request: PlaylistsRequest, completion: @escaping PlaylistsCompletionHandler) {
        let endPoint = String(format: EndPoint.playlists, KeyChainServiceWrapper.standard.userHashId)
        self.networkService.performRequest(endPoint: endPoint, method: .get, requestObject: request, headers: TokenManager.shared().getRequestHeaders(), encodingType: .urlEncoding) { (result: Result<Playlists, APIError>) in
            switch result {
            case .success(let model):
                completion(.success(model))
            case .failure( let error):
                completion(.failure(error))
            }
        }
    }
    
    func getPlaylistDetails(request: PlaylistDetailsRequest, completion: @escaping PlaylistDetailsCompletionHandler) {
        let endPoint = String(format: EndPoint.playlist, KeyChainServiceWrapper.standard.userHashId, request.id)
        self.networkService.performRequest(endPoint: endPoint, method: .get, requestObject: request, headers: TokenManager.shared().getRequestHeaders(), encodingType: .urlEncoding) { (result: Result<Playlist, APIError>) in
            switch result {
            case .success(let model):
                completion(.success(model))
            case .failure( let error):
                completion(.failure(error))
            }
        }
    }
    
    func getMyLikes(request: MyLikesRequest, completion: @escaping MyLikesCompletionHandler) {
        let endPoint = String(format: EndPoint.myLikes, KeyChainServiceWrapper.standard.userHashId)
        self.networkService.performRequest(endPoint: endPoint, method: .get, requestObject: request, headers: TokenManager.shared().getRequestHeaders(), encodingType: .urlEncoding) { (result: Result<MyLikes, APIError>) in
            switch result {
            case .success(let model):
                completion(.success(model))
            case .failure( let error):
                completion(.failure(error))
            }
        }
    }
    
    func toggleLikePlaylistDetails(request: ToggleLikePlaylistRequest, completion: @escaping ToggleLikePlaylistCompletionHandler) {
        let endPoint = String(format: EndPoint.likePlaylist, KeyChainServiceWrapper.standard.userHashId, request.id)
        self.networkService.performRequest(endPoint: endPoint, method: .post, requestObject: request, headers: TokenManager.shared().getRequestHeaders(), encodingType: .jsonEncoding) { (result: Result<ToggleLikePlaylistResponse, APIError>) in
            switch result {
            case .success(let model):
                completion(.success(model))
            case .failure( let error):
                completion(.failure(error))
            }
        }
    }
    
    func createPlaylist(request: CreatePlaylistRequest, completion: @escaping PlaylistDetailsCompletionHandler) {
        let endPoint = String(format: EndPoint.playlists, KeyChainServiceWrapper.standard.userHashId)
        self.networkService.performRequest(endPoint: endPoint, method: .post, requestObject: request, headers: TokenManager.shared().getRequestHeaders(), encodingType: .jsonEncoding) { (result: Result<Playlist, APIError>) in
            switch result {
            case .success(let model):
                completion(.success(model))
            case .failure( let error):
                completion(.failure(error))
            }
        }
    }
    
    func editPlaylist(request: PlaylistEditRequest, playlistId: String, completion: @escaping PlaylistDetailsCompletionHandler) {
        let endPoint = String(format: EndPoint.playlist, KeyChainServiceWrapper.standard.userHashId, playlistId)
        self.networkService.performRequest(endPoint: endPoint, method: .put, requestObject: request, headers: TokenManager.shared().getRequestHeaders(), encodingType: .jsonEncoding) { (result: Result<Playlist, APIError>) in
            switch result {
            case .success(let model):
                completion(.success(model))
            case .failure( let error):
                completion(.failure(error))
            }
        }
    }
    
    func addVenueToPlaylist(request: AddVenueToPlaylistRequest, playlistId: String, completion: @escaping UpdatePlaylistCompletionHandler) {
        let endPoint = String(format: EndPoint.venues, KeyChainServiceWrapper.standard.userHashId, playlistId)
        self.networkService.performRequest(endPoint: endPoint, method: .post, requestObject: request, headers: TokenManager.shared().getRequestHeaders(), encodingType: .jsonEncoding) { (result: Result<EmptyResponse, APIError>) in
            switch result {
            case .success(let model):
                completion(.success(model))
            case .failure( let error):
                completion(.failure(error))
            }
        }
    }
    
    func deleteVenueFromPlaylist(request: DeleteVenueFromPlaylistRequest, playlistId: String, venueId: String, completion: @escaping UpdatePlaylistCompletionHandler) {
        let endPoint = String(format: EndPoint.updateVenues, KeyChainServiceWrapper.standard.userHashId, playlistId, venueId)
        self.networkService.performRequest(endPoint: endPoint, method: .delete, requestObject: request, headers: TokenManager.shared().getRequestHeaders(), encodingType: .urlEncoding) { (result: Result<EmptyResponse, APIError>) in
            switch result {
            case .success(let model):
                completion(.success(model))
            case .failure( let error):
                completion(.failure(error))
            }
        }
    }
    
    func deletePlaylist(request: DeletePlaylistRequest, completion: @escaping DeletePlaylistCompletionHandler) {
        let endPoint = String(format: EndPoint.playlist, KeyChainServiceWrapper.standard.userHashId, request.id)
        self.networkService.performRequest(endPoint: endPoint, method: .delete, requestObject: request, headers: TokenManager.shared().getRequestHeaders(), encodingType: .urlEncoding) { (result: Result<EmptyResponse, APIError>) in
            switch result {
            case .success(let model):
                completion(.success(model))
            case .failure( let error):
                completion(.failure(error))
            }
        }
    }
    
    func getVenues(request: VenuesRequest, completion: @escaping VenuesCompletionHandler) {
        let endPoint = String(format: EndPoint.likedVenues, KeyChainServiceWrapper.standard.userHashId) 
        self.networkService.performRequest(endPoint: endPoint, method: .get, requestObject: request, headers: TokenManager.shared().getRequestHeaders(), encodingType: .urlEncoding) { (result: Result<Venues, APIError>) in
            switch result {
            case .success(let model):
                completion(.success(model))
            case .failure( let error):
                completion(.failure(error))
            }
        }
    }
    
    func getVenue(request: VenueRequest, completion: @escaping VenueCompletionHandler) {
        let endPoint = String(format: EndPoint.venue, KeyChainServiceWrapper.standard.userHashId, request.id)
        self.networkService.performRequest(endPoint: endPoint, method: .get, requestObject: request, headers: TokenManager.shared().getRequestHeaders(), encodingType: .urlEncoding) { (result: Result<Venue, APIError>) in
            switch result {
            case .success(let model):
                completion(.success(model))
            case .failure( let error):
                completion(.failure(error))
            }
        }
    }
    
    func updateVenue(request: UpdateVenueRequest, playlistId: String, venueId: String, completion: @escaping UpdateVenueCompletionHandler) {
        let endPoint = String(format: EndPoint.updateVenues, KeyChainServiceWrapper.standard.userHashId, playlistId, venueId)
        self.networkService.performRequest(endPoint: endPoint, method: .patch, requestObject: request, headers: TokenManager.shared().getRequestHeaders(), encodingType: .jsonEncoding) { (result: Result<Venue, APIError>) in
            switch result {
            case .success(let model):
                completion(.success(model))
            case .failure( let error):
                completion(.failure(error))
            }
        }
    }
    
    func toggleLikeVenue(request: ToggleLikeVenueRequest, completion: @escaping ToggleLikeVenueCompletionHandler) {
        let endPoint = String(format: EndPoint.likeVenue, KeyChainServiceWrapper.standard.userHashId, request.id)
        self.networkService.performRequest(endPoint: endPoint, method: .post, requestObject: request, headers: TokenManager.shared().getRequestHeaders(), encodingType: .jsonEncoding) { (result: Result<ToggleLikeVenueResponse, APIError>) in
            switch result {
            case .success(let model):
                completion(.success(model))
            case .failure( let error):
                completion(.failure(error))
            }
        }
    }
    
}
