//
//  SocialLoginExtention.swift
//  SBC

import UIKit
import FBSDKLoginKit

extension LoginViewController: LoginButtonDelegate {

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
    
    func getUserProfile(token: AccessToken?, userId: String?) {
        let graphRequest: GraphRequest = GraphRequest(graphPath: "me", parameters: ["fields": "id, first_name, middle_name, last_name, name, picture, email"])
        graphRequest.start { _, result, error in
            if error == nil {
                let data: [String: AnyObject] = result as! [String: AnyObject]
                if
                    let email = data["email"] as? String,
                    let facebookId = data["id"] as? String {
                    let loginRequest = LoginRequest(deviceId: K.deviceId, email: email, password: "", loginType: "facebook", facebookId: facebookId, appleId: "")
                    self.loginViewModel?.callLoginAPI(loginRequest: loginRequest)
                }
                print("Facebook Access Token: \(token?.tokenString ?? "")")
            } else {
                print("Error: Trying to get user's info")
            }
        }
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
                        self.navigateToDashBoardVC()
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
