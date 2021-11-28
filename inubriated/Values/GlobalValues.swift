//  GlobalValues.swift
//  inubriated
//
//  Created by David Holeman on 6/1/21
//  Copyright © 2021 OpExNetworks. All rights reserved.
//

import SwiftUI

// MARK: Enums
enum TabItemList: Int {
    case home = 0
    case other = 1
}

// MARK: Structs
struct AppValue {
    //static var searchWordLength = 0
    static var sectionTags = [["PINNED","*|PINNED|* Helpful Articles"],["SECURITY","Security"], ["OTHER","Other"]]
    
    static var pinnedUnicode = "\u{8}\u{2605}"
    static var pinnedUnicodeOptions = ["\u{8}\u{2605}","\u{8}\u{2606}","\u{8}\u{25CF}"]
    
    static var landingPage = "Home"
    static var landingPageOptions = ["Home", "Other"]
    
    static var licenseURL = "https://www.opexnetworks.com/apps/globulon/license/license.html"
    static var privacyURL = "https://www.opexnetworks.com/apps/globulon/privacy/privacy.html"
    static var termsURL =   "https://www.opexnetworks.com/apps/globulon/terms/terms.json"
    
    static var supportEmail = "david.holeman@opexnetworks.com"
    
    //static var avatar = UIImage(imageLiteralResourceName: "imgAvatarDefault")
    
    static var screen = UIScreen.main.bounds
    static var settingsMenuWidth: CGFloat = 200
    
    static var displaySettings: String {
        var txtBody = """
            <style type="text/css">
                body {
                    font-size: 32pt;
                    font-family: monospace;
                }
                a {
                    text-decoration: none;
                    color: black;
                }
            </style>
        """
        txtBody = txtBody + "<p>"
        txtBody = txtBody + "<br/>Settings:" + ""
        txtBody = txtBody + "<br/>isAutoLogin.... " + String(UserSettings.init().isAutoLogin) + ""
        txtBody = txtBody + "<br/>isBiometricID.. " + String(UserSettings.init().isBiometricID) + ""
        txtBody = txtBody + "<br/>"
        txtBody = txtBody + "<br/>isOnboarded.... " + String(UserSettings.init().isOnboarded) + ""
        txtBody = txtBody + "<br/>isTerms........ " + String(UserSettings.init().isTerms) + ""
        txtBody = txtBody + "<br/>isWelcomed..... " + String(UserSettings.init().isWelcomed) + ""
        txtBody = txtBody + "<br/>"
        txtBody = txtBody + "<br/>landingPage.... " + String(UserSettings.init().landingPage) + ""
        txtBody = txtBody + "<br/>pinnedUnicode.. " + String(UserSettings.init().pinnedUnicode) + ""
        txtBody = txtBody + "<br/>"
        txtBody = txtBody + "<br/>username....... " + String(UserSettings.init().username) + ""
        txtBody = txtBody + "<br/>email.......... " + String(UserSettings.init().email) + ""
        txtBody = txtBody + "<br/>"
        txtBody = txtBody + "<br/>firstname...... " + String(UserSettings.init().firstname) + ""
        txtBody = txtBody + "<br/>lastname....... " + String(UserSettings.init().lastname) + ""
        txtBody = txtBody + "<br/>phoneCell...... " + String(UserSettings.init().phoneCell) + ""
        txtBody = txtBody + "</p>"
        return txtBody
    }
    
    static var appLogo = "logoApp"
    static var appLogoBlack = "logoAppBlack"
    static var appLogoWhite = "logoAppWhite"
    static var appLogoDarkMode = "logoAppDarkMode"
    static var appName = "inubriated"
}

struct AppDefault {
    static var alias = "<alias>"
    static var avatar = UIImage(imageLiteralResourceName: "imgAvatarDefault")
    
}

// MARK: sample values, text, etc.
struct DemoValue {
    static var loremIpsum: String {
        return "Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Nam liber te conscient to factor tum poen legum odioque civiuda."
    }
}

// MARK: Arrays
// load JSON data into a structure
let termsData = TermsData()

