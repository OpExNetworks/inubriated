//  OnboardLaunchView.swift
//  inubriated
//
//  Created by David Holeman on 6/2/21
//  Copyright © 2021 OpExNetworks. All rights reserved.
//

import SwiftUI

struct OnboardLaunchView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @ObservedObject var globalVariables = GlobalVariables()
    
    //@State var isOnboarded: Bool = myUserSettings.isOnboarded
    
    @EnvironmentObject var viewRouteControllerOnboard: ViewRouteControllerOnboard
    
    var body: some View {
        switch viewRouteControllerOnboard.currentPageView {
        case .onboardStartView:
            OnboardStartView()
        case .onboardTermsView:
            OnboardTermsView()
        case .onboardAccountView:
            OnboardAccountView()
        case .onboardEmailView:
            OnboardEmailView()
        case .onboardPasswordView:
            OnboardPasswordView()
        case .onboardCompleteView:
            OnboardCompleteView()
        }
    } // end View
} // end OnboardView


struct OnboardView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardLaunchView()
            .environmentObject(ViewRouteControllerOnboard())
    }
}
