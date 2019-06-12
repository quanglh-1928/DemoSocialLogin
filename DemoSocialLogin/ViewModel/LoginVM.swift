//
//  LoginVM.swift
//  DemoSocialLogin
//
//  Created by ly.hoang.quang on 6/11/19.
//  Copyright © 2019 ly.hoang.quang. All rights reserved.
//

import UIKit
import GoogleSignIn
import FBSDKLoginKit
import FBSDKCoreKit
import Crashlytics

class LoginVM: NSObject {
    
    var didCompleteGGSignin: ((User?) -> Void)?
    var uiForGGSignin: ((Bool, UIViewController) -> Void)?
    
    var didCompleteFBLogin: ((User?) -> Void)?
    
    func ggSignIn() {
        GIDSignIn.sharedInstance()?.delegate = self
        GIDSignIn.sharedInstance()?.uiDelegate = self
        GIDSignIn.sharedInstance()?.signIn()
    }
    
    func ggSignOut() {
        GIDSignIn.sharedInstance()?.signOut()
    }
    
    func fbLogin() {
        let loginManager = LoginManager()
        loginManager.logIn(permissions: ["public_profile", "email"],
                           from: UIViewController.topViewController())
        {[weak self] (result, error) in
            if let result = result {
                if result.isCancelled {
                    print("Cancelled")
                } else {
                    self?.getFBInfo()
                }
            }
        }
    }
    
    func fbLogout() {
        let loginManager = LoginManager()
        loginManager.logOut()
    }
    
    func crash() {
        Crashlytics.sharedInstance().crash()
    }
    
    private func getFBInfo() {
        guard let _ = AccessToken.current else {
            return
        }
        let params = ["fields": "id,name,email,picture,first_name,last_name"]
        GraphRequest(graphPath: "me", parameters: params).start { [weak self] (_, result, error) in
            guard let `self` = self else { return }
            if let error = error {
                print(error.localizedDescription)
            } else if let result = result as? [String: Any] {
                print(result)
                let id = result["id"] as? String
                let name = result["name"] as? String
                let email = result["email"] as? String
                var url: String?
                if let pictureDict = result["picture"] as? [String: Any] {
                    if let data = pictureDict["data"] as? [String: Any] {
                        url = data["url"] as? String
                    }
                }
                let firstName = result["first_name"] as? String
                let lastName = result["last_name"] as? String
                let user = User(id: id,
                                email: email,
                                userName: name,
                                name: (firstName ?? "") + " " + (lastName ?? ""),
                                profileUrl: URL(string: url ?? ""))
                self.didCompleteFBLogin?(user)
            }
        }
    }
    
}

extension LoginVM: GIDSignInDelegate, GIDSignInUIDelegate {
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let ggUser = user {
            let appUser = User(id: ggUser.userID,
                               email: ggUser.profile.email,
                               userName: ggUser.profile.name,
                               name: ggUser.profile.givenName + " " + ggUser.profile.familyName,
                               profileUrl: ggUser.profile.imageURL(withDimension: 30))
            didCompleteGGSignin?(appUser)
        } else {
            didCompleteGGSignin?(nil)
        }
    }
    
    func sign(inWillDispatch signIn: GIDSignIn!, error: Error!) {
        if let error = error {
            didCompleteGGSignin?(nil)
            print(error.localizedDescription)
        }
    }
    
    func sign(_ signIn: GIDSignIn!, present viewController: UIViewController!) {
        uiForGGSignin?(true, viewController)
    }
    
    func sign(_ signIn: GIDSignIn!, dismiss viewController: UIViewController!) {
        uiForGGSignin?(false, viewController)
    }
}
