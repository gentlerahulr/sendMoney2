import Foundation

class UserDBService: BaseDBService, UserServiceProtocol {
    
    func performSignUp(request: SignUpRequest, completion: @escaping SignUpCompletionHandler) {
        debugPrint("Method Not Implemented for UserDBService")
    }
    
    func performLogin(request: LoginRequest, completion: @escaping LoginCompletionHandler) {
        debugPrint("Method Not Implemented for UserDBService")
    }
    func performGetOTP(request: OTPGenerationRequest, completion: @escaping OtpGenerationCompletionHandler) {
        debugPrint("Method Not Implemented for UserDBService")
    }
    func performVerifyOTP(request: OTPVerificationRequest, completion: @escaping OtpVerificationCompletionHandler) {
        debugPrint("Method Not Implemented for UserDBService")
    }

    func performForgotPassword(request: ForgotPasswordRequest, completion: @escaping ForgotPasswordCompletionHandler) {
        debugPrint("Method Not Implemented for UserDBService")
    }
    
    func performResetPassword(request: ResetPasswordRequest, completion: @escaping ResetPasswordCompletionHandler) {
        debugPrint("Method Not Implemented for UserDBService")
    }
    
    func updateTnCStatus(request: UpdateTnCStatusRequest, completion: @escaping UpdateTnCStatusCompletionHandler) {
        debugPrint("Method Not Implemented for UserDBService")
    }
}
