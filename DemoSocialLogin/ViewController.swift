//
//  ViewController.swift
//  DemoSocialLogin
//
//  Created by ly.hoang.quang on 6/11/19.
//  Copyright © 2019 ly.hoang.quang. All rights reserved.
//

import UIKit
import Kingfisher

class ViewController: UIViewController {

    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    let viewModel = LoginVM()
    var crashString: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupClosures()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        AnalyticsHelper.logScreenView(name: AnalyticsKey.Screen.main)
    }
    
    private func setupClosures() {
        viewModel.didCompleteGGSignin = {[weak self] user in
            if let user = user {
                self?.configUI(user: user)
            } else {
                print("Can't access user infomation")
            }
        }
        
        viewModel.uiForGGSignin = {[weak self] isPresent, vc in
            isPresent ? self?.present(vc, animated: true, completion: nil) : self?.dismiss(animated: true, completion: nil)
        }
        
        viewModel.didCompleteFBLogin = { [weak self] user in
            if let user = user {
                self?.configUI(user: user)
            } else {
                print("Can't access user infomation")
            }
        }
    }
    
    private func configUI(user: User) {
        avatarImageView.kf.setImage(with: user.profileUrl)
        idLabel.text = "ID: " + (user.id ?? "")
        nameLabel.text = "Name: " + (user.name ?? "")
        userNameLabel.text = "User name: " + (user.userName ?? "")
        emailLabel.text = "Email: " + (user.email ?? "")
        viewModel.ggSignOut()
        viewModel.fbLogout()
    }

    @IBAction func onFbLogin(_ sender: Any) {
        AnalyticsHelper.logEventAction(name: AnalyticsKey.Action.loginFb)
        viewModel.fbLogin()
    }
    
    @IBAction func onGoogleLogin(_ sender: Any) {
        AnalyticsHelper.logEventAction(name: AnalyticsKey.Action.loginGg)
        viewModel.ggSignIn()
    }
    
    @IBAction func onTestCrashlytic(_ sender: Any) {
        viewModel.crash()
    }
    
}

extension UIViewController {
    class func topViewController(controller: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let navigationController = controller as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topViewController(controller: selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
        return controller
    }
}
