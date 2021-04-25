import Foundation

typealias LoginCompletionHandler = (_ result: Result<LoginResponse, APIError>) -> Void
typealias SignUpCompletionHandler = (_ result: Result<SignUpResponse, APIError>) -> Void
typealias OtpGenerationCompletionHandler = (_ result: Result<OTPResponse, APIError>) -> Void
typealias OtpVerificationCompletionHandler = (_ result: Result<OTPResponse, APIError>) -> Void
typealias ForgotPasswordCompletionHandler = (_ result: Result<ForgotPasswordResponse, APIError>) -> Void
typealias ResetPasswordCompletionHandler = (_ result: Result<CommonNotificationResponse, APIError>) -> Void
typealias UpdateTnCStatusCompletionHandler = (_ result: Result<CommonNotificationResponse, APIError>) -> Void

class UserManager: BaseManager {
    
    func performLogin(request: LoginRequest, completion: @escaping LoginCompletionHandler) {
        self.dataStore.userService.performLogin(request: request) { (result: Result<LoginResponse, APIError>) in
            
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
    
    func performSignUp(request: SignUpRequest, completion: @escaping SignUpCompletionHandler) {
        self.dataStore.userService.performSignUp(request: request) { (result: Result<SignUpResponse, APIError>) in
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
    
    func performGetOTP(request: OTPGenerationRequest, completion: @escaping OtpGenerationCompletionHandler) {
          self.dataStore.userService.performGetOTP(request: request) { (result: Result<OTPResponse, APIError>) in
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
    
    func performVerifyOTP(request: OTPVerificationRequest, completion: @escaping OtpVerificationCompletionHandler) {
            self.dataStore.userService.performVerifyOTP(request: request) { (result: Result<OTPResponse, APIError>) in
                
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
    
    func performForgotPassword(request: ForgotPasswordRequest, completion: @escaping ForgotPasswordCompletionHandler) {
        self.dataStore.userService.performForgotPassword(request: request) { (result: Result<ForgotPasswordResponse, APIError>) in
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
    
    func performResetPassword(request: ResetPasswordRequest, completion: @escaping ResetPasswordCompletionHandler) {
        self.dataStore.userService.performResetPassword(request: request) { (result: Result<CommonNotificationResponse, APIError>) in
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
            
    func updateTnCStatus(request: UpdateTnCStatusRequest, completion: @escaping UpdateTnCStatusCompletionHandler) {
        self.dataStore.userService.updateTnCStatus(request: request) { (result: Result<CommonNotificationResponse, APIError>) in
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
