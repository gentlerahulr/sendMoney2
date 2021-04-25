import Foundation

class UserNWService: BaseNetworkService, UserServiceProtocol {
  
    func performSignUp(request: SignUpRequest, completion: @escaping SignUpCompletionHandler) {
        let endPoint = EndPoint.signUP
        self.networkService.performRequest(endPoint: endPoint, method: .post, requestObject: request, headers: TokenManager.shared().getRequestHeaders(), encodingType: .jsonEncoding) { (result: Result<SignUpResponse, APIError>) in
            switch result {
            case .success(let model):
                KeyChainServiceWrapper.standard.userHashId = model.userHashId
                completion(.success(model))
            case .failure( let error):
                completion(.failure(error))
            }
        }
        
    }
    
    func performLogin(request: LoginRequest, completion: @escaping LoginCompletionHandler) {
        setAppConfiguration()
        let endPoint = EndPoint.login
        self.networkService.performRequest(endPoint: endPoint, method: .post, requestObject: request, headers: TokenManager.shared().getRequestHeaders(), encodingType: .jsonEncoding) { (result: Result<LoginResponse, APIError>) in
            switch result {
            case .success(let model):
                KeyChainServiceWrapper.standard.userHashId = model.userHashId
                completion(.success(model))
            case .failure( let error):
                completion(.failure(error))
            }
        }   
    }
    
    private func setAppConfiguration() {
        let endPoint = String(format: EndPoint.configuration, Config.CLIENT_HASHID)
        if UserDefaults.standard.appConfigurationValues == nil {
            self.networkService.performRequest(endPoint: endPoint, method: .get, requestObject: NilRequest(), headers: TokenManager.shared().getRequestHeaders(), encodingType: .jsonEncoding) { (result: Result<ONZConfiguration, APIError>) in
                switch result {
                case .success(let data):
                    UserDefaults.standard.appConfigurationValues = data
                case .failure( let error):
                    debugPrint("failed to load value\(error.localizedDescription)")
                }
            }
        }
    }
    
    func performGetOTP(request: OTPGenerationRequest, completion: @escaping OtpGenerationCompletionHandler) {
        let endPoint = String(format: EndPoint.getOTP, KeyChainServiceWrapper.standard.userHashId)
        self.networkService.performRequest(endPoint: endPoint, method: .post, requestObject: request, headers: TokenManager.shared().getBasicAuthRequestHeader(), encodingType: .jsonEncoding) { (result: Result<OTPResponse, APIError>) in
            switch result {
            case .success(let model):
                completion(.success(model))
            case .failure( let error):
                completion(.failure(error))
            }
        }
    }
    
    func performVerifyOTP(request: OTPVerificationRequest, completion: @escaping OtpVerificationCompletionHandler) {
        let endPoint = EndPoint.emailOTPVerification
        self.networkService.performRequest(endPoint: endPoint, method: .post, requestObject: request, headers: TokenManager.shared().getBasicAuthRequestHeader(), encodingType: .jsonEncoding) { (result: Result<OTPResponse, APIError>) in
            switch result {
            case .success(let model):
                completion(.success(model))
            case .failure( let error):
                completion(.failure(error))
            }
        }
    }
    
    func performForgotPassword(request: ForgotPasswordRequest, completion: @escaping ForgotPasswordCompletionHandler) {
        let endPoint = EndPoint.forgotPassword
        self.networkService.performRequest(endPoint: endPoint, method: .post, requestObject: request, headers: TokenManager.shared().getBasicAuthRequestHeader(), encodingType: .jsonEncoding) { (result: Result<ForgotPasswordResponse, APIError>) in
            switch result {
            case .success(let model):
                completion(.success(model))
            case .failure( let error):
                completion(.failure(error))
            }
        }
    }
    
    func performResetPassword(request: ResetPasswordRequest, completion: @escaping ResetPasswordCompletionHandler) {
        let endPoint = EndPoint.resetPassword
        self.networkService.performRequest(endPoint: endPoint, method: .post, requestObject: request, headers: TokenManager.shared().getBasicAuthRequestHeader(), encodingType: .jsonEncoding) { (result: Result<CommonNotificationResponse, APIError>) in
            switch result {
            case .success(let model):
                //TODO: Update User data to sotore details in DB.
                completion(.success(model))
            case .failure( let error):
                completion(.failure(error))
            }
        }
    }
    
    func updateTnCStatus(request: UpdateTnCStatusRequest, completion: @escaping UpdateTnCStatusCompletionHandler) {
        let endPoint = String(format: EndPoint.updateTnCStatus, KeyChainServiceWrapper.standard.userHashId)
        self.networkService.performRequest(endPoint: endPoint, method: .post, requestObject: request, headers: TokenManager.shared().getBasicAuthRequestHeader(), encodingType: .jsonEncoding) { (result: Result<CommonNotificationResponse, APIError>) in
            switch result {
            case .success(let model):
                completion(.success(model))
            case .failure( let error):
                completion(.failure(error))
            }
        }
    }
    
}
