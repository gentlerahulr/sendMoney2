import Foundation

protocol LoginDataPassingDelegate: AnyObject {
    func loginFailureWithError(message: String)
    func didLoginSuccess(loginResponse: LoginResponse)
}

protocol LoginViewModelProtocol {
    var delegate: LoginDataPassingDelegate? { get set }
    var loginType: String? { get set }
    func callLoginAPI(loginRequest: LoginRequest)
}

class LoginViewModel: LoginViewModelProtocol {
    
    weak var delegate: LoginDataPassingDelegate?
    var loginResponse: LoginResponse?
    var loginType: String?
    let userManager = UserManager(dataStore: APIStore.instance)
    func callLoginAPI(loginRequest: LoginRequest) {
        CommonUtil.sharedInstance.showLoader()
        userManager.performLogin(request: loginRequest, completion: { result in
            CommonUtil.sharedInstance.removeLoader()
            switch result {
            case .success(let loginData):
                self.loginResponse = loginData
                self.delegate?.didLoginSuccess(loginResponse: loginData)
            case .failure( let error):
                self.delegate?.loginFailureWithError(message: error.localizedDescription)
            }
        })
    }
    
}
