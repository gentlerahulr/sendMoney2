//
//  YourLikesViewModel.swift
//  SBC
//

import Foundation

protocol YourLikesDataDelegate: AnyObject {
    func didReceiveData()
    func failureWithError(message: String)
    func didToggleLikePlaylist(error: APIError?, indexPath: IndexPath?)
    func didToggleLikeVenue(error: APIError?, indexPath: IndexPath?)
}

class YourLikesViewModel {
    
    let Playlist_Request_Limit_Size = 7
    
    weak var delegate: YourLikesDataDelegate?
    private let playlistManager = PlaylistManager(dataStore: APIStore.instance)
    var playlists: Playlists?
    var venues: Venues?
    
    var likedPlaylistsSectionTitle: String {
        "LISTS_YOU_HAVE_LIKED".localized(bundle: Bundle.main)
    }
    
    var likedVenuesSectionTitle: String {
        "VENUES_YOU_HAVE_LIKED".localized(bundle: Bundle.main)
    }
    
    //used for local state. Prevents misuse and increases usability
    private var likedPlayListsIDs = [String]()
    private var likedVenueIds = [String]()
    
    func loadRemoteData() {
        callMyLikesAPI()
    }
    
    func loadAdditionalPlaylistData() {
        callPlayListsAPI()
    }
    
    private func callMyLikesAPI() {
        let myLikesRequest = MyLikesRequest()
        playlistManager.getMyLikes(request: myLikesRequest, completion: { result in
            switch result {
            case .success(let data):
                self.playlists = data.playlists
                self.venues = data.venues
                self.delegate?.didReceiveData()
            case .failure( let error):
                self.delegate?.failureWithError(message: error.localizedDescription)
            }
        })
    }
    
    private func callPlayListsAPI() {
        let playListsRequest = PlaylistsRequest(limit: Playlist_Request_Limit_Size, user: nil, pageToken: playlists?.nextPageToken, venueId: nil, liked: "true")
        playlistManager.getPlaylistList(request: playListsRequest) { result in
            switch result {
            case .success(let newPlaylists):
                if let items = newPlaylists.data {
                    self.playlists?.data?.append(contentsOf: items)
                    self.playlists?.count = newPlaylists.count
                    self.playlists?.nextPageToken = newPlaylists.nextPageToken
                }
                self.delegate?.didReceiveData()
            case .failure( let error):
                self.delegate?.failureWithError(message: error.localizedDescription)
            }
        }
    }
    
    func likePlaylist(indexPath: IndexPath?) {
        if let indexPath = indexPath, let playlistId = playlists?.data?[indexPath.row].id {
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
        if let indexPath = indexPath, let likedId = venues?.data[indexPath.row].id {
            
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
}
