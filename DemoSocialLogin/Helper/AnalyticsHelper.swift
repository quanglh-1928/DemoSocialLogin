//
//  AnalyticsHelper.swift
//  DemoSocialLogin
//
//  Created by ly.hoang.quang on 6/12/19.
//  Copyright © 2019 ly.hoang.quang. All rights reserved.
//

import Foundation
import FirebaseAnalytics

class AnalyticsHelper {
    
    static func logEventAction(name: String) {
        Analytics.logEvent(name, parameters: nil)
    }
    
    static func logScreenView(name: String) {
        Analytics.setScreenName(name, screenClass: nil)
    }
}
