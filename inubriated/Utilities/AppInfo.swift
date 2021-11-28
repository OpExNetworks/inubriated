//  AppInfo.swift
//  inubriated
//
//  Created by David Holeman on 6/1/21
//  Copyright © 2021 OpExNetworks. All rights reserved.
//

import SwiftUI

class AppInfo {
    static var version: String {
        return Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String
    }
    static var build: String {
        return Bundle.main.infoDictionary!["CFBundleVersion"] as! String
    }
    static var release: String {
        return String(format: "%@.%@", Bundle.main.infoDictionary!["CFBundleShortVersionString"]! as! CVarArg, Bundle.main.infoDictionary!["CFBundleVersion"] as! CVarArg)
    }
}
