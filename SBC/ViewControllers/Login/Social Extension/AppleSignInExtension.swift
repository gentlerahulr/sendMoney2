//
//  AppleSignInExtension.swift
//  SBC
//
import AuthenticationServices
import UIKit

@available(iOS 13.0, *)
extension LoginViewController: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    
    /// This method checks for Apple Sign In
    func checAppleSignIn() {
        let appleLogInButton = ASAuthorizationAppleIDButton()
        appleLogInButton.addTarget(self, action: #selector(handleLogInWithAppleID), for: .touchUpInside)
        if UserDefaults.standard.dAppleUserIdentifier != "" {
            let authorizationProvider = ASAuthorizationAppleIDProvider()
            authorizationProvider.getCredentialState(forUserID: UserDefaults.standard.dAppleUserIdentifier) { (state, _) in
                switch state {
                case .authorized:
                    debugPrint("Account Found - Signed In")
                    DispatchQueue.main.async {
                        //Navigate to next VC
                    }
                    break
                case .revoked:
                    debugPrint("No Account Found")
                    fallthrough
                case .notFound:
                    debugPrint("No Account Found")
                    DispatchQueue.main.async {
                        // Navigate to Login VC
                    }
                default:
                    break
                }
            }
        } else {
            // Fallback on earlier versions
        }
    }
    
    @objc func handleLogInWithAppleID() {
        let request = ASAuthorizationAppleIDProvider().createRequest()
        request.requestedScopes = [.fullName, .email]
        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = self
        controller.presentationContextProvider = self
        controller.performRequests()
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        switch authorization.credential {
        case let appleIDCredential as ASAuthorizationAppleIDCredential:
            UserDefaults.standard.dAppleUserIdentifier = appleIDCredential.user
            let appleUserEmail = appleIDCredential.email
            let loginRequest = LoginRequest(deviceId: K.deviceId, email: appleUserEmail ?? "", password: "", loginType: "appleId", facebookId: "", appleId: UserDefaults.standard.dAppleUserIdentifier)
            self.loginViewModel?.callLoginAPI(loginRequest: loginRequest)
            break
        default:
            break
        }
    }
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
    
}
