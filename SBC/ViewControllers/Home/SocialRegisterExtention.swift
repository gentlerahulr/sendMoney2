//
//  SocialRegisterExtention.swift
//  SBC

import UIKit
import FBSDKLoginKit
import AuthenticationServices

extension HomeViewController: LoginButtonDelegate, ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    
    /// This method checks for Apple Sign In
    @available(iOS 13.0, *)
    func checAppleSignIn() {
        let appleLogInButton = ASAuthorizationAppleIDButton()
        appleLogInButton.addTarget(self, action: #selector(handleLogInWithAppleID), for: .touchUpInside)
        if UserDefaults.standard.dAppleUserIdentifier != ""{
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
    
    @available(iOS 13.0, *)
    @objc func handleLogInWithAppleID() {
        let request = ASAuthorizationAppleIDProvider().createRequest()
        request.requestedScopes = [.fullName, .email]
        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = self
        controller.presentationContextProvider = self
        controller.performRequests()
    }
    
    @available(iOS 13.0, *)
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        switch authorization.credential {
        case let appleIDCredential as ASAuthorizationAppleIDCredential:
            UserDefaults.standard.dAppleUserIdentifier = appleIDCredential.user
            let appleUserFirstName = appleIDCredential.fullName?.givenName
            let appleUserFamilyName = appleIDCredential.fullName?.familyName
            let appleUserEmail = appleIDCredential.email
            singUpViewModel.updateName(name: "\(appleUserFirstName ?? "")\(appleUserFamilyName ?? "")")
            singUpViewModel.updateEmail(email: appleUserEmail)
            singUpViewModel.updateAppleId(appleId: appleIDCredential.user)
            self.singUpViewModel.callSignUpAPI(type: "appleId")
            break
        default:
            break
        }
    }
    @available(iOS 13.0, *)
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
    // MARK: FB login delegates
    
    func fetchifUserLoggedInWithFB() {
        GraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, email"]).start(completionHandler: { (_, result, error) -> Void in
            if error == nil {
                //parse the fields out of the result
                if result as? [String: Any] != nil {
                    //Todo:
                }
            }
        })
    }
    
    /// This method adds fb login button to loginViewController
    func addFBLoginButton() {
        if let token = AccessToken.current,
            !token.isExpired {
            fetchifUserLoggedInWithFB()
        }
    }
    
    ///This method has the logic
    func fbLoginLogic() {
        loginManager.logIn(permissions: ["public_profile", "email"], from: self, handler: { result, error in
            if error != nil {
                print("ERROR: Trying to get login results")
            } else if result?.isCancelled != nil {
                print("The token is \(result?.token?.tokenString ?? "")")
                if result?.token?.tokenString != nil {
                    print("Logged in")
                    self.getUserProfile(token: result?.token, userId: result?.token?.userID)
                } else {
                    print("Cancelled")
                }
            }
        })
    }
    
    func getUserProfile(token: AccessToken?, userId: String?) {
        let graphRequest: GraphRequest = GraphRequest(graphPath: "me", parameters: ["fields": "id, first_name, middle_name, last_name, name, picture, email"])
        graphRequest.start { _, result, error in
            if error == nil {
                let data: [String: AnyObject] = result as! [String: AnyObject]
                if let firtName = data["first_name"] as? String,
                    let lastName = data["last_name"] as? String,
                    let email = data["email"] as? String,
                    let facebookId = data["id"] as? String {
                    self.singUpViewModel.updateName(name: "\(firtName) \(lastName)")
                    self.singUpViewModel.updateEmail(email: email)
                    self.singUpViewModel.updateFacebookId(facebookId: facebookId)
                    self.singUpViewModel.callSignUpAPI(type: "facebook")
                }
                print("Facebook Access Token: \(token?.tokenString ?? "")")
            } else {
                print("Error: Trying to get user's info")
            }
        }
    }
    
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
        print("Did logout from facebook successfully")
    }
    
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
        if error != nil {
            print(error ?? "")
            return
        }
        if (AccessToken.current) != nil {
            GraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, email"]).start(completionHandler: { (_, result, error) -> Void in
                if error == nil {
                    //parse the fields out of the result
                    if let fields = result as? [String: Any] {
                        self.callUserSignUp(result: fields)
                        self.navigateToTnCVC()
                    }
                }
            })
        }
        print("Successfully Logged in with facebook... ")
    }
    
    // MARK: SignUp Delegate
    func signUpSuccessful(userMessage: String) {
        // this method handles success of sign in
    }
    
    func signUpFailure(alertMessage: String, alertTitle: String, cancelButtonTitle: String) {
        // this method handles failure of sign in
    }
    
    /// This method is to call user signup api after soacial login
    /// - Parameter result: response from social login
    func callUserSignUp(result: [String: Any] ) {
        //Write api call for signup
    }
    
    /// This method enable Signup button
    func enableSignUp() {
        //TODO:
    }
}
