import Foundation

typealias WalletRegisterCompletionHandler = (_ result: Result<CommonNotificationResponse, APIError>) -> Void
typealias GetWalletStatusompletionHandler = (_ result: Result<WalletRegisterStatusResponse, APIError>) -> Void
typealias WalletOTPCompletionHandler = (_ result: Result<CommonNotificationResponse, APIError>) -> Void
typealias UpdateWalletRegisteredStatusCompletionHandler = (_ result: Result<CommonNotificationResponse, APIError>) -> Void
typealias CreateMpinCompletionHandler = (_ result: Result<CommonNotificationResponse, APIError>) -> Void
typealias ValidateMpinCompletionHandler = (_ result: Result<ValidateMpinResponse, APIError>) -> Void
typealias ForgotMpinCompletionHandler = (_ result: Result<CommonNotificationResponse, APIError>) -> Void
typealias UpdateWalletDataCompletionHandler = (_ result: Result<CommonNotificationResponse, APIError>) -> Void
typealias CustomerWithMinimalDataCompletionHandler = (_ result: Result<MinimalCustomerDataResponse, APIError>) -> Void
typealias GetCustomerDataCompletionHandler = (_ result: Result<Customer, APIError>) -> Void
typealias GetWalletTnCCompletionHandler = (_ result: Result<GetWalletTnCResponse, APIError>) -> Void
typealias AcceptWalletTnCCompletionHandler = (_ result: Result<CommonNotificationResponse, APIError>) -> Void
typealias UpdateMobileNoCompletionHandler = (_ result: Result<CommonNotificationResponse, APIError>) -> Void
typealias AddCardCompletionHandler = (_ result: Result<AddCardResponse, APIError>) -> Void
typealias GetWalletBalanceCompletionHandler = (_ result: Result<WalletBalanceResponseArray, APIError>) -> Void

class WalletManager: BaseManager {
    
    func performGetwAlletStatus( completion: @escaping GetWalletStatusompletionHandler) {
        self.dataStore.walletService.performGetRegisterWalletStatus { (result: Result<WalletRegisterStatusResponse, APIError>) in
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
    
    func performUpdateWalletStatus( request: UpdateWalletRegisteredRequest, completion: @escaping UpdateWalletRegisteredStatusCompletionHandler) {
        self.dataStore.walletService.performUpdateWalletRegisteredStatus(request: request) { (result: Result<CommonNotificationResponse, APIError>) in
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
    
    func performOTPgenerationForMobile(for generateOTPEndPoint: MobileOTPType, request: OTPGenerationRequest, completion: @escaping WalletOTPCompletionHandler) {
        self.dataStore.walletService.performGenerateOTPForWallet(for: generateOTPEndPoint, request: request) { (result: Result<CommonNotificationResponse, APIError>) in
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
    
    func performVerifyMobile(request: VerifyMobileForWalletRequest, completion: @escaping WalletOTPCompletionHandler) {
        self.dataStore.walletService.performVerifyMobileForWallet(request: request) { (result: Result<CommonNotificationResponse, APIError>) in
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
    
    func performCreateMPIN(request: MpinRequest, completion: @escaping CreateMpinCompletionHandler) {
        self.dataStore.walletService.performCreateMpin(request: request) { (result: Result<CommonNotificationResponse, APIError>) in
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
    
    func performValidateMPIN(request: MpinRequest, completion: @escaping ValidateMpinCompletionHandler) {
        self.dataStore.walletService.performValidateMpin(request: request) { (result: Result<ValidateMpinResponse, APIError>) in
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
    
    func performAddCustomerWithMinimalCustomerData(request: MinimalCustomerDataRequest, completion: @escaping CustomerWithMinimalDataCompletionHandler) {
        self.dataStore.walletService.performAddCustomerwithMinimalCustomerData(request: request) { (result: Result<MinimalCustomerDataResponse, APIError>) in
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
    
    func performGetCustomerData(customerHashID: String, completion: @escaping GetCustomerDataCompletionHandler) {
        self.dataStore.walletService.performGetCustomerData(customerHASHID: customerHashID) { (result: Result<Customer, APIError>) in
            switch result {
            case .success(let model):
                DispatchQueue.main.async {
                    CommonUtil.userMobile = model.mobile ?? ""
                    CommonUtil.userEmail = model.email ?? ""
                    CommonUtil.customerHashID = model.customerHashId ?? ""
                    CommonUtil.walletHashID  = model.walletHashId ?? ""
                    completion(.success(model))
                }
            case .failure( let error):
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
                   
       func performUpdateWalletData(request: UpdateWalletDataRequest, completion: @escaping UpdateWalletDataCompletionHandler) {
           self.dataStore.walletService.performUpdateWalletData(request: request) { (result: Result<CommonNotificationResponse, APIError>) in
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
    
    func performGetWalletTnC( completion: @escaping GetWalletTnCCompletionHandler) {
        self.dataStore.walletService.performGetWalletTnC { (result: Result<GetWalletTnCResponse, APIError>) in
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
    
    func performAcceptTnC(request: AcceptWalletTnCRequest, completion: @escaping AcceptWalletTnCCompletionHandler) {
        self.dataStore.walletService.performAcceptWalletTnC(request: request) { (result: Result<CommonNotificationResponse, APIError>) in
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
    
    func performUpdateCustomerMobile(request: WalletRegisterRequest, completion: @escaping UpdateMobileNoCompletionHandler) {
        self.dataStore.walletService.performUpdateMobileNo(request: request) { (result: Result<CommonNotificationResponse, APIError>) in
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
    
    func performAddCard(completion: @escaping AddCardCompletionHandler) {
        self.dataStore.walletService.performAddCard { (result: Result<AddCardResponse, APIError>) in
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
    
    func performGetWalletBalance(completion: @escaping GetWalletBalanceCompletionHandler) {
        self.dataStore.walletService.performGetWalletBalance { (result: Result<WalletBalanceResponseArray, APIError>) in
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
