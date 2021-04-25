import Foundation
class WalletNWService: BaseNetworkService, WalletServiceProtocol {
   
    func performWalletRegistration(request: WalletRegisterRequest, completion: @escaping WalletRegisterCompletionHandler) {
        let endPoint = String(format: EndPoint.wallet_register, KeyChainServiceWrapper.standard.userHashId)
        self.networkService.performRequest(endPoint: endPoint, method: .post, requestObject: request, headers: TokenManager.shared().getRequestHeaders(), encodingType: .jsonEncoding) { (result: Result<CommonNotificationResponse, APIError>) in
            switch result {
            case .success(let model):
                completion(.success(model))
            case .failure( let error):
                completion(.failure(error))
            }
        }
    }

    func performGetRegisterWalletStatus(completion: @escaping GetWalletStatusompletionHandler) {
        let endPoint = String(format: EndPoint.wallet_register_status, KeyChainServiceWrapper.standard.userHashId)
        self.networkService.performRequest(endPoint: endPoint, method: .get, requestObject: NilRequest(), headers: TokenManager.shared().getRequestHeaders(), encodingType: .jsonEncoding) { (result: Result<WalletRegisterStatusResponse, APIError>) in
            switch result {
            case .success(let model):
                completion(.success(model))
            case .failure( let error):
                completion(.failure(error))
            }
        }
    }
    
    func performGenerateOTPForWallet(for generateMobileOTPEndPoint: MobileOTPType, request: OTPGenerationRequest, completion: @escaping WalletRegisterCompletionHandler) {
        
        var endPoint = ""
        if generateMobileOTPEndPoint == .registerWallet {
            endPoint = String(format: EndPoint.wallet_register, KeyChainServiceWrapper.standard.userHashId)
        } else if generateMobileOTPEndPoint == .updatePin {
            endPoint = String(format: EndPoint.generate_mobile_otp, KeyChainServiceWrapper.standard.userHashId)
        } else if generateMobileOTPEndPoint == .forgotPin {
            endPoint = String(format: EndPoint.forgot_mpin, KeyChainServiceWrapper.standard.userHashId)
        } else if generateMobileOTPEndPoint == .otpVerification {
            endPoint = String(format: EndPoint.generate_mobile_otp, KeyChainServiceWrapper.standard.userHashId)
        } else if generateMobileOTPEndPoint == .updateMobileNo {
            endPoint = String(format: EndPoint.updateMobileNo, KeyChainServiceWrapper.standard.userHashId)
        }
    
        self.networkService.performRequest(endPoint: endPoint, method: .post, requestObject: request, headers: TokenManager.shared().getRequestHeaders(), encodingType: .jsonEncoding) { (result: Result<CommonNotificationResponse, APIError>) in
            switch result {
            case .success(let model):
                completion(.success(model))
            case .failure( let error):
                completion(.failure(error))
            }
        }
    }
    
    func performVerifyMobileForWallet(request: VerifyMobileForWalletRequest, completion: @escaping WalletRegisterCompletionHandler) {
        let endPoint = String(format: EndPoint.verify_mobile_otp, KeyChainServiceWrapper.standard.userHashId)
        self.networkService.performRequest(endPoint: endPoint, method: .post, requestObject: request, headers: TokenManager.shared().getRequestHeaders(), encodingType: .jsonEncoding) { (result: Result<CommonNotificationResponse, APIError>) in
            switch result {
            case .success(let model):
                completion(.success(model))
            case .failure( let error):
                completion(.failure(error))
            }
        }
    }
    
    func performUpdateMobileNo(request: WalletRegisterRequest, completion: @escaping UpdateMobileNoCompletionHandler) {
        let endPoint = String(format: EndPoint.updateCustomerMobileNo, Config.CLIENT_HASHID, CommonUtil.customerHashID )
        self.networkService.performRequest(endPoint: endPoint, method: .post, requestObject: request, headers: TokenManager.shared().getRequestHeaders(), encodingType: .jsonEncoding) { (result: Result<CommonNotificationResponse, APIError>) in
            switch result {
            case .success(let model):
                completion(.success(model))
            case .failure( let error):
                completion(.failure(error))
            }
        }
    }
    
    func performCreateMpin(request: MpinRequest, completion: @escaping CreateMpinCompletionHandler) {
        let endPoint = String(format: EndPoint.create_mpin, KeyChainServiceWrapper.standard.userHashId)
        self.networkService.performRequest(endPoint: endPoint, method: .post, requestObject: request, headers: TokenManager.shared().getRequestHeaders(), encodingType: .jsonEncoding) { (result: Result<CommonNotificationResponse, APIError>) in
            switch result {
            case .success(let model):
                KeyChainServiceWrapper.standard.loginWalletPassword = request.mpin
                completion(.success(model))
            case .failure( let error):
                completion(.failure(error))
            }
        }
    }
    
    func performValidateMpin(request: MpinRequest, completion: @escaping ValidateMpinCompletionHandler) {
        let endPoint = String(format: EndPoint.validate_mpin, KeyChainServiceWrapper.standard.userHashId)
        self.networkService.performRequest(endPoint: endPoint, method: .post, requestObject: request, headers: TokenManager.shared().getRequestHeaders(), encodingType: .jsonEncoding) { (result: Result<ValidateMpinResponse, APIError>) in
            switch result {
            case .success(let model):
                KeyChainServiceWrapper.standard.loginWalletPassword = request.mpin
                completion(.success(model))
            case .failure( let error):
                completion(.failure(error))
            }
        }
    }
    
    func performForgotMpin(request: WalletRegisterRequest, completion: @escaping ForgotMpinCompletionHandler) {
        let endPoint = String(format: EndPoint.forgot_mpin, KeyChainServiceWrapper.standard.userHashId)
        self.networkService.performRequest(endPoint: endPoint, method: .post, requestObject: request, headers: TokenManager.shared().getRequestHeaders(), encodingType: .jsonEncoding) { (result: Result<CommonNotificationResponse, APIError>) in
            switch result {
            case .success(let model):
                completion(.success(model))
            case .failure( let error):
                completion(.failure(error))
            }
        }
    }
    
    func performUpdateWalletData(request: UpdateWalletDataRequest, completion: @escaping UpdateWalletDataCompletionHandler) {
        let endPoint = String(format: EndPoint.update_wallet_data, KeyChainServiceWrapper.standard.userHashId)
        self.networkService.performRequest(endPoint: endPoint, method: .post, requestObject: request, headers: TokenManager.shared().getRequestHeaders(), encodingType: .jsonEncoding) { (result: Result<CommonNotificationResponse, APIError>) in
            switch result {
            case .success(let model):
                completion(.success(model))
            case .failure( let error):
                completion(.failure(error))
            }
        }
    }
    
    func performAddCustomerwithMinimalCustomerData(request: MinimalCustomerDataRequest, completion: @escaping CustomerWithMinimalDataCompletionHandler) {
        let endPoint = String(format: EndPoint.minimal_Customer_Data, Config.CLIENT_HASHID)
        self.networkService.performRequest(endPoint: endPoint, method: .post, requestObject: request, headers: TokenManager.shared().getRequestHeaders(), encodingType: .jsonEncoding) { (result: Result<MinimalCustomerDataResponse, APIError>) in
            switch result {
            case .success(let model):
                completion(.success(model))
            case .failure( let error):
                completion(.failure(error))
            }
        }
    }

    func performGetCustomerData(customerHASHID: String, completion: @escaping GetCustomerDataCompletionHandler) {
        let endPoint = String(format: EndPoint.getCustomerDetail, Config.CLIENT_HASHID, customerHASHID)
        self.networkService.performRequest(endPoint: endPoint, method: .get, requestObject: NilRequest(), headers: TokenManager.shared().getRequestHeaders(), encodingType: .jsonEncoding) { (result: Result<Customer, APIError>) in
            switch result {
            case .success(let model):
                CommonUtil.userMobile = model.mobile ?? ""
                CommonUtil.userEmail = model.email ?? ""
                CommonUtil.customerHashID = model.customerHashId ?? ""
                CommonUtil.walletHashID  = model.walletHashId ?? ""
                completion(.success(model))
            case .failure( let error):
                completion(.failure(error))
            }
        }
    }
    
    func performUpdateWalletRegisteredStatus(request: UpdateWalletRegisteredRequest, completion: @escaping UpdateWalletRegisteredStatusCompletionHandler) {
        let endPoint = String(format: EndPoint.wallet_register_status, KeyChainServiceWrapper.standard.userHashId)
        self.networkService.performRequest(endPoint: endPoint, method: .post, requestObject: request, headers: TokenManager.shared().getRequestHeaders(), encodingType: .jsonEncoding) { (result: Result<CommonNotificationResponse, APIError>) in
            switch result {
            case .success(let model):
                completion(.success(model))
            case .failure( let error):
                completion(.failure(error))
            }
        }
    }    
    
    func performGetWalletTnC(completion: @escaping GetWalletTnCCompletionHandler) {
        let endPoint = String(format: EndPoint.get_wallet_tnc, Config.CLIENT_HASHID)
        self.networkService.performRequest(endPoint: endPoint, method: .get, requestObject: NilRequest(), headers: TokenManager.shared().getRequestHeaders(), encodingType: .jsonEncoding) { (result: Result<GetWalletTnCResponse, APIError>) in
            switch result {
            case .success(let model):
                completion(.success(model))
            case .failure( let error):
                completion(.failure(error))
            }
        }
    }

    func performAcceptWalletTnC(request: AcceptWalletTnCRequest, completion: @escaping AcceptWalletTnCCompletionHandler) {
        let endPoint = String(format: EndPoint.accept_wallet_tnc, Config.CLIENT_HASHID, CommonUtil.customerHashID )
        self.networkService.performRequest(endPoint: endPoint, method: .post, requestObject: request, headers: TokenManager.shared().getRequestHeaders(), encodingType: .jsonEncoding) { (result: Result<CommonNotificationResponse, APIError>) in
            switch result {
            case .success(let model):
                completion(.success(model))
            case .failure( let error):
                completion(.failure(error))
            }
        }
    }
    
    func performAddCard(completion: @escaping AddCardCompletionHandler) {
        let endPoint = String(format: EndPoint.addCard, Config.CLIENT_HASHID, CommonUtil.customerHashID, CommonUtil.walletHashID)
        self.networkService.performRequest(endPoint: endPoint, method: .get, requestObject: NilRequest(), headers: TokenManager.shared().getRequestHeaders(), encodingType: .jsonEncoding) { (result: Result<AddCardResponse, APIError>) in
            switch result {
            case .success(let model):
                completion(.success(model))
            case .failure( let error):
                completion(.failure(error))
            }
        }
    }
    
    func performGetWalletBalance(completion: @escaping GetWalletBalanceCompletionHandler) {
        let endPoint = String(format: EndPoint.getWalletBalance, Config.CLIENT_HASHID, CommonUtil.customerHashID, CommonUtil.walletHashID)
        self.networkService.performRequest(endPoint: endPoint, method: .get, requestObject: NilRequest(), headers: TokenManager.shared().getRequestHeaders(), encodingType: .jsonEncoding) { (result: Result<WalletBalanceResponseArray, APIError>) in
            switch result {
            case .success(let model):
                completion(.success(model))
            case .failure( let error):
                completion(.failure(error))
            }
        }
    }

}
