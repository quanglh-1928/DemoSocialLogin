//
//  User.swift
//  DemoSocialLogin
//
//  Created by ly.hoang.quang on 6/11/19.
//  Copyright © 2019 ly.hoang.quang. All rights reserved.
//

import UIKit

class User {
    var id: String?
    var name: String?
    var email: String?
    var userName: String?
    var profileUrl: URL?
    
    init(id: String?, email: String?, userName: String?, name: String?, profileUrl: URL?) {
        self.id = id
        self.name = name
        self.userName = userName
        self.email = email
        self.profileUrl = profileUrl
    }
}
