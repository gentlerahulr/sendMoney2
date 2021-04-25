import Foundation

protocol EditPlaylistViewModelProtocol: class {
    func updateLoadingStatus(isLoading: Bool)
    func goBack(withData: Playlist?)
    func goToNewPlaylist(withData: Playlist?)
    func failureWithError(error: APIError)
}
protocol CreatePlaylistViewModelProtocol: class {
    func goBack(withText: String, forField: PlaylistField)
}

class EditPlaylistFieldViewModel: BaseViewModel {
    
    var field: PlaylistField
    var playlist: Playlist?
    var venue: Venue?
    var currentValue: String?
    let playlistManager = PlaylistManager(dataStore: APIStore.instance)
    weak var editDelegate: EditPlaylistViewModelProtocol?
    weak var createDelegate: CreatePlaylistViewModelProtocol?
    var lastRequest: Any?
    
    init(withField: PlaylistField, playlist: Playlist? = nil, currentValue: String? = nil) {
        self.field = withField
        self.playlist = playlist
        self.currentValue = currentValue
    }
    
    func currentFieldValue() -> String {
        if let playlist = playlist {
            switch field {
            case .title:
                return playlist.title ?? ""
            case .subtitle:
                return playlist.subtitle ?? ""
            case .description:
                return playlist.description ?? ""
            case .venueCaption:
                return venue?.caption ?? ""
            case .newList:
                return ""
            }
        } else {
            return currentValue ?? ""
        }
    }
    
    func validateField(textToValidate: String) -> ValidationState {
        if Validator.validate(textToValidate, rules: [.minLength(3)]) != .valid {
            return .inValid(field.minLengthError)
        }
        if Validator.validate(textToValidate, rules: [.oneLetter]) != .valid {
            return .inValid(field.oneLetterError)
        }
        
        return .valid
    }
    
    private func createPlaylist(createRequest: CreatePlaylistRequest) {
        lastRequest = createRequest
        editDelegate?.updateLoadingStatus(isLoading: true)
        playlistManager.createPlaylist(request: createRequest, completion: { result in
            switch result {
            case .success(let playlistData):
                self.editDelegate?.updateLoadingStatus(isLoading: false)
                self.editDelegate?.goToNewPlaylist(withData: playlistData)
            case .failure(let error):
                self.editDelegate?.updateLoadingStatus(isLoading: false)
                self.editDelegate?.failureWithError(error: error)
            }
        })
    }
    
    private func editPlaylist(request: PlaylistEditRequest) {
        if let playlist = playlist {
            lastRequest = request
            editDelegate?.updateLoadingStatus(isLoading: true)
            playlistManager.editPlaylist(request: request, playlistId: playlist.id, completion: { result in
                switch result {
                case .success(let playlistData):
                    self.editDelegate?.updateLoadingStatus(isLoading: false)
                    self.editDelegate?.goBack(withData: playlistData)
                case .failure(let error):
                    self.editDelegate?.updateLoadingStatus(isLoading: false)
                    self.editDelegate?.failureWithError(error: error)
                }
            })
        }
    }
    
    private func editVenue(editRequest: UpdateVenueRequest) {
        lastRequest = editRequest
        editDelegate?.updateLoadingStatus(isLoading: true)
        if let playlist = playlist, let venue = venue {
            playlistManager.updateVenue(request: editRequest, playlistId: playlist.id, venueId: venue.id, completion: { result in
                switch result {
                case .success(let venue):
                    let playlistData = self.manuallyEditCaption(withText: (venue.caption ?? editRequest.caption)!)
                    self.editDelegate?.updateLoadingStatus(isLoading: false)
                    self.editDelegate?.goBack(withData: playlistData)
                case .failure(let error):
                    self.editDelegate?.updateLoadingStatus(isLoading: false)
                    self.editDelegate?.failureWithError(error: error)
                }
            })
        }
    }
    
    func performRequest(withTitle: String, subtitle: String?, description: String?) {
        switch field {
        case .description, .subtitle, .title:
            if let playlist = playlist {
                let editRequest = PlaylistEditRequest(title: field == .title ? withTitle : playlist.title, subtitle: field == .subtitle ? withTitle : playlist.subtitle, description: field == .description ? withTitle : playlist.description)
                editPlaylist(request: editRequest)
            } else {
                createDelegate?.goBack(withText: withTitle, forField: field)
            }
        case .newList:
            let createRequest = CreatePlaylistRequest(title: withTitle, subtitle: subtitle, description: description, venueId: venue?.id)
            createPlaylist(createRequest: createRequest)
        case .venueCaption:
            let editRequest = UpdateVenueRequest(caption: withTitle)
            editVenue(editRequest: editRequest)
        }
    }
    
    func tryAgain() {
        if let lastRequest = lastRequest as? CreatePlaylistRequest {
            createPlaylist(createRequest: lastRequest)
        } else if let lastRequest = lastRequest as? PlaylistEditRequest {
            editPlaylist(request: lastRequest)
        } else if let lastRequest = lastRequest as? UpdateVenueRequest {
            editVenue(editRequest: lastRequest)
        }
    }
    
    private func manuallyEditCaption(withText: String) -> Playlist? {
        if var playlistData = playlist, var currentVenue = venue, var venues = playlistData.venues, let indexOfVenue = venues.data.firstIndex(of: currentVenue) {
            currentVenue.caption = withText
            venues.data[indexOfVenue] = currentVenue
            playlistData.venues = venues
            return playlistData
        }
        return nil
    }
}
