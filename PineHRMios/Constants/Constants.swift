//
//  Constants.swift
//  PineHRMios
//
//  Created by Md Munir Hossain on 1/21/19.
//  Copyright © 2019 Md Munir Hossain. All rights reserved.
//

import Foundation
struct Constants {
    static let base_url = "https://www.pinehrm.com/cna/site/"
    static let login_url = base_url + "apilogin"
    static let validate_token_url = base_url + "vaidateaccesstocken";

    //storyboard identifiers
    static let LOGINVIEW_TO_MAINVC = "loginToMain"
    static let MAINVC_TO_LOGINVIEW = "MainToLogin"
    static let MAINVC_TO_DETAILS = "itemDetails"
    static let KEY_TOKEN = "token"
    static let KEY_EMAIL = "email"
    static let KEY_NAME = "name"

}
