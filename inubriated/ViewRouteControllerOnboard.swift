//  ViewRouteControllerOnboard.swift
//  inubriated
//
//  Created by David Holeman on 6/2/21
//  Copyright © 2021 OpExNetworks. All rights reserved.
//

import Foundation

/// Used for the onboarding sequence of views
enum PageView {
    case onboardStartView
    case onboardTermsView
    case onboardAccountView
    case onboardEmailView
    case onboardPasswordView
    case onboardCompleteView
}

class ViewRouteControllerOnboard: ObservableObject {
    
    @Published var currentPageView: PageView = .onboardStartView
    
}
