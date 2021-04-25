import Foundation

protocol UserServiceProtocol {
    func performLogin(request: LoginRequest, completion:@escaping LoginCompletionHandler)
    func performSignUp(request: SignUpRequest, completion:@escaping SignUpCompletionHandler)
    func performGetOTP(request: OTPGenerationRequest, completion:@escaping OtpGenerationCompletionHandler)
    func performVerifyOTP(request: OTPVerificationRequest, completion:@escaping OtpVerificationCompletionHandler)
    func performForgotPassword(request: ForgotPasswordRequest, completion: @escaping ForgotPasswordCompletionHandler)
    func performResetPassword(request: ResetPasswordRequest, completion: @escaping ResetPasswordCompletionHandler)
    func updateTnCStatus(request: UpdateTnCStatusRequest, completion: @escaping UpdateTnCStatusCompletionHandler)
}

protocol WalletServiceProtocol {
    func performGetRegisterWalletStatus(completion: @escaping GetWalletStatusompletionHandler)
    func performGenerateOTPForWallet(for  generateMobileOTPEndPoint: MobileOTPType, request: OTPGenerationRequest, completion: @escaping WalletRegisterCompletionHandler)
    func performUpdateWalletRegisteredStatus(request: UpdateWalletRegisteredRequest, completion: @escaping UpdateWalletRegisteredStatusCompletionHandler)
    func performCreateMpin(request: MpinRequest, completion: @escaping CreateMpinCompletionHandler)
    func performValidateMpin(request: MpinRequest, completion: @escaping ValidateMpinCompletionHandler)
    func performForgotMpin(request: WalletRegisterRequest, completion: @escaping ForgotMpinCompletionHandler)
    func performUpdateWalletData(request: UpdateWalletDataRequest, completion: @escaping UpdateWalletDataCompletionHandler)
    func performVerifyMobileForWallet(request: VerifyMobileForWalletRequest, completion: @escaping WalletRegisterCompletionHandler)
    func performAddCustomerwithMinimalCustomerData(request: MinimalCustomerDataRequest, completion: @escaping CustomerWithMinimalDataCompletionHandler)
    func performGetCustomerData(customerHASHID: String, completion: @escaping GetCustomerDataCompletionHandler)
    func performGetWalletTnC(completion: @escaping GetWalletTnCCompletionHandler)
    func performAcceptWalletTnC(request: AcceptWalletTnCRequest, completion: @escaping AcceptWalletTnCCompletionHandler)
    func performUpdateMobileNo(request: WalletRegisterRequest, completion: @escaping UpdateMobileNoCompletionHandler)
    func performAddCard(completion: @escaping AddCardCompletionHandler)
    func performGetWalletBalance(completion: @escaping GetWalletBalanceCompletionHandler)
}
//@escaping TopUpCardTransactionResponse
protocol TopUpServiceProtocol {
    func performGetSavedCardList(customerHASHID: String, completion: @escaping GetListSaveCardCompletionHandler)
    func performTopUpUsingCard(request: TopUpCardRequest, completion: @escaping TopUpCardCompletionHandler)
    func performGetTransactionUsingSystemRefNo(systemReferanceNo: String, completion: @escaping GetTransacUsingSystemRefCompletionHandler)
    func performTopUpFromPaynow(request: TopUpFromPayNowRequest, completion: @escaping PayNowTopUpCompletionHandler)
}

protocol WithdrawServiceProtocol {
    func performAddBenificiary(request: AddBenificiaryRequest, completion: @escaping AddBenifiCiaryCompletionHandler)
    func performGetBenificiaryDetail(beneficiaryHashId: String, completion: @escaping BenifiCiaryDetailCompletionHandler )
    func performGetBenifiCiaryList(completion: @escaping BenifiCiaryListCompletionHandler)
    func performGetRoutingCode(beneficiaryHashId: String, routingCodeType1: String, routingCodeValue1: String, completion: @escaping RoutingCodeCompletionHandler)
    func perfromExchangeRate(comletion: @escaping ExchangeRateCompletionHandler)
    func performTransferMoney(request: TransferMoneyRequest, completion: @escaping TransferMoneyCompletionHandler)
    func performSearchBank(request: SearchBankRequest, completion: @escaping BankListCompletionHandler)
    func performValidateSchema(completion: @escaping ValidateSchema)
}

protocol CustomerServiceProtocol {
    func performGetCardDetails(cardHashId: String, completion: @escaping CardDetailsCompletionHandler)
    func performGetUnmaskCardDetail(cardHashId: String, completion: @escaping UnmaskCardDetailCompletionHandler)
    func performGetCardCVVDetail(cardHashId: String, completion: @escaping CardCVVDetailCompletionHandler)
    func performGetCardDetailList(completion: @escaping CardDetailListCompletionHandler)
    func performGetCardImageURLs(completion: @escaping CardImageURLsCompletionHandler)
}

protocol TransferServiceProtocol {
    
}

protocol MoneyThorServiceProtocol {
    func performGetTransactionList(
        request: MTTransactionListRequest,
        completion: @escaping GetTransactionListCompletionHandler
    )

    func performGetTransaction(
        request: MTTransactionDetailRequest,
        completion: @escaping GetTransactionCompletionHandler
    )

    func performGetTransactionCategories(
        completion: @escaping GetTransactionCategoriesCompletionHandler
    )

    func performSyncTransactionCustomFields(
        request: MTSyncTransactionCustomFieldRequest,
        completion: @escaping UpdateTransactionCompletionHandler
    )
}

protocol PlaylistServiceProtocol {
    func getPlaylists(request: PlaylistsRequest, completion: @escaping PlaylistsCompletionHandler)
    func getPlaylistDetails(request: PlaylistDetailsRequest, completion: @escaping PlaylistDetailsCompletionHandler)
    func getMyLikes(request: MyLikesRequest, completion: @escaping MyLikesCompletionHandler)
    func createPlaylist(request: CreatePlaylistRequest, completion: @escaping PlaylistDetailsCompletionHandler)
    func toggleLikePlaylistDetails(request: ToggleLikePlaylistRequest, completion: @escaping ToggleLikePlaylistCompletionHandler)
    func editPlaylist(request: PlaylistEditRequest, playlistId: String, completion: @escaping PlaylistDetailsCompletionHandler)
    func addVenueToPlaylist(request: AddVenueToPlaylistRequest, playlistId: String, completion: @escaping UpdatePlaylistCompletionHandler)
    func deleteVenueFromPlaylist(request: DeleteVenueFromPlaylistRequest, playlistId: String, venueId: String, completion: @escaping UpdatePlaylistCompletionHandler)
    func deletePlaylist(request: DeletePlaylistRequest, completion: @escaping DeletePlaylistCompletionHandler)
    func getVenues(request: VenuesRequest, completion: @escaping VenuesCompletionHandler)
    func getVenue(request: VenueRequest, completion: @escaping VenueCompletionHandler)
    func updateVenue(request: UpdateVenueRequest, playlistId: String, venueId: String, completion: @escaping UpdateVenueCompletionHandler)
    func toggleLikeVenue(request: ToggleLikeVenueRequest, completion: @escaping ToggleLikeVenueCompletionHandler)
}

protocol RecommendationsServiceProtocol {
    func getRecommendations(request: RecommendationsRequest, completion: @escaping RecommendationsCompletionHandler)
}

protocol SearchServiceProtocol {
    func getTrendingList(request: TrendingRequest, completion: @escaping TrendingsCompletionHandler)
    func getSuggestedList(request: SuggestedRequest, completion: @escaping TrendingsCompletionHandler)
    func getCuisineList(request: CuisinesRequest, completion: @escaping CuisinesCompletionHandler)
    func getSearchResult(request: SearchRequest, completion: @escaping SearchResultCompletionHandler)
}
