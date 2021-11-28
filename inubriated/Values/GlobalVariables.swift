//  GlobalVariables.swift
//  inubriated
//
//  Created by David Holeman on 6/1/21
//  Copyright © 2021 OpExNetworks. All rights reserved.
//

import SwiftUI
import Foundation
import Combine

// MARK: Global Observable Variables
class GlobalVariables: ObservableObject {
    @Published var isLoggedIn = false
    @Published var isShowSettingsMenu = false

    @Published var isCurrentTabIndex: Int = 0 //myLandingPageIndex(string: myUserSettings.landingPage)
    @Published var isLandingPageIndex: Int = 0 //myLandingPageIndex(string: myUserSettings.landingPage)
    @Published var isPinnedSymbolIndex: Int = 0 //myPinnedSymbolIndex(string: myUserSettings.pinnedUnicode)

}
